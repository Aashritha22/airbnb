# 👨‍💼 Admin Dashboard - Airbnb Clone

A comprehensive Flutter-based admin dashboard for managing the Airbnb Clone platform, featuring real-time analytics, user management, and property administration.

## ✨ Features

### 📊 Dashboard & Analytics
- **Real-time Statistics**: Live metrics and performance indicators
- **Revenue Analytics**: Track revenue trends and financial performance
- **User Analytics**: Monitor user growth and engagement
- **Booking Analytics**: Analyze booking patterns and occupancy rates
- **Interactive Charts**: Visual data representation with FL Chart

### 👥 User Management
- **User Overview**: View all registered users with detailed information
- **User Verification**: Verify user accounts and documents
- **User Blocking**: Block or unblock user accounts
- **User Statistics**: Track user activity and engagement metrics
- **Search & Filter**: Advanced search and filtering capabilities

### 🏠 Property Management
- **Property Listings**: Manage all property listings
- **Property Verification**: Verify properties and approve listings
- **Property Statistics**: Track property performance and metrics
- **Category Management**: Manage property categories and types
- **Amenity Management**: Configure property amenities

### 📅 Booking Management
- **Booking Overview**: View all bookings across the platform
- **Booking Status**: Monitor booking statuses and changes
- **Booking Analytics**: Analyze booking patterns and trends
- **Revenue Tracking**: Track revenue from bookings
- **Cancellation Management**: Handle booking cancellations

### 💳 Payment Management
- **Payment Overview**: View all payment transactions
- **Payment Status**: Monitor payment processing and completion
- **Refund Processing**: Process refunds for cancelled bookings
- **Payment Analytics**: Track payment methods and success rates
- **Revenue Reports**: Generate financial reports

### 🎫 Support Management
- **Support Tickets**: Handle customer support tickets
- **Ticket Assignment**: Assign tickets to support staff
- **Ticket Resolution**: Track and resolve support issues
- **Support Analytics**: Monitor support performance metrics
- **Customer Communication**: Manage customer interactions

### 👨‍💼 Admin User Management
- **Admin Accounts**: Manage admin user accounts
- **Role Management**: Assign roles and permissions
- **Department Management**: Organize admin users by department
- **Access Control**: Control admin access and permissions
- **Activity Logging**: Track admin activities and changes

## 🛠 Tech Stack

- **Flutter**: Cross-platform admin interface
- **Provider**: State management for admin data
- **FL Chart**: Interactive charts and analytics
- **Dio**: HTTP client for API communication
- **Shared Preferences**: Local storage for admin session
- **Responsive Design**: Adaptive UI for different screen sizes

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.9.2 or higher)
- Dart SDK (v3.9.2 or higher)
- Backend API running on localhost:5000

### Installation

1. **Navigate to the project directory**
   ```bash
   cd admin-dashboard
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the admin dashboard**
   ```bash
   # For web development
   flutter run -d web-server --web-port 3001 --web-hostname 0.0.0.0
   
   # For desktop development
   flutter run -d macos    # macOS
   flutter run -d windows  # Windows
   flutter run -d linux    # Linux
   ```

### Access the Admin Dashboard
- **Web**: http://localhost:3001
- **Desktop**: Available on supported platforms

## 🔧 Configuration

### API Configuration
The admin dashboard connects to the backend API at `http://localhost:5000/api/admin`. To change this:

1. Open `lib/services/api_service.dart`
2. Update the `adminBaseUrl` constant:
   ```dart
   static const String adminBaseUrl = 'http://your-api-url:port/api/admin';
   ```

### Admin Permissions
Admin users have different permission levels:
- **Super Admin**: Full access to all features
- **Admin**: Most features except admin user management
- **Moderator**: Property and user management
- **Support**: Support ticket management only

## 📁 Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── user.dart            # User model
│   ├── admin_user.dart      # Admin user model
│   ├── property.dart        # Property model
│   ├── booking.dart         # Booking model
│   └── analytics.dart       # Analytics model
├── providers/               # State management
│   ├── auth_provider.dart   # Authentication state
│   ├── admin_provider.dart  # Admin data state
│   └── theme_provider.dart  # Theme management
├── screens/                 # Admin screens
│   ├── login_screen.dart    # Admin login
│   ├── dashboard_screen.dart # Main dashboard
│   ├── users_screen.dart    # User management
│   ├── properties_screen.dart # Property management
│   ├── bookings_screen.dart # Booking management
│   ├── payments_screen.dart # Payment management
│   ├── support_screen.dart  # Support management
│   ├── analytics_screen.dart # Analytics dashboard
│   └── settings_screen.dart # Settings and configuration
├── services/                # API services
│   └── api_service.dart     # Admin API communication
└── widgets/                 # Reusable widgets
    ├── admin_sidebar.dart   # Navigation sidebar
    ├── admin_card.dart      # Dashboard cards
    ├── admin_chart.dart     # Chart components
    └── admin_table.dart     # Data tables
```

## 🔑 Authentication

### Admin Test Accounts
- **Super Admin**: `admin@airbnbclone.com` / `admin123`
- **Support Staff**: `support@airbnbclone.com` / `support123`
- **Moderator**: `moderator@airbnbclone.com` / `moderator123`

### Authentication Flow
1. Admin enters credentials
2. Dashboard sends login request to admin API
3. Backend validates admin credentials and returns JWT token
4. Dashboard stores admin token securely
5. Token is included in all admin API requests

## 🎯 Features in Detail

### Dashboard Overview
- **Key Metrics**: Total users, properties, bookings, revenue
- **Revenue Chart**: Monthly revenue trends
- **Booking Chart**: Booking volume over time
- **User Growth**: User registration trends
- **Quick Actions**: Fast access to common tasks

### User Management
- **User List**: Comprehensive user listing with search
- **User Details**: Detailed user information and activity
- **Verification**: Verify user accounts and documents
- **Blocking**: Block or unblock user accounts
- **Statistics**: User engagement and activity metrics

### Property Management
- **Property List**: All properties with filtering options
- **Property Details**: Complete property information
- **Verification**: Verify and approve property listings
- **Performance**: Property booking and revenue metrics
- **Categories**: Manage property categories and types

### Analytics & Reporting
- **Revenue Analytics**: Track financial performance
- **User Analytics**: Monitor user behavior and growth
- **Booking Analytics**: Analyze booking patterns
- **Property Analytics**: Property performance metrics
- **Custom Reports**: Generate custom analytics reports

## 📊 Dashboard Sections

### 1. Overview Dashboard
- Key performance indicators
- Revenue and booking trends
- User growth statistics
- Quick action buttons

### 2. User Management
- User listing with search and filters
- User verification and blocking
- User activity tracking
- Account management tools

### 3. Property Management
- Property listings and details
- Property verification system
- Category and amenity management
- Property performance analytics

### 4. Booking Management
- All bookings overview
- Booking status tracking
- Revenue from bookings
- Cancellation management

### 5. Payment Management
- Payment transaction history
- Refund processing
- Payment method analytics
- Financial reporting

### 6. Support Management
- Support ticket queue
- Ticket assignment and resolution
- Customer communication
- Support performance metrics

### 7. Analytics Dashboard
- Comprehensive analytics
- Interactive charts and graphs
- Custom date range selection
- Export capabilities

### 8. Settings & Configuration
- System settings
- Admin user management
- Permission configuration
- System maintenance

## 🔒 Security Features

### Authentication & Authorization
- **JWT Tokens**: Secure authentication
- **Role-based Access**: Different permission levels
- **Session Management**: Secure session handling
- **Logout Security**: Secure token cleanup

### Data Protection
- **Input Validation**: All inputs validated
- **XSS Protection**: Cross-site scripting prevention
- **CSRF Protection**: Cross-site request forgery prevention
- **Secure Headers**: Security headers implementation

## 🐛 Troubleshooting

### Common Issues

1. **Login Issues**
   - Verify admin credentials
   - Check backend API connection
   - Ensure JWT token is valid

2. **Data Loading Issues**
   - Check API endpoints
   - Verify database connection
   - Check network connectivity

3. **Build Errors**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Debug Mode
Run with debug flags for detailed logging:
```bash
flutter run --debug --verbose
```

## 🚀 Building for Production

### Web Build
```bash
flutter build web --release
```

### Desktop Build
```bash
flutter build macos --release  # macOS
flutter build windows --release # Windows
flutter build linux --release   # Linux
```

## 📊 Performance

### Optimizations
- **Lazy Loading**: Data loaded on demand
- **Caching**: API response caching
- **State Management**: Efficient state updates
- **Chart Performance**: Optimized chart rendering

### Metrics
- **Load Time**: Fast dashboard loading
- **Memory Usage**: Efficient memory management
- **API Calls**: Minimal and optimized API requests
- **Responsiveness**: Smooth user interactions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly on different screen sizes
5. Submit a pull request

### Development Guidelines
- Follow Flutter style guidelines
- Write meaningful commit messages
- Add comments for complex logic
- Test responsive design
- Ensure accessibility

## 📄 License

This project is licensed under the MIT License.

## 📞 Support

For issues and questions:
1. Check the main project README
2. Create an issue in the repository
3. Follow the startup guide for setup help