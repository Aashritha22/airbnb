const mongoose = require('mongoose');

const propertySchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Property title is required'],
    trim: true,
    maxlength: [100, 'Title cannot be more than 100 characters']
  },
  description: {
    type: String,
    required: [true, 'Property description is required'],
    trim: true,
    maxlength: [2000, 'Description cannot be more than 2000 characters']
  },
  location: {
    address: {
      type: String,
      required: [true, 'Address is required'],
      trim: true
    },
    city: {
      type: String,
      required: [true, 'City is required'],
      trim: true
    },
    state: {
      type: String,
      required: [true, 'State is required'],
      trim: true
    },
    country: {
      type: String,
      required: [true, 'Country is required'],
      trim: true
    },
    zipCode: {
      type: String,
      required: [true, 'ZIP code is required'],
      trim: true
    },
    coordinates: {
      latitude: { type: Number, required: true },
      longitude: { type: Number, required: true }
    }
  },
  category: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'PropertyCategory',
    required: [true, 'Property category is required']
  },
  host: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Host is required']
  },
  price: {
    basePrice: {
      type: Number,
      required: [true, 'Base price is required'],
      min: [0, 'Price cannot be negative']
    },
    currency: {
      type: String,
      default: 'USD',
      enum: ['USD', 'EUR', 'GBP', 'CAD', 'AUD']
    },
    cleaningFee: { type: Number, default: 0 },
    serviceFee: { type: Number, default: 0 },
    taxes: { type: Number, default: 0 }
  },
  capacity: {
    maxGuests: {
      type: Number,
      required: [true, 'Maximum guests is required'],
      min: [1, 'Maximum guests must be at least 1'],
      max: [20, 'Maximum guests cannot exceed 20']
    },
    bedrooms: {
      type: Number,
      required: [true, 'Number of bedrooms is required'],
      min: [0, 'Bedrooms cannot be negative'],
      max: [10, 'Bedrooms cannot exceed 10']
    },
    bathrooms: {
      type: Number,
      required: [true, 'Number of bathrooms is required'],
      min: [0, 'Bathrooms cannot be negative'],
      max: [10, 'Bathrooms cannot exceed 10']
    },
    beds: {
      type: Number,
      required: [true, 'Number of beds is required'],
      min: [1, 'Must have at least 1 bed'],
      max: [20, 'Beds cannot exceed 20']
    }
  },
  amenities: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Amenity'
  }],
  images: [{
    url: {
      type: String,
      required: true
    },
    caption: String,
    isPrimary: { type: Boolean, default: false },
    uploadedAt: { type: Date, default: Date.now }
  }],
  availability: {
    isAvailable: { type: Boolean, default: true },
    checkInTime: { type: String, default: '15:00' },
    checkOutTime: { type: String, default: '11:00' },
    minimumStay: { type: Number, default: 1 },
    maximumStay: { type: Number, default: 30 },
    advanceNotice: { type: Number, default: 24 }, // hours
    blockedDates: [{
      startDate: Date,
      endDate: Date,
      reason: String
    }]
  },
  rules: {
    houseRules: [String],
    smokingAllowed: { type: Boolean, default: false },
    petsAllowed: { type: Boolean, default: false },
    partiesAllowed: { type: Boolean, default: false },
    quietHours: {
      start: { type: String, default: '22:00' },
      end: { type: String, default: '08:00' }
    }
  },
  ratings: {
    overall: {
      type: Number,
      default: 0,
      min: 0,
      max: 5
    },
    cleanliness: { type: Number, default: 0, min: 0, max: 5 },
    accuracy: { type: Number, default: 0, min: 0, max: 5 },
    checkIn: { type: Number, default: 0, min: 0, max: 5 },
    communication: { type: Number, default: 0, min: 0, max: 5 },
    location: { type: Number, default: 0, min: 0, max: 5 },
    value: { type: Number, default: 0, min: 0, max: 5 }
  },
  reviews: {
    totalCount: { type: Number, default: 0 },
    averageRating: { type: Number, default: 0, min: 0, max: 5 }
  },
  statistics: {
    totalBookings: { type: Number, default: 0 },
    totalRevenue: { type: Number, default: 0 },
    occupancyRate: { type: Number, default: 0 },
    viewCount: { type: Number, default: 0 },
    favoriteCount: { type: Number, default: 0 }
  },
  status: {
    isActive: { type: Boolean, default: true },
    isVerified: { type: Boolean, default: false },
    isBlocked: { type: Boolean, default: false },
    verificationStatus: {
      type: String,
      enum: ['pending', 'verified', 'rejected'],
      default: 'pending'
    },
    verificationNotes: String
  },
  policies: {
    cancellationPolicy: {
      type: String,
      enum: ['flexible', 'moderate', 'strict', 'super-strict'],
      default: 'moderate'
    },
    refundPolicy: String,
    damagePolicy: String
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Virtual for full address
propertySchema.virtual('fullAddress').get(function() {
  return `${this.location.address}, ${this.location.city}, ${this.location.state} ${this.location.zipCode}, ${this.location.country}`;
});

// Virtual for total price calculation
propertySchema.virtual('totalPrice').get(function() {
  return this.price.basePrice + this.price.cleaningFee + this.price.serviceFee + this.price.taxes;
});

// Indexes for better query performance
propertySchema.index({ 'location.coordinates': '2dsphere' });
propertySchema.index({ host: 1, 'status.isActive': 1 });
propertySchema.index({ category: 1, 'status.isActive': 1 });
propertySchema.index({ 'ratings.overall': -1 });
propertySchema.index({ price: 1 });
propertySchema.index({ createdAt: -1 });
propertySchema.index({ title: 'text', description: 'text' });

// Pre-save middleware to update statistics
propertySchema.pre('save', function(next) {
  if (this.isModified('reviews.totalCount') || this.isModified('reviews.averageRating')) {
    this.ratings.overall = this.reviews.averageRating;
  }
  next();
});

// Static method to get property stats
propertySchema.statics.getPropertyStats = async function() {
  const stats = await this.aggregate([
    {
      $group: {
        _id: null,
        totalProperties: { $sum: 1 },
        activeProperties: { $sum: { $cond: ['$status.isActive', 1, 0] } },
        verifiedProperties: { $sum: { $cond: ['$status.isVerified', 1, 0] } },
        blockedProperties: { $sum: { $cond: ['$status.isBlocked', 1, 0] } },
        totalRevenue: { $sum: '$statistics.totalRevenue' },
        averageRating: { $avg: '$ratings.overall' },
        averagePrice: { $avg: '$price.basePrice' }
      }
    }
  ]);
  
  return {
    totalProperties: stats[0]?.totalProperties || 0,
    activeProperties: stats[0]?.activeProperties || 0,
    verifiedProperties: stats[0]?.verifiedProperties || 0,
    blockedProperties: stats[0]?.blockedProperties || 0,
    totalRevenue: stats[0]?.totalRevenue || 0,
    averageRating: Math.round((stats[0]?.averageRating || 0) * 10) / 10,
    averagePrice: Math.round(stats[0]?.averagePrice || 0)
  };
};

// Method to update ratings
propertySchema.methods.updateRatings = async function() {
  const Review = mongoose.model('Review');
  const reviewStats = await Review.aggregate([
    { $match: { property: this._id } },
    {
      $group: {
        _id: null,
        totalCount: { $sum: 1 },
        averageRating: { $avg: '$overallRating' },
        avgCleanliness: { $avg: '$cleanliness' },
        avgAccuracy: { $avg: '$accuracy' },
        avgCheckIn: { $avg: '$checkIn' },
        avgCommunication: { $avg: '$communication' },
        avgLocation: { $avg: '$location' },
        avgValue: { $avg: '$value' }
      }
    }
  ]);
  
  if (reviewStats.length > 0) {
    this.reviews.totalCount = reviewStats[0].totalCount;
    this.reviews.averageRating = Math.round(reviewStats[0].averageRating * 10) / 10;
    this.ratings.overall = this.reviews.averageRating;
    this.ratings.cleanliness = Math.round(reviewStats[0].avgCleanliness * 10) / 10;
    this.ratings.accuracy = Math.round(reviewStats[0].avgAccuracy * 10) / 10;
    this.ratings.checkIn = Math.round(reviewStats[0].avgCheckIn * 10) / 10;
    this.ratings.communication = Math.round(reviewStats[0].avgCommunication * 10) / 10;
    this.ratings.location = Math.round(reviewStats[0].avgLocation * 10) / 10;
    this.ratings.value = Math.round(reviewStats[0].avgValue * 10) / 10;
  }
  
  await this.save();
};

module.exports = mongoose.model('Property', propertySchema);
