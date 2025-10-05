class User {
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.joinDate,
    required this.isVerified,
    required this.isHost,
    required this.isActive,
    required this.profileImage,
    required this.totalBookings,
    required this.totalSpent,
    required this.averageRating,
    required this.isBlocked,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final DateTime joinDate;
  final bool isVerified;
  final bool isHost;
  final bool isActive;
  final String? profileImage;
  final int totalBookings;
  final double totalSpent;
  final double averageRating;
  final bool isBlocked;

  String get fullName => '$firstName $lastName';

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? dateOfBirth,
    String? gender,
    DateTime? joinDate,
    bool? isVerified,
    bool? isHost,
    bool? isActive,
    String? profileImage,
    int? totalBookings,
    double? totalSpent,
    double? averageRating,
    bool? isBlocked,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      joinDate: joinDate ?? this.joinDate,
      isVerified: isVerified ?? this.isVerified,
      isHost: isHost ?? this.isHost,
      isActive: isActive ?? this.isActive,
      profileImage: profileImage ?? this.profileImage,
      totalBookings: totalBookings ?? this.totalBookings,
      totalSpent: totalSpent ?? this.totalSpent,
      averageRating: averageRating ?? this.averageRating,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
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
