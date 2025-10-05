# Airbnb Clone Backend API

A comprehensive backend API for the Airbnb Clone application and Admin Dashboard.

## Features

### Core Features
- **User Management**: Registration, authentication, profile management
- **Property Management**: CRUD operations for properties, categories, amenities
- **Booking System**: Complete booking lifecycle management
- **Payment Processing**: Integration with Stripe for secure payments
- **Admin Dashboard**: Full admin panel with analytics and management tools
- **Real-time Features**: Socket.io for live updates
- **File Upload**: Cloudinary integration for image management

### Security Features
- JWT-based authentication
- Role-based access control (RBAC)
- Rate limiting
- Input validation and sanitization
- CORS protection
- Helmet security headers

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB with Mongoose
- **Authentication**: JWT + bcryptjs
- **File Upload**: Cloudinary
- **Payments**: Stripe
- **Real-time**: Socket.io
- **Validation**: express-validator
- **Security**: helmet, cors, express-rate-limit

## API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/refresh` - Refresh token
- `POST /api/auth/logout` - User logout
- `POST /api/auth/forgot-password` - Password reset request
- `POST /api/auth/reset-password` - Password reset

### Users
- `GET /api/users` - Get all users (Admin)
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user (Admin)
- `POST /api/users/:id/verify` - Verify user (Admin)

### Properties
- `GET /api/properties` - Get all properties with filters
- `GET /api/properties/:id` - Get property by ID
- `POST /api/properties` - Create property (Host)
- `PUT /api/properties/:id` - Update property (Host/Admin)
- `DELETE /api/properties/:id` - Delete property (Host/Admin)
- `POST /api/properties/:id/images` - Upload property images

### Bookings
- `GET /api/bookings` - Get user bookings
- `GET /api/bookings/:id` - Get booking by ID
- `POST /api/bookings` - Create booking
- `PUT /api/bookings/:id` - Update booking
- `DELETE /api/bookings/:id` - Cancel booking

### Payments
- `POST /api/payments/create-intent` - Create payment intent
- `POST /api/payments/confirm` - Confirm payment
- `POST /api/payments/refund` - Process refund
- `GET /api/payments/:id` - Get payment details

### Admin
- `GET /api/admin/dashboard` - Dashboard analytics
- `GET /api/admin/users` - Admin user management
- `GET /api/admin/properties` - Admin property management
- `GET /api/admin/bookings` - Admin booking management
- `GET /api/admin/analytics` - Analytics data
- `GET /api/admin/support-tickets` - Support tickets

## Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   ```bash
   cp env.example .env
   # Edit .env with your configuration
   ```

4. Start the development server:
   ```bash
   npm run dev
   ```

## Database Setup

1. Make sure MongoDB is running
2. Run the seeder to populate sample data:
   ```bash
   npm run seed
   ```

## Environment Variables

See `env.example` for all required environment variables.

## API Documentation

The API follows RESTful conventions and returns JSON responses.

### Response Format

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

### Error Format

```json
{
  "success": false,
  "error": {
    "message": "Error message",
    "code": "ERROR_CODE",
    "details": {}
  }
}
```

## Testing

Run tests with:
```bash
npm test
```

## Deployment

The application is ready for deployment on platforms like:
- Heroku
- DigitalOcean
- AWS
- Google Cloud Platform

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License
