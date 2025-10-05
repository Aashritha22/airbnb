const mongoose = require('mongoose');

const reviewSchema = new mongoose.Schema({
  property: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Property',
    required: [true, 'Property reference is required']
  },
  booking: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Booking',
    required: [true, 'Booking reference is required']
  },
  guest: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Guest reference is required']
  },
  host: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Host reference is required']
  },
  ratings: {
    overall: {
      type: Number,
      required: [true, 'Overall rating is required'],
      min: [1, 'Rating must be at least 1'],
      max: [5, 'Rating cannot exceed 5']
    },
    cleanliness: {
      type: Number,
      required: [true, 'Cleanliness rating is required'],
      min: [1, 'Rating must be at least 1'],
      max: [5, 'Rating cannot exceed 5']
    },
    accuracy: {
      type: Number,
      required: [true, 'Accuracy rating is required'],
      min: [1, 'Rating must be at least 1'],
      max: [5, 'Rating cannot exceed 5']
    },
    checkIn: {
      type: Number,
      required: [true, 'Check-in rating is required'],
      min: [1, 'Rating must be at least 1'],
      max: [5, 'Rating cannot exceed 5']
    },
    communication: {
      type: Number,
      required: [true, 'Communication rating is required'],
      min: [1, 'Rating must be at least 1'],
      max: [5, 'Rating cannot exceed 5']
    },
    location: {
      type: Number,
      required: [true, 'Location rating is required'],
      min: [1, 'Rating must be at least 1'],
      max: [5, 'Rating cannot exceed 5']
    },
    value: {
      type: Number,
      required: [true, 'Value rating is required'],
      min: [1, 'Rating must be at least 1'],
      max: [5, 'Rating cannot exceed 5']
    }
  },
  comment: {
    type: String,
    required: [true, 'Review comment is required'],
    trim: true,
    maxlength: [1000, 'Comment cannot be more than 1000 characters']
  },
  images: [{
    url: String,
    caption: String,
    uploadedAt: { type: Date, default: Date.now }
  }],
  isPublic: {
    type: Boolean,
    default: true
  },
  isVerified: {
    type: Boolean,
    default: false
  },
  helpfulVotes: {
    count: { type: Number, default: 0 },
    voters: [{
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    }]
  },
  response: {
    message: String,
    respondedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    respondedAt: Date
  },
  status: {
    type: String,
    enum: ['pending', 'approved', 'rejected', 'flagged'],
    default: 'pending'
  },
  moderation: {
    moderatedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'AdminUser'
    },
    moderatedAt: Date,
    moderationNotes: String,
    flagReason: String
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Indexes for better query performance
reviewSchema.index({ property: 1, createdAt: -1 });
reviewSchema.index({ guest: 1, createdAt: -1 });
reviewSchema.index({ host: 1, createdAt: -1 });
reviewSchema.index({ booking: 1 });
reviewSchema.index({ 'ratings.overall': -1 });
reviewSchema.index({ status: 1 });
reviewSchema.index({ isPublic: 1, status: 1 });

// Pre-save middleware to ensure unique review per booking
reviewSchema.pre('save', async function(next) {
  if (this.isNew) {
    const existingReview = await this.constructor.findOne({ booking: this.booking });
    if (existingReview) {
      return next(new Error('Review already exists for this booking'));
    }
  }
  next();
});

// Static method to get review stats
reviewSchema.statics.getReviewStats = async function() {
  const stats = await this.aggregate([
    {
      $group: {
        _id: null,
        totalReviews: { $sum: 1 },
        averageRating: { $avg: '$ratings.overall' },
        pendingReviews: { $sum: { $cond: [{ $eq: ['$status', 'pending'] }, 1, 0] } },
        approvedReviews: { $sum: { $cond: [{ $eq: ['$status', 'approved'] }, 1, 0] } },
        flaggedReviews: { $sum: { $cond: [{ $eq: ['$status', 'flagged'] }, 1, 0] } }
      }
    }
  ]);
  
  // Get rating distribution
  const ratingDistribution = await this.aggregate([
    {
      $group: {
        _id: '$ratings.overall',
        count: { $sum: 1 }
      }
    },
    { $sort: { _id: -1 } }
  ]);
  
  return {
    totalReviews: stats[0]?.totalReviews || 0,
    averageRating: Math.round((stats[0]?.averageRating || 0) * 10) / 10,
    pendingReviews: stats[0]?.pendingReviews || 0,
    approvedReviews: stats[0]?.approvedReviews || 0,
    flaggedReviews: stats[0]?.flaggedReviews || 0,
    ratingDistribution: ratingDistribution
  };
};

// Method to vote helpful
reviewSchema.methods.voteHelpful = function(userId) {
  if (this.helpfulVotes.voters.includes(userId)) {
    // Remove vote
    this.helpfulVotes.voters = this.helpfulVotes.voters.filter(id => !id.equals(userId));
    this.helpfulVotes.count = Math.max(0, this.helpfulVotes.count - 1);
  } else {
    // Add vote
    this.helpfulVotes.voters.push(userId);
    this.helpfulVotes.count += 1;
  }
  
  return this.save();
};

// Method to add host response
reviewSchema.methods.addResponse = function(message, hostId) {
  this.response = {
    message,
    respondedBy: hostId,
    respondedAt: new Date()
  };
  
  return this.save();
};

module.exports = mongoose.model('Review', reviewSchema);
