import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/admin_card.dart';
import '../widgets/admin_chart.dart';
import '../widgets/responsive_layout.dart';
import '../utils/responsive.dart';
import '../widgets/admin_table.dart';
import '../models/analytics.dart';
import '../models/booking.dart';

class DashboardOverviewScreen extends StatelessWidget {
  const DashboardOverviewScreen({super.key});

  Widget _buildChartCard(BuildContext context, String title, List<double> data, Color color) {
    return Container(
      padding: Responsive.getResponsiveEdgeInsets(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: Responsive.getResponsiveValue(
                context,
                mobile: 16.0,
                tablet: 18.0,
                desktop: 20.0,
              ),
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: Responsive.getResponsiveValue(
            context,
            mobile: 12.0,
            tablet: 16.0,
            desktop: 20.0,
          )),
          SizedBox(
            height: Responsive.getResponsiveValue(
              context,
              mobile: 150.0,
              tablet: 180.0,
              desktop: 200.0,
            ),
            child: AdminChart(
              data: data,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sample data - in a real app, this would come from an API
    final analytics = const Analytics(
      totalRevenue: 125000,
      monthlyRevenue: 15000,
      totalBookings: 1250,
      monthlyBookings: 180,
      totalUsers: 850,
      monthlyUsers: 45,
      totalProperties: 320,
      monthlyProperties: 12,
      occupancyRate: 78.5,
      averageRating: 4.8,
      revenueGrowth: 12.5,
      bookingGrowth: 8.3,
      userGrowth: 15.2,
      propertyGrowth: 5.7,
    );

    final revenueData = [
      {'month': 'Jan', 'value': 12000.0},
      {'month': 'Feb', 'value': 13500.0},
      {'month': 'Mar', 'value': 14200.0},
      {'month': 'Apr', 'value': 13800.0},
      {'month': 'May', 'value': 15200.0},
      {'month': 'Jun', 'value': 14800.0},
      {'month': 'Jul', 'value': 16200.0},
      {'month': 'Aug', 'value': 15800.0},
      {'month': 'Sep', 'value': 17200.0},
      {'month': 'Oct', 'value': 16800.0},
      {'month': 'Nov', 'value': 18200.0},
      {'month': 'Dec', 'value': 17500.0},
    ];

    final bookingData = [
      {'month': 'Jan', 'value': 120.0},
      {'month': 'Feb', 'value': 135.0},
      {'month': 'Mar', 'value': 142.0},
      {'month': 'Apr', 'value': 138.0},
      {'month': 'May', 'value': 152.0},
      {'month': 'Jun', 'value': 148.0},
      {'month': 'Jul', 'value': 162.0},
      {'month': 'Aug', 'value': 158.0},
      {'month': 'Sep', 'value': 172.0},
      {'month': 'Oct', 'value': 168.0},
      {'month': 'Nov', 'value': 182.0},
      {'month': 'Dec', 'value': 175.0},
    ];

    final recentBookings = [
      Booking(
        id: '1',
        userId: 'user1',
        propertyId: 'prop1',
        propertyTitle: 'Cozy Studio Apartment',
        hostId: 'host1',
        hostName: 'Sarah Johnson',
        checkInDate: DateTime.now().add(const Duration(days: 2)),
        checkOutDate: DateTime.now().add(const Duration(days: 5)),
        guests: 2,
        totalAmount: 6504,
        status: BookingStatus.confirmed,
        bookingDate: DateTime.now().subtract(const Duration(hours: 2)),
        paymentMethod: 'Credit Card',
        isRefundable: true,
      ),
      Booking(
        id: '2',
        userId: 'user2',
        propertyId: 'prop2',
        propertyTitle: 'Modern Beach House',
        hostId: 'host2',
        hostName: 'Emma Wilson',
        checkInDate: DateTime.now().add(const Duration(days: 7)),
        checkOutDate: DateTime.now().add(const Duration(days: 12)),
        guests: 4,
        totalAmount: 1250,
        status: BookingStatus.pending,
        bookingDate: DateTime.now().subtract(const Duration(hours: 1)),
        paymentMethod: 'PayPal',
        isRefundable: true,
      ),
      Booking(
        id: '3',
        userId: 'user3',
        propertyId: 'prop3',
        propertyTitle: 'Luxury Mountain Cabin',
        hostId: 'host3',
        hostName: 'Mike Chen',
        checkInDate: DateTime.now().add(const Duration(days: 14)),
        checkOutDate: DateTime.now().add(const Duration(days: 18)),
        guests: 6,
        totalAmount: 900,
        status: BookingStatus.confirmed,
        bookingDate: DateTime.now().subtract(const Duration(minutes: 30)),
        paymentMethod: 'Credit Card',
        isRefundable: true,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFE31C5F),
                  const Color(0xFFE31C5F).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back, Admin!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Here\'s what\'s happening with your platform today.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.dashboard,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
                // Stats Cards
                ResponsiveGrid(
                  children: [
              AdminCard(
                title: 'Total Revenue',
                value: NumberFormat.currency(symbol: '\$').format(analytics.totalRevenue),
                icon: Icons.attach_money,
                color: Colors.green,
                subtitle: 'This month: ${NumberFormat.currency(symbol: '\$').format(analytics.monthlyRevenue)}',
                trend: analytics.revenueGrowth,
              ),
              AdminCard(
                title: 'Total Bookings',
                value: analytics.totalBookings.toString(),
                icon: Icons.book_online,
                color: Colors.blue,
                subtitle: 'This month: ${analytics.monthlyBookings}',
                trend: analytics.bookingGrowth,
              ),
              AdminCard(
                title: 'Total Users',
                value: analytics.totalUsers.toString(),
                icon: Icons.people,
                color: Colors.purple,
                subtitle: 'This month: +${analytics.monthlyUsers}',
                trend: analytics.userGrowth,
              ),
              AdminCard(
                title: 'Properties',
                value: analytics.totalProperties.toString(),
                icon: Icons.home,
                color: Colors.orange,
                subtitle: 'This month: +${analytics.monthlyProperties}',
                trend: analytics.propertyGrowth,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Charts Row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AdminChart(
                  title: 'Revenue Trend',
                  data: revenueData,
                  isRevenue: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: AdminChart(
                  title: 'Bookings Trend',
                  data: bookingData,
                  isRevenue: false,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent Bookings Table
          AdminTable(
            headers: const ['Property', 'Guest', 'Check-in', 'Check-out', 'Amount', 'Status'],
            rows: recentBookings.map((booking) {
              return [
                AdminTableCell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.propertyTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'by ${booking.hostName}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    'User ${booking.userId}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(booking.checkInDate),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(booking.checkOutDate),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    NumberFormat.currency(symbol: '\$').format(booking.totalAmount),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AdminTableCell(
                  child: StatusBadge(
                    status: booking.status.displayName,
                    color: _getStatusColor(booking.status.color),
                  ),
                ),
              ];
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String colorName) {
    switch (colorName) {
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'purple':
        return Colors.purple;
      case 'gray':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
