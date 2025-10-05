const express = require('express');
const User = require('../models/User');
const Property = require('../models/Property');
const Booking = require('../models/Booking');
const Payment = require('../models/Payment');
const Review = require('../models/Review');
const { adminAuth, requirePermission } = require('../middleware/auth');

const router = express.Router();

// @desc    Get analytics overview
// @route   GET /api/analytics/overview
// @access  Private/Admin
router.get('/overview', adminAuth, requirePermission('analytics:read'), async (req, res, next) => {
  try {
    // Get all statistics in parallel
    const [
      userStats,
      propertyStats,
      bookingStats,
      paymentStats,
      reviewStats
    ] = await Promise.all([
      User.getUserStats(),
      Property.getPropertyStats(),
      Booking.getBookingStats(),
      Payment.getPaymentStats(),
      Review.getReviewStats()
    ]);

    res.status(200).json({
      success: true,
      data: {
        users: userStats,
        properties: propertyStats,
        bookings: bookingStats,
        payments: paymentStats,
        reviews: reviewStats
      }
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get revenue analytics
// @route   GET /api/analytics/revenue
// @access  Private/Admin
router.get('/revenue', adminAuth, requirePermission('analytics:read'), async (req, res, next) => {
  try {
    const { period = 'month', limit = 12 } = req.query;

    let dateFilter = {};
    const now = new Date();

    switch (period) {
      case 'day':
        dateFilter = {
          $gte: new Date(now.getFullYear(), now.getMonth(), now.getDate() - parseInt(limit))
        };
        break;
      case 'week':
        dateFilter = {
          $gte: new Date(now.getTime() - (parseInt(limit) * 7 * 24 * 60 * 60 * 1000))
        };
        break;
      case 'month':
        dateFilter = {
          $gte: new Date(now.getFullYear(), now.getMonth() - parseInt(limit), 1)
        };
        break;
      case 'year':
        dateFilter = {
          $gte: new Date(now.getFullYear() - parseInt(limit), 0, 1)
        };
        break;
    }

    // Revenue over time
    const revenueData = await Payment.aggregate([
      {
        $match: {
          status: 'completed',
          'timeline.completedAt': dateFilter
        }
      },
      {
        $group: {
          _id: {
            $dateToString: {
              format: period === 'day' ? '%Y-%m-%d' : 
                     period === 'week' ? '%Y-%U' :
                     period === 'month' ? '%Y-%m' : '%Y',
              date: '$timeline.completedAt'
            }
          },
          revenue: { $sum: '$amount.total' },
          count: { $sum: 1 }
        }
      },
      { $sort: { _id: 1 } }
    ]);

    // Payment method distribution
    const paymentMethodData = await Payment.aggregate([
      {
        $match: {
          status: 'completed',
          'timeline.completedAt': dateFilter
        }
      },
      {
        $group: {
          _id: '$method.type',
          count: { $sum: 1 },
          revenue: { $sum: '$amount.total' }
        }
      }
    ]);

    // Top performing properties
    const topProperties = await Property.aggregate([
      {
        $lookup: {
          from: 'payments',
          localField: '_id',
          foreignField: 'property',
          as: 'payments'
        }
      },
      {
        $unwind: '$payments'
      },
      {
        $match: {
          'payments.status': 'completed',
          'payments.timeline.completedAt': dateFilter
        }
      },
      {
        $group: {
          _id: '$_id',
          title: { $first: '$title' },
          location: { $first: '$location' },
          revenue: { $sum: '$payments.amount.total' },
          bookings: { $sum: 1 }
        }
      },
      { $sort: { revenue: -1 } },
      { $limit: 10 }
    ]);

    res.status(200).json({
      success: true,
      data: {
        revenueOverTime: revenueData,
        paymentMethods: paymentMethodData,
        topProperties: topProperties
      }
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get user analytics
// @route   GET /api/analytics/users
// @access  Private/Admin
router.get('/users', adminAuth, requirePermission('analytics:read'), async (req, res, next) => {
  try {
    const { period = 'month', limit = 12 } = req.query;

    let dateFilter = {};
    const now = new Date();

    switch (period) {
      case 'day':
        dateFilter = {
          $gte: new Date(now.getFullYear(), now.getMonth(), now.getDate() - parseInt(limit))
        };
        break;
      case 'week':
        dateFilter = {
          $gte: new Date(now.getTime() - (parseInt(limit) * 7 * 24 * 60 * 60 * 1000))
        };
        break;
      case 'month':
        dateFilter = {
          $gte: new Date(now.getFullYear(), now.getMonth() - parseInt(limit), 1)
        };
        break;
      case 'year':
        dateFilter = {
          $gte: new Date(now.getFullYear() - parseInt(limit), 0, 1)
        };
        break;
    }

    // User registration over time
    const userRegistrationData = await User.aggregate([
      {
        $match: {
          createdAt: dateFilter
        }
      },
      {
        $group: {
          _id: {
            $dateToString: {
              format: period === 'day' ? '%Y-%m-%d' : 
                     period === 'week' ? '%Y-%U' :
                     period === 'month' ? '%Y-%m' : '%Y',
              date: '$createdAt'
            }
          },
          count: { $sum: 1 }
        }
      },
      { $sort: { _id: 1 } }
    ]);

    // User type distribution
    const userTypeData = await User.aggregate([
      {
        $group: {
          _id: {
            isHost: '$isHost',
            isVerified: '$isVerified',
            isActive: '$isActive'
          },
          count: { $sum: 1 }
        }
      }
    ]);

    // Top users by spending
    const topUsers = await User.aggregate([
      {
        $lookup: {
          from: 'payments',
          localField: '_id',
          foreignField: 'user',
          as: 'payments'
        }
      },
      {
        $unwind: '$payments'
      },
      {
        $match: {
          'payments.status': 'completed',
          'payments.timeline.completedAt': dateFilter
        }
      },
      {
        $group: {
          _id: '$_id',
          firstName: { $first: '$firstName' },
          lastName: { $first: '$lastName' },
          email: { $first: '$email' },
          totalSpent: { $sum: '$payments.amount.total' },
          bookings: { $sum: 1 }
        }
      },
      { $sort: { totalSpent: -1 } },
      { $limit: 10 }
    ]);

    res.status(200).json({
      success: true,
      data: {
        registrationOverTime: userRegistrationData,
        userTypes: userTypeData,
        topUsers: topUsers
      }
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Get booking analytics
// @route   GET /api/analytics/bookings
// @access  Private/Admin
router.get('/bookings', adminAuth, requirePermission('analytics:read'), async (req, res, next) => {
  try {
    const { period = 'month', limit = 12 } = req.query;

    let dateFilter = {};
    const now = new Date();

    switch (period) {
      case 'day':
        dateFilter = {
          $gte: new Date(now.getFullYear(), now.getMonth(), now.getDate() - parseInt(limit))
        };
        break;
      case 'week':
        dateFilter = {
          $gte: new Date(now.getTime() - (parseInt(limit) * 7 * 24 * 60 * 60 * 1000))
        };
        break;
      case 'month':
        dateFilter = {
          $gte: new Date(now.getFullYear(), now.getMonth() - parseInt(limit), 1)
        };
        break;
      case 'year':
        dateFilter = {
          $gte: new Date(now.getFullYear() - parseInt(limit), 0, 1)
        };
        break;
    }

    // Bookings over time
    const bookingData = await Booking.aggregate([
      {
        $match: {
          createdAt: dateFilter
        }
      },
      {
        $group: {
          _id: {
            $dateToString: {
              format: period === 'day' ? '%Y-%m-%d' : 
                     period === 'week' ? '%Y-%U' :
                     period === 'month' ? '%Y-%m' : '%Y',
              date: '$createdAt'
            }
          },
          count: { $sum: 1 },
          revenue: { $sum: '$pricing.totalAmount' }
        }
      },
      { $sort: { _id: 1 } }
    ]);

    // Booking status distribution
    const bookingStatusData = await Booking.aggregate([
      {
        $group: {
          _id: '$status',
          count: { $sum: 1 }
        }
      }
    ]);

    // Average booking duration
    const averageDuration = await Booking.aggregate([
      {
        $match: {
          createdAt: dateFilter
        }
      },
      {
        $group: {
          _id: null,
          averageNights: { $avg: '$dates.nights' }
        }
      }
    ]);

    res.status(200).json({
      success: true,
      data: {
        bookingsOverTime: bookingData,
        statusDistribution: bookingStatusData,
        averageDuration: averageDuration[0]?.averageNights || 0
      }
    });
  } catch (error) {
    next(error);
  }
});

// @desc    Export analytics data
// @route   GET /api/analytics/export
// @access  Private/Admin
router.get('/export', adminAuth, requirePermission('analytics:export'), async (req, res, next) => {
  try {
    const { type, format = 'json', startDate, endDate } = req.query;

    let dateFilter = {};
    if (startDate && endDate) {
      dateFilter = {
        $gte: new Date(startDate),
        $lte: new Date(endDate)
      };
    }

    let data = {};

    switch (type) {
      case 'users':
        data = await User.find(dateFilter).select('-password');
        break;
      case 'properties':
        data = await Property.find(dateFilter)
          .populate('host', 'firstName lastName email')
          .populate('category', 'name');
        break;
      case 'bookings':
        data = await Booking.find(dateFilter)
          .populate('user', 'firstName lastName email')
          .populate('property', 'title location')
          .populate('host', 'firstName lastName email');
        break;
      case 'payments':
        data = await Payment.find(dateFilter)
          .populate('user', 'firstName lastName email')
          .populate('property', 'title location');
        break;
      default:
        return res.status(400).json({
          success: false,
          error: {
            message: 'Invalid export type',
            code: 'INVALID_EXPORT_TYPE'
          }
        });
    }

    if (format === 'csv') {
      // Convert to CSV format
      const csv = convertToCSV(data);
      res.setHeader('Content-Type', 'text/csv');
      res.setHeader('Content-Disposition', `attachment; filename=${type}_export_${Date.now()}.csv`);
      return res.send(csv);
    }

    res.status(200).json({
      success: true,
      data: data,
      count: data.length,
      exportedAt: new Date().toISOString()
    });
  } catch (error) {
    next(error);
  }
});

// Helper function to convert data to CSV
function convertToCSV(data) {
  if (!data || data.length === 0) return '';

  const headers = Object.keys(data[0].toObject ? data[0].toObject() : data[0]);
  const csvHeaders = headers.join(',');
  
  const csvRows = data.map(row => {
    const obj = row.toObject ? row.toObject() : row;
    return headers.map(header => {
      const value = obj[header];
      if (value === null || value === undefined) return '';
      if (typeof value === 'object') return `"${JSON.stringify(value).replace(/"/g, '""')}"`;
      return `"${String(value).replace(/"/g, '""')}"`;
    }).join(',');
  });

  return [csvHeaders, ...csvRows].join('\n');
}

module.exports = router;
