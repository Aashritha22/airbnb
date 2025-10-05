import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/admin_card.dart';
import '../widgets/admin_table.dart';
import '../widgets/responsive_layout.dart';
import '../models/booking.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Pending', 'Confirmed', 'Cancelled', 'Completed'];

  @override
  Widget build(BuildContext context) {
    // Sample data - in a real app, this would come from an API
    final bookingStats = const BookingStats(
      totalBookings: 1250,
      pendingBookings: 45,
      confirmedBookings: 980,
      cancelledBookings: 225,
      totalRevenue: 125000.0,
      averageBookingValue: 100.0,
      occupancyRate: 78.5,
    );

    final bookings = [
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
      Booking(
        id: '4',
        userId: 'user4',
        propertyId: 'prop4',
        propertyTitle: 'Downtown Loft',
        hostId: 'host4',
        hostName: 'David Brown',
        checkInDate: DateTime.now().subtract(const Duration(days: 2)),
        checkOutDate: DateTime.now().add(const Duration(days: 1)),
        guests: 2,
        totalAmount: 640,
        status: BookingStatus.checkedIn,
        bookingDate: DateTime.now().subtract(const Duration(days: 7)),
        paymentMethod: 'Credit Card',
        isRefundable: true,
      ),
      Booking(
        id: '5',
        userId: 'user5',
        propertyId: 'prop5',
        propertyTitle: 'Rustic Farmhouse',
        hostId: 'host5',
        hostName: 'Lisa Garcia',
        checkInDate: DateTime.now().subtract(const Duration(days: 5)),
        checkOutDate: DateTime.now().subtract(const Duration(days: 2)),
        guests: 4,
        totalAmount: 750,
        status: BookingStatus.checkedOut,
        bookingDate: DateTime.now().subtract(const Duration(days: 14)),
        paymentMethod: 'Bank Transfer',
        isRefundable: true,
      ),
      Booking(
        id: '6',
        userId: 'user6',
        propertyId: 'prop6',
        propertyTitle: 'Lakefront Villa',
        hostId: 'host6',
        hostName: 'Maria Rodriguez',
        checkInDate: DateTime.now().add(const Duration(days: 10)),
        checkOutDate: DateTime.now().add(const Duration(days: 15)),
        guests: 8,
        totalAmount: 2000,
        status: BookingStatus.cancelled,
        bookingDate: DateTime.now().subtract(const Duration(days: 3)),
        paymentMethod: 'Credit Card',
        isRefundable: true,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ResponsiveLayout(
            mobile: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bookings Management',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle add booking
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Booking'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE31C5F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            desktop: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Bookings Management',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle add booking
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Booking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31C5F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Stats Cards
          ResponsiveLayout(
            mobile: Column(
              children: [
                AdminCard(
                  title: 'Total Bookings',
                  value: bookingStats.totalBookings.toString(),
                  icon: Icons.book_online,
                  color: Colors.blue,
                  subtitle: 'Confirmed: ${bookingStats.confirmedBookings}',
                ),
                const SizedBox(height: 16),
                AdminCard(
                  title: 'Pending Bookings',
                  value: bookingStats.pendingBookings.toString(),
                  icon: Icons.schedule,
                  color: Colors.orange,
                  subtitle: 'Awaiting confirmation',
                ),
                const SizedBox(height: 16),
                AdminCard(
                  title: 'Total Revenue',
                  value: NumberFormat.currency(symbol: '\$').format(bookingStats.totalRevenue),
                  icon: Icons.attach_money,
                  color: Colors.green,
                  subtitle: 'Avg: ${NumberFormat.currency(symbol: '\$').format(bookingStats.averageBookingValue)}',
                ),
                const SizedBox(height: 16),
                AdminCard(
                  title: 'Occupancy Rate',
                  value: '${bookingStats.occupancyRate.toStringAsFixed(1)}%',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                  subtitle: 'Current month',
                ),
              ],
            ),
            desktop: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.8,
              children: [
                AdminCard(
                  title: 'Total Bookings',
                  value: bookingStats.totalBookings.toString(),
                  icon: Icons.book_online,
                  color: Colors.blue,
                  subtitle: 'Confirmed: ${bookingStats.confirmedBookings}',
                ),
                AdminCard(
                  title: 'Pending Bookings',
                  value: bookingStats.pendingBookings.toString(),
                  icon: Icons.schedule,
                  color: Colors.orange,
                  subtitle: 'Awaiting confirmation',
                ),
                AdminCard(
                  title: 'Total Revenue',
                  value: NumberFormat.currency(symbol: '\$').format(bookingStats.totalRevenue),
                  icon: Icons.attach_money,
                  color: Colors.green,
                  subtitle: 'Avg: ${NumberFormat.currency(symbol: '\$').format(bookingStats.averageBookingValue)}',
                ),
                AdminCard(
                  title: 'Occupancy Rate',
                  value: '${bookingStats.occupancyRate.toStringAsFixed(1)}%',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                  subtitle: 'Current month',
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Text(
                  'Filter by status:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filters.map((filter) {
                        final isSelected = selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                selectedFilter = filter;
                              });
                            },
                            backgroundColor: Colors.grey.shade100,
                            selectedColor: const Color(0xFFE31C5F).withOpacity(0.2),
                            checkmarkColor: const Color(0xFFE31C5F),
                            labelStyle: TextStyle(
                              color: isSelected ? const Color(0xFFE31C5F) : Colors.grey.shade700,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Bookings Table
          AdminTable(
            headers: const ['Booking ID', 'Property', 'Guest', 'Host', 'Check-in', 'Check-out', 'Guests', 'Amount', 'Status', 'Actions'],
            rows: bookings.map((booking) {
              return [
                AdminTableCell(
                  child: Text(
                    '#${booking.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
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
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${booking.nights} nights',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    'User ${booking.userId}',
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    booking.hostName,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(booking.checkInDate),
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(booking.checkOutDate),
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    booking.guests.toString(),
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AdminTableCell(
                  child: Text(
                    NumberFormat.currency(symbol: '\$').format(booking.totalAmount),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AdminTableCell(
                  child: StatusBadge(
                    status: booking.status.displayName,
                    color: _getStatusColor(booking.status.color),
                  ),
                ),
                AdminTableCell(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _showBookingDetails(booking);
                        },
                        icon: const Icon(Icons.visibility, size: 20),
                        tooltip: 'View Details',
                      ),
                      IconButton(
                        onPressed: () {
                          _editBooking(booking);
                        },
                        icon: const Icon(Icons.edit, size: 20),
                        tooltip: 'Edit Booking',
                      ),
                      if (booking.status == BookingStatus.pending)
                        IconButton(
                          onPressed: () {
                            _confirmBooking(booking);
                          },
                          icon: const Icon(Icons.check, size: 20),
                          tooltip: 'Confirm Booking',
                        ),
                      if (booking.status == BookingStatus.confirmed)
                        IconButton(
                          onPressed: () {
                            _cancelBooking(booking);
                          },
                          icon: const Icon(Icons.cancel, size: 20),
                          tooltip: 'Cancel Booking',
                        ),
                    ],
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

  void _showBookingDetails(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Details - #${booking.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Property', booking.propertyTitle),
              _buildDetailRow('Host', booking.hostName),
              _buildDetailRow('Guest', 'User ${booking.userId}'),
              _buildDetailRow('Check-in', DateFormat('MMM dd, yyyy').format(booking.checkInDate)),
              _buildDetailRow('Check-out', DateFormat('MMM dd, yyyy').format(booking.checkOutDate)),
              _buildDetailRow('Nights', booking.nights.toString()),
              _buildDetailRow('Guests', booking.guests.toString()),
              _buildDetailRow('Total Amount', NumberFormat.currency(symbol: '\$').format(booking.totalAmount)),
              _buildDetailRow('Status', booking.status.displayName),
              _buildDetailRow('Payment Method', booking.paymentMethod),
              _buildDetailRow('Booking Date', DateFormat('MMM dd, yyyy HH:mm').format(booking.bookingDate)),
              _buildDetailRow('Refundable', booking.isRefundable ? 'Yes' : 'No'),
              if (booking.notes != null) ...[
                const SizedBox(height: 8),
                const Text(
                  'Notes:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(booking.notes!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _editBooking(Booking booking) {
    // Handle edit booking
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit booking: #${booking.id}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _confirmBooking(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Text(
          'Are you sure you want to confirm booking #${booking.id}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking confirmed successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _cancelBooking(Booking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text(
          'Are you sure you want to cancel booking #${booking.id}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking cancelled successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }
}
