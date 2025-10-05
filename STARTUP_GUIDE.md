# 🚀 Airbnb Clone - Dynamic Data Integration Guide

This guide will help you set up and run the complete Airbnb Clone system with dynamic data from the backend API.

## 📋 Prerequisites

Before starting, ensure you have the following installed:

- **Node.js** (v18 or higher)
- **MongoDB** (v4.4 or higher)
- **Flutter** (v3.9.2 or higher)
- **Dart** (v3.9.2 or higher)

## 🏗️ System Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Airbnb Clone  │    │   Backend API   │    │ Admin Dashboard │
│   (Flutter)     │◄──►│   (Node.js)     │◄──►│   (Flutter)     │
│                 │    │                 │    │                 │
│ - User App      │    │ - REST API      │    │ - Admin Panel   │
│ - Property List │    │ - MongoDB       │    │ - Analytics     │
│ - Bookings      │    │ - JWT Auth      │    │ - Management    │
│ - Payments      │    │ - Socket.io     │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Quick Start

### 1. Start the Backend API

```bash
cd backend

# Install dependencies
npm install

# Copy environment file
cp env.example .env

# Edit .env with your configuration
# At minimum, set:
# - MONGODB_URI=mongodb://localhost:27017/airbnb_clone
# - JWT_SECRET=your_super_secret_jwt_key_here

# Start MongoDB (in a separate terminal)
mongod

# Start the backend server
npm run dev

# Seed the database with sample data
npm run seed
```

The backend will be available at `http://localhost:5000`

### 2. Start the Airbnb Clone App

```bash
cd airbnb_clone

# Install dependencies
flutter pub get

# Run the app
flutter run -d chrome
# or
flutter run -d macos
```

### 3. Start the Admin Dashboard

```bash
cd admin-dashboard

# Install dependencies
flutter pub get

# Run the admin dashboard
flutter run -d macos
# or
flutter run -d chrome
```

## 🔧 Configuration

### Backend Configuration

Edit `backend/.env`:

```env
# Server Configuration
PORT=5000
NODE_ENV=development

# Database Configuration
MONGODB_URI=mongodb://localhost:27017/airbnb_clone

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key_here_make_it_long_and_random
JWT_EXPIRE=7d

# CORS Configuration
FRONTEND_URL=http://localhost:3000
ADMIN_URL=http://localhost:3001
```

### Flutter App Configuration

The Flutter apps are configured to connect to `http://localhost:5000` by default. If you need to change this, update the `baseUrl` in:

- `airbnb_clone/lib/services/api_service.dart`
- `admin-dashboard/lib/services/api_service.dart`

## 👤 Test Accounts

After seeding the database, you can use these test accounts:

### Admin Accounts
- **Super Admin**: `admin@airbnbclone.com` / `admin123`
- **Support Staff**: `support@airbnbclone.com` / `support123`
- **Moderator**: `moderator@airbnbclone.com` / `moderator123`

### User Accounts
- **Host**: `john.doe@example.com` / `password123`
- **Guest**: `jane.smith@example.com` / `password123`

## 📊 Sample Data

The seeded database includes:

- **5 Users** (3 hosts, 2 guests)
- **3 Admin Users** (different roles)
- **6 Property Categories**
- **15 Amenities**
- **20 Properties** with realistic data
- **50 Bookings** with various statuses
- **40 Payments** with different methods
- **100 Reviews** with ratings
- **20 Support Tickets** with messages

## 🔄 Dynamic Features

### Airbnb Clone App

- ✅ **Real-time Property Search** - Search by location, price, amenities
- ✅ **Dynamic Property Listings** - Loaded from API with pagination
- ✅ **Category Filtering** - Filter by property categories
- ✅ **User Authentication** - Login/register with JWT tokens
- ✅ **Booking System** - Create and manage bookings
- ✅ **Payment Integration** - Ready for Stripe integration
- ✅ **Support Tickets** - Create and track support requests

### Admin Dashboard

- ✅ **Real-time Dashboard** - Live statistics and analytics
- ✅ **User Management** - View, verify, block users
- ✅ **Property Management** - Verify and manage properties
- ✅ **Booking Management** - View and manage all bookings
- ✅ **Payment Management** - Process refunds and view transactions
- ✅ **Support Management** - Handle support tickets
- ✅ **Analytics** - Revenue, user, and booking analytics
- ✅ **Admin User Management** - Manage admin accounts

## 🛠️ API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/admin/login` - Admin login

### Properties
- `GET /api/properties` - Get properties with filters
- `GET /api/properties/:id` - Get property details
- `GET /api/properties/categories` - Get property categories

### Bookings
- `GET /api/bookings` - Get user bookings
- `POST /api/bookings` - Create booking
- `PUT /api/bookings/:id/cancel` - Cancel booking

### Admin
- `GET /api/admin/dashboard` - Dashboard data
- `GET /api/admin/users` - Get all users
- `GET /api/admin/properties` - Get all properties
- `GET /api/analytics/*` - Analytics data

## 🔍 Troubleshooting

### Common Issues

1. **MongoDB Connection Error**
   ```bash
   # Make sure MongoDB is running
   mongod
   
   # Check if the URI in .env is correct
   MONGODB_URI=mongodb://localhost:27017/airbnb_clone
   ```

2. **Flutter Dependencies Error**
   ```bash
   # Clean and get dependencies
   flutter clean
   flutter pub get
   ```

3. **API Connection Error**
   - Check if backend is running on port 5000
   - Verify CORS settings in backend
   - Check network connectivity

4. **JWT Token Error**
   - Make sure JWT_SECRET is set in .env
   - Check token expiration settings

### Debug Mode

To enable debug logging:

```bash
# Backend
NODE_ENV=development npm run dev

# Flutter
flutter run --debug
```

## 📱 Mobile Development

To run on mobile devices:

```bash
# iOS (requires macOS and Xcode)
flutter run -d ios

# Android (requires Android Studio)
flutter run -d android
```

Make sure to update the API base URL for mobile:
```dart
// For mobile, use your computer's IP address
static const String baseUrl = 'http://192.168.1.100:5000/api';
```

## 🌐 Production Deployment

### Backend Deployment

1. **Environment Variables**
   ```env
   NODE_ENV=production
   MONGODB_URI=mongodb://your-production-db-url
   JWT_SECRET=your-production-secret
   ```

2. **Deploy to Heroku/DigitalOcean**
   ```bash
   npm run build
   npm start
   ```

### Flutter Deployment

1. **Build for Web**
   ```bash
   flutter build web
   ```

2. **Build for Mobile**
   ```bash
   flutter build apk  # Android
   flutter build ios  # iOS
   ```

## 📈 Performance Optimization

### Backend
- Enable MongoDB indexing
- Use Redis for caching
- Implement rate limiting
- Add request compression

### Flutter
- Use lazy loading for lists
- Implement image caching
- Optimize API calls
- Use pagination

## 🔐 Security Considerations

- Change default JWT secrets
- Use HTTPS in production
- Implement proper CORS policies
- Add input validation
- Use environment variables for secrets

## 📞 Support

If you encounter any issues:

1. Check the console logs for errors
2. Verify all services are running
3. Check network connectivity
4. Review the API documentation

## 🎉 You're All Set!

Your dynamic Airbnb Clone system is now running with:

- ✅ Real-time data from MongoDB
- ✅ RESTful API with authentication
- ✅ Responsive Flutter applications
- ✅ Admin dashboard with analytics
- ✅ Complete booking and payment system

Happy coding! 🚀
