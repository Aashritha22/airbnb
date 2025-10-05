import 'property_category.dart';

class Property {
  const Property({
    required this.id,
    required this.title,
    required this.location,
    required this.category,
    required this.hostId,
    required this.hostName,
    required this.price,
    required this.rating,
    required this.totalReviews,
    required this.isActive,
    required this.isVerified,
    required this.createdDate,
    required this.lastUpdated,
    required this.imageUrl,
    required this.description,
    required this.amenities,
    required this.maxGuests,
    required this.bedrooms,
    required this.bathrooms,
    required this.totalBookings,
    required this.totalRevenue,
    required this.isBlocked,
  });

  final String id;
  final String title;
  final String location;
  final PropertyCategory category;
  final String hostId;
  final String hostName;
  final double price;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final bool isVerified;
  final DateTime createdDate;
  final DateTime lastUpdated;
  final String? imageUrl;
  final String description;
  final List<String> amenities;
  final int maxGuests;
  final int bedrooms;
  final int bathrooms;
  final int totalBookings;
  final double totalRevenue;
  final bool isBlocked;

  Property copyWith({
    String? id,
    String? title,
    String? location,
    PropertyCategory? category,
    String? hostId,
    String? hostName,
    double? price,
    double? rating,
    int? totalReviews,
    bool? isActive,
    bool? isVerified,
    DateTime? createdDate,
    DateTime? lastUpdated,
    String? imageUrl,
    String? description,
    List<String>? amenities,
    int? maxGuests,
    int? bedrooms,
    int? bathrooms,
    int? totalBookings,
    double? totalRevenue,
    bool? isBlocked,
  }) {
    return Property(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      category: category ?? this.category,
      hostId: hostId ?? this.hostId,
      hostName: hostName ?? this.hostName,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      createdDate: createdDate ?? this.createdDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      amenities: amenities ?? this.amenities,
      maxGuests: maxGuests ?? this.maxGuests,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      totalBookings: totalBookings ?? this.totalBookings,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}

class PropertyStats {
  const PropertyStats({
    required this.totalProperties,
    required this.activeProperties,
    required this.verifiedProperties,
    required this.blockedProperties,
    required this.averageRating,
    required this.totalRevenue,
    required this.averagePrice,
  });

  final int totalProperties;
  final int activeProperties;
  final int verifiedProperties;
  final int blockedProperties;
  final double averageRating;
  final double totalRevenue;
  final double averagePrice;
}
