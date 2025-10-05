# Airbnb Clone Backend API Documentation

## Overview

This backend API provides comprehensive functionality for both the Airbnb Clone application and the Admin Dashboard. It includes user management, property listings, booking system, payment processing, analytics, and support ticket management.

## Base URL

```
http://localhost:5000/api
```

## Authentication

The API uses JWT (JSON Web Tokens) for authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your_jwt_token>
```

## API Endpoints

### Authentication

| Method | Endpoint | Description | Access |
|--------|----------|-------------|---------|
| POST | `/auth/register` | Register new user | Public |
| POST | `/auth/login` | User login | Public |
| POST | `/auth/logout` | User logout | Private |
| GET | `/auth/me` | Get current user | Private |
| PUT | `/auth/updatedetails` | Update user details | Private |
| PUT | `/auth/updatepassword` | Update password | Private |
| POST | `/auth/forgotpassword` | Request password reset | Public |
| PUT | `/auth/resetpassword/:token` | Reset password | Public |

### Users

| Method | Endpoint | Description | Access |
|--------|----------|-------------|---------|
| GET | `/users` | Get all users | Admin |
| GET | `/users/:id` | Get user by ID | Private |
| PUT | `/users/:id` | Update user | Private |
| DELETE | `/users/:id` | Delete user | Admin |
| POST | `/users/:id/verify` | Verify user | Admin |
| POST | `/users/:id/block` | Block/unblock user | Admin |
| GET | `/users/stats/overview` | Get user statistics | Admin |

### Properties

| Method | Endpoint | Description | Access |
|--------|----------|-------------|---------|
| GET | `/properties` | Get all properties | Public |
| GET | `/properties/:id` | Get property by ID | Public |
| POST | `/properties` | Create property | Private |
| PUT | `/properties/:id` | Update property | Private |
| DELETE | `/properties/:id` | Delete property | Private |
| GET | `/properties/categories` | Get property categories | Public |
| GET | `/properties/amenities` | Get amenities | Public |
| GET | `/properties/user/:userId` | Get user's properties | Private |
| POST | `/properties/:id/verify` | Verify property | Admin |
| GET | `/properties/stats/overview` | Get property statistics | Admin |

### Bookings

| Method | Endpoint | Description | Access |
|--------|----------|-------------|---------|
| GET | `/bookings` | Get user bookings | Private |
| GET | `/bookings/:id` | Get booking by ID | Private |
| POST | `/bookings` | Create booking | Private |
| PUT | `/bookings/:id/cancel` | Cancel booking | Private |
| GET | `/bookings/admin/all` | Get all bookings | Admin |
| GET | `/bookings/stats/overview` | Get booking statistics | Admin |

### Payments

| Method | Endpoint | Description | Access |
|--------|----------|-------------|---------|
| POST | `/payments/create-intent` | Create payment intent | Private |
| POST | `/payments/confirm` | Confirm payment | Private |
| POST | `/payments/refund` | Process refund | Admin |
| GET | `/payments/:id` | Get payment by ID | Private |
| GET | `/payments/admin/all` | Get all payments | Admin |
| GET | `/payments/stats/overview` | Get payment statistics | Admin |

### Admin

| Method | Endpoint | Description | Access |
|--------|----------|-------------|---------|
| POST | `/admin/login` | Admin login | Public |
| GET | `/admin/dashboard` | Get dashboard data | Admin |
| GET | `/admin/users` | Get admin users | Admin |
| POST | `/admin/users` | Create admin user | Super Admin |
| PUT | `/admin/users/:id` | Update admin user | Super Admin |
| DELETE | `/admin/users/:id` | Delete admin user | Super Admin |
| GET | `/admin/users/stats` | Get admin user statistics | Admin |
| GET | `/admin/me` | Get current admin user | Admin |

### Analytics

| Method | Endpoint | Description | Access |
|--------|----------|-------------|---------|
| GET | `/analytics/overview` | Get analytics overview | Admin |
| GET | `/analytics/revenue` | Get revenue analytics | Admin |
| GET | `/analytics/users` | Get user analytics | Admin |
| GET | `/analytics/bookings` | Get booking analytics | Admin |
| GET | `/analytics/export` | Export analytics data | Admin |

### Support

| Method | Endpoint | Description | Access |
|--------|----------|-------------|---------|
| GET | `/support/tickets` | Get user tickets | Private |
| GET | `/support/tickets/:id` | Get ticket by ID | Private |
| POST | `/support/tickets` | Create support ticket | Private |
| POST | `/support/tickets/:id/messages` | Add message to ticket | Private |
| GET | `/support/admin/tickets` | Get all tickets | Admin |
| POST | `/support/admin/tickets/:id/assign` | Assign ticket | Admin |
| POST | `/support/admin/tickets/:id/resolve` | Resolve ticket | Admin |
| POST | `/support/admin/tickets/:id/close` | Close ticket | Admin |
| GET | `/support/admin/stats` | Get support statistics | Admin |

## Response Format

### Success Response

```json
{
  "success": true,
  "data": {},
  "message": "Success message",
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 100,
    "pages": 10
  }
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "message": "Error message",
    "code": "ERROR_CODE",
    "details": []
  }
}
```

## Error Codes

| Code | Description |
|------|-------------|
| `VALIDATION_ERROR` | Input validation failed |
| `USER_NOT_FOUND` | User does not exist |
| `PROPERTY_NOT_FOUND` | Property does not exist |
| `BOOKING_NOT_FOUND` | Booking does not exist |
| `PAYMENT_NOT_FOUND` | Payment does not exist |
| `ACCESS_DENIED` | Insufficient permissions |
| `INVALID_CREDENTIALS` | Wrong email/password |
| `TOKEN_INVALID` | Invalid or expired token |
| `ACCOUNT_LOCKED` | Account temporarily locked |
| `ACCOUNT_BLOCKED` | Account is blocked |

## Sample Data

The backend includes sample data for testing:

### Test Accounts

**Admin Users:**
- Super Admin: `admin@airbnbclone.com` / `admin123`
- Support Staff: `support@airbnbclone.com` / `support123`
- Moderator: `moderator@airbnbclone.com` / `moderator123`

**Regular Users:**
- Host: `john.doe@example.com` / `password123`
- Guest: `jane.smith@example.com` / `password123`

### Sample Data Includes

- 5 Users (3 hosts, 2 guests)
- 3 Admin Users (different roles)
- 6 Property Categories
- 15 Amenities
- 20 Properties
- 50 Bookings
- 40 Payments
- 100 Reviews
- 20 Support Tickets

## Getting Started

1. **Install Dependencies:**
   ```bash
   npm install
   ```

2. **Setup Environment:**
   ```bash
   cp env.example .env
   # Edit .env with your configuration
   ```

3. **Start MongoDB:**
   ```bash
   mongod
   ```

4. **Seed Database (Optional):**
   ```bash
   npm run seed
   ```

5. **Start Server:**
   ```bash
   npm run dev
   ```

## Features

### Core Features
- ✅ User Registration & Authentication
- ✅ Property Management (CRUD)
- ✅ Booking System
- ✅ Payment Processing (Stripe integration ready)
- ✅ Review System
- ✅ Admin Dashboard
- ✅ Analytics & Reporting
- ✅ Support Ticket System

### Security Features
- ✅ JWT Authentication
- ✅ Role-based Access Control (RBAC)
- ✅ Rate Limiting
- ✅ Input Validation
- ✅ Password Hashing (bcrypt)
- ✅ Account Lockout Protection
- ✅ CORS Protection

### Admin Features
- ✅ User Management
- ✅ Property Verification
- ✅ Booking Management
- ✅ Payment Processing
- ✅ Analytics Dashboard
- ✅ Support Ticket Management
- ✅ Admin User Management

## Technology Stack

- **Runtime:** Node.js 18+
- **Framework:** Express.js
- **Database:** MongoDB with Mongoose
- **Authentication:** JWT + bcryptjs
- **Validation:** express-validator
- **Security:** helmet, cors, express-rate-limit
- **File Upload:** Cloudinary (ready for integration)
- **Payments:** Stripe (ready for integration)
- **Real-time:** Socket.io

## Database Schema

The backend uses MongoDB with the following main collections:

- `users` - User accounts
- `adminusers` - Admin accounts
- `properties` - Property listings
- `propertycategories` - Property categories
- `amenities` - Property amenities
- `bookings` - Booking records
- `payments` - Payment records
- `reviews` - Property reviews
- `supporttickets` - Support tickets

## API Rate Limits

- **General:** 100 requests per 15 minutes per IP
- **Authentication:** 5 login attempts per IP per 15 minutes
- **File Upload:** 10MB max file size

## WebSocket Events

The API includes Socket.io for real-time features:

- `join-room` - Join a room (e.g., property, booking)
- `leave-room` - Leave a room
- Real-time notifications for bookings, payments, support tickets

## Deployment

The backend is ready for deployment on:
- Heroku
- DigitalOcean
- AWS
- Google Cloud Platform
- Any Node.js hosting platform

## Support

For support or questions about the API, please refer to the main README.md file or create a support ticket through the application.
