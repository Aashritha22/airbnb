import 'package:equatable/equatable.dart';

enum AdminRole {
  superAdmin,
  admin,
  moderator,
  support,
}

enum AdminStatus {
  active,
  inactive,
  suspended,
}

class AdminUser extends Equatable {
  const AdminUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.lastLoginAt,
    this.profileImage,
    this.phoneNumber,
    this.department,
    this.permissions,
    this.twoFactorEnabled = false,
    this.loginAttempts = 0,
    this.lastLoginIp,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final AdminRole role;
  final AdminStatus status;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final String? profileImage;
  final String? phoneNumber;
  final String? department;
  final List<String>? permissions;
  final bool twoFactorEnabled;
  final int loginAttempts;
  final String? lastLoginIp;

  AdminUser copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    AdminRole? role,
    AdminStatus? status,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    String? profileImage,
    String? phoneNumber,
    String? department,
    List<String>? permissions,
    bool? twoFactorEnabled,
    int? loginAttempts,
    String? lastLoginIp,
  }) {
    return AdminUser(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      profileImage: profileImage ?? this.profileImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
      permissions: permissions ?? this.permissions,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      loginAttempts: loginAttempts ?? this.loginAttempts,
      lastLoginIp: lastLoginIp ?? this.lastLoginIp,
    );
  }

  String get fullName => '$firstName $lastName';

  String get roleText {
    switch (role) {
      case AdminRole.superAdmin:
        return 'Super Admin';
      case AdminRole.admin:
        return 'Admin';
      case AdminRole.moderator:
        return 'Moderator';
      case AdminRole.support:
        return 'Support';
    }
  }

  String get statusText {
    switch (status) {
      case AdminStatus.active:
        return 'Active';
      case AdminStatus.inactive:
        return 'Inactive';
      case AdminStatus.suspended:
        return 'Suspended';
    }
  }

  bool get isActive => status == AdminStatus.active;

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        role,
        status,
        createdAt,
        lastLoginAt,
        profileImage,
        phoneNumber,
        department,
        permissions,
        twoFactorEnabled,
        loginAttempts,
        lastLoginIp,
      ];

  // Sample data
  static List<AdminUser> sampleAdminUsers = [
    AdminUser(
      id: 'ADM001',
      email: 'admin@airbnb.com',
      firstName: 'John',
      lastName: 'Administrator',
      role: AdminRole.superAdmin,
      status: AdminStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      lastLoginAt: DateTime.now().subtract(const Duration(minutes: 15)),
      phoneNumber: '+1 (555) 123-4567',
      department: 'IT',
      permissions: ['all'],
      twoFactorEnabled: true,
      lastLoginIp: '192.168.1.100',
    ),
    AdminUser(
      id: 'ADM002',
      email: 'support@airbnb.com',
      firstName: 'Jane',
      lastName: 'Support',
      role: AdminRole.support,
      status: AdminStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
      phoneNumber: '+1 (555) 234-5678',
      department: 'Customer Support',
      permissions: ['users', 'bookings', 'support'],
      twoFactorEnabled: false,
      lastLoginIp: '192.168.1.101',
    ),
    AdminUser(
      id: 'ADM003',
      email: 'moderator@airbnb.com',
      firstName: 'Mike',
      lastName: 'Moderator',
      role: AdminRole.moderator,
      status: AdminStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      lastLoginAt: DateTime.now().subtract(const Duration(days: 1)),
      phoneNumber: '+1 (555) 345-6789',
      department: 'Content',
      permissions: ['properties', 'users'],
      twoFactorEnabled: true,
      lastLoginIp: '192.168.1.102',
    ),
    AdminUser(
      id: 'ADM004',
      email: 'finance@airbnb.com',
      firstName: 'Sarah',
      lastName: 'Finance',
      role: AdminRole.admin,
      status: AdminStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 120)),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 6)),
      phoneNumber: '+1 (555) 456-7890',
      department: 'Finance',
      permissions: ['payments', 'analytics', 'reports'],
      twoFactorEnabled: true,
      lastLoginIp: '192.168.1.103',
    ),
    AdminUser(
      id: 'ADM005',
      email: 'suspended@airbnb.com',
      firstName: 'Tom',
      lastName: 'Suspended',
      role: AdminRole.moderator,
      status: AdminStatus.suspended,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      lastLoginAt: DateTime.now().subtract(const Duration(days: 7)),
      phoneNumber: '+1 (555) 567-8901',
      department: 'Content',
      permissions: ['properties'],
      twoFactorEnabled: false,
      loginAttempts: 5,
      lastLoginIp: '192.168.1.104',
    ),
  ];
}

class AdminUserStats {
  const AdminUserStats({
    required this.totalAdmins,
    required this.activeAdmins,
    required this.inactiveAdmins,
    required this.suspendedAdmins,
    required this.superAdmins,
    required this.regularAdmins,
    required this.supportStaff,
    required this.moderators,
  });

  final int totalAdmins;
  final int activeAdmins;
  final int inactiveAdmins;
  final int suspendedAdmins;
  final int superAdmins;
  final int regularAdmins;
  final int supportStaff;
  final int moderators;

  static AdminUserStats calculateStats(List<AdminUser> admins) {
    final totalAdmins = admins.length;
    final activeAdmins = admins.where((a) => a.status == AdminStatus.active).length;
    final inactiveAdmins = admins.where((a) => a.status == AdminStatus.inactive).length;
    final suspendedAdmins = admins.where((a) => a.status == AdminStatus.suspended).length;
    final superAdmins = admins.where((a) => a.role == AdminRole.superAdmin).length;
    final regularAdmins = admins.where((a) => a.role == AdminRole.admin).length;
    final supportStaff = admins.where((a) => a.role == AdminRole.support).length;
    final moderators = admins.where((a) => a.role == AdminRole.moderator).length;

    return AdminUserStats(
      totalAdmins: totalAdmins,
      activeAdmins: activeAdmins,
      inactiveAdmins: inactiveAdmins,
      suspendedAdmins: suspendedAdmins,
      superAdmins: superAdmins,
      regularAdmins: regularAdmins,
      supportStaff: supportStaff,
      moderators: moderators,
    );
  }
}
