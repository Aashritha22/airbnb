const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  bookingNumber: {
    type: String,
    unique: true,
    required: true
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'User is required']
  },
  property: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Property',
    required: [true, 'Property is required']
  },
  host: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Host is required']
  },
  dates: {
    checkIn: {
      type: Date,
      required: [true, 'Check-in date is required']
    },
    checkOut: {
      type: Date,
      required: [true, 'Check-out date is required']
    },
    nights: {
      type: Number,
      required: true,
      min: [1, 'Must book at least 1 night']
    }
  },
  guests: {
    adults: {
      type: Number,
      required: [true, 'Number of adults is required'],
      min: [1, 'Must have at least 1 adult'],
      max: [20, 'Cannot exceed 20 adults']
    },
    children: { type: Number, default: 0, min: 0, max: 10 },
    infants: { type: Number, default: 0, min: 0, max: 5 },
    pets: { type: Number, default: 0, min: 0, max: 3 }
  },
  pricing: {
    basePrice: { type: Number, required: true },
    cleaningFee: { type: Number, default: 0 },
    serviceFee: { type: Number, default: 0 },
    taxes: { type: Number, default: 0 },
    totalAmount: { type: Number, required: true },
    currency: { type: String, default: 'USD' },
    discount: { type: Number, default: 0 },
    discountCode: String
  },
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'checked-in', 'checked-out', 'cancelled', 'refunded'],
    default: 'pending'
  },
  payment: {
    method: {
      type: String,
      enum: ['credit_card', 'debit_card', 'paypal', 'bank_transfer', 'stripe', 'apple_pay', 'google_pay'],
      required: true
    },
    status: {
      type: String,
      enum: ['pending', 'completed', 'failed', 'refunded', 'cancelled'],
      default: 'pending'
    },
    transactionId: String,
    paymentIntentId: String,
    paidAt: Date,
    refundedAt: Date,
    refundAmount: { type: Number, default: 0 }
  },
  cancellation: {
    isCancelled: { type: Boolean, default: false },
    cancelledBy: {
      type: String,
      enum: ['guest', 'host', 'admin', 'system']
    },
    cancelledAt: Date,
    reason: String,
    refundEligible: { type: Boolean, default: true },
    refundAmount: { type: Number, default: 0 },
    cancellationPolicy: String
  },
  checkIn: {
    isCheckedIn: { type: Boolean, default: false },
    checkedInAt: Date,
    checkedInBy: String,
    notes: String
  },
  checkOut: {
    isCheckedOut: { type: Boolean, default: false },
    checkedOutAt: Date,
    checkedOutBy: String,
    notes: String
  },
  specialRequests: String,
  notes: String,
  communication: [{
    sender: {
      type: String,
      enum: ['guest', 'host', 'admin'],
      required: true
    },
    message: { type: String, required: true },
    timestamp: { type: Date, default: Date.now },
    isRead: { type: Boolean, default: false }
  }],
  review: {
    hasReviewed: { type: Boolean, default: false },
    reviewedAt: Date,
    rating: { type: Number, min: 1, max: 5 },
    comment: String
  },
  hostReview: {
    hasReviewed: { type: Boolean, default: false },
    reviewedAt: Date,
    rating: { type: Number, min: 1, max: 5 },
    comment: String
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Virtual for total guests
bookingSchema.virtual('totalGuests').get(function() {
  return this.guests.adults + this.guests.children + this.guests.infants;
});

// Virtual for booking duration
bookingSchema.virtual('duration').get(function() {
  return this.dates.checkOut.getTime() - this.dates.checkIn.getTime();
});

// Indexes for better query performance
bookingSchema.index({ bookingNumber: 1 });
bookingSchema.index({ user: 1, createdAt: -1 });
bookingSchema.index({ property: 1, 'dates.checkIn': 1, 'dates.checkOut': 1 });
bookingSchema.index({ host: 1, createdAt: -1 });
bookingSchema.index({ status: 1 });
bookingSchema.index({ 'dates.checkIn': 1, 'dates.checkOut': 1 });

// Pre-save middleware to generate booking number and calculate nights
bookingSchema.pre('save', function(next) {
  if (this.isNew) {
    // Generate booking number
    const timestamp = Date.now().toString().slice(-6);
    const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
    this.bookingNumber = `BK${timestamp}${random}`;
    
    // Calculate nights
    const timeDiff = this.dates.checkOut.getTime() - this.dates.checkIn.getTime();
    this.dates.nights = Math.ceil(timeDiff / (1000 * 3600 * 24));
  }
  next();
});

// Static method to check property availability
bookingSchema.statics.checkAvailability = async function(propertyId, checkIn, checkOut, excludeBookingId = null) {
  const query = {
    property: propertyId,
    status: { $in: ['confirmed', 'checked-in', 'checked-out'] },
    $or: [
      {
        $and: [
          { 'dates.checkIn': { $lt: checkOut } },
          { 'dates.checkOut': { $gt: checkIn } }
        ]
      }
    ]
  };
  
  if (excludeBookingId) {
    query._id = { $ne: excludeBookingId };
  }
  
  const conflictingBookings = await this.find(query);
  return conflictingBookings.length === 0;
};

// Static method to get booking stats
bookingSchema.statics.getBookingStats = async function() {
  const stats = await this.aggregate([
    {
      $group: {
        _id: null,
        totalBookings: { $sum: 1 },
        pendingBookings: { $sum: { $cond: [{ $eq: ['$status', 'pending'] }, 1, 0] } },
        confirmedBookings: { $sum: { $cond: [{ $eq: ['$status', 'confirmed'] }, 1, 0] } },
        cancelledBookings: { $sum: { $cond: [{ $eq: ['$status', 'cancelled'] }, 1, 0] } },
        totalRevenue: { $sum: '$pricing.totalAmount' },
        averageBookingValue: { $avg: '$pricing.totalAmount' }
      }
    }
  ]);
  
  // Calculate occupancy rate
  const totalProperties = await mongoose.model('Property').countDocuments({ 'status.isActive': true });
  const activeBookings = await this.countDocuments({ 
    status: { $in: ['confirmed', 'checked-in'] },
    'dates.checkIn': { $lte: new Date() },
    'dates.checkOut': { $gte: new Date() }
  });
  
  const occupancyRate = totalProperties > 0 ? (activeBookings / totalProperties) * 100 : 0;
  
  return {
    totalBookings: stats[0]?.totalBookings || 0,
    pendingBookings: stats[0]?.pendingBookings || 0,
    confirmedBookings: stats[0]?.confirmedBookings || 0,
    cancelledBookings: stats[0]?.cancelledBookings || 0,
    totalRevenue: stats[0]?.totalRevenue || 0,
    averageBookingValue: Math.round(stats[0]?.averageBookingValue || 0),
    occupancyRate: Math.round(occupancyRate * 10) / 10
  };
};

// Method to cancel booking
bookingSchema.methods.cancelBooking = function(cancelledBy, reason) {
  this.status = 'cancelled';
  this.cancellation = {
    isCancelled: true,
    cancelledBy,
    cancelledAt: new Date(),
    reason
  };
  
  // Calculate refund based on cancellation policy
  // This would be implemented based on the property's cancellation policy
  const daysUntilCheckIn = Math.ceil((this.dates.checkIn - new Date()) / (1000 * 60 * 60 * 24));
  
  if (daysUntilCheckIn >= 7) {
    this.cancellation.refundAmount = this.pricing.totalAmount * 0.8; // 80% refund
  } else if (daysUntilCheckIn >= 3) {
    this.cancellation.refundAmount = this.pricing.totalAmount * 0.5; // 50% refund
  } else {
    this.cancellation.refundAmount = 0; // No refund
  }
  
  return this.save();
};

module.exports = mongoose.model('Booking', bookingSchema);
