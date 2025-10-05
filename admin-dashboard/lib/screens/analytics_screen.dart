import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../widgets/admin_card.dart';
import '../widgets/admin_chart.dart';
import '../models/analytics.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

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

    final userGrowthData = [
      {'month': 'Jan', 'value': 650.0},
      {'month': 'Feb', 'value': 680.0},
      {'month': 'Mar', 'value': 710.0},
      {'month': 'Apr', 'value': 735.0},
      {'month': 'May', 'value': 760.0},
      {'month': 'Jun', 'value': 785.0},
      {'month': 'Jul', 'value': 810.0},
      {'month': 'Aug', 'value': 830.0},
      {'month': 'Sep', 'value': 845.0},
      {'month': 'Oct', 'value': 855.0},
      {'month': 'Nov', 'value': 865.0},
      {'month': 'Dec', 'value': 875.0},
    ];

    final categoryData = [
      {'category': 'Beach', 'count': 45, 'revenue': 25000.0, 'percentage': 20.0},
      {'category': 'Mountain', 'count': 38, 'revenue': 22000.0, 'percentage': 17.6},
      {'category': 'City', 'count': 52, 'revenue': 30000.0, 'percentage': 24.0},
      {'category': 'Countryside', 'count': 28, 'revenue': 18000.0, 'percentage': 14.4},
      {'category': 'Lakefront', 'count': 22, 'revenue': 15000.0, 'percentage': 12.0},
      {'category': 'Tropical', 'count': 18, 'revenue': 12000.0, 'percentage': 9.6},
      {'category': 'Other', 'count': 17, 'revenue': 8000.0, 'percentage': 6.4},
    ];

    final topLocations = [
      {'location': 'Bengaluru, India', 'bookings': 125, 'revenue': 18750.0, 'rating': 4.8},
      {'location': 'New York, NY', 'bookings': 98, 'revenue': 29400.0, 'rating': 4.7},
      {'location': 'Malibu, California', 'bookings': 87, 'revenue': 21750.0, 'rating': 4.9},
      {'location': 'Aspen, Colorado', 'bookings': 76, 'revenue': 13680.0, 'rating': 4.6},
      {'location': 'Tuscany, Italy', 'bookings': 65, 'revenue': 9750.0, 'rating': 4.9},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Analytics & Reports',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Key Metrics
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.8,
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
                title: 'Occupancy Rate',
                value: '${analytics.occupancyRate.toStringAsFixed(1)}%',
                icon: Icons.trending_up,
                color: Colors.orange,
                subtitle: 'Average rating: ${analytics.averageRating}',
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Charts Row 1
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AdminChart(
                  title: 'Revenue Trend (Last 12 Months)',
                  data: revenueData,
                  isRevenue: true,
                  height: 300,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: AdminChart(
                  title: 'Bookings Trend (Last 12 Months)',
                  data: bookingData,
                  isRevenue: false,
                  height: 300,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // User Growth Chart
          AdminChart(
            title: 'User Growth (Last 12 Months)',
            data: userGrowthData,
            isRevenue: false,
            height: 300,
          ),
          
          const SizedBox(height: 24),
          
          // Category Distribution and Top Locations
          Row(
            children: [
              Expanded(
                child: _buildCategoryDistribution(categoryData),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTopLocations(topLocations),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDistribution(List<Map<String, dynamic>> categoryData) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Property Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: categoryData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    final colors = [
                      const Color(0xFFE31C5F),
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                      Colors.purple,
                      Colors.teal,
                      Colors.pink,
                    ];
                    
                    return PieChartSectionData(
                      color: colors[index % colors.length],
                      value: data['percentage'],
                      title: '${data['percentage'].toStringAsFixed(1)}%',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  centerSpaceColor: Colors.grey.shade100,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...categoryData.map((data) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['category'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      '${data['count']} properties',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopLocations(List<Map<String, dynamic>> topLocations) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Locations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            ...topLocations.asMap().entries.map((entry) {
              final index = entry.key;
              final location = entry.value;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE31C5F),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location['location'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${location['bookings']} bookings',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                NumberFormat.currency(symbol: '\$').format(location['revenue']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location['rating'].toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
