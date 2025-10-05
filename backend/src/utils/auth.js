const jwt = require('jsonwebtoken');
const crypto = require('crypto');

// Generate JWT token
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE || '7d',
  });
};

// Generate refresh token
const generateRefreshToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_REFRESH_SECRET, {
    expiresIn: process.env.JWT_REFRESH_EXPIRE || '30d',
  });
};

// Send token response
const sendTokenResponse = (user, statusCode, res) => {
  // Create token
  const token = generateToken(user._id);
  const refreshToken = generateRefreshToken(user._id);

  const options = {
    expires: new Date(
      Date.now() + (process.env.JWT_COOKIE_EXPIRE || 7) * 24 * 60 * 60 * 1000,
    ),
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict'
  };

  res
    .status(statusCode)
    .cookie('token', token, options)
    .json({
      success: true,
      token,
      refreshToken,
      data: user,
      expiresIn: process.env.JWT_EXPIRE || '7d'
    });
};

// Generate reset token
const generateResetToken = () => {
  return crypto.randomBytes(20).toString('hex');
};

// Hash reset token
const hashResetToken = (token) => {
  return crypto.createHash('sha256').update(token).digest('hex');
};

// Generate email verification token
const generateEmailVerificationToken = () => {
  return crypto.randomBytes(32).toString('hex');
};

// Verify JWT token
const verifyToken = (token) => {
  try {
    return jwt.verify(token, process.env.JWT_SECRET);
  } catch (error) {
    throw new Error('Invalid token');
  }
};

// Verify refresh token
const verifyRefreshToken = (token) => {
  try {
    return jwt.verify(token, process.env.JWT_REFRESH_SECRET);
  } catch (error) {
    throw new Error('Invalid refresh token');
  }
};

// Generate two-factor authentication secret
const generate2FASecret = () => {
  return crypto.randomBytes(32).toString('base64');
};

// Generate two-factor authentication backup codes
const generate2FABackupCodes = (count = 10) => {
  const codes = [];
  for (let i = 0; i < count; i++) {
    codes.push(crypto.randomBytes(4).toString('hex').toUpperCase());
  }
  return codes;
};

module.exports = {
  generateToken,
  generateRefreshToken,
  sendTokenResponse,
  generateResetToken,
  hashResetToken,
  generateEmailVerificationToken,
  verifyToken,
  verifyRefreshToken,
  generate2FASecret,
  generate2FABackupCodes
};
