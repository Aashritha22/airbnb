import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../models/auth.dart';
import '../utils/responsive.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isCollapsed = false,
  });

  final int selectedIndex;
  final Function(int) onItemSelected;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ThemeProvider>(
      builder: (context, authProvider, themeProvider, child) {
        final List<SidebarItem> items = [
          SidebarItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            index: 0,
            permission: Permission.viewAnalytics,
          ),
          SidebarItem(
            icon: Icons.people,
            title: 'Users',
            index: 1,
            permission: Permission.viewUsers,
          ),
          SidebarItem(
            icon: Icons.home,
            title: 'Properties',
            index: 2,
            permission: Permission.viewProperties,
          ),
          SidebarItem(
            icon: Icons.book_online,
            title: 'Bookings',
            index: 3,
            permission: Permission.viewBookings,
          ),
          SidebarItem(
            icon: Icons.analytics,
            title: 'Analytics',
            index: 4,
            permission: Permission.viewAnalytics,
          ),
          SidebarItem(
            icon: Icons.payment,
            title: 'Payments',
            index: 5,
            permission: Permission.viewPayments,
          ),
          SidebarItem(
            icon: Icons.support_agent,
            title: 'Support',
            index: 6,
            permission: Permission.viewTickets,
          ),
          SidebarItem(
            icon: Icons.admin_panel_settings,
            title: 'Admin Users',
            index: 7,
            permission: Permission.viewAdmins,
          ),
          SidebarItem(
            icon: Icons.settings,
            title: 'Settings',
            index: 8,
            permission: Permission.viewSettings,
          ),
        ];

        // Filter items based on permissions
        final visibleItems = items.where((item) {
          return authProvider.canAccessFeature(item.permission);
        }).toList();

              return Container(
                width: isCollapsed ? 80 : Responsive.getResponsiveValue(
                  context,
                  mobile: 280.0,
                  tablet: 260.0,
                  desktop: 280.0,
                ),
                decoration: BoxDecoration(
                  gradient: themeProvider.isDarkMode
                      ? LinearGradient(
                          colors: [
                            const Color(0xFF1A1A2E),
                            const Color(0xFF16213E),
                            const Color(0xFF0F3460),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : LinearGradient(
                          colors: [
                            Colors.grey.shade900,
                            Colors.grey.shade800,
                            Colors.grey.shade700,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(2, 0),
                    ),
                  ],
                ),
          child: Column(
            children: [
                    // Logo Section
                    Container(
                      padding: EdgeInsets.all(isCollapsed ? 16 : Responsive.getResponsiveValue(
                        context,
                        mobile: 20.0,
                        tablet: 22.0,
                        desktop: 24.0,
                      )),
                child: Row(
                  children: [
                    Container(
                      width: Responsive.getResponsiveValue(
                        context,
                        mobile: 35.0,
                        tablet: 38.0,
                        desktop: 40.0,
                      ),
                      height: Responsive.getResponsiveValue(
                        context,
                        mobile: 35.0,
                        tablet: 38.0,
                        desktop: 40.0,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE31C5F), Color(0xFFE31C5F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: Responsive.getResponsiveValue(
                          context,
                          mobile: 20.0,
                          tablet: 22.0,
                          desktop: 24.0,
                        ),
                      ),
                    ),
                    if (!isCollapsed) ...[
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                  Text(
                                    'Admin Panel',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Airbnb Clone',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white70,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Navigation Items
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: visibleItems.length,
                  itemBuilder: (context, index) {
                    final item = visibleItems[index];
                    final isSelected = selectedIndex == item.index;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => onItemSelected(item.index),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isCollapsed ? 12 : 16,
                              vertical: 12,
                            ),
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                        ? LinearGradient(
                                            colors: [
                                              const Color(0xFFE31C5F).withOpacity(0.3),
                                              const Color(0xFFE31C5F).withOpacity(0.1),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          )
                                        : null,
                                      color: themeProvider.isDarkMode && !isSelected
                                          ? Colors.grey.shade800.withOpacity(0.3)
                                          : null,
                                      borderRadius: BorderRadius.circular(12),
                                      border: isSelected
                                        ? Border.all(
                                            color: const Color(0xFFE31C5F).withOpacity(0.5),
                                            width: 1,
                                          )
                                        : null,
                                    ),
                            child: Row(
                              children: [
                        Icon(
                          item.icon,
                          color: isSelected
                            ? Colors.white
                            : Colors.white70,
                          size: Responsive.getResponsiveValue(
                            context,
                            mobile: 20.0,
                            tablet: 22.0,
                            desktop: 24.0,
                          ),
                        ),
                                if (!isCollapsed) ...[
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: Responsive.getResponsiveValue(
                                          context,
                                          mobile: 14.0,
                                          tablet: 15.0,
                                          desktop: 16.0,
                                        ),
                                        fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                        color: isSelected
                                          ? Colors.white
                                          : Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

                    // User Profile Section
                    Container(
                      padding: EdgeInsets.all(isCollapsed ? 16 : Responsive.getResponsiveValue(
                        context,
                        mobile: 16.0,
                        tablet: 18.0,
                        desktop: 20.0,
                      )),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: isCollapsed ? 16 : Responsive.getResponsiveValue(
                        context,
                        mobile: 16.0,
                        tablet: 18.0,
                        desktop: 20.0,
                      ),
                      backgroundColor: const Color(0xFFE31C5F),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: Responsive.getResponsiveValue(
                          context,
                          mobile: 16.0,
                          tablet: 18.0,
                          desktop: 20.0,
                        ),
                      ),
                    ),
                    if (!isCollapsed) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                  Text(
                                    authProvider.user?.fullName ?? 'User',
                                    style: TextStyle(
                                      fontSize: Responsive.getResponsiveValue(
                                        context,
                                        mobile: 12.0,
                                        tablet: 13.0,
                                        desktop: 14.0,
                                      ),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    authProvider.user?.roleDisplayName ?? 'Role',
                                    style: TextStyle(
                                      fontSize: Responsive.getResponsiveValue(
                                        context,
                                        mobile: 10.0,
                                        tablet: 11.0,
                                        desktop: 12.0,
                                      ),
                                      color: Colors.white70,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showLogoutDialog(context);
                        },
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white70,
                          size: Responsive.getResponsiveValue(
                            context,
                            mobile: 18.0,
                            tablet: 19.0,
                            desktop: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class SidebarItem {
  const SidebarItem({
    required this.icon,
    required this.title,
    required this.index,
    required this.permission,
  });

  final IconData icon;
  final String title;
  final int index;
  final Permission permission;
}