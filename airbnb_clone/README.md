# 🏠 Airbnb Clone - User Application

A Flutter-based user application for the Airbnb Clone platform, featuring dynamic property browsing, search functionality, and booking management.

## ✨ Features

- **Dynamic Property Browsing**: Browse properties loaded from MongoDB database
- **Advanced Search & Filters**: Search by location, price, amenities, and categories
- **Property Categories**: Filter by Beach, City, Mountain, Countryside, Lake, Desert
- **Responsive Design**: Optimized for desktop, tablet, and mobile devices
- **User Authentication**: Login/Register with JWT token authentication
- **Booking System**: Create and manage property bookings
- **Payment Integration**: Ready for Stripe payment processing
- **Support System**: Create and track support tickets
- **Real-time Data**: All data loaded dynamically from backend API

## 🛠 Tech Stack

- **Flutter**: Cross-platform mobile/web development
- **Provider**: State management
- **Dio**: HTTP client for API communication
- **Shared Preferences**: Local storage for user data
- **JSON Annotation**: JSON serialization

## 📱 Screenshots

### Home Screen
- Property grid with dynamic loading
- Category filters with emoji icons
- Search functionality
- Responsive layout

### Property Details
- High-quality property images
- Detailed property information
- Amenities list
- Booking interface

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.9.2 or higher)
- Dart SDK (v3.9.2 or higher)
- Backend API running on localhost:5000

### Installation

1. **Navigate to the project directory**
   ```bash
   cd airbnb_clone
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # For web development
   flutter run -d web-server --web-port 3000 --web-hostname 0.0.0.0
   
   # For mobile development
   flutter run -d chrome    # Web browser
   flutter run -d android   # Android device
   flutter run -d ios       # iOS device (macOS only)
   ```

### Access the Application
- **Web**: http://localhost:3000
- **Mobile**: Available on connected devices

## 🔧 Configuration

### API Configuration
The app is configured to connect to the backend API at `http://localhost:5000`. To change this:

1. Open `lib/services/api_service.dart`
2. Update the `baseUrl` constant:
   ```dart
   static const String baseUrl = 'http://your-api-url:port/api';
   ```

### Environment Setup
For mobile development, update the API URL to use your computer's IP address:
```dart
static const String baseUrl = 'http://192.168.1.100:5000/api';
```

## 📁 Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── api_property.dart    # API property model
│   ├── property.dart        # Legacy property model
│   └── category_icon.dart   # Category model
├── providers/               # State management
│   ├── auth_provider.dart   # Authentication state
│   └── property_provider.dart # Property data state
├── screens/                 # UI screens
│   ├── dynamic_home_screen.dart # Main home screen
│   ├── property_details_screen.dart # Property details
│   └── profile_screen.dart  # User profile
├── services/                # API services
│   └── api_service.dart     # API communication
└── widgets/                 # Reusable widgets
    ├── property_card.dart   # Property display card
    ├── search_segment.dart  # Search interface
    └── nav_tab.dart        # Navigation tabs
```

## 🔑 Authentication

### Test Accounts
- **User**: `john.doe@example.com` / `password123`
- **Host**: `jane.smith@example.com` / `password123`

### Authentication Flow
1. User enters credentials
2. App sends login request to backend API
3. Backend validates credentials and returns JWT token
4. App stores token in SharedPreferences
5. Token is included in subsequent API requests

## 🎯 Features in Detail

### Property Browsing
- **Dynamic Loading**: Properties loaded from MongoDB via API
- **Pagination**: Infinite scroll for better performance
- **Categories**: Filter by property type (Beach, City, Mountain, etc.)
- **Search**: Text-based search across property titles and descriptions

### Property Details
- **Image Gallery**: Multiple property images with navigation
- **Detailed Information**: Complete property details, amenities, and location
- **Booking Interface**: Date selection and booking form
- **Reviews**: User reviews and ratings

### User Management
- **Profile**: User profile with personal information
- **Bookings**: View and manage booking history
- **Favorites**: Save favorite properties
- **Settings**: Account and notification settings

## 🐛 Troubleshooting

### Common Issues

1. **API Connection Error**
   - Ensure backend is running on port 5000
   - Check network connectivity
   - Verify API URL in `api_service.dart`

2. **Build Errors**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Dependency Issues**
   ```bash
   flutter pub deps
   flutter pub upgrade
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

### Android Build
```bash
flutter build apk --release
```

### iOS Build
```bash
flutter build ios --release
```

## 📊 Performance

### Optimizations
- **Lazy Loading**: Properties loaded on demand
- **Image Caching**: Network images cached locally
- **State Management**: Efficient state updates with Provider
- **API Optimization**: Minimal API calls with caching

### Metrics
- **Bundle Size**: Optimized for web deployment
- **Load Time**: Fast initial load with lazy loading
- **Memory Usage**: Efficient memory management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Development Guidelines
- Follow Flutter style guidelines
- Write meaningful commit messages
- Add comments for complex logic
- Test on multiple devices

## 📄 License

This project is licensed under the MIT License.

## 📞 Support

For issues and questions:
1. Check the main project README
2. Create an issue in the repository
3. Follow the startup guide for setup help