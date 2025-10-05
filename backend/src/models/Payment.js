const mongoose = require('mongoose');

const paymentSchema = new mongoose.Schema({
  paymentId: {
    type: String,
    unique: true,
    required: true
  },
  booking: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Booking',
    required: [true, 'Booking reference is required']
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'User reference is required']
  },
  property: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Property',
    required: [true, 'Property reference is required']
  },
  host: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Host reference is required']
  },
  amount: {
    total: {
      type: Number,
      required: [true, 'Total amount is required'],
      min: [0, 'Amount cannot be negative']
    },
    baseAmount: { type: Number, required: true },
    platformFee: { type: Number, required: true },
    hostAmount: { type: Number, required: true },
    taxAmount: { type: Number, default: 0 },
    currency: { type: String, default: 'USD', enum: ['USD', 'EUR', 'GBP', 'CAD', 'AUD'] }
  },
  method: {
    type: {
      type: String,
      enum: ['credit_card', 'debit_card', 'paypal', 'bank_transfer', 'stripe', 'apple_pay', 'google_pay'],
      required: [true, 'Payment method is required']
    },
    cardDetails: {
      last4: String,
      brand: String,
      expiryMonth: Number,
      expiryYear: Number
    },
    bankDetails: {
      accountLast4: String,
      bankName: String
    }
  },
  status: {
    type: String,
    enum: ['pending', 'processing', 'completed', 'failed', 'cancelled', 'refunded', 'partially_refunded'],
    default: 'pending'
  },
  transaction: {
    stripePaymentIntentId: String,
    stripeChargeId: String,
    paypalTransactionId: String,
    bankTransactionId: String,
    transactionFee: { type: Number, default: 0 },
    netAmount: { type: Number, required: true },
    exchangeRate: { type: Number, default: 1 }
  },
  timeline: {
    initiatedAt: { type: Date, default: Date.now },
    processedAt: Date,
    completedAt: Date,
    failedAt: Date,
    cancelledAt: Date,
    refundedAt: Date
  },
  failure: {
    reason: String,
    code: String,
    message: String,
    retryAttempts: { type: Number, default: 0 },
    maxRetries: { type: Number, default: 3 }
  },
  refund: {
    amount: { type: Number, default: 0 },
    reason: String,
    processedBy: {
      type: String,
      enum: ['guest', 'host', 'admin', 'system']
    },
    refundMethod: String,
    stripeRefundId: String,
    paypalRefundId: String,
    bankRefundId: String,
    estimatedRefundDate: Date,
    actualRefundDate: Date
  },
  metadata: {
    ipAddress: String,
    userAgent: String,
    deviceType: String,
    browserInfo: String,
    referrer: String
  },
  webhooks: [{
    eventType: String,
    eventId: String,
    receivedAt: { type: Date, default: Date.now },
    processed: { type: Boolean, default: false },
    data: mongoose.Schema.Types.Mixed
  }],
  notes: String
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Virtual for payment status display
paymentSchema.virtual('statusDisplay').get(function() {
  const statusMap = {
    'pending': 'Pending',
    'processing': 'Processing',
    'completed': 'Completed',
    'failed': 'Failed',
    'cancelled': 'Cancelled',
    'refunded': 'Refunded',
    'partially_refunded': 'Partially Refunded'
  };
  return statusMap[this.status] || this.status;
});

// Virtual for method display
paymentSchema.virtual('methodDisplay').get(function() {
  const methodMap = {
    'credit_card': 'Credit Card',
    'debit_card': 'Debit Card',
    'paypal': 'PayPal',
    'bank_transfer': 'Bank Transfer',
    'stripe': 'Stripe',
    'apple_pay': 'Apple Pay',
    'google_pay': 'Google Pay'
  };
  return methodMap[this.method.type] || this.method.type;
});

// Indexes for better query performance
paymentSchema.index({ paymentId: 1 });
paymentSchema.index({ user: 1, createdAt: -1 });
paymentSchema.index({ host: 1, createdAt: -1 });
paymentSchema.index({ booking: 1 });
paymentSchema.index({ status: 1 });
paymentSchema.index({ 'transaction.stripePaymentIntentId': 1 });
paymentSchema.index({ 'timeline.completedAt': -1 });

// Pre-save middleware to generate payment ID
paymentSchema.pre('save', function(next) {
  if (this.isNew && !this.paymentId) {
    const timestamp = Date.now().toString().slice(-6);
    const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
    this.paymentId = `PAY${timestamp}${random}`;
  }
  
  // Calculate net amount
  if (this.isModified('amount.total') || this.isModified('transaction.transactionFee')) {
    this.transaction.netAmount = this.amount.total - (this.transaction.transactionFee || 0);
  }
  
  next();
});

// Static method to get payment stats
paymentSchema.statics.getPaymentStats = async function() {
  const stats = await this.aggregate([
    {
      $group: {
        _id: null,
        totalPayments: { $sum: 1 },
        totalAmount: { $sum: '$amount.total' },
        pendingPayments: { $sum: { $cond: [{ $eq: ['$status', 'pending'] }, 1, 0] } },
        completedPayments: { $sum: { $cond: [{ $eq: ['$status', 'completed'] }, 1, 0] } },
        failedPayments: { $sum: { $cond: [{ $eq: ['$status', 'failed'] }, 1, 0] } },
        refundedPayments: { $sum: { $cond: [{ $in: ['$status', ['refunded', 'partially_refunded']] }, 1, 0] } },
        averageTransactionValue: { $avg: '$amount.total' }
      }
    }
  ]);
  
  // Calculate monthly revenue
  const currentMonth = new Date();
  currentMonth.setDate(1);
  currentMonth.setHours(0, 0, 0, 0);
  
  const monthlyRevenue = await this.aggregate([
    {
      $match: {
        status: 'completed',
        'timeline.completedAt': { $gte: currentMonth }
      }
    },
    {
      $group: {
        _id: null,
        revenue: { $sum: '$amount.total' }
      }
    }
  ]);
  
  return {
    totalPayments: stats[0]?.totalPayments || 0,
    totalAmount: stats[0]?.totalAmount || 0,
    pendingPayments: stats[0]?.pendingPayments || 0,
    completedPayments: stats[0]?.completedPayments || 0,
    failedPayments: stats[0]?.failedPayments || 0,
    refundedPayments: stats[0]?.refundedPayments || 0,
    averageTransactionValue: Math.round(stats[0]?.averageTransactionValue || 0),
    monthlyRevenue: monthlyRevenue[0]?.revenue || 0
  };
};

// Method to process refund
paymentSchema.methods.processRefund = function(refundAmount, reason, processedBy) {
  if (this.status !== 'completed') {
    throw new Error('Only completed payments can be refunded');
  }
  
  if (refundAmount > this.amount.total) {
    throw new Error('Refund amount cannot exceed original payment amount');
  }
  
  const totalRefunded = this.refund.amount + refundAmount;
  
  if (totalRefunded > this.amount.total) {
    throw new Error('Total refund amount cannot exceed original payment amount');
  }
  
  this.refund.amount = totalRefunded;
  this.refund.reason = reason;
  this.refund.processedBy = processedBy;
  this.refund.actualRefundDate = new Date();
  
  if (totalRefunded === this.amount.total) {
    this.status = 'refunded';
    this.timeline.refundedAt = new Date();
  } else {
    this.status = 'partially_refunded';
  }
  
  return this.save();
};

// Method to update payment status
paymentSchema.methods.updateStatus = function(newStatus, additionalData = {}) {
  const statusTimelineMap = {
    'processing': 'processedAt',
    'completed': 'completedAt',
    'failed': 'failedAt',
    'cancelled': 'cancelledAt',
    'refunded': 'refundedAt'
  };
  
  this.status = newStatus;
  
  if (statusTimelineMap[newStatus]) {
    this.timeline[statusTimelineMap[newStatus]] = new Date();
  }
  
  // Update failure information if status is failed
  if (newStatus === 'failed' && additionalData.failure) {
    this.failure = {
      ...this.failure,
      ...additionalData.failure
    };
  }
  
  return this.save();
};

module.exports = mongoose.model('Payment', paymentSchema);
