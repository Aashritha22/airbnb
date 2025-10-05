const express = require('express');
const { body, validationResult } = require('express-validator');
const Property = require('../models/Property');
const PropertyCategory = require('../models/PropertyCategory');
const Amenity = require('../models/Amenity');
const { protect, adminAuth, requirePermission, optionalAuth } = require('../middleware/auth');

const router = express.Router();

// @desc    Get all properties
// @route   GET /api/properties
// @access  Public
router.get('/', optionalAuth, async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 12;
    const skip = (page - 1) * limit;

    let filter = { 'status.isActive': true };

    // Apply filters
    if (req.query.search) {
      filter.$or = [
        { title: { $regex: req.query.search, $options: 'i' } },
        { description: { $regex: req.query.search, $options: 'i' } },
        { 'location.city': { $regex: req.query.search, $options: 'i' } },
        { 'location.address': { $regex: req.query.search, $options: 'i' } }
      ];
    }

    if (req.query.category) {
      filter.category = req.query.category;
    }

    if (req.query.minPrice) {
      filter['price.basePrice'] = { ...filter['price.basePrice'], $gte: parseInt(req.query.minPrice) };
    }

    if (req.query.maxPrice) {
      filter['price.basePrice'] = { ...filter['price.basePrice'], $lte: parseInt(req.query.maxPrice) };
    }

    if (req.query.guests) {
      filter['capacity.maxGuests'] = { $gte: parseInt(req.query.guests) };
    }

    if (req.query.bedrooms) {
      filter['capacity.bedrooms'] = { $gte: parseInt(req.query.bedrooms) };
    }

    if (req.query.bathrooms) {
      filter['capacity.bathrooms'] = { $gte: parseInt(req.query.bathrooms) };
    }

    if (req.query.amenities) {
      const amenities = req.query.amenities.split(',');
      filter.amenities = { $all: amenities };
    }

    if (req.query.latitude && req.query.longitude && req.query.radius) {
      const lat = parseFloat(req.query.latitude);
      const lng = parseFloat(req.query.longitude);
      const radius = parseFloat(req.query.radius) / 6371; // Convert km to radians

      filter['location.coordinates'] = {
        $geoWithin: {
          $centerSphere: [[lng, lat], radius]
        }
      };
    }

    if (req.query.checkIn && req.query.checkOut) {
      const checkIn = new Date(req.query.checkIn);
      const checkOut = new Date(req.query.checkOut);

      filter['availability.blockedDates'] = {
        $not: {
          $elemMatch: {
            startDate: { $lte: checkOut },
            endDate: { $gte: checkIn }
          }
        }
      };
    }

    // Sorting
    let sort = {};
    switch (req.query.sort) {
      case 'price-low':
        sort = { 'price.basePrice': 1 };
        break;
      case 'price-high':
        sort = { 'price.basePrice': -1 };
        break;
      case 'rating':
        sort = { 'ratings.overall': -1 };
        break;
      case 'newest':
        sort = { createdAt: -1 };
        break;
      default:
        sort = { 'ratings.overall': -1, 'reviews.totalCount': -1 };
    }

    const properties = await Property.find(filter)
      .populate('category', 'name emoji color')
      .populate('host', 'firstName lastName profileImage')
      .populate('amenities', 'name icon category')
      .sort(sort)
      .skip(skip)
      .limit(limit);

    const total = await Property.countDocuments(filter);
    const totalPages = Math.ceil(total / limit);

    res.status(200).json({
      success: true,
      data: properties,
      pagination: {
        page,
        limit,
        total,
        pages: totalPages
      }
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get property categories
// @route   GET /api/properties/categories
// @access  Public
router.get('/categories', async (req, res, next) => {
  try {
    const categories = await PropertyCategory.find({ isActive: true })
      .sort({ sortOrder: 1, name: 1 });

    res.status(200).json({
      success: true,
      data: categories
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get amenities
// @route   GET /api/properties/amenities
// @access  Public
router.get('/amenities', async (req, res, next) => {
  try {
    const amenities = await Amenity.find({ isActive: true })
      .sort({ category: 1, name: 1 });

    res.status(200).json({
      success: true,
      data: amenities
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get property by ID
// @route   GET /api/properties/:id
// @access  Public
router.get('/:id', optionalAuth, async (req, res, next) => {
  try {
    const property = await Property.findById(req.params.id)
      .populate('category', 'name emoji color description')
      .populate('host', 'firstName lastName profileImage isVerified')
      .populate('amenities', 'name icon category description');

    if (!property) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Property not found',
          code: 'PROPERTY_NOT_FOUND'
        }
      });
    }

    // Increment view count
    property.statistics.viewCount += 1;
    await property.save();

    res.status(200).json({
      success: true,
      data: property
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Create property
// @route   POST /api/properties
// @access  Private
router.post('/', protect, [
  body('title').trim().notEmpty().withMessage('Property title is required'),
  body('description').trim().notEmpty().withMessage('Property description is required'),
  body('location.address').notEmpty().withMessage('Address is required'),
  body('location.city').notEmpty().withMessage('City is required'),
  body('location.state').notEmpty().withMessage('State is required'),
  body('location.country').notEmpty().withMessage('Country is required'),
  body('location.zipCode').notEmpty().withMessage('ZIP code is required'),
  body('location.coordinates.latitude').isNumeric().withMessage('Valid latitude is required'),
  body('location.coordinates.longitude').isNumeric().withMessage('Valid longitude is required'),
  body('category').isMongoId().withMessage('Valid category is required'),
  body('price.basePrice').isNumeric().withMessage('Base price is required'),
  body('capacity.maxGuests').isInt({ min: 1 }).withMessage('Maximum guests must be at least 1'),
  body('capacity.bedrooms').isInt({ min: 0 }).withMessage('Bedrooms cannot be negative'),
  body('capacity.bathrooms').isInt({ min: 0 }).withMessage('Bathrooms cannot be negative'),
  body('capacity.beds').isInt({ min: 1 }).withMessage('Must have at least 1 bed')
], async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Validation failed',
          code: 'VALIDATION_ERROR',
          details: errors.array()
        }
      });
    }

    // Set the host to the current user
    req.body.host = req.user.id;

    const property = await Property.create(req.body);

    await property.populate('category', 'name emoji color');
    await property.populate('host', 'firstName lastName profileImage');
    await property.populate('amenities', 'name icon category');

    res.status(201).json({
      success: true,
      data: property
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Update property
// @route   PUT /api/properties/:id
// @access  Private
router.put('/:id', protect, async (req, res, next) => {
  try {
    let property = await Property.findById(req.params.id);

    if (!property) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Property not found',
          code: 'PROPERTY_NOT_FOUND'
        }
      });
    }

    // Check if user owns the property or is admin
    if (property.host.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Not authorized to update this property',
          code: 'ACCESS_DENIED'
        }
      });
    }

    property = await Property.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    }).populate('category', 'name emoji color')
      .populate('host', 'firstName lastName profileImage')
      .populate('amenities', 'name icon category');

    res.status(200).json({
      success: true,
      data: property
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Delete property
// @route   DELETE /api/properties/:id
// @access  Private
router.delete('/:id', protect, async (req, res, next) => {
  try {
    const property = await Property.findById(req.params.id);

    if (!property) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Property not found',
          code: 'PROPERTY_NOT_FOUND'
        }
      });
    }

    // Check if user owns the property or is admin
    if (property.host.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Not authorized to delete this property',
          code: 'ACCESS_DENIED'
        }
      });
    }

    await Property.findByIdAndDelete(req.params.id);

    res.status(200).json({
      success: true,
      message: 'Property deleted successfully'
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get user's properties
// @route   GET /api/properties/user/:userId
// @access  Private
router.get('/user/:userId', protect, async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    // Users can only view their own properties unless they're admin
    if (req.params.userId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Not authorized to view these properties',
          code: 'ACCESS_DENIED'
        }
      });
    }

    const properties = await Property.find({ host: req.params.userId })
      .populate('category', 'name emoji color')
      .populate('amenities', 'name icon category')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    const total = await Property.countDocuments({ host: req.params.userId });
    const totalPages = Math.ceil(total / limit);

    res.status(200).json({
      success: true,
      data: properties,
      pagination: {
        page,
        limit,
        total,
        pages: totalPages
      }
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Verify property (Admin only)
// @route   POST /api/properties/:id/verify
// @access  Private/Admin
router.post('/:id/verify', adminAuth, requirePermission('properties:verify'), async (req, res, next) => {
  try {
    const property = await Property.findById(req.params.id);

    if (!property) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Property not found',
          code: 'PROPERTY_NOT_FOUND'
        }
      });
    }

    property.status.isVerified = !property.status.isVerified;
    property.status.verificationStatus = property.status.isVerified ? 'verified' : 'pending';
    await property.save();

    res.status(200).json({
      success: true,
      data: property,
      message: `Property ${property.status.isVerified ? 'verified' : 'unverified'} successfully`
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get property statistics (Admin only)
// @route   GET /api/properties/stats/overview
// @access  Private/Admin
router.get('/stats/overview', adminAuth, requirePermission('analytics:read'), async (req, res, next) => {
  try {
    const stats = await Property.getPropertyStats();

    res.status(200).json({
      success: true,
      data: stats
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
