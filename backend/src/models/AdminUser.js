const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const adminUserSchema = new mongoose.Schema({
  firstName: {
    type: String,
    required: [true, 'First name is required'],
    trim: true,
    maxlength: [50, 'First name cannot be more than 50 characters']
  },
  lastName: {
    type: String,
    required: [true, 'Last name is required'],
    trim: true,
    maxlength: [50, 'Last name cannot be more than 50 characters']
  },
  email: {
    type: String,
    required: [true, 'Email is required'],
    unique: true,
    lowercase: true,
    match: [/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/, 'Please enter a valid email']
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
    minlength: [8, 'Password must be at least 8 characters'],
    select: false
  },
  phoneNumber: {
    type: String,
    match: [/^\+?[\d\s-()]+$/, 'Please enter a valid phone number']
  },
  role: {
    type: String,
    enum: ['super_admin', 'admin', 'moderator', 'support'],
    required: [true, 'Role is required'],
    default: 'support'
  },
  department: {
    type: String,
    enum: ['IT', 'Customer Support', 'Content', 'Finance', 'Marketing', 'Operations'],
    required: [true, 'Department is required']
  },
  status: {
    type: String,
    enum: ['active', 'inactive', 'suspended'],
    default: 'active'
  },
  profileImage: {
    type: String,
    default: null
  },
  permissions: [{
    type: String,
    enum: [
      'users:read', 'users:write', 'users:delete',
      'properties:read', 'properties:write', 'properties:delete', 'properties:verify',
      'bookings:read', 'bookings:write', 'bookings:cancel',
      'payments:read', 'payments:refund',
      'analytics:read', 'analytics:export',
      'admin_users:read', 'admin_users:write', 'admin_users:delete',
      'support_tickets:read', 'support_tickets:write', 'support_tickets:close',
      'system_settings:read', 'system_settings:write'
    ]
  }],
  twoFactorEnabled: {
    type: Boolean,
    default: false
  },
  twoFactorSecret: {
    type: String,
    select: false
  },
  twoFactorBackupCodes: [{
    type: String,
    select: false
  }],
  lastLoginAt: {
    type: Date,
    default: Date.now
  },
  lastLoginIp: String,
  loginAttempts: {
    type: Number,
    default: 0
  },
  lockUntil: Date,
  passwordChangedAt: Date,
  passwordResetToken: String,
  passwordResetExpires: Date,
  emailVerificationToken: String,
  emailVerificationExpires: Date,
  isEmailVerified: {
    type: Boolean,
    default: false
  },
  preferences: {
    notifications: {
      email: { type: Boolean, default: true },
      push: { type: Boolean, default: true },
      dashboard: { type: Boolean, default: true }
    },
    language: { type: String, default: 'en' },
    timezone: { type: String, default: 'UTC' },
    theme: { type: String, enum: ['light', 'dark', 'auto'], default: 'light' }
  },
  activityLog: [{
    action: {
      type: String,
      required: true
    },
    description: String,
    ipAddress: String,
    userAgent: String,
    timestamp: { type: Date, default: Date.now },
    metadata: mongoose.Schema.Types.Mixed
  }]
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Virtual for full name
adminUserSchema.virtual('fullName').get(function() {
  return `${this.firstName} ${this.lastName}`;
});

// Virtual for account locked status
adminUserSchema.virtual('isLocked').get(function() {
  return !!(this.lockUntil && this.lockUntil > Date.now());
});

// Virtual for role display name
adminUserSchema.virtual('roleDisplay').get(function() {
  const roleMap = {
    'super_admin': 'Super Admin',
    'admin': 'Admin',
    'moderator': 'Moderator',
    'support': 'Support'
  };
  return roleMap[this.role] || this.role;
});

// Virtual for status display name
adminUserSchema.virtual('statusDisplay').get(function() {
  const statusMap = {
    'active': 'Active',
    'inactive': 'Inactive',
    'suspended': 'Suspended'
  };
  return statusMap[this.status] || this.status;
});

// Indexes for better query performance
adminUserSchema.index({ email: 1 });
adminUserSchema.index({ role: 1, status: 1 });
adminUserSchema.index({ department: 1 });
adminUserSchema.index({ createdAt: -1 });

// Pre-save middleware to hash password
adminUserSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  
  const saltRounds = parseInt(process.env.BCRYPT_ROUNDS) || 12;
  this.password = await bcrypt.hash(this.password, saltRounds);
  this.passwordChangedAt = new Date();
  next();
});

// Method to compare password
adminUserSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

// Method to generate JWT token
adminUserSchema.methods.generateAuthToken = function() {
  return jwt.sign(
    { 
      id: this._id, 
      email: this.email, 
      role: this.role,
      permissions: this.permissions
    },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRE || '7d' }
  );
};

// Method to generate refresh token
adminUserSchema.methods.generateRefreshToken = function() {
  return jwt.sign(
    { id: this._id, role: 'admin' },
    process.env.JWT_REFRESH_SECRET,
    { expiresIn: process.env.JWT_REFRESH_EXPIRE || '30d' }
  );
};

// Method to check permission
adminUserSchema.methods.hasPermission = function(permission) {
  if (this.role === 'super_admin') return true;
  return this.permissions.includes(permission);
};

// Method to increment login attempts
adminUserSchema.methods.incLoginAttempts = function() {
  // If we have a previous lock that has expired, restart at 1
  if (this.lockUntil && this.lockUntil < Date.now()) {
    return this.updateOne({
      $unset: { lockUntil: 1 },
      $set: { loginAttempts: 1 }
    });
  }
  
  const updates = { $inc: { loginAttempts: 1 } };
  
  // Lock account after 5 failed attempts for 2 hours
  if (this.loginAttempts + 1 >= 5 && !this.isLocked) {
    updates.$set = { lockUntil: Date.now() + 2 * 60 * 60 * 1000 }; // 2 hours
  }
  
  return this.updateOne(updates);
};

// Method to reset login attempts
adminUserSchema.methods.resetLoginAttempts = function() {
  return this.updateOne({
    $unset: { loginAttempts: 1, lockUntil: 1 }
  });
};

// Method to log activity
adminUserSchema.methods.logActivity = function(action, description, metadata = {}) {
  this.activityLog.push({
    action,
    description,
    ipAddress: metadata.ipAddress,
    userAgent: metadata.userAgent,
    metadata
  });
  
  // Keep only last 100 activity logs
  if (this.activityLog.length > 100) {
    this.activityLog = this.activityLog.slice(-100);
  }
  
  return this.save();
};

// Static method to get admin user stats
adminUserSchema.statics.getAdminUserStats = async function() {
  const stats = await this.aggregate([
    {
      $group: {
        _id: null,
        totalAdmins: { $sum: 1 },
        activeAdmins: { $sum: { $cond: [{ $eq: ['$status', 'active'] }, 1, 0] } },
        inactiveAdmins: { $sum: { $cond: [{ $eq: ['$status', 'inactive'] }, 1, 0] } },
        suspendedAdmins: { $sum: { $cond: [{ $eq: ['$status', 'suspended'] }, 1, 0] } },
        superAdmins: { $sum: { $cond: [{ $eq: ['$role', 'super_admin'] }, 1, 0] } },
        regularAdmins: { $sum: { $cond: [{ $eq: ['$role', 'admin'] }, 1, 0] } },
        supportStaff: { $sum: { $cond: [{ $eq: ['$role', 'support'] }, 1, 0] } },
        moderators: { $sum: { $cond: [{ $eq: ['$role', 'moderator'] }, 1, 0] } }
      }
    }
  ]);
  
  return {
    totalAdmins: stats[0]?.totalAdmins || 0,
    activeAdmins: stats[0]?.activeAdmins || 0,
    inactiveAdmins: stats[0]?.inactiveAdmins || 0,
    suspendedAdmins: stats[0]?.suspendedAdmins || 0,
    superAdmins: stats[0]?.superAdmins || 0,
    regularAdmins: stats[0]?.regularAdmins || 0,
    supportStaff: stats[0]?.supportStaff || 0,
    moderators: stats[0]?.moderators || 0
  };
};

// Static method to get role permissions
adminUserSchema.statics.getRolePermissions = function(role) {
  const rolePermissions = {
    'super_admin': [
      'users:read', 'users:write', 'users:delete',
      'properties:read', 'properties:write', 'properties:delete', 'properties:verify',
      'bookings:read', 'bookings:write', 'bookings:cancel',
      'payments:read', 'payments:refund',
      'analytics:read', 'analytics:export',
      'admin_users:read', 'admin_users:write', 'admin_users:delete',
      'support_tickets:read', 'support_tickets:write', 'support_tickets:close',
      'system_settings:read', 'system_settings:write'
    ],
    'admin': [
      'users:read', 'users:write',
      'properties:read', 'properties:write', 'properties:verify',
      'bookings:read', 'bookings:write', 'bookings:cancel',
      'payments:read', 'payments:refund',
      'analytics:read', 'analytics:export',
      'admin_users:read',
      'support_tickets:read', 'support_tickets:write', 'support_tickets:close'
    ],
    'moderator': [
      'users:read',
      'properties:read', 'properties:write', 'properties:verify',
      'bookings:read',
      'analytics:read',
      'support_tickets:read', 'support_tickets:write'
    ],
    'support': [
      'users:read',
      'properties:read',
      'bookings:read',
      'support_tickets:read', 'support_tickets:write'
    ]
  };
  
  return rolePermissions[role] || [];
};

module.exports = mongoose.model('AdminUser', adminUserSchema);
