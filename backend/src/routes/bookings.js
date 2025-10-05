const express = require('express');
const { body, validationResult } = require('express-validator');
const Booking = require('../models/Booking');
const Property = require('../models/Property');
const { protect, adminAuth, requirePermission } = require('../middleware/auth');

const router = express.Router();

// @desc    Get user bookings
// @route   GET /api/bookings
// @access  Private
router.get('/', protect, async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const filter = { user: req.user.id };

    if (req.query.status) {
      filter.status = req.query.status;
    }

    const bookings = await Booking.find(filter)
      .populate('property', 'title location images price ratings')
      .populate('host', 'firstName lastName profileImage')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    const total = await Booking.countDocuments(filter);
    const totalPages = Math.ceil(total / limit);

    res.status(200).json({
      success: true,
      data: bookings,
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

// @desc    Get booking by ID
// @route   GET /api/bookings/:id
// @access  Private
router.get('/:id', protect, async (req, res, next) => {
  try {
    const booking = await Booking.findById(req.params.id)
      .populate('property', 'title location images price ratings amenities')
      .populate('user', 'firstName lastName email phone')
      .populate('host', 'firstName lastName email phone profileImage');

    if (!booking) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Booking not found',
          code: 'BOOKING_NOT_FOUND'
        }
      });
    }

    // Check if user owns the booking or is admin
    if (booking.user._id.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Not authorized to access this booking',
          code: 'ACCESS_DENIED'
        }
      });
    }

    res.status(200).json({
      success: true,
      data: booking
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Create booking
// @route   POST /api/bookings
// @access  Private
router.post('/', protect, [
  body('propertyId').isMongoId().withMessage('Valid property ID is required'),
  body('checkIn').isISO8601().withMessage('Valid check-in date is required'),
  body('checkOut').isISO8601().withMessage('Valid check-out date is required'),
  body('guests.adults').isInt({ min: 1 }).withMessage('At least 1 adult is required')
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

    const { propertyId, checkIn, checkOut, guests, specialRequests } = req.body;

    // Get property
    const property = await Property.findById(propertyId);
    if (!property) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Property not found',
          code: 'PROPERTY_NOT_FOUND'
        }
      });
    }

    // Check availability
    const isAvailable = await Booking.checkAvailability(propertyId, new Date(checkIn), new Date(checkOut));
    if (!isAvailable) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Property is not available for the selected dates',
          code: 'PROPERTY_NOT_AVAILABLE'
        }
      });
    }

    // Check guest capacity
    const totalGuests = guests.adults + (guests.children || 0) + (guests.infants || 0);
    if (totalGuests > property.capacity.maxGuests) {
      return res.status(400).json({
        success: false,
        error: {
          message: `Property can only accommodate ${property.capacity.maxGuests} guests`,
          code: 'GUEST_LIMIT_EXCEEDED'
        }
      });
    }

    // Calculate pricing
    const nights = Math.ceil((new Date(checkOut) - new Date(checkIn)) / (1000 * 60 * 60 * 24));
    const basePrice = property.price.basePrice * nights;
    const totalAmount = basePrice + property.price.cleaningFee + property.price.serviceFee + property.price.taxes;

    const booking = await Booking.create({
      user: req.user.id,
      property: propertyId,
      host: property.host,
      dates: {
        checkIn: new Date(checkIn),
        checkOut: new Date(checkOut),
        nights
      },
      guests,
      pricing: {
        basePrice,
        cleaningFee: property.price.cleaningFee,
        serviceFee: property.price.serviceFee,
        taxes: property.price.taxes,
        totalAmount,
        currency: property.price.currency
      },
      payment: {
        method: 'credit_card', // Default, will be updated when payment is processed
        status: 'pending'
      },
      specialRequests
    });

    await booking.populate('property', 'title location images');
    await booking.populate('host', 'firstName lastName profileImage');

    res.status(201).json({
      success: true,
      data: booking
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Cancel booking
// @route   PUT /api/bookings/:id/cancel
// @access  Private
router.put('/:id/cancel', protect, async (req, res, next) => {
  try {
    const booking = await Booking.findById(req.params.id);

    if (!booking) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Booking not found',
          code: 'BOOKING_NOT_FOUND'
        }
      });
    }

    // Check if user owns the booking or is admin
    if (booking.user.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Not authorized to cancel this booking',
          code: 'ACCESS_DENIED'
        }
      });
    }

    if (booking.status === 'cancelled') {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Booking is already cancelled',
          code: 'ALREADY_CANCELLED'
        }
      });
    }

    await booking.cancelBooking(req.user.role === 'admin' ? 'admin' : 'guest', req.body.reason || 'No reason provided');

    res.status(200).json({
      success: true,
      data: booking,
      message: 'Booking cancelled successfully'
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get all bookings (Admin only)
// @route   GET /api/bookings/admin/all
// @access  Private/Admin
router.get('/admin/all', adminAuth, requirePermission('bookings:read'), async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const filter = {};

    if (req.query.status) {
      filter.status = req.query.status;
    }

    if (req.query.search) {
      filter.$or = [
        { bookingNumber: { $regex: req.query.search, $options: 'i' } }
      ];
    }

    const bookings = await Booking.find(filter)
      .populate('user', 'firstName lastName email')
      .populate('property', 'title location')
      .populate('host', 'firstName lastName email')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    const total = await Booking.countDocuments(filter);
    const totalPages = Math.ceil(total / limit);

    res.status(200).json({
      success: true,
      data: bookings,
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

// @desc    Get booking statistics (Admin only)
// @route   GET /api/bookings/stats/overview
// @access  Private/Admin
router.get('/stats/overview', adminAuth, requirePermission('analytics:read'), async (req, res, next) => {
  try {
    const stats = await Booking.getBookingStats();

    res.status(200).json({
      success: true,
      data: stats
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
