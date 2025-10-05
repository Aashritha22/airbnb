import 'package:flutter/material.dart';
import '../widgets/admin_sidebar.dart';
import '../utils/responsive.dart';
import 'dashboard_overview_screen.dart';
import 'users_screen.dart';
import 'properties_screen.dart';
import 'bookings_screen.dart';
import 'analytics_screen.dart';
import 'payments_screen.dart';
import 'support_screen.dart';
import 'settings_screen.dart';
import 'admin_users_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int selectedIndex = 0;
  bool isSidebarCollapsed = false;
  bool isMobileMenuOpen = false;

  final List<Widget> screens = [
    const DashboardOverviewScreen(),
    const UsersScreen(),
    const PropertiesScreen(),
    const BookingsScreen(),
    const AnalyticsScreen(),
    const PaymentsScreen(),
    const SupportScreen(),
    const AdminUsersScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive.isMobile(context) ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Mobile Top Bar
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Menu Button
              IconButton(
                onPressed: () {
                  setState(() {
                    isMobileMenuOpen = !isMobileMenuOpen;
                  });
                },
                icon: Icon(
                  isMobileMenuOpen ? Icons.close : Icons.menu,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(width: 8),

              // Page Title
              Expanded(
                child: Text(
                  _getPageTitle(),
                  style: const TextStyle(
                    fontSize: 16, // Reduced from 18
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 4), // Reduced spacing

              // Notifications
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      // Handle notifications
                    },
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: Colors.grey.shade600,
                      size: 20, // Reduced size
                    ),
                  ),
                  Positioned(
                    right: 6, // Reduced from 8
                    top: 6,   // Reduced from 8
                    child: Container(
                      width: 6, // Reduced from 8
                      height: 6, // Reduced from 8
                      decoration: const BoxDecoration(
                        color: Color(0xFFE31C5F),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),

              // Profile
              CircleAvatar(
                radius: 14, // Reduced from 16
                backgroundColor: const Color(0xFFE31C5F),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 14, // Reduced from 16
                ),
              ),
            ],
          ),
        ),
        
        // Mobile Menu Drawer
        if (isMobileMenuOpen)
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: AdminSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  selectedIndex = index;
                  isMobileMenuOpen = false;
                });
              },
              isCollapsed: false,
            ),
          ),
        
        // Screen Content
        Expanded(
          child: screens[selectedIndex],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Sidebar
        AdminSidebar(
          selectedIndex: selectedIndex,
          onItemSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          isCollapsed: isSidebarCollapsed,
        ),
        
        // Main Content
        Expanded(
          child: Column(
            children: [
              // Top Bar
              Container(
                height: Responsive.getResponsiveValue(
                  context,
                  mobile: 60.0,
                  tablet: 70.0,
                  desktop: 80.0,
                ),
                padding: Responsive.getResponsiveHorizontalPadding(context).copyWith(
                  top: 16,
                  bottom: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Toggle Sidebar Button
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isSidebarCollapsed = !isSidebarCollapsed;
                        });
                      },
                      icon: Icon(
                        isSidebarCollapsed ? Icons.menu : Icons.menu_open,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Page Title
                    Text(
                      _getPageTitle(),
                      style: TextStyle(
                        fontSize: Responsive.getResponsiveValue(
                          context,
                          mobile: 18.0,
                          tablet: 20.0,
                          desktop: 24.0,
                        ),
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Search Bar
                    if (!Responsive.isTablet(context))
                      Container(
                        width: Responsive.getResponsiveValue(
                          context,
                          mobile: 200.0,
                          tablet: 250.0,
                          desktop: 300.0,
                        ),
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade500,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    
                    const SizedBox(width: 16),
                    
                    // Notifications
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            // Handle notifications
                          },
                          icon: Icon(
                            Icons.notifications_outlined,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE31C5F),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    // Profile
                    CircleAvatar(
                      radius: Responsive.getResponsiveValue(
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
                  ],
                ),
              ),
              
              // Screen Content
              Expanded(
                child: screens[selectedIndex],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getPageTitle() {
    switch (selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Users';
      case 2:
        return 'Properties';
      case 3:
        return 'Bookings';
      case 4:
        return 'Analytics';
      case 5:
        return 'Payments';
      case 6:
        return 'Support';
      case 7:
        return 'Settings';
      default:
        return 'Dashboard';
    }
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '$title Screen',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
