const express = require('express');
const { body, validationResult } = require('express-validator');
const SupportTicket = require('../models/SupportTicket');
const { protect, adminAuth, requirePermission } = require('../middleware/auth');

const router = express.Router();

// @desc    Get user's support tickets
// @route   GET /api/support/tickets
// @access  Private
router.get('/tickets', protect, async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const filter = { user: req.user.id };

    if (req.query.status) {
      filter.status = req.query.status;
    }

    if (req.query.category) {
      filter.category = req.query.category;
    }

    const tickets = await SupportTicket.find(filter)
      .populate('assignedTo', 'firstName lastName email')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    const total = await SupportTicket.countDocuments(filter);
    const totalPages = Math.ceil(total / limit);

    res.status(200).json({
      success: true,
      data: tickets,
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

// @desc    Get support ticket by ID
// @route   GET /api/support/tickets/:id
// @access  Private
router.get('/tickets/:id', protect, async (req, res, next) => {
  try {
    const ticket = await SupportTicket.findById(req.params.id)
      .populate('user', 'firstName lastName email')
      .populate('assignedTo', 'firstName lastName email')
      .populate('relatedBooking', 'bookingNumber dates')
      .populate('relatedProperty', 'title location');

    if (!ticket) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Support ticket not found',
          code: 'TICKET_NOT_FOUND'
        }
      });
    }

    // Check if user owns the ticket or is admin
    if (ticket.user._id.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Not authorized to access this ticket',
          code: 'ACCESS_DENIED'
        }
      });
    }

    res.status(200).json({
      success: true,
      data: ticket
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Create support ticket
// @route   POST /api/support/tickets
// @access  Private
router.post('/tickets', protect, [
  body('subject').trim().notEmpty().withMessage('Subject is required'),
  body('category').isIn(['technical', 'billing', 'account', 'booking', 'property', 'general', 'complaint']).withMessage('Invalid category'),
  body('description').trim().notEmpty().withMessage('Description is required'),
  body('priority').optional().isIn(['low', 'medium', 'high', 'urgent']).withMessage('Invalid priority')
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

    const { subject, category, description, priority = 'medium', relatedBooking, relatedProperty, relatedPayment } = req.body;

    const ticket = await SupportTicket.create({
      user: req.user.id,
      subject,
      category,
      priority,
      description,
      relatedBooking,
      relatedProperty,
      relatedPayment,
      metadata: {
        ipAddress: req.ip,
        userAgent: req.get('User-Agent'),
        source: 'web'
      }
    });

    await ticket.populate('user', 'firstName lastName email');

    res.status(201).json({
      success: true,
      data: ticket
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Add message to support ticket
// @route   POST /api/support/tickets/:id/messages
// @access  Private
router.post('/tickets/:id/messages', protect, [
  body('message').trim().notEmpty().withMessage('Message is required')
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

    const ticket = await SupportTicket.findById(req.params.id);

    if (!ticket) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Support ticket not found',
          code: 'TICKET_NOT_FOUND'
        }
      });
    }

    // Check if user owns the ticket or is admin
    if (ticket.user.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Not authorized to add message to this ticket',
          code: 'ACCESS_DENIED'
        }
      });
    }

    const sender = req.user.role === 'admin' ? 'admin' : 'user';
    const senderId = req.user.role === 'admin' ? req.adminUser?.id : req.user.id;

    await ticket.addMessage(sender, senderId, req.body.message, {
      attachments: req.body.attachments || []
    });

    res.status(200).json({
      success: true,
      data: ticket,
      message: 'Message added successfully'
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get all support tickets (Admin only)
// @route   GET /api/support/admin/tickets
// @access  Private/Admin
router.get('/admin/tickets', adminAuth, requirePermission('support_tickets:read'), async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const filter = {};

    if (req.query.status) {
      filter.status = req.query.status;
    }

    if (req.query.category) {
      filter.category = req.query.category;
    }

    if (req.query.priority) {
      filter.priority = req.query.priority;
    }

    if (req.query.assignedTo) {
      filter.assignedTo = req.query.assignedTo;
    }

    if (req.query.search) {
      filter.$or = [
        { ticketNumber: { $regex: req.query.search, $options: 'i' } },
        { subject: { $regex: req.query.search, $options: 'i' } }
      ];
    }

    const tickets = await SupportTicket.find(filter)
      .populate('user', 'firstName lastName email')
      .populate('assignedTo', 'firstName lastName email')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    const total = await SupportTicket.countDocuments(filter);
    const totalPages = Math.ceil(total / limit);

    res.status(200).json({
      success: true,
      data: tickets,
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

// @desc    Assign support ticket
// @route   POST /api/support/admin/tickets/:id/assign
// @access  Private/Admin
router.post('/admin/tickets/:id/assign', adminAuth, requirePermission('support_tickets:write'), [
  body('assignedTo').isMongoId().withMessage('Valid admin user ID is required')
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

    const ticket = await SupportTicket.findById(req.params.id);

    if (!ticket) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Support ticket not found',
          code: 'TICKET_NOT_FOUND'
        }
      });
    }

    await ticket.assignTicket(req.body.assignedTo);

    res.status(200).json({
      success: true,
      data: ticket,
      message: 'Ticket assigned successfully'
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Resolve support ticket
// @route   POST /api/support/admin/tickets/:id/resolve
// @access  Private/Admin
router.post('/admin/tickets/:id/resolve', adminAuth, requirePermission('support_tickets:write'), async (req, res, next) => {
  try {
    const ticket = await SupportTicket.findById(req.params.id);

    if (!ticket) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Support ticket not found',
          code: 'TICKET_NOT_FOUND'
        }
      });
    }

    await ticket.resolveTicket();

    res.status(200).json({
      success: true,
      data: ticket,
      message: 'Ticket resolved successfully'
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Close support ticket
// @route   POST /api/support/admin/tickets/:id/close
// @access  Private/Admin
router.post('/admin/tickets/:id/close', adminAuth, requirePermission('support_tickets:close'), async (req, res, next) => {
  try {
    const ticket = await SupportTicket.findById(req.params.id);

    if (!ticket) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Support ticket not found',
          code: 'TICKET_NOT_FOUND'
        }
      });
    }

    await ticket.closeTicket();

    res.status(200).json({
      success: true,
      data: ticket,
      message: 'Ticket closed successfully'
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get support ticket statistics (Admin only)
// @route   GET /api/support/admin/stats
// @access  Private/Admin
router.get('/admin/stats', adminAuth, requirePermission('support_tickets:read'), async (req, res, next) => {
  try {
    const stats = await SupportTicket.getSupportTicketStats();

    res.status(200).json({
      success: true,
      data: stats
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
