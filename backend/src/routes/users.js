const express = require('express');
const { body, validationResult } = require('express-validator');
const User = require('../models/User');
const { protect, adminAuth, authorize, requirePermission } = require('../middleware/auth');

const router = express.Router();

// @desc    Get all users (Admin only)
// @route   GET /api/users
// @access  Private/Admin
router.get('/', adminAuth, requirePermission('users:read'), async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;
    
    const filter = {};
    
    // Apply filters
    if (req.query.search) {
      filter.$or = [
        { firstName: { $regex: req.query.search, $options: 'i' } },
        { lastName: { $regex: req.query.search, $options: 'i' } },
        { email: { $regex: req.query.search, $options: 'i' } }
      ];
    }
    
    if (req.query.isVerified !== undefined) {
      filter.isVerified = req.query.isVerified === 'true';
    }
    
    if (req.query.isHost !== undefined) {
      filter.isHost = req.query.isHost === 'true';
    }
    
    if (req.query.isActive !== undefined) {
      filter.isActive = req.query.isActive === 'true';
    }
    
    if (req.query.isBlocked !== undefined) {
      filter.isBlocked = req.query.isBlocked === 'true';
    }

    const users = await User.find(filter)
      .select('-password')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    const total = await User.countDocuments(filter);
    const totalPages = Math.ceil(total / limit);

    res.status(200).json({
      success: true,
      data: users,
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

// @desc    Get user by ID
// @route   GET /api/users/:id
// @access  Private
router.get('/:id', protect, async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id).select('-password');

    if (!user) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'User not found',
          code: 'USER_NOT_FOUND'
        }
      });
    }

    // Users can only view their own profile unless they're admin
    if (user._id.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Not authorized to access this user',
          code: 'ACCESS_DENIED'
        }
      });
    }

    res.status(200).json({
      success: true,
      data: user
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Update user
// @route   PUT /api/users/:id
// @access  Private
router.put('/:id', protect, [
  body('firstName').optional().trim().notEmpty().withMessage('First name cannot be empty'),
  body('lastName').optional().trim().notEmpty().withMessage('Last name cannot be empty'),
  body('phone').optional().matches(/^\+?[\d\s-()]+$/).withMessage('Please provide a valid phone number'),
  body('dateOfBirth').optional().isISO8601().withMessage('Please provide a valid date of birth'),
  body('gender').optional().isIn(['male', 'female', 'other', 'prefer-not-to-say']).withMessage('Invalid gender')
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

    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'User not found',
          code: 'USER_NOT_FOUND'
        }
      });
    }

    // Users can only update their own profile unless they're admin
    if (user._id.toString() !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        error: {
          message: 'Not authorized to update this user',
          code: 'ACCESS_DENIED'
        }
      });
    }

    const fieldsToUpdate = {
      firstName: req.body.firstName,
      lastName: req.body.lastName,
      phone: req.body.phone,
      dateOfBirth: req.body.dateOfBirth ? new Date(req.body.dateOfBirth) : undefined,
      gender: req.body.gender,
      profileImage: req.body.profileImage
    };

    // Admin-only fields
    if (req.user.role === 'admin') {
      fieldsToUpdate.isVerified = req.body.isVerified;
      fieldsToUpdate.isHost = req.body.isHost;
      fieldsToUpdate.isActive = req.body.isActive;
      fieldsToUpdate.isBlocked = req.body.isBlocked;
    }

    // Remove undefined fields
    Object.keys(fieldsToUpdate).forEach(key => 
      fieldsToUpdate[key] === undefined && delete fieldsToUpdate[key]
    );

    const updatedUser = await User.findByIdAndUpdate(req.params.id, fieldsToUpdate, {
      new: true,
      runValidators: true
    }).select('-password');

    res.status(200).json({
      success: true,
      data: updatedUser
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Delete user (Admin only)
// @route   DELETE /api/users/:id
// @access  Private/Admin
router.delete('/:id', adminAuth, requirePermission('users:delete'), async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'User not found',
          code: 'USER_NOT_FOUND'
        }
      });
    }

    // Prevent admin from deleting themselves
    if (user._id.toString() === req.adminUser.id) {
      return res.status(400).json({
        success: false,
        error: {
          message: 'Cannot delete your own account',
          code: 'CANNOT_DELETE_SELF'
        }
      });
    }

    await User.findByIdAndDelete(req.params.id);

    res.status(200).json({
      success: true,
      message: 'User deleted successfully'
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Verify user (Admin only)
// @route   POST /api/users/:id/verify
// @access  Private/Admin
router.post('/:id/verify', adminAuth, requirePermission('users:write'), async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'User not found',
          code: 'USER_NOT_FOUND'
        }
      });
    }

    user.isVerified = !user.isVerified;
    await user.save();

    res.status(200).json({
      success: true,
      data: user,
      message: `User ${user.isVerified ? 'verified' : 'unverified'} successfully`
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Block/Unblock user (Admin only)
// @route   POST /api/users/:id/block
// @access  Private/Admin
router.post('/:id/block', adminAuth, requirePermission('users:write'), async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({
        success: false,
        error: {
          message: 'User not found',
          code: 'USER_NOT_FOUND'
        }
      });
    }

    user.isBlocked = !user.isBlocked;
    await user.save();

    res.status(200).json({
      success: true,
      data: user,
      message: `User ${user.isBlocked ? 'blocked' : 'unblocked'} successfully`
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get user statistics (Admin only)
// @route   GET /api/users/stats/overview
// @access  Private/Admin
router.get('/stats/overview', adminAuth, requirePermission('analytics:read'), async (req, res, next) => {
  try {
    const stats = await User.getUserStats();

    res.status(200).json({
      success: true,
      data: stats
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
