class Analytics {
  const Analytics({
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.totalBookings,
    required this.monthlyBookings,
    required this.totalUsers,
    required this.monthlyUsers,
    required this.totalProperties,
    required this.monthlyProperties,
    required this.occupancyRate,
    required this.averageRating,
    required this.revenueGrowth,
    required this.bookingGrowth,
    required this.userGrowth,
    required this.propertyGrowth,
  });

  final double totalRevenue;
  final double monthlyRevenue;
  final int totalBookings;
  final int monthlyBookings;
  final int totalUsers;
  final int monthlyUsers;
  final int totalProperties;
  final int monthlyProperties;
  final double occupancyRate;
  final double averageRating;
  final double revenueGrowth;
  final double bookingGrowth;
  final double userGrowth;
  final double propertyGrowth;
}

class RevenueData {
  const RevenueData({
    required this.month,
    required this.revenue,
    required this.bookings,
  });

  final String month;
  final double revenue;
  final int bookings;
}

class UserGrowthData {
  const UserGrowthData({
    required this.month,
    required this.newUsers,
    required this.totalUsers,
  });

  final String month;
  final int newUsers;
  final int totalUsers;
}

class PropertyCategoryData {
  const PropertyCategoryData({
    required this.category,
    required this.count,
    required this.revenue,
    required this.percentage,
  });

  final String category;
  final int count;
  final double revenue;
  final double percentage;
}

class TopLocation {
  const TopLocation({
    required this.location,
    required this.bookings,
    required this.revenue,
    required this.averageRating,
  });

  final String location;
  final int bookings;
  final double revenue;
  final double averageRating;
}
