const mongoose = require('mongoose');

const supportTicketSchema = new mongoose.Schema({
  ticketNumber: {
    type: String,
    unique: true,
    required: true
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'User reference is required']
  },
  subject: {
    type: String,
    required: [true, 'Subject is required'],
    trim: true,
    maxlength: [200, 'Subject cannot be more than 200 characters']
  },
  category: {
    type: String,
    enum: ['technical', 'billing', 'account', 'booking', 'property', 'general', 'complaint'],
    required: [true, 'Category is required'],
    default: 'general'
  },
  priority: {
    type: String,
    enum: ['low', 'medium', 'high', 'urgent'],
    default: 'medium'
  },
  status: {
    type: String,
    enum: ['open', 'in_progress', 'resolved', 'closed'],
    default: 'open'
  },
  description: {
    type: String,
    required: [true, 'Description is required'],
    trim: true,
    maxlength: [2000, 'Description cannot be more than 2000 characters']
  },
  messages: [{
    sender: {
      type: String,
      enum: ['user', 'admin', 'system'],
      required: true
    },
    senderId: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'messages.senderModel'
    },
    senderModel: {
      type: String,
      enum: ['User', 'AdminUser']
    },
    message: {
      type: String,
      required: true,
      trim: true,
      maxlength: [2000, 'Message cannot be more than 2000 characters']
    },
    attachments: [{
      url: String,
      filename: String,
      size: Number,
      type: String
    }],
    isInternal: { type: Boolean, default: false },
    timestamp: { type: Date, default: Date.now }
  }],
  assignedTo: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'AdminUser'
  },
  tags: [String],
  relatedBooking: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Booking'
  },
  relatedProperty: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Property'
  },
  relatedPayment: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Payment'
  },
  timeline: {
    openedAt: { type: Date, default: Date.now },
    assignedAt: Date,
    firstResponseAt: Date,
    resolvedAt: Date,
    closedAt: Date,
    lastActivityAt: { type: Date, default: Date.now }
  },
  satisfaction: {
    rating: { type: Number, min: 1, max: 5 },
    feedback: String,
    ratedAt: Date
  },
  metadata: {
    ipAddress: String,
    userAgent: String,
    source: { type: String, default: 'web' }, // web, mobile, email, phone
    department: String
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Virtual for ticket status display
supportTicketSchema.virtual('statusDisplay').get(function() {
  const statusMap = {
    'open': 'Open',
    'in_progress': 'In Progress',
    'resolved': 'Resolved',
    'closed': 'Closed'
  };
  return statusMap[this.status] || this.status;
});

// Virtual for priority display
supportTicketSchema.virtual('priorityDisplay').get(function() {
  const priorityMap = {
    'low': 'Low',
    'medium': 'Medium',
    'high': 'High',
    'urgent': 'Urgent'
  };
  return priorityMap[this.priority] || this.priority;
});

// Virtual for category display
supportTicketSchema.virtual('categoryDisplay').get(function() {
  const categoryMap = {
    'technical': 'Technical',
    'billing': 'Billing',
    'account': 'Account',
    'booking': 'Booking',
    'property': 'Property',
    'general': 'General',
    'complaint': 'Complaint'
  };
  return categoryMap[this.category] || this.category;
});

// Indexes for better query performance
supportTicketSchema.index({ ticketNumber: 1 });
supportTicketSchema.index({ user: 1, createdAt: -1 });
supportTicketSchema.index({ assignedTo: 1, status: 1 });
supportTicketSchema.index({ status: 1, priority: 1 });
supportTicketSchema.index({ category: 1 });
supportTicketSchema.index({ createdAt: -1 });

// Pre-save middleware to generate ticket number and update timeline
supportTicketSchema.pre('save', function(next) {
  if (this.isNew) {
    // Generate ticket number
    const timestamp = Date.now().toString().slice(-6);
    const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
    this.ticketNumber = `TKT${timestamp}${random}`;
    
    this.timeline.openedAt = new Date();
  }
  
  // Update last activity timestamp
  this.timeline.lastActivityAt = new Date();
  
  next();
});

// Static method to get support ticket stats
supportTicketSchema.statics.getSupportTicketStats = async function() {
  const stats = await this.aggregate([
    {
      $group: {
        _id: null,
        totalTickets: { $sum: 1 },
        openTickets: { $sum: { $cond: [{ $eq: ['$status', 'open'] }, 1, 0] } },
        inProgressTickets: { $sum: { $cond: [{ $eq: ['$status', 'in_progress'] }, 1, 0] } },
        resolvedTickets: { $sum: { $cond: [{ $eq: ['$status', 'resolved'] }, 1, 0] } },
        closedTickets: { $sum: { $cond: [{ $eq: ['$status', 'closed'] }, 1, 0] } }
      }
    }
  ]);
  
  // Calculate average resolution time
  const resolutionTimeStats = await this.aggregate([
    {
      $match: {
        status: { $in: ['resolved', 'closed'] },
        'timeline.resolvedAt': { $exists: true }
      }
    },
    {
      $project: {
        resolutionTime: {
          $subtract: ['$timeline.resolvedAt', '$timeline.openedAt']
        }
      }
    },
    {
      $group: {
        _id: null,
        averageResolutionTime: { $avg: '$resolutionTime' }
      }
    }
  ]);
  
  // Calculate first response time
  const firstResponseStats = await this.aggregate([
    {
      $match: {
        'timeline.firstResponseAt': { $exists: true }
      }
    },
    {
      $project: {
        firstResponseTime: {
          $subtract: ['$timeline.firstResponseAt', '$timeline.openedAt']
        }
      }
    },
    {
      $group: {
        _id: null,
        averageFirstResponseTime: { $avg: '$firstResponseTime' }
      }
    }
  ]);
  
  const averageResolutionTime = resolutionTimeStats[0]?.averageResolutionTime || 0;
  const averageFirstResponseTime = firstResponseStats[0]?.averageFirstResponseTime || 0;
  
  return {
    totalTickets: stats[0]?.totalTickets || 0,
    openTickets: stats[0]?.openTickets || 0,
    inProgressTickets: stats[0]?.inProgressTickets || 0,
    resolvedTickets: stats[0]?.resolvedTickets || 0,
    closedTickets: stats[0]?.closedTickets || 0,
    averageResolutionTimeHours: Math.round(averageResolutionTime / (1000 * 60 * 60) * 10) / 10,
    averageFirstResponseTimeHours: Math.round(averageFirstResponseTime / (1000 * 60 * 60) * 10) / 10
  };
};

// Method to add message
supportTicketSchema.methods.addMessage = function(sender, senderId, message, options = {}) {
  const newMessage = {
    sender,
    senderId,
    senderModel: sender === 'user' ? 'User' : 'AdminUser',
    message,
    attachments: options.attachments || [],
    isInternal: options.isInternal || false
  };
  
  this.messages.push(newMessage);
  
  // Update timeline
  if (sender === 'admin' && !this.timeline.firstResponseAt) {
    this.timeline.firstResponseAt = new Date();
  }
  
  return this.save();
};

// Method to assign ticket
supportTicketSchema.methods.assignTicket = function(adminUserId) {
  this.assignedTo = adminUserId;
  this.status = 'in_progress';
  this.timeline.assignedAt = new Date();
  
  return this.save();
};

// Method to resolve ticket
supportTicketSchema.methods.resolveTicket = function() {
  this.status = 'resolved';
  this.timeline.resolvedAt = new Date();
  
  return this.save();
};

// Method to close ticket
supportTicketSchema.methods.closeTicket = function() {
  this.status = 'closed';
  this.timeline.closedAt = new Date();
  
  return this.save();
};

module.exports = mongoose.model('SupportTicket', supportTicketSchema);
