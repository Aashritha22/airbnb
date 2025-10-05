const mongoose = require('mongoose');

const propertyCategorySchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Category name is required'],
    unique: true,
    trim: true,
    maxlength: [50, 'Category name cannot be more than 50 characters']
  },
  emoji: {
    type: String,
    required: [true, 'Category emoji is required'],
    maxlength: [10, 'Emoji cannot be more than 10 characters']
  },
  description: {
    type: String,
    trim: true,
    maxlength: [200, 'Description cannot be more than 200 characters']
  },
  icon: {
    type: String,
    default: 'home'
  },
  color: {
    type: String,
    default: '#6B7280',
    match: [/^#[0-9A-F]{6}$/i, 'Color must be a valid hex color']
  },
  isActive: {
    type: Boolean,
    default: true
  },
  sortOrder: {
    type: Number,
    default: 0
  },
  properties: {
    total: { type: Number, default: 0 },
    active: { type: Number, default: 0 },
    verified: { type: Number, default: 0 }
  },
  metadata: {
    searchKeywords: [String],
    relatedCategories: [{
      type: mongoose.Schema.Types.ObjectId,
      ref: 'PropertyCategory'
    }]
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Indexes
propertyCategorySchema.index({ name: 1 });
propertyCategorySchema.index({ isActive: 1, sortOrder: 1 });

// Static method to get category stats
propertyCategorySchema.statics.getCategoryStats = async function() {
  const Property = mongoose.model('Property');
  
  const categories = await this.find({ isActive: true }).sort({ sortOrder: 1, name: 1 });
  const stats = [];
  
  for (const category of categories) {
    const categoryStats = await Property.aggregate([
      { $match: { category: category._id } },
      {
        $group: {
          _id: null,
          total: { $sum: 1 },
          active: { $sum: { $cond: ['$status.isActive', 1, 0] } },
          verified: { $sum: { $cond: ['$status.isVerified', 1, 0] } }
        }
      }
    ]);
    
    stats.push({
      category: category,
      properties: categoryStats[0] || { total: 0, active: 0, verified: 0 }
    });
  }
  
  return stats;
};

module.exports = mongoose.model('PropertyCategory', propertyCategorySchema);
