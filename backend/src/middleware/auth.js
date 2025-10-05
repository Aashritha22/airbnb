const jwt = require('jsonwebtoken');
const User = require('../models/User');
const AdminUser = require('../models/AdminUser');

// Protect routes - require authentication
const protect = async (req, res, next) => {
  let token;

  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      // Get token from header
      token = req.headers.authorization.split(' ')[1];

      // Verify token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Get user from the token
      req.user = await User.findById(decoded.id).select('-password');

      if (!req.user) {
        return res.status(401).json({
          success: false,
          error: {
            message: 'Not authorized, user not found',
            code: 'USER_NOT_FOUND'
          }
        });
      }

      // Check if user is active
      if (!req.user.isActive) {
        return res.status(401).json({
          success: false,
          error: {
            message: 'Account is deactivated',
            code: 'ACCOUNT_DEACTIVATED'
          }
        });
      }

      // Check if user is blocked
      if (req.user.isBlocked) {
        return res.status(401).json({
          success: false,
          error: {
            message: 'Account is blocked',
            code: 'ACCOUNT_BLOCKED'
          }
        });
      }

      next();
    } catch (error) {
      console.error('Auth middleware error:', error);
      return res.status(401).json({
        success: false,
        error: {
          message: 'Not authorized, token failed',
          code: 'TOKEN_INVALID'
        }
      });
    }
  }

  if (!token) {
    return res.status(401).json({
      success: false,
      error: {
        message: 'Not authorized, no token',
        code: 'NO_TOKEN'
      }
    });
  }
};

// Admin authentication
const adminAuth = async (req, res, next) => {
  let token;

  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      token = req.headers.authorization.split(' ')[1];
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      req.adminUser = await AdminUser.findById(decoded.id).select('-password');

      if (!req.adminUser) {
        return res.status(401).json({
          success: false,
          error: {
            message: 'Not authorized, admin user not found',
            code: 'ADMIN_NOT_FOUND'
          }
        });
      }

      if (req.adminUser.status !== 'active') {
        return res.status(401).json({
          success: false,
          error: {
            message: 'Admin account is not active',
            code: 'ADMIN_INACTIVE'
          }
        });
      }

      next();
    } catch (error) {
      console.error('Admin auth middleware error:', error);
      return res.status(401).json({
        success: false,
        error: {
          message: 'Not authorized, admin token failed',
          code: 'ADMIN_TOKEN_INVALID'
        }
      });
    }
  }

  if (!token) {
    return res.status(401).json({
      success: false,
      error: {
        message: 'Not authorized, no admin token',
        code: 'NO_ADMIN_TOKEN'
      }
    });
  }
};

// Role-based authorization
const authorize = (...roles) => {
  return (req, res, next) => {
    if (!req.adminUser) {
      return res.status(401).json({
        success: false,
        error: {
          message: 'Not authorized',
          code: 'NOT_AUTHORIZED'
        }
      });
    }

    if (!roles.includes(req.adminUser.role)) {
      return res.status(403).json({
        success: false,
        error: {
          message: `User role ${req.adminUser.role} is not authorized to access this resource`,
          code: 'INSUFFICIENT_PERMISSIONS'
        }
      });
    }

    next();
  };
};

// Permission-based authorization
const requirePermission = (permission) => {
  return (req, res, next) => {
    if (!req.adminUser) {
      return res.status(401).json({
        success: false,
        error: {
          message: 'Not authorized',
          code: 'NOT_AUTHORIZED'
        }
      });
    }

    if (!req.adminUser.hasPermission(permission)) {
      return res.status(403).json({
        success: false,
        error: {
          message: `Insufficient permissions. Required: ${permission}`,
          code: 'INSUFFICIENT_PERMISSIONS'
        }
      });
    }

    next();
  };
};

// Optional authentication (doesn't fail if no token)
const optionalAuth = async (req, res, next) => {
  let token;

  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      token = req.headers.authorization.split(' ')[1];
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      req.user = await User.findById(decoded.id).select('-password');
    } catch (error) {
      // Ignore token errors for optional auth
      console.log('Optional auth token error:', error.message);
    }
  }

  next();
};

// Check if user owns resource
const checkOwnership = (model, paramName = 'id') => {
  return async (req, res, next) => {
    try {
      const resourceId = req.params[paramName];
      const resource = await model.findById(resourceId);

      if (!resource) {
        return res.status(404).json({
          success: false,
          error: {
            message: 'Resource not found',
            code: 'RESOURCE_NOT_FOUND'
          }
        });
      }

      // Check if user owns the resource or is admin
      const isOwner = resource.user && resource.user.toString() === req.user.id.toString();
      const isHost = resource.host && resource.host.toString() === req.user.id.toString();
      const isAdmin = req.adminUser;

      if (!isOwner && !isHost && !isAdmin) {
        return res.status(403).json({
          success: false,
          error: {
            message: 'Not authorized to access this resource',
            code: 'ACCESS_DENIED'
          }
        });
      }

      req.resource = resource;
      next();
    } catch (error) {
      return res.status(500).json({
        success: false,
        error: {
          message: 'Error checking ownership',
          code: 'OWNERSHIP_CHECK_ERROR'
        }
      });
    }
  };
};

module.exports = {
  protect,
  adminAuth,
  authorize,
  requirePermission,
  optionalAuth,
  checkOwnership
};
