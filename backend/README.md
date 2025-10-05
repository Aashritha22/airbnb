# 🔧 Backend API - Airbnb Clone

A comprehensive Node.js backend API for the Airbnb Clone platform, featuring RESTful endpoints, MongoDB integration, JWT authentication, and comprehensive data management.

## ✨ Features

### 🔐 Authentication & Authorization
- **JWT Authentication**: Secure token-based authentication
- **Role-based Access Control**: Different permission levels for users and admins
- **Password Security**: Bcrypt password hashing
- **Session Management**: Secure session handling
- **Password Reset**: Email-based password reset functionality

### 🏠 Property Management
- **Property CRUD**: Create, read, update, delete properties
- **Property Categories**: Manage property categories and types
- **Amenities**: Property amenities and features
- **Image Management**: Property image handling
- **Search & Filters**: Advanced property search with multiple filters
- **Location Services**: Geographic search and filtering

### 👥 User Management
- **User Registration**: User account creation
- **User Profiles**: Complete user profile management
- **User Verification**: Account verification system
- **User Statistics**: User analytics and metrics
- **Admin User Management**: Admin account management

### 📅 Booking System
- **Booking Creation**: Create property bookings
- **Booking Management**: Update and cancel bookings
- **Booking Status**: Track booking statuses
- **Availability**: Check property availability
- **Booking Analytics**: Booking statistics and trends

### 💳 Payment Processing
- **Payment Intent**: Create payment intents
- **Payment Confirmation**: Confirm payment transactions
- **Refund Processing**: Process refunds for cancellations
- **Payment Analytics**: Payment statistics and reports
- **Multiple Payment Methods**: Support for various payment options

### 🎫 Support System
- **Support Tickets**: Create and manage support tickets
- **Ticket Assignment**: Assign tickets to support staff
- **Ticket Resolution**: Track and resolve support issues
- **Message System**: Communication within tickets
- **Support Analytics**: Support performance metrics

### 📊 Analytics & Reporting
- **Revenue Analytics**: Financial performance tracking
- **User Analytics**: User behavior and growth metrics
- **Booking Analytics**: Booking patterns and trends
- **Property Analytics**: Property performance metrics
- **Custom Reports**: Generate custom analytics reports

### 🔒 Security Features
- **Rate Limiting**: API rate limiting for security
- **CORS Support**: Cross-origin resource sharing
- **Input Validation**: Comprehensive input validation
- **Data Sanitization**: MongoDB injection prevention
- **XSS Protection**: Cross-site scripting prevention
- **Security Headers**: Helmet.js security headers

## 🛠 Tech Stack

### Core Technologies
- **Node.js**: JavaScript runtime environment
- **Express.js**: Web application framework
- **MongoDB**: NoSQL database
- **Mongoose**: MongoDB object modeling

### Authentication & Security
- **JWT**: JSON Web Token authentication
- **Bcrypt**: Password hashing
- **Helmet**: Security middleware
- **Express Rate Limit**: API rate limiting
- **Express Mongo Sanitize**: MongoDB injection prevention
- **XSS Clean**: XSS protection

### Development Tools
- **Nodemon**: Development server auto-restart
- **Morgan**: HTTP request logger
- **Dotenv**: Environment variable management

## 🚀 Getting Started

### Prerequisites
- Node.js (v18 or higher)
- MongoDB (v4.4 or higher)
- npm or yarn package manager

### Installation

1. **Navigate to the project directory**
   ```bash
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment Configuration**
   ```bash
   cp env.example .env
   ```
   
   Edit `.env` with your configuration:
   ```env
   # Server Configuration
   PORT=5000
   NODE_ENV=development
   
   # Database Configuration
   MONGODB_URI=mongodb://localhost:27017/airbnb_clone
   
   # JWT Configuration
   JWT_SECRET=your_super_secret_jwt_key_here
   JWT_EXPIRE=7d
   
   # CORS Configuration
   FRONTEND_URL=http://localhost:3000
   ADMIN_URL=http://localhost:3001
   ```

4. **Start MongoDB**
   ```bash
   # macOS (using Homebrew)
   brew services start mongodb-community
   
   # Ubuntu/Debian
   sudo systemctl start mongod
   
   # Windows
   # Start MongoDB service from Services panel
   ```

5. **Seed the database**
   ```bash
   npm run seed
   ```

6. **Start the development server**
   ```bash
   npm run dev
   ```

The API will be available at `http://localhost:5000`

## 📁 Project Structure

```
src/
├── server.js                 # Main server file
├── models/                   # Database models
│   ├── User.js              # User model
│   ├── AdminUser.js         # Admin user model
│   ├── Property.js          # Property model
│   ├── Booking.js           # Booking model
│   ├── Payment.js           # Payment model
│   ├── Review.js            # Review model
│   ├── SupportTicket.js     # Support ticket model
│   ├── PropertyCategory.js  # Property category model
│   └── Amenity.js           # Amenity model
├── routes/                   # API routes
│   ├── auth.js              # Authentication routes
│   ├── users.js             # User management routes
│   ├── properties.js        # Property management routes
│   ├── bookings.js          # Booking management routes
│   ├── payments.js          # Payment processing routes
│   ├── admin.js             # Admin-specific routes
│   ├── analytics.js         # Analytics routes
│   └── support.js           # Support ticket routes
├── middleware/               # Custom middleware
│   ├── auth.js              # Authentication middleware
│   └── errorHandler.js      # Error handling middleware
├── utils/                    # Utility functions
│   └── auth.js              # Authentication utilities
└── database/                 # Database configuration
    ├── connection.js        # MongoDB connection
    └── seed.js              # Database seeding script
```

## 🔌 API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/forgot-password` - Request password reset
- `POST /api/auth/reset-password` - Reset password
- `GET /api/auth/me` - Get current user
- `POST /api/auth/logout` - User logout

### Admin Authentication
- `POST /api/admin/login` - Admin login
- `POST /api/admin/logout` - Admin logout
- `GET /api/admin/me` - Get current admin

### Properties
- `GET /api/properties` - Get all properties (with filters)
- `GET /api/properties/:id` - Get property by ID
- `POST /api/properties` - Create property (authenticated)
- `PUT /api/properties/:id` - Update property (authenticated)
- `DELETE /api/properties/:id` - Delete property (authenticated)
- `GET /api/properties/categories` - Get property categories
- `GET /api/properties/amenities` - Get amenities

### Users
- `GET /api/users` - Get all users (admin only)
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user (authenticated)
- `DELETE /api/users/:id` - Delete user (admin only)
- `POST /api/users/:id/verify` - Verify user (admin only)
- `POST /api/users/:id/block` - Block user (admin only)

### Bookings
- `GET /api/bookings` - Get user bookings (authenticated)
- `GET /api/bookings/:id` - Get booking by ID
- `POST /api/bookings` - Create booking (authenticated)
- `PUT /api/bookings/:id` - Update booking (authenticated)
- `PUT /api/bookings/:id/cancel` - Cancel booking (authenticated)

### Payments
- `GET /api/payments` - Get user payments (authenticated)
- `POST /api/payments/create-intent` - Create payment intent
- `POST /api/payments/confirm` - Confirm payment
- `POST /api/payments/refund` - Process refund (admin only)

### Admin Routes
- `GET /api/admin/dashboard` - Dashboard data
- `GET /api/admin/users` - Get all users
- `GET /api/admin/properties` - Get all properties
- `GET /api/admin/bookings` - Get all bookings
- `GET /api/admin/payments` - Get all payments

### Analytics
- `GET /api/analytics/overview` - Analytics overview
- `GET /api/analytics/revenue` - Revenue analytics
- `GET /api/analytics/users` - User analytics
- `GET /api/analytics/bookings` - Booking analytics

### Support
- `GET /api/support/tickets` - Get user support tickets
- `POST /api/support/tickets` - Create support ticket
- `GET /api/support/tickets/:id` - Get ticket details
- `POST /api/support/tickets/:id/messages` - Add message to ticket

For complete API documentation, see [API_DOCUMENTATION.md](API_DOCUMENTATION.md)

## 🗄 Database Schema

### Collections Overview
- **Users**: User accounts and profiles
- **AdminUsers**: Admin accounts with permissions
- **Properties**: Property listings and details
- **Bookings**: Reservation data
- **Payments**: Payment transactions
- **Reviews**: Property reviews and ratings
- **SupportTickets**: Customer support tickets
- **PropertyCategories**: Property categories
- **Amenities**: Property amenities

### Sample Data
The database is seeded with comprehensive sample data:
- 5 Users (3 hosts, 2 guests)
- 3 Admin Users (different roles and permissions)
- 6 Property Categories (Beach, City, Mountain, etc.)
- 15 Amenities (WiFi, Pool, Kitchen, etc.)
- 20 Properties with realistic data and images
- 50 Bookings with various statuses
- 40 Payments with different methods and statuses
- 9 Reviews with ratings and comments
- 20 Support Tickets with messages and assignments

## 🔑 Test Accounts

### Admin Accounts
- **Super Admin**: `admin@airbnbclone.com` / `admin123`
- **Support Staff**: `support@airbnbclone.com` / `support123`
- **Moderator**: `moderator@airbnbclone.com` / `moderator123`

### User Accounts
- **Host**: `john.doe@example.com` / `password123`
- **Guest**: `jane.smith@example.com` / `password123`

## 🛠 Development

### Available Scripts
```bash
npm start          # Start production server
npm run dev        # Start development server with nodemon
npm run seed       # Seed database with sample data
npm test           # Run tests (when implemented)
```

### Environment Variables
Create a `.env` file with the following variables:
```env
# Server Configuration
PORT=5000
NODE_ENV=development

# Database Configuration
MONGODB_URI=mongodb://localhost:27017/airbnb_clone

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key_here
JWT_EXPIRE=7d

# CORS Configuration
FRONTEND_URL=http://localhost:3000
ADMIN_URL=http://localhost:3001

# Email Configuration (for password reset)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_app_password
```

### Database Seeding
The database seeding script creates comprehensive sample data:
```bash
npm run seed
```

This will:
1. Clear existing data
2. Create property categories and amenities
3. Create sample users and admin users
4. Create sample properties with realistic data
5. Create sample bookings and payments
6. Create sample reviews and support tickets

## 🔒 Security Features

### Authentication Security
- **JWT Tokens**: Secure token-based authentication
- **Password Hashing**: Bcrypt with salt rounds
- **Token Expiration**: Configurable token expiration
- **Secure Headers**: Helmet.js security headers

### API Security
- **Rate Limiting**: 100 requests per 15 minutes per IP
- **Input Validation**: Comprehensive input validation
- **Data Sanitization**: MongoDB injection prevention
- **XSS Protection**: Cross-site scripting prevention
- **CORS Configuration**: Controlled cross-origin requests

### Data Protection
- **Environment Variables**: Sensitive data in environment variables
- **Error Handling**: Secure error messages
- **Input Sanitization**: All inputs sanitized and validated
- **Password Security**: Strong password requirements

## 📊 Performance

### Optimizations
- **Database Indexing**: Optimized MongoDB indexes
- **Query Optimization**: Efficient database queries
- **Caching**: Response caching where appropriate
- **Compression**: Response compression
- **Rate Limiting**: API rate limiting for performance

### Monitoring
- **Request Logging**: Morgan HTTP request logging
- **Error Tracking**: Comprehensive error handling
- **Performance Metrics**: Response time monitoring
- **Database Monitoring**: MongoDB query performance

## 🐛 Troubleshooting

### Common Issues

1. **MongoDB Connection Error**
   ```bash
   # Check if MongoDB is running
   mongod
   
   # Verify connection string
   MONGODB_URI=mongodb://localhost:27017/airbnb_clone
   ```

2. **JWT Token Error**
   - Ensure JWT_SECRET is set in .env
   - Check token expiration settings
   - Verify token format

3. **Port Already in Use**
   ```bash
   # Kill process using port 5000
   lsof -ti:5000 | xargs kill -9
   ```

4. **Database Seeding Error**
   ```bash
   # Clear database and reseed
   npm run seed
   ```

### Debug Mode
Run with debug logging:
```bash
DEBUG=* npm run dev
```

## 🚀 Deployment

### Production Deployment
1. Set production environment variables
2. Build and deploy to your preferred platform:
   - **Heroku**: Easy deployment with Heroku CLI
   - **DigitalOcean**: Deploy to Droplet
   - **AWS**: Deploy to EC2 or Elastic Beanstalk
   - **Railway**: Modern deployment platform

### Environment Setup
```env
NODE_ENV=production
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/airbnb_clone
JWT_SECRET=your_production_secret
```

### Database Deployment
- **MongoDB Atlas**: Cloud MongoDB service
- **Local MongoDB**: Self-hosted MongoDB
- **Docker**: Containerized MongoDB

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow Node.js best practices
- Write meaningful commit messages
- Add tests for new features
- Update documentation
- Follow security best practices

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For issues and questions:
1. Check the [Issues](https://github.com/yourusername/airbnb-clone/issues) page
2. Create a new issue if your problem isn't already reported
3. Follow the [Startup Guide](../STARTUP_GUIDE.md) for detailed setup instructions

## 🎯 Roadmap

- [ ] Real-time notifications with Socket.io
- [ ] Email service integration
- [ ] Payment gateway integration (Stripe)
- [ ] Image upload and storage
- [ ] Advanced search with Elasticsearch
- [ ] API documentation with Swagger
- [ ] Unit and integration tests
- [ ] Docker containerization
- [ ] CI/CD pipeline setup
- [ ] Performance monitoring and logging