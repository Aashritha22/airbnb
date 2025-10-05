const express = require('express');
const { body, validationResult } = require('express-validator');
const Payment = require('../models/Payment');
const Booking = require('../models/Booking');
const { protect, adminAuth, requirePermission } = require('../middleware/auth');

const router = express.Router();

// @desc    Create payment intent
// @route   POST /api/payments/create-intent
// @access  Private
router.post('/create-intent', protect, [
  body('bookingId').isMongoId().withMessage('Valid booking ID is required'),
  body('paymentMethod').notEmpty().withMessage('Payment method is required')
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

    const { bookingId, paymentMethod } = req.body;

    // Get booking
    const booking = await Booking.findById(bookingId);
    if (!booking) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Booking not found',
          code: 'BOOKING_NOT_FOUND'
        }
      });
    }

    // Check if user owns the booking
    if (booking.user.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Not authorized to pay for this booking',
          code: 'ACCESS_DENIED'
        }
      });
    }

    // Check if booking is pending
    if (booking.status !== 'pending') {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Booking is not in pending status',
          code: 'INVALID_BOOKING_STATUS'
        }
      });
    }

    // Create payment record
    const payment = await Payment.create({
      booking: bookingId,
      user: req.user.id,
      property: booking.property,
      host: booking.host,
      amount: {
        total: booking.pricing.totalAmount,
        baseAmount: booking.pricing.basePrice,
        platformFee: booking.pricing.serviceFee * 0.1,
        hostAmount: booking.pricing.totalAmount * 0.85,
        taxAmount: booking.pricing.taxes,
        currency: booking.pricing.currency
      },
      method: {
        type: paymentMethod
      },
      status: 'pending',
      transaction: {
        stripePaymentIntentId: `pi_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        transactionFee: booking.pricing.totalAmount * 0.029 + 0.30,
        netAmount: booking.pricing.totalAmount * 0.971 - 0.30
      }
    });

    // Update booking payment method
    booking.payment.method = paymentMethod;
    booking.payment.paymentIntentId = payment.transaction.stripePaymentIntentId;
    await booking.save();

    res.status(201).json({
      success: true,
      data: {
        paymentId: payment.paymentId,
        paymentIntentId: payment.transaction.stripePaymentIntentId,
        amount: payment.amount.total,
        currency: payment.amount.currency
      }
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Confirm payment
// @route   POST /api/payments/confirm
// @access  Private
router.post('/confirm', protect, [
  body('paymentId').notEmpty().withMessage('Payment ID is required'),
  body('transactionId').notEmpty().withMessage('Transaction ID is required')
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

    const { paymentId, transactionId } = req.body;

    const payment = await Payment.findOne({ paymentId });
    if (!payment) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Payment not found',
          code: 'PAYMENT_NOT_FOUND'
        }
      });
    }

    // Check if user owns the payment
    if (payment.user.toString() !== req.user.id) {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Not authorized to confirm this payment',
          code: 'ACCESS_DENIED'
        }
      });
    }

    // Update payment status
    await payment.updateStatus('completed', {
      transactionId: transactionId,
      completedAt: new Date()
    });

    // Update booking status
    const booking = await Booking.findById(payment.booking);
    booking.status = 'confirmed';
    booking.payment.status = 'completed';
    booking.payment.transactionId = transactionId;
    booking.payment.paidAt = new Date();
    await booking.save();

    res.status(200).json({
      success: true,
      data: payment,
      message: 'Payment confirmed successfully'
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Process refund
// @route   POST /api/payments/refund
// @access  Private/Admin
router.post('/refund', adminAuth, requirePermission('payments:refund'), [
  body('paymentId').notEmpty().withMessage('Payment ID is required'),
  body('refundAmount').isNumeric().withMessage('Valid refund amount is required'),
  body('reason').notEmpty().withMessage('Refund reason is required')
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

    const { paymentId, refundAmount, reason } = req.body;

    const payment = await Payment.findOne({ paymentId });
    if (!payment) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Payment not found',
          code: 'PAYMENT_NOT_FOUND'
        }
      });
    }

    await payment.processRefund(parseFloat(refundAmount), reason, 'admin');

    // Update booking status if full refund
    if (payment.status === 'refunded') {
      const booking = await Booking.findById(payment.booking);
      booking.status = 'refunded';
      await booking.save();
    }

    res.status(200).json({
      success: true,
      data: payment,
      message: 'Refund processed successfully'
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get payment by ID
// @route   GET /api/payments/:id
// @access  Private
router.get('/:id', protect, async (req, res, next) => {
  try {
    const payment = await Payment.findById(req.params.id)
      .populate('booking', 'bookingNumber dates guests')
      .populate('user', 'firstName lastName email')
      .populate('property', 'title location')
      .populate('host', 'firstName lastName email');

    if (!payment) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Payment not found',
          code: 'PAYMENT_NOT_FOUND'
        }
      });
    }

    // Check if user owns the payment or is admin
    if (payment.user._id.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Not authorized to access this payment',
          code: 'ACCESS_DENIED'
        }
      });
    }

    res.status(200).json({
      success: true,
      data: payment
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get all payments (Admin only)
// @route   GET /api/payments/admin/all
// @access  Private/Admin
router.get('/admin/all', adminAuth, requirePermission('payments:read'), async (req, res, next) => {
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
        { paymentId: { $regex: req.query.search, $options: 'i' } },
        { 'transaction.stripePaymentIntentId': { $regex: req.query.search, $options: 'i' } }
      ];
    }

    const payments = await Payment.find(filter)
      .populate('booking', 'bookingNumber')
      .populate('user', 'firstName lastName email')
      .populate('property', 'title location')
      .populate('host', 'firstName lastName email')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    const total = await Payment.countDocuments(filter);
    const totalPages = Math.ceil(total / limit);

    res.status(200).json({
      success: true,
      data: payments,
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

// @desc    Get payment statistics (Admin only)
// @route   GET /api/payments/stats/overview
// @access  Private/Admin
router.get('/stats/overview', adminAuth, requirePermission('analytics:read'), async (req, res, next) => {
  try {
    const stats = await Payment.getPaymentStats();

    res.status(200).json({
      success: true,
      data: stats
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
