# 🏠 Airbnb Clone - Full Stack Application

A complete Airbnb clone built with Flutter frontend and Node.js backend, featuring dynamic data management, admin dashboard, and comprehensive booking system.

![Airbnb Clone](https://img.shields.io/badge/Airbnb-Clone-FF5A5F?style=for-the-badge&logo=airbnb&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-4EA94B?style=for-the-badge&logo=mongodb&logoColor=white)

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Installation & Setup](#-installation--setup)
- [Running the Applications](#-running-the-applications)
- [API Documentation](#-api-documentation)
- [Database Schema](#-database-schema)
- [Test Accounts](#-test-accounts)
- [Screenshots](#-screenshots)
- [Contributing](#-contributing)
- [License](#-license)

## ✨ Features

### 🏠 User Application (Airbnb Clone)
- **Property Browsing**: Browse properties with dynamic data from MongoDB
- **Advanced Search**: Search by location, price range, amenities, and categories
- **Property Categories**: Filter by Beach, City, Mountain, Countryside, etc.
- **Responsive Design**: Works seamlessly on desktop, tablet, and mobile
- **User Authentication**: Login/Register with JWT tokens
- **Booking System**: Create and manage property bookings
- **Payment Integration**: Ready for Stripe payment processing
- **Support System**: Create and track support tickets

### 👨‍💼 Admin Dashboard
- **Real-time Analytics**: Live statistics and performance metrics
- **User Management**: View, verify, block, and manage users
- **Property Management**: Verify properties and manage listings
- **Booking Management**: View and manage all bookings
- **Payment Management**: Process refunds and view transactions
- **Support Management**: Handle customer support tickets
- **Admin User Management**: Manage admin accounts and permissions
- **Revenue Analytics**: Track revenue, occupancy rates, and trends

### 🔧 Backend API
- **RESTful API**: Complete REST API with proper HTTP methods
- **JWT Authentication**: Secure authentication with role-based access
- **MongoDB Integration**: NoSQL database with Mongoose ODM
- **Data Validation**: Input validation and sanitization
- **Error Handling**: Comprehensive error handling middleware
- **Rate Limiting**: API rate limiting for security
- **CORS Support**: Cross-origin resource sharing enabled
- **Environment Configuration**: Configurable via environment variables

## 🛠 Tech Stack

### Frontend
- **Flutter**: Cross-platform mobile/web development
- **Provider**: State management
- **Dio**: HTTP client for API communication
- **Shared Preferences**: Local storage
- **FL Chart**: Charts and analytics visualization

### Backend
- **Node.js**: JavaScript runtime
- **Express.js**: Web application framework
- **MongoDB**: NoSQL database
- **Mongoose**: MongoDB object modeling
- **JWT**: JSON Web Token authentication
- **Bcrypt**: Password hashing
- **Express Rate Limit**: API rate limiting
- **Helmet**: Security middleware

### Development Tools
- **Nodemon**: Auto-restart development server
- **ESLint**: Code linting
- **Prettier**: Code formatting
- **Git**: Version control

## 📁 Project Structure

```
airbnb/
├── airbnb_clone/                 # Flutter User Application
│   ├── lib/
│   │   ├── models/              # Data models
│   │   ├── providers/           # State management
│   │   ├── screens/             # UI screens
│   │   ├── services/            # API services
│   │   └── widgets/             # Reusable widgets
│   ├── pubspec.yaml
│   └── README.md
├── admin-dashboard/              # Flutter Admin Dashboard
│   ├── lib/
│   │   ├── models/              # Admin data models
│   │   ├── providers/           # Admin state management
│   │   ├── screens/             # Admin screens
│   │   ├── services/            # Admin API services
│   │   └── widgets/             # Admin widgets
│   ├── pubspec.yaml
│   └── README.md
├── backend/                      # Node.js Backend API
│   ├── src/
│   │   ├── models/              # Database models
│   │   ├── routes/              # API routes
│   │   ├── middleware/          # Custom middleware
│   │   ├── utils/               # Utility functions
│   │   └── database/            # Database connection & seeding
│   ├── package.json
│   ├── env.example
│   └── README.md
├── STARTUP_GUIDE.md             # Complete setup guide
└── README.md                    # This file
```

## 📋 Prerequisites

Before running this project, make sure you have the following installed:

- **Node.js** (v18 or higher)
- **MongoDB** (v4.4 or higher)
- **Flutter** (v3.9.2 or higher)
- **Dart** (v3.9.2 or higher)
- **Git** (for version control)

### Installation Commands

#### macOS (using Homebrew)
```bash
# Install Node.js
brew install node

# Install MongoDB
brew tap mongodb/brew
brew install mongodb-community

# Install Flutter
brew install flutter
```

#### Ubuntu/Debian
```bash
# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# Install Flutter
sudo snap install flutter --classic
```

#### Windows
1. Download and install [Node.js](https://nodejs.org/)
2. Download and install [MongoDB](https://www.mongodb.com/try/download/community)
3. Download and install [Flutter](https://flutter.dev/docs/get-started/install/windows)

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/airbnb-clone.git
cd airbnb-clone
```

### 2. Backend Setup
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

# Seed the database with sample data
npm run seed

# Start the backend server
npm run dev
```

The backend will be available at `http://localhost:5000`

### 3. Flutter Applications Setup

#### User Application (Airbnb Clone)
```bash
cd airbnb_clone

# Install dependencies
flutter pub get

# Run the application
flutter run -d web-server --web-port 3000 --web-hostname 0.0.0.0
```

#### Admin Dashboard
```bash
cd admin-dashboard

# Install dependencies
flutter pub get

# Run the admin dashboard
flutter run -d web-server --web-port 3001 --web-hostname 0.0.0.0
```

## 🌐 Running the Applications

### Quick Start Commands

```bash
# Terminal 1: Start MongoDB
mongod

# Terminal 2: Start Backend
cd backend
npm install
npm run seed
npm run dev

# Terminal 3: Start User App
cd airbnb_clone
flutter pub get
flutter run -d web-server --web-port 3000

# Terminal 4: Start Admin Dashboard
cd admin-dashboard
flutter pub get
flutter run -d web-server --web-port 3001
```

### Access URLs
- **User Application**: http://localhost:3000
- **Admin Dashboard**: http://localhost:3001
- **Backend API**: http://localhost:5000
- **API Health Check**: http://localhost:5000/health

## 📚 API Documentation

### Authentication Endpoints
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/admin/login` - Admin login
- `GET /api/auth/me` - Get current user

### Property Endpoints
- `GET /api/properties` - Get all properties (with filters)
- `GET /api/properties/:id` - Get property by ID
- `GET /api/properties/categories` - Get property categories
- `GET /api/properties/amenities` - Get amenities

### Booking Endpoints
- `GET /api/bookings` - Get user bookings
- `POST /api/bookings` - Create booking
- `PUT /api/bookings/:id/cancel` - Cancel booking

### Admin Endpoints
- `GET /api/admin/dashboard` - Dashboard data
- `GET /api/admin/users` - Get all users
- `GET /api/admin/properties` - Get all properties
- `GET /api/analytics/*` - Analytics data

For complete API documentation, see [API_DOCUMENTATION.md](backend/API_DOCUMENTATION.md)

## 🗄 Database Schema

### Collections
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
The database is seeded with:
- 5 Users (3 hosts, 2 guests)
- 3 Admin Users (different roles)
- 6 Property Categories
- 15 Amenities
- 20 Properties with realistic data
- 50 Bookings with various statuses
- 40 Payments with different methods
- 9 Reviews with ratings
- 20 Support Tickets with messages

## 🔑 Test Accounts

### Admin Accounts
- **Super Admin**: `admin@airbnbclone.com` / `admin123`
- **Support Staff**: `support@airbnbclone.com` / `support123`
- **Moderator**: `moderator@airbnbclone.com` / `moderator123`

### User Accounts
- **Host**: `john.doe@example.com` / `password123`
- **Guest**: `jane.smith@example.com` / `password123`

## 📱 Screenshots

### User Application
- Property browsing with search and filters
- Property details with images and amenities
- Booking flow and payment integration
- User profile and booking history

### Admin Dashboard
- Real-time analytics dashboard
- User management interface
- Property verification system
- Support ticket management

## 🛠 Development

### Code Structure
- **Frontend**: Flutter with Provider state management
- **Backend**: Express.js with MVC architecture
- **Database**: MongoDB with Mongoose ODM
- **Authentication**: JWT with role-based access control

### Environment Variables
Create a `.env` file in the backend directory:
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

### Scripts
```bash
# Backend
npm run dev          # Start development server
npm run seed         # Seed database
npm start            # Start production server

# Flutter
flutter pub get      # Install dependencies
flutter run          # Run application
flutter build web    # Build for web
```

## 🚀 Deployment

### Backend Deployment
1. Set production environment variables
2. Build and deploy to your preferred platform (Heroku, DigitalOcean, AWS)
3. Configure MongoDB Atlas for production database

### Flutter Deployment
1. Build web version: `flutter build web`
2. Deploy to your preferred hosting platform (Firebase Hosting, Netlify, Vercel)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter and Dart style guidelines
- Use meaningful commit messages
- Add tests for new features
- Update documentation as needed

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

If you have any questions or need help:

1. Check the [Issues](https://github.com/yourusername/airbnb-clone/issues) page
2. Create a new issue if your problem isn't already reported
3. Follow the [Startup Guide](STARTUP_GUIDE.md) for detailed setup instructions

## 🎯 Roadmap

- [ ] Mobile app deployment (iOS/Android)
- [ ] Real-time notifications
- [ ] Advanced search filters
- [ ] Payment integration (Stripe)
- [ ] Image upload and management
- [ ] Multi-language support
- [ ] Performance optimizations
- [ ] Unit and integration tests

## ⭐ Show Your Support

Give a ⭐️ if this project helped you!

---

**Built with ❤️ by Aashritha**
