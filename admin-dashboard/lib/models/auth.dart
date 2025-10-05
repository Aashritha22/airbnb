import 'package:equatable/equatable.dart';

enum UserRole {
  superAdmin,
  admin,
  moderator,
  support,
  guest,
}

enum Permission {
  // User Management
  viewUsers,
  createUsers,
  editUsers,
  deleteUsers,
  blockUsers,
  
  // Property Management
  viewProperties,
  createProperties,
  editProperties,
  deleteProperties,
  verifyProperties,
  
  // Booking Management
  viewBookings,
  createBookings,
  editBookings,
  deleteBookings,
  cancelBookings,
  
  // Payment Management
  viewPayments,
  processPayments,
  refundPayments,
  viewFinancials,
  
  // Support Management
  viewTickets,
  createTickets,
  editTickets,
  closeTickets,
  
  // Analytics
  viewAnalytics,
  exportReports,
  
  // Admin Management
  viewAdmins,
  createAdmins,
  editAdmins,
  deleteAdmins,
  
  // Settings
  viewSettings,
  editSettings,
  systemSettings,
}

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.role,
    required this.permissions,
    required this.isActive,
    this.profileImage,
    this.lastLogin,
    this.createdAt,
  });

  final String id;
  final String email;
  final String username;
  final String fullName;
  final UserRole role;
  final List<Permission> permissions;
  final bool isActive;
  final String? profileImage;
  final DateTime? lastLogin;
  final DateTime? createdAt;

  AuthUser copyWith({
    String? id,
    String? email,
    String? username,
    String? fullName,
    UserRole? role,
    List<Permission>? permissions,
    bool? isActive,
    String? profileImage,
    DateTime? lastLogin,
    DateTime? createdAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      isActive: isActive ?? this.isActive,
      profileImage: profileImage ?? this.profileImage,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get roleDisplayName {
    switch (role) {
      case UserRole.superAdmin:
        return 'Super Administrator';
      case UserRole.admin:
        return 'Administrator';
      case UserRole.moderator:
        return 'Moderator';
      case UserRole.support:
        return 'Support Staff';
      case UserRole.guest:
        return 'Guest';
    }
  }

  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

  bool hasAnyPermission(List<Permission> permissionList) {
    return permissionList.any((permission) => permissions.contains(permission));
  }

  bool hasAllPermissions(List<Permission> permissionList) {
    return permissionList.every((permission) => permissions.contains(permission));
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        fullName,
        role,
        permissions,
        isActive,
        profileImage,
        lastLogin,
        createdAt,
      ];
}

class AuthState extends Equatable {
  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
  });

  final AuthUser? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  AuthState copyWith({
    AuthUser? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [user, isAuthenticated, isLoading, error];
}

class RolePermissions {
  static const Map<UserRole, List<Permission>> rolePermissions = {
    UserRole.superAdmin: [
      // All permissions
      Permission.viewUsers,
      Permission.createUsers,
      Permission.editUsers,
      Permission.deleteUsers,
      Permission.blockUsers,
      Permission.viewProperties,
      Permission.createProperties,
      Permission.editProperties,
      Permission.deleteProperties,
      Permission.verifyProperties,
      Permission.viewBookings,
      Permission.createBookings,
      Permission.editBookings,
      Permission.deleteBookings,
      Permission.cancelBookings,
      Permission.viewPayments,
      Permission.processPayments,
      Permission.refundPayments,
      Permission.viewFinancials,
      Permission.viewTickets,
      Permission.createTickets,
      Permission.editTickets,
      Permission.closeTickets,
      Permission.viewAnalytics,
      Permission.exportReports,
      Permission.viewAdmins,
      Permission.createAdmins,
      Permission.editAdmins,
      Permission.deleteAdmins,
      Permission.viewSettings,
      Permission.editSettings,
      Permission.systemSettings,
    ],
    UserRole.admin: [
      Permission.viewUsers,
      Permission.createUsers,
      Permission.editUsers,
      Permission.blockUsers,
      Permission.viewProperties,
      Permission.createProperties,
      Permission.editProperties,
      Permission.verifyProperties,
      Permission.viewBookings,
      Permission.createBookings,
      Permission.editBookings,
      Permission.cancelBookings,
      Permission.viewPayments,
      Permission.processPayments,
      Permission.refundPayments,
      Permission.viewFinancials,
      Permission.viewTickets,
      Permission.createTickets,
      Permission.editTickets,
      Permission.closeTickets,
      Permission.viewAnalytics,
      Permission.exportReports,
      Permission.viewAdmins,
      Permission.viewSettings,
      Permission.editSettings,
    ],
    UserRole.moderator: [
      Permission.viewUsers,
      Permission.editUsers,
      Permission.blockUsers,
      Permission.viewProperties,
      Permission.editProperties,
      Permission.verifyProperties,
      Permission.viewBookings,
      Permission.editBookings,
      Permission.cancelBookings,
      Permission.viewPayments,
      Permission.viewTickets,
      Permission.createTickets,
      Permission.editTickets,
      Permission.closeTickets,
      Permission.viewAnalytics,
    ],
    UserRole.support: [
      Permission.viewUsers,
      Permission.viewProperties,
      Permission.viewBookings,
      Permission.viewPayments,
      Permission.viewTickets,
      Permission.createTickets,
      Permission.editTickets,
      Permission.closeTickets,
    ],
    UserRole.guest: [],
  };

  static List<Permission> getPermissionsForRole(UserRole role) {
    return rolePermissions[role] ?? [];
  }

  static bool canAccessFeature(UserRole role, Permission permission) {
    final permissions = getPermissionsForRole(role);
    return permissions.contains(permission);
  }
}

// Sample authenticated users for testing
class AuthRepository {
  static final List<AuthUser> _users = [
    AuthUser(
      id: '1',
      email: 'superadmin@airbnb.com',
      username: 'superadmin',
      fullName: 'Super Administrator',
      role: UserRole.superAdmin,
      permissions: RolePermissions.getPermissionsForRole(UserRole.superAdmin),
      isActive: true,
      lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    AuthUser(
      id: '2',
      email: 'admin@airbnb.com',
      username: 'admin',
      fullName: 'Administrator',
      role: UserRole.admin,
      permissions: RolePermissions.getPermissionsForRole(UserRole.admin),
      isActive: true,
      lastLogin: DateTime.now().subtract(const Duration(hours: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
    ),
    AuthUser(
      id: '3',
      email: 'moderator@airbnb.com',
      username: 'moderator',
      fullName: 'Content Moderator',
      role: UserRole.moderator,
      permissions: RolePermissions.getPermissionsForRole(UserRole.moderator),
      isActive: true,
      lastLogin: DateTime.now().subtract(const Duration(minutes: 30)),
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    AuthUser(
      id: '4',
      email: 'support@airbnb.com',
      username: 'support',
      fullName: 'Support Staff',
      role: UserRole.support,
      permissions: RolePermissions.getPermissionsForRole(UserRole.support),
      isActive: true,
      lastLogin: DateTime.now().subtract(const Duration(minutes: 15)),
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
  ];

  static Future<AuthUser?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple authentication logic (in real app, this would be API call)
    final user = _users.firstWhere(
      (user) => user.email == email && user.isActive,
      orElse: () => throw Exception('Invalid credentials'),
    );
    
    // In real app, verify password hash
    if (password == 'password123') {
      return user.copyWith(
        lastLogin: DateTime.now(),
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  static Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // In real app, this would invalidate the session
  }

  static AuthUser? getCurrentUser() {
    // In real app, this would get user from secure storage
    return _users.first;
  }
}
