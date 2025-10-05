const mongoose = require('mongoose');

const amenitySchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Amenity name is required'],
    unique: true,
    trim: true,
    maxlength: [50, 'Amenity name cannot be more than 50 characters']
  },
  icon: {
    type: String,
    required: [true, 'Amenity icon is required'],
    maxlength: [10, 'Icon cannot be more than 10 characters']
  },
  category: {
    type: String,
    enum: ['essential', 'features', 'location', 'safety', 'accessibility'],
    required: [true, 'Amenity category is required'],
    default: 'features'
  },
  description: {
    type: String,
    trim: true,
    maxlength: [200, 'Description cannot be more than 200 characters']
  },
  isActive: {
    type: Boolean,
    default: true
  },
  isPopular: {
    type: Boolean,
    default: false
  },
  sortOrder: {
    type: Number,
    default: 0
  },
  usage: {
    totalProperties: { type: Number, default: 0 },
    percentage: { type: Number, default: 0 }
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Indexes
amenitySchema.index({ name: 1 });
amenitySchema.index({ category: 1, isActive: 1, sortOrder: 1 });
amenitySchema.index({ isPopular: 1 });

// Static method to get amenity stats
amenitySchema.statics.getAmenityStats = async function() {
  const Property = mongoose.model('Property');
  
  const totalProperties = await Property.countDocuments({ 'status.isActive': true });
  
  const amenities = await this.find({ isActive: true }).sort({ category: 1, sortOrder: 1 });
  const stats = [];
  
  for (const amenity of amenities) {
    const amenityUsage = await Property.countDocuments({
      'status.isActive': true,
      amenities: amenity._id
    });
    
    const percentage = totalProperties > 0 ? Math.round((amenityUsage / totalProperties) * 100) : 0;
    
    stats.push({
      amenity: amenity,
      usage: {
        totalProperties: amenityUsage,
        percentage: percentage
      }
    });
  }
  
  return stats;
};

// Static method to get popular amenities
amenitySchema.statics.getPopularAmenities = async function(limit = 10) {
  const Property = mongoose.model('Property');
  
  const popularAmenities = await this.aggregate([
    { $match: { isActive: true } },
    {
      $lookup: {
        from: 'properties',
        localField: '_id',
        foreignField: 'amenities',
        as: 'properties'
      }
    },
    {
      $project: {
        name: 1,
        icon: 1,
        category: 1,
        description: 1,
        usage: {
          totalProperties: { $size: '$properties' },
          percentage: {
            $multiply: [
              { $divide: [{ $size: '$properties' }, await Property.countDocuments({ 'status.isActive': true })] },
              100
            ]
          }
        }
      }
    },
    { $sort: { 'usage.totalProperties': -1 } },
    { $limit: limit }
  ]);
  
  return popularAmenities;
};

module.exports = mongoose.model('Amenity', amenitySchema);
