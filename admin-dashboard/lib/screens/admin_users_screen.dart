import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/admin_user.dart';
import '../widgets/admin_card.dart';
import '../widgets/admin_table.dart';
import '../widgets/responsive_layout.dart';
import '../utils/responsive.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  List<AdminUser> _adminUsers = AdminUser.sampleAdminUsers;
  String _searchQuery = '';
  String _selectedRole = 'All';
  String _selectedStatus = 'All';
  final AdminUserStats _adminStats = AdminUserStats.calculateStats(AdminUser.sampleAdminUsers);

  final List<String> _roleFilters = [
    'All',
    'Super Admin',
    'Admin',
    'Moderator',
    'Support',
  ];

  final List<String> _statusFilters = [
    'All',
    'Active',
    'Inactive',
    'Suspended',
  ];

  void _updateAdminStatus(AdminUser admin, AdminStatus newStatus) {
    setState(() {
      final int index = _adminUsers.indexOf(admin);
      if (index != -1) {
        _adminUsers[index] = admin.copyWith(status: newStatus);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Admin user status updated to ${newStatus.name}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  List<AdminUser> get _filteredAdminUsers {
    return _adminUsers.where((AdminUser admin) {
      final bool matchesSearch = admin.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          admin.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final bool matchesRole = _selectedRole == 'All' || admin.roleText == _selectedRole;
      final bool matchesStatus = _selectedStatus == 'All' || admin.statusText == _selectedStatus;
      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  Color _getStatusColor(AdminStatus status) {
    switch (status) {
      case AdminStatus.active:
        return Colors.green;
      case AdminStatus.inactive:
        return Colors.orange;
      case AdminStatus.suspended:
        return Colors.red;
    }
  }

  Color _getRoleColor(AdminRole role) {
    switch (role) {
      case AdminRole.superAdmin:
        return Colors.purple;
      case AdminRole.admin:
        return Colors.blue;
      case AdminRole.moderator:
        return Colors.orange;
      case AdminRole.support:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  'Admin Users',
                  style: TextStyle(
                    fontSize: Responsive.getResponsiveValue(
                      context,
                      mobile: 20.0,
                      tablet: 24.0,
                      desktop: 28.0,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showAddAdminDialog();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Admin'),
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
              children: [
                Text(
                  'Admin Users',
                  style: TextStyle(
                    fontSize: Responsive.getResponsiveValue(
                      context,
                      mobile: 20.0,
                      tablet: 24.0,
                      desktop: 28.0,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddAdminDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Admin'),
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
                title: 'Total Admins',
                value: _adminStats.totalAdmins.toString(),
                icon: Icons.admin_panel_settings,
                color: Colors.blue,
                subtitle: '${_adminStats.activeAdmins} active',
              ),
              AdminCard(
                title: 'Super Admins',
                value: _adminStats.superAdmins.toString(),
                icon: Icons.star,
                color: Colors.purple,
                subtitle: 'Full access',
              ),
              AdminCard(
                title: 'Support Staff',
                value: _adminStats.supportStaff.toString(),
                icon: Icons.support_agent,
                color: Colors.green,
                subtitle: 'Customer support',
              ),
              AdminCard(
                title: 'Active Sessions',
                value: '3',
                icon: Icons.people,
                color: Colors.orange,
                subtitle: 'Currently online',
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Search and Filters
          Container(
            padding: Responsive.getResponsiveEdgeInsets(context),
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
                      hintText: 'Search by name or email...',
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
                ResponsiveLayout(
                  mobile: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filters:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Role Filter
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: _roleFilters
                              .map((String role) => DropdownMenuItem<String>(
                                    value: role,
                                    child: Text(role),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRole = newValue!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Status Filter
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: _statusFilters
                              .map((String status) => DropdownMenuItem<String>(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedStatus = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  desktop: Row(
                    children: [
                      const Text(
                        'Filters:',
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
                            children: [
                              // Role Filter
                              DropdownButton<String>(
                                value: _selectedRole,
                                items: _roleFilters
                                    .map((String role) => DropdownMenuItem<String>(
                                          value: role,
                                          child: Text(role),
                                        ))
                                    .toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedRole = newValue!;
                                  });
                                },
                              ),
                              const SizedBox(width: 16),
                              // Status Filter
                              DropdownButton<String>(
                                value: _selectedStatus,
                                items: _statusFilters
                                    .map((String status) => DropdownMenuItem<String>(
                                          value: status,
                                          child: Text(status),
                                        ))
                                    .toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedStatus = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Admin Users Table
          ResponsiveLayout(
            mobile: _buildMobileAdminTable(),
            desktop: _buildDesktopAdminTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileAdminTable() {
    return Column(
      children: _filteredAdminUsers.map((admin) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _getRoleColor(admin.role),
                      child: Text(
                        admin.firstName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            admin.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            admin.email,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(admin.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        admin.statusText,
                        style: TextStyle(
                          color: _getStatusColor(admin.status),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Role',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getRoleColor(admin.role).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              admin.roleText,
                              style: TextStyle(
                                color: _getRoleColor(admin.role),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Department',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            admin.department ?? 'N/A',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Login',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            DateFormat('MMM dd, yyyy').format(admin.lastLoginAt),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2FA',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Icon(
                            admin.twoFactorEnabled ? Icons.check_circle : Icons.cancel,
                            color: admin.twoFactorEnabled ? Colors.green : Colors.red,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, size: 20),
                      onPressed: () => _showAdminDetails(admin),
                      tooltip: 'View Details',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditAdminDialog(admin),
                      tooltip: 'Edit',
                    ),
                    if (admin.status == AdminStatus.active)
                      IconButton(
                        icon: const Icon(Icons.pause, color: Colors.orange, size: 20),
                        onPressed: () => _updateAdminStatus(admin, AdminStatus.inactive),
                        tooltip: 'Deactivate',
                      )
                    else if (admin.status == AdminStatus.inactive)
                      IconButton(
                        icon: const Icon(Icons.play_arrow, color: Colors.green, size: 20),
                        onPressed: () => _updateAdminStatus(admin, AdminStatus.active),
                        tooltip: 'Activate',
                      ),
                    if (admin.status != AdminStatus.suspended)
                      IconButton(
                        icon: const Icon(Icons.block, color: Colors.red, size: 20),
                        onPressed: () => _updateAdminStatus(admin, AdminStatus.suspended),
                        tooltip: 'Suspend',
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDesktopAdminTable() {
    return AdminTable(
      headers: const [
        'Admin',
        'Email',
        'Role',
        'Department',
        'Status',
        'Last Login',
        '2FA',
        'Actions'
      ],
      rows: _filteredAdminUsers.map((AdminUser admin) {
        return [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: _getRoleColor(admin.role),
                child: Text(
                  admin.firstName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      admin.fullName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (admin.phoneNumber != null)
                      Text(
                        admin.phoneNumber!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Text(
              admin.email,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getRoleColor(admin.role).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                admin.roleText,
                style: TextStyle(
                  color: _getRoleColor(admin.role),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            child: Text(
              admin.department ?? 'N/A',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(admin.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                admin.statusText,
                style: TextStyle(
                  color: _getStatusColor(admin.status),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(admin.lastLoginAt),
                  overflow: TextOverflow.ellipsis,
                ),
                if (admin.lastLoginIp != null)
                  Text(
                    admin.lastLoginIp!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontFamily: 'monospace',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Icon(
            admin.twoFactorEnabled ? Icons.check_circle : Icons.cancel,
            color: admin.twoFactorEnabled ? Colors.green : Colors.red,
            size: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 18),
                onPressed: () => _showAdminDetails(admin),
                tooltip: 'View Details',
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () => _showEditAdminDialog(admin),
                tooltip: 'Edit',
              ),
              if (admin.status == AdminStatus.active)
                IconButton(
                  icon: const Icon(Icons.pause, color: Colors.orange, size: 18),
                  onPressed: () => _updateAdminStatus(admin, AdminStatus.inactive),
                  tooltip: 'Deactivate',
                )
              else if (admin.status == AdminStatus.inactive)
                IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.green, size: 18),
                  onPressed: () => _updateAdminStatus(admin, AdminStatus.active),
                  tooltip: 'Activate',
                ),
              if (admin.status != AdminStatus.suspended)
                IconButton(
                  icon: const Icon(Icons.block, color: Colors.red, size: 18),
                  onPressed: () => _updateAdminStatus(admin, AdminStatus.suspended),
                  tooltip: 'Suspend',
                ),
            ],
          ),
        ];
      }).toList(),
    );
  }

  void _showAdminDetails(AdminUser admin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Admin Details - ${admin.fullName}'),
        content: SizedBox(
          width: Responsive.getResponsiveValue(
            context,
            mobile: 300.0,
            tablet: 400.0,
            desktop: 500.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('ID', admin.id),
              _buildDetailRow('Email', admin.email),
              _buildDetailRow('Name', admin.fullName),
              _buildDetailRow('Role', admin.roleText),
              _buildDetailRow('Department', admin.department ?? 'N/A'),
              _buildDetailRow('Status', admin.statusText),
              _buildDetailRow('Phone', admin.phoneNumber ?? 'N/A'),
              _buildDetailRow('Created', DateFormat('MMM dd, yyyy').format(admin.createdAt)),
              _buildDetailRow('Last Login', DateFormat('MMM dd, yyyy HH:mm').format(admin.lastLoginAt)),
              if (admin.lastLoginIp != null)
                _buildDetailRow('Last Login IP', admin.lastLoginIp!),
              _buildDetailRow('2FA Enabled', admin.twoFactorEnabled ? 'Yes' : 'No'),
              _buildDetailRow('Login Attempts', admin.loginAttempts.toString()),
              if (admin.permissions != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Permissions:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: admin.permissions!
                      .map((permission) => Chip(
                            label: Text(permission),
                            backgroundColor: Colors.blue.shade100,
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditAdminDialog(admin);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE31C5F),
              foregroundColor: Colors.white,
            ),
            child: const Text('Edit'),
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

  void _showAddAdminDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Admin'),
        content: const Text('Add admin form would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Admin user added successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE31C5F),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Admin'),
          ),
        ],
      ),
    );
  }

  void _showEditAdminDialog(AdminUser admin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Admin - ${admin.fullName}'),
        content: const Text('Edit admin form would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Admin user updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE31C5F),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
