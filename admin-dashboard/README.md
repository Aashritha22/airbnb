# Admin Dashboard - Airbnb Clone

A comprehensive admin dashboard for managing the Airbnb Clone platform, built with Flutter.

## Features

### 🏠 Dashboard Overview
- Real-time analytics and key metrics
- Revenue and booking trends
- Recent bookings table
- Interactive charts and graphs

### 👥 User Management
- View all users with detailed information
- Filter users by status (All, Verified, Hosts, Blocked, New)
- User statistics and insights
- Block/unblock users
- View user details and edit profiles

### 🏡 Property Management
- Manage all properties on the platform
- Filter properties by status (All, Active, Verified, Blocked, New)
- Property statistics and analytics
- View property details and amenities
- Block/unblock properties
- Property verification system

### 📅 Booking Management
- View all bookings with comprehensive details
- Filter bookings by status (All, Pending, Confirmed, Cancelled, Completed)
- Booking statistics and revenue tracking
- Confirm/cancel bookings
- Booking details and payment information

### 📊 Analytics & Reports
- Revenue trends and growth analysis
- Booking patterns and statistics
- User growth tracking
- Property category distribution
- Top performing locations
- Interactive charts and visualizations

## Technology Stack

- **Framework**: Flutter
- **Charts**: FL Chart
- **Date Formatting**: Intl package
- **UI Components**: Material Design 3
- **Architecture**: Clean architecture with models, widgets, and screens

## Project Structure

```
lib/
├── main.dart
├── models/
│   ├── user.dart
│   ├── booking.dart
│   ├── property.dart
│   ├── property_category.dart
│   └── analytics.dart
├── widgets/
│   ├── admin_card.dart
│   ├── admin_chart.dart
│   ├── admin_table.dart
│   └── admin_sidebar.dart
└── screens/
    ├── admin_dashboard_screen.dart
    ├── dashboard_overview_screen.dart
    ├── users_screen.dart
    ├── properties_screen.dart
    ├── bookings_screen.dart
    └── analytics_screen.dart
```

## Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd admin-dashboard
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## Key Features Explained

### Admin Cards
- Display key metrics with icons and trends
- Color-coded for different data types
- Responsive design with growth indicators

### Admin Charts
- Interactive line charts for trends
- Revenue and booking analytics
- Customizable data visualization

### Admin Tables
- Sortable and filterable data tables
- Action buttons for each row
- Status badges and indicators
- Responsive design

### Admin Sidebar
- Collapsible navigation menu
- Active state indicators
- User profile section
- Clean and intuitive design

## Data Models

### User Model
- Complete user information
- Verification and hosting status
- Booking history and statistics
- Account management features

### Booking Model
- Comprehensive booking details
- Status tracking and management
- Payment information
- Guest and host details

### Property Model
- Property information and amenities
- Host details and verification
- Booking statistics and revenue
- Category and location data

### Analytics Model
- Platform-wide statistics
- Growth metrics and trends
- Revenue and booking data
- User and property insights

## Customization

The admin dashboard is designed to be easily customizable:

- **Colors**: Update the color scheme in `main.dart`
- **Charts**: Modify chart configurations in `admin_chart.dart`
- **Tables**: Customize table headers and data in respective screens
- **Navigation**: Add new menu items in `admin_sidebar.dart`

## Future Enhancements

- Real-time notifications
- Advanced filtering and search
- Export functionality for reports
- Mobile-responsive improvements
- Dark mode support
- Multi-language support
- Advanced analytics and insights

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.
