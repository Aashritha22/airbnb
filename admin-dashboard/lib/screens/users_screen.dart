import 'package:flutter/material.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_card.dart';
import '../widgets/responsive_layout.dart';
import '../utils/responsive.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String _searchQuery = '';
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Verified', 'Hosts', 'Blocked', 'New'];

  @override
  Widget build(BuildContext context) {
    // Sample data - in a real app, this would come from an API
    final userStats = const UserStats(
      totalUsers: 850,
      newUsersThisMonth: 45,
      verifiedUsers: 720,
      hostUsers: 180,
      activeUsers: 820,
      blockedUsers: 30,
    );

    final users = [
      const User(
        id: '1',
        fullName: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+1 (555) 123-4567',
        joinDate: '2024-01-15',
        totalBookings: 12,
        totalSpent: 3200.0,
        averageRating: 4.8,
        isBlocked: false,
      ),
      const User(
        id: '2',
        fullName: 'Jane Smith',
        email: 'jane.smith@example.com',
        phone: '+1 (555) 234-5678',
        joinDate: '2024-02-20',
        totalBookings: 8,
        totalSpent: 2100.0,
        averageRating: 4.6,
        isBlocked: false,
      ),
      const User(
        id: '3',
        fullName: 'Mike Johnson',
        email: 'mike.johnson@example.com',
        phone: '+1 (555) 345-6789',
        joinDate: '2024-03-10',
        totalBookings: 15,
        totalSpent: 5200.0,
        averageRating: 4.9,
        isBlocked: true,
      ),
    ];

    return SingleChildScrollView(
      padding: Responsive.getResponsiveEdgeInsets(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ResponsiveLayout(
            mobile: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Users Management',
                  style: TextStyle(
                    fontSize: Responsive.getResponsiveValue(
                      context,
                      mobile: 20.0,
                      tablet: 24.0,
                      desktop: 28.0,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Handle add user
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add User'),
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
                Expanded(
                  child: Text(
                    'Users Management',
                    style: TextStyle(
                      fontSize: Responsive.getResponsiveValue(
                        context,
                        mobile: 20.0,
                        tablet: 24.0,
                        desktop: 28.0,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle add user
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add User'),
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
          ResponsiveGrid(
            children: [
              AdminCard(
                title: 'Total Users',
                value: userStats.totalUsers.toString(),
                icon: Icons.people,
                color: Colors.blue,
                subtitle: 'New this month: ${userStats.newUsersThisMonth}',
              ),
              AdminCard(
                title: 'Verified Users',
                value: userStats.verifiedUsers.toString(),
                icon: Icons.verified,
                color: Colors.green,
                subtitle: '${((userStats.verifiedUsers / userStats.totalUsers) * 100).toStringAsFixed(1)}% of total',
              ),
              AdminCard(
                title: 'Host Users',
                value: userStats.hostUsers.toString(),
                icon: Icons.home,
                color: Colors.purple,
                subtitle: '${((userStats.hostUsers / userStats.totalUsers) * 100).toStringAsFixed(1)}% of total',
              ),
              AdminCard(
                title: 'Blocked Users',
                value: userStats.blockedUsers.toString(),
                icon: Icons.block,
                color: Colors.red,
                subtitle: '${((userStats.blockedUsers / userStats.totalUsers) * 100).toStringAsFixed(1)}% of total',
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Search and Filters
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.grey.shade50,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search users by name or email...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE31C5F), Color(0xFFE31C5F)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey.shade500,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Filter Chips
                Row(
                  children: [
                    const Text(
                      'Filter by:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
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
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Users Table
          AdminTable(
            headers: const ['User', 'Email', 'Phone', 'Join Date', 'Status', 'Bookings', 'Actions'],
            rows: users.map((user) {
              return [
                AdminTableCell(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blueGrey.shade100,
                        child: Text(
                          user.fullName.substring(0, 1).toUpperCase(),
                          style: TextStyle(color: Colors.blueGrey.shade700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          user.fullName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                AdminTableCell(child: Text(user.email, overflow: TextOverflow.ellipsis)),
                AdminTableCell(child: Text(user.phone, overflow: TextOverflow.ellipsis)),
                AdminTableCell(child: Text(user.joinDate, overflow: TextOverflow.ellipsis)),
                AdminTableCell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: user.isBlocked ? Colors.red.shade100 : Colors.green.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      user.isBlocked ? 'Blocked' : 'Active',
                      style: TextStyle(
                        color: user.isBlocked ? Colors.red.shade700 : Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                AdminTableCell(child: Text(user.totalBookings.toString())),
                AdminTableCell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.visibility, size: 18),
                        onPressed: () {
                          // View user details
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () {
                          // Edit user
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          // Toggle user status
                        },
                        icon: Icon(
                          user.isBlocked ? Icons.check_circle : Icons.block,
                          size: 18,
                        ),
                        tooltip: user.isBlocked ? 'Unblock User' : 'Block User',
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
}

// Sample User model for demonstration
class User {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.joinDate,
    required this.totalBookings,
    required this.totalSpent,
    required this.averageRating,
    required this.isBlocked,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String joinDate;
  final int totalBookings;
  final double totalSpent;
  final double averageRating;
  final bool isBlocked;
}

class UserStats {
  const UserStats({
    required this.totalUsers,
    required this.newUsersThisMonth,
    required this.verifiedUsers,
    required this.hostUsers,
    required this.activeUsers,
    required this.blockedUsers,
  });

  final int totalUsers;
  final int newUsersThisMonth;
  final int verifiedUsers;
  final int hostUsers;
  final int activeUsers;
  final int blockedUsers;
}