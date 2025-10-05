const express = require('express');
const { body, validationResult } = require('express-validator');
const AdminUser = require('../models/AdminUser');
const User = require('../models/User');
const Property = require('../models/Property');
const Booking = require('../models/Booking');
const Payment = require('../models/Payment');
const SupportTicket = require('../models/SupportTicket');
const { adminAuth, authorize, requirePermission } = require('../middleware/auth');

const router = express.Router();

// @desc    Admin login
// @route   POST /api/admin/login
// @access  Public
router.post('/login', [
  body('email').isEmail().normalizeEmail().withMessage('Please provide a valid email'),
  body('password').notEmpty().withMessage('Password is required')
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

    const { email, password } = req.body;

    // Check for admin user
    const adminUser = await AdminUser.findOne({ email }).select('+password');
    if (!adminUser) {
      return res.status(401).json({
        success: false,
        error: {
          message: 'Invalid credentials',
          code: 'INVALID_CREDENTIALS'
        }
      });
    }

    // Check if account is locked
    if (adminUser.isLocked) {
      return res.status(401).json({
        success: false,
        error: {
          message: 'Account is temporarily locked due to too many failed login attempts',
          code: 'ACCOUNT_LOCKED'
        }
      });
    }

    // Check password
    const isMatch = await adminUser.comparePassword(password);
    if (!isMatch) {
      await adminUser.incLoginAttempts();
      return res.status(401).json({
        success: false,
        error: {
          message: 'Invalid credentials',
          code: 'INVALID_CREDENTIALS'
        }
      });
    }

    // Reset login attempts on successful login
    await adminUser.resetLoginAttempts();

    // Update last login
    adminUser.lastLoginAt = new Date();
    adminUser.lastLoginIp = req.ip;
    await adminUser.save();

    // Log activity
    await adminUser.logActivity('login', 'Admin user logged in', {
      ipAddress: req.ip,
      userAgent: req.get('User-Agent')
    });

    // Generate tokens
    const token = adminUser.generateAuthToken();
    const refreshToken = adminUser.generateRefreshToken();

    res.status(200).json({
      success: true,
      token,
      refreshToken,
      data: adminUser,
      expiresIn: process.env.JWT_EXPIRE || '7d'
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get admin dashboard data
// @route   GET /api/admin/dashboard
// @access  Private/Admin
router.get('/dashboard', adminAuth, async (req, res, next) => {
  try {
    // Get all statistics in parallel
    const [
      userStats,
      propertyStats,
      bookingStats,
      paymentStats,
      supportStats
    ] = await Promise.all([
      User.getUserStats(),
      Property.getPropertyStats(),
      Booking.getBookingStats(),
      Payment.getPaymentStats(),
      SupportTicket.getSupportTicketStats()
    ]);

    // Get recent activities
    const recentBookings = await Booking.find()
      .populate('user', 'firstName lastName')
      .populate('property', 'title')
      .sort({ createdAt: -1 })
      .limit(5);

    const recentUsers = await User.find()
      .select('firstName lastName email createdAt')
      .sort({ createdAt: -1 })
      .limit(5);

    const recentProperties = await Property.find()
      .populate('host', 'firstName lastName')
      .select('title location createdAt status')
      .sort({ createdAt: -1 })
      .limit(5);

    const dashboardData = {
      statistics: {
        users: userStats,
        properties: propertyStats,
        bookings: bookingStats,
        payments: paymentStats,
        support: supportStats
      },
      recentActivities: {
        bookings: recentBookings,
        users: recentUsers,
        properties: recentProperties
      },
      summary: {
        totalUsers: userStats.totalUsers,
        totalProperties: propertyStats.totalProperties,
        totalBookings: bookingStats.totalBookings,
        totalRevenue: paymentStats.totalAmount,
        activeSupportTickets: supportStats.openTickets + supportStats.inProgressTickets
      }
    };

    res.status(200).json({
      success: true,
      data: dashboardData
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get admin users
// @route   GET /api/admin/users
// @access  Private/Admin
router.get('/users', adminAuth, authorize('super_admin', 'admin'), async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const filter = {};

    if (req.query.role) {
      filter.role = req.query.role;
    }

    if (req.query.status) {
      filter.status = req.query.status;
    }

    if (req.query.department) {
      filter.department = req.query.department;
    }

    const adminUsers = await AdminUser.find(filter)
      .select('-password')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    const total = await AdminUser.countDocuments(filter);
    const totalPages = Math.ceil(total / limit);

    res.status(200).json({
      success: true,
      data: adminUsers,
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

// @desc    Create admin user
// @route   POST /api/admin/users
// @access  Private/Super Admin
router.post('/users', adminAuth, authorize('super_admin'), [
  body('firstName').trim().notEmpty().withMessage('First name is required'),
  body('lastName').trim().notEmpty().withMessage('Last name is required'),
  body('email').isEmail().normalizeEmail().withMessage('Please provide a valid email'),
  body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters'),
  body('role').isIn(['admin', 'moderator', 'support']).withMessage('Invalid role'),
  body('department').notEmpty().withMessage('Department is required')
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

    const { firstName, lastName, email, password, role, department, phoneNumber } = req.body;

    // Check if admin user already exists
    const existingAdmin = await AdminUser.findOne({ email });
    if (existingAdmin) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Admin user already exists with this email',
          code: 'ADMIN_EXISTS'
        }
      });
    }

    // Get default permissions for role
    const permissions = AdminUser.getRolePermissions(role);

    const adminUser = await AdminUser.create({
      firstName,
      lastName,
      email,
      password,
      role,
      department,
      phoneNumber,
      permissions
    });

    // Log activity
    await req.adminUser.logActivity('create_admin', `Created admin user: ${adminUser.email}`, {
      targetAdminId: adminUser._id,
      ipAddress: req.ip,
      userAgent: req.get('User-Agent')
    });

    res.status(201).json({
      success: true,
      data: adminUser
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Update admin user
// @route   PUT /api/admin/users/:id
// @access  Private/Super Admin
router.put('/users/:id', adminAuth, authorize('super_admin'), [
  body('firstName').optional().trim().notEmpty().withMessage('First name cannot be empty'),
  body('lastName').optional().trim().notEmpty().withMessage('Last name cannot be empty'),
  body('email').optional().isEmail().normalizeEmail().withMessage('Please provide a valid email'),
  body('role').optional().isIn(['admin', 'moderator', 'support']).withMessage('Invalid role'),
  body('department').optional().notEmpty().withMessage('Department cannot be empty'),
  body('status').optional().isIn(['active', 'inactive', 'suspended']).withMessage('Invalid status')
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

    const adminUser = await AdminUser.findById(req.params.id);
    if (!adminUser) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Admin user not found',
          code: 'ADMIN_NOT_FOUND'
        }
      });
    }

    // Prevent updating own account
    if (adminUser._id.toString() === req.adminUser.id) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Cannot update your own account',
          code: 'CANNOT_UPDATE_SELF'
        }
      });
    }

    const fieldsToUpdate = {
      firstName: req.body.firstName,
      lastName: req.body.lastName,
      email: req.body.email,
      role: req.body.role,
      department: req.body.department,
      status: req.body.status,
      phoneNumber: req.body.phoneNumber
    };

    // Remove undefined fields
    Object.keys(fieldsToUpdate).forEach(key => 
      fieldsToUpdate[key] === undefined && delete fieldsToUpdate[key]
    );

    // Update permissions if role changed
    if (req.body.role && req.body.role !== adminUser.role) {
      fieldsToUpdate.permissions = AdminUser.getRolePermissions(req.body.role);
    }

    const updatedAdminUser = await AdminUser.findByIdAndUpdate(req.params.id, fieldsToUpdate, {
      new: true,
      runValidators: true
    }).select('-password');

    // Log activity
    await req.adminUser.logActivity('update_admin', `Updated admin user: ${updatedAdminUser.email}`, {
      targetAdminId: updatedAdminUser._id,
      ipAddress: req.ip,
      userAgent: req.get('User-Agent')
    });

    res.status(200).json({
      success: true,
      data: updatedAdminUser
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Delete admin user
// @route   DELETE /api/admin/users/:id
// @access  Private/Super Admin
router.delete('/users/:id', adminAuth, authorize('super_admin'), async (req, res, next) => {
  try {
    const adminUser = await AdminUser.findById(req.params.id);
    if (!adminUser) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'Admin user not found',
          code: 'ADMIN_NOT_FOUND'
        }
      });
    }

    // Prevent deleting own account
    if (adminUser._id.toString() === req.adminUser.id) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Cannot delete your own account',
          code: 'CANNOT_DELETE_SELF'
        }
      });
    }

    await AdminUser.findByIdAndDelete(req.params.id);

    // Log activity
    await req.adminUser.logActivity('delete_admin', `Deleted admin user: ${adminUser.email}`, {
      targetAdminId: adminUser._id,
      ipAddress: req.ip,
      userAgent: req.get('User-Agent')
    });

    res.status(200).json({
      success: true,
      message: 'Admin user deleted successfully'
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get admin user statistics
// @route   GET /api/admin/users/stats
// @access  Private/Admin
router.get('/users/stats', adminAuth, requirePermission('analytics:read'), async (req, res, next) => {
  try {
    const stats = await AdminUser.getAdminUserStats();

    res.status(200).json({
      success: true,
      data: stats
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get current admin user
// @route   GET /api/admin/me
// @access  Private/Admin
router.get('/me', adminAuth, async (req, res, next) => {
  try {
    const adminUser = await AdminUser.findById(req.adminUser.id).select('-password');

    res.status(200).json({
      success: true,
      data: adminUser
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
