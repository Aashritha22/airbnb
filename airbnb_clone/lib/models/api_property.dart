class ApiProperty {
  final String id;
  final String title;
  final String description;
  final PropertyLocation location;
  final PropertyCategory category;
  final PropertyHost host;
  final PropertyPrice price;
  final PropertyCapacity capacity;
  final List<PropertyAmenity> amenities;
  final List<PropertyImage> images;
  final PropertyAvailability availability;
  final PropertyRatings ratings;
  final PropertyReviews reviews;
  final PropertyStatistics statistics;
  final PropertyStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApiProperty({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.category,
    required this.host,
    required this.price,
    required this.capacity,
    required this.amenities,
    required this.images,
    required this.availability,
    required this.ratings,
    required this.reviews,
    required this.statistics,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApiProperty.fromJson(Map<String, dynamic> json) {
    return ApiProperty(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: PropertyLocation.fromJson(json['location'] ?? {}),
      category: PropertyCategory.fromJson(json['category'] ?? {}),
      host: PropertyHost.fromJson(json['host'] ?? {}),
      price: PropertyPrice.fromJson(json['price'] ?? {}),
      capacity: PropertyCapacity.fromJson(json['capacity'] ?? {}),
      amenities: (json['amenities'] as List?)
          ?.map((amenity) => PropertyAmenity.fromJson(amenity))
          .toList() ?? [],
      images: (json['images'] as List?)
          ?.map((image) => PropertyImage.fromJson(image))
          .toList() ?? [],
      availability: PropertyAvailability.fromJson(json['availability'] ?? {}),
      ratings: PropertyRatings.fromJson(json['ratings'] ?? {}),
      reviews: PropertyReviews.fromJson(json['reviews'] ?? {}),
      statistics: PropertyStatistics.fromJson(json['statistics'] ?? {}),
      status: PropertyStatus.fromJson(json['status'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location.toJson(),
      'category': category.toJson(),
      'host': host.toJson(),
      'price': price.toJson(),
      'capacity': capacity.toJson(),
      'amenities': amenities.map((amenity) => amenity.toJson()).toList(),
      'images': images.map((image) => image.toJson()).toList(),
      'availability': availability.toJson(),
      'ratings': ratings.toJson(),
      'reviews': reviews.toJson(),
      'statistics': statistics.toJson(),
      'status': status.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper getters for compatibility with existing UI
  String get imageUrl => images.isNotEmpty ? images.first.url : '';
  String get imageEmoji => category.emoji;
  String get hostName => host.firstName + ' ' + host.lastName;
  bool get isGuestFavourite => statistics.favoriteCount > 0;
  int get imageCount => images.length;
  List<Review> get reviewsList => []; // Will be populated from reviews endpoint
}

class PropertyLocation {
  final String address;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final PropertyCoordinates coordinates;

  PropertyLocation({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.coordinates,
  });

  factory PropertyLocation.fromJson(Map<String, dynamic> json) {
    return PropertyLocation(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipCode: json['zipCode'] ?? '',
      coordinates: PropertyCoordinates.fromJson(json['coordinates'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
      'coordinates': coordinates.toJson(),
    };
  }

  String get fullLocation => '$city, $state';
  String get distance => '2.5 km away'; // This would come from user's location
}

class PropertyCoordinates {
  final double latitude;
  final double longitude;

  PropertyCoordinates({
    required this.latitude,
    required this.longitude,
  });

  factory PropertyCoordinates.fromJson(Map<String, dynamic> json) {
    return PropertyCoordinates(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class PropertyCategory {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final String icon;
  final String color;

  PropertyCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.icon,
    required this.color,
  });

  factory PropertyCategory.fromJson(Map<String, dynamic> json) {
    return PropertyCategory(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      emoji: json['emoji'] ?? '🏠',
      description: json['description'] ?? '',
      icon: json['icon'] ?? 'home',
      color: json['color'] ?? '#6B7280',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'description': description,
      'icon': icon,
      'color': color,
    };
  }
}

class PropertyHost {
  final String id;
  final String firstName;
  final String lastName;
  final String? profileImage;
  final bool isVerified;

  PropertyHost({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    required this.isVerified,
  });

  factory PropertyHost.fromJson(Map<String, dynamic> json) {
    return PropertyHost(
      id: json['_id'] ?? json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      profileImage: json['profileImage'],
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'profileImage': profileImage,
      'isVerified': isVerified,
    };
  }
}

class PropertyPrice {
  final double basePrice;
  final String currency;
  final double cleaningFee;
  final double serviceFee;
  final double taxes;

  PropertyPrice({
    required this.basePrice,
    required this.currency,
    required this.cleaningFee,
    required this.serviceFee,
    required this.taxes,
  });

  factory PropertyPrice.fromJson(Map<String, dynamic> json) {
    return PropertyPrice(
      basePrice: (json['basePrice'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'USD',
      cleaningFee: (json['cleaningFee'] ?? 0.0).toDouble(),
      serviceFee: (json['serviceFee'] ?? 0.0).toDouble(),
      taxes: (json['taxes'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basePrice': basePrice,
      'currency': currency,
      'cleaningFee': cleaningFee,
      'serviceFee': serviceFee,
      'taxes': taxes,
    };
  }

  double get totalPrice => basePrice + cleaningFee + serviceFee + taxes;
  String get priceText => '\$${basePrice.toStringAsFixed(0)}';
}

class PropertyCapacity {
  final int maxGuests;
  final int bedrooms;
  final int bathrooms;
  final int beds;

  PropertyCapacity({
    required this.maxGuests,
    required this.bedrooms,
    required this.bathrooms,
    required this.beds,
  });

  factory PropertyCapacity.fromJson(Map<String, dynamic> json) {
    return PropertyCapacity(
      maxGuests: json['maxGuests'] ?? 1,
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      beds: json['beds'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maxGuests': maxGuests,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'beds': beds,
    };
  }
}

class PropertyAmenity {
  final String id;
  final String name;
  final String icon;
  final String category;

  PropertyAmenity({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
  });

  factory PropertyAmenity.fromJson(Map<String, dynamic> json) {
    return PropertyAmenity(
      id: json['_id'] ?? json['id'],
      name: json['name'] ?? '',
      icon: json['icon'] ?? '🏠',
      category: json['category'] ?? 'features',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'category': category,
    };
  }
}

class PropertyImage {
  final String url;
  final String? caption;
  final bool isPrimary;
  final DateTime uploadedAt;

  PropertyImage({
    required this.url,
    this.caption,
    required this.isPrimary,
    required this.uploadedAt,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      url: json['url'] ?? '',
      caption: json['caption'],
      isPrimary: json['isPrimary'] ?? false,
      uploadedAt: DateTime.parse(json['uploadedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'caption': caption,
      'isPrimary': isPrimary,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}

class PropertyAvailability {
  final bool isAvailable;
  final String checkInTime;
  final String checkOutTime;
  final int minimumStay;
  final int maximumStay;
  final int advanceNotice;

  PropertyAvailability({
    required this.isAvailable,
    required this.checkInTime,
    required this.checkOutTime,
    required this.minimumStay,
    required this.maximumStay,
    required this.advanceNotice,
  });

  factory PropertyAvailability.fromJson(Map<String, dynamic> json) {
    return PropertyAvailability(
      isAvailable: json['isAvailable'] ?? true,
      checkInTime: json['checkInTime'] ?? '15:00',
      checkOutTime: json['checkOutTime'] ?? '11:00',
      minimumStay: json['minimumStay'] ?? 1,
      maximumStay: json['maximumStay'] ?? 30,
      advanceNotice: json['advanceNotice'] ?? 24,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAvailable': isAvailable,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'minimumStay': minimumStay,
      'maximumStay': maximumStay,
      'advanceNotice': advanceNotice,
    };
  }
}

class PropertyRatings {
  final double overall;
  final double cleanliness;
  final double accuracy;
  final double checkIn;
  final double communication;
  final double location;
  final double value;

  PropertyRatings({
    required this.overall,
    required this.cleanliness,
    required this.accuracy,
    required this.checkIn,
    required this.communication,
    required this.location,
    required this.value,
  });

  factory PropertyRatings.fromJson(Map<String, dynamic> json) {
    return PropertyRatings(
      overall: (json['overall'] ?? 0.0).toDouble(),
      cleanliness: (json['cleanliness'] ?? 0.0).toDouble(),
      accuracy: (json['accuracy'] ?? 0.0).toDouble(),
      checkIn: (json['checkIn'] ?? 0.0).toDouble(),
      communication: (json['communication'] ?? 0.0).toDouble(),
      location: (json['location'] ?? 0.0).toDouble(),
      value: (json['value'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall': overall,
      'cleanliness': cleanliness,
      'accuracy': accuracy,
      'checkIn': checkIn,
      'communication': communication,
      'location': location,
      'value': value,
    };
  }
}

class PropertyReviews {
  final int totalCount;
  final double averageRating;

  PropertyReviews({
    required this.totalCount,
    required this.averageRating,
  });

  factory PropertyReviews.fromJson(Map<String, dynamic> json) {
    return PropertyReviews(
      totalCount: json['totalCount'] ?? 0,
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'averageRating': averageRating,
    };
  }
}

class PropertyStatistics {
  final int totalBookings;
  final double totalRevenue;
  final double occupancyRate;
  final int viewCount;
  final int favoriteCount;

  PropertyStatistics({
    required this.totalBookings,
    required this.totalRevenue,
    required this.occupancyRate,
    required this.viewCount,
    required this.favoriteCount,
  });

  factory PropertyStatistics.fromJson(Map<String, dynamic> json) {
    return PropertyStatistics(
      totalBookings: json['totalBookings'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
      occupancyRate: (json['occupancyRate'] ?? 0.0).toDouble(),
      viewCount: json['viewCount'] ?? 0,
      favoriteCount: json['favoriteCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBookings': totalBookings,
      'totalRevenue': totalRevenue,
      'occupancyRate': occupancyRate,
      'viewCount': viewCount,
      'favoriteCount': favoriteCount,
    };
  }
}

class PropertyStatus {
  final bool isActive;
  final bool isVerified;
  final bool isBlocked;
  final String verificationStatus;

  PropertyStatus({
    required this.isActive,
    required this.isVerified,
    required this.isBlocked,
    required this.verificationStatus,
  });

  factory PropertyStatus.fromJson(Map<String, dynamic> json) {
    return PropertyStatus(
      isActive: json['isActive'] ?? true,
      isVerified: json['isVerified'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      verificationStatus: json['verificationStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'isVerified': isVerified,
      'isBlocked': isBlocked,
      'verificationStatus': verificationStatus,
    };
  }
}

// Keep the existing Review class for compatibility
class Review {
  const Review({
    required this.guestName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.guestTenure,
    this.guestAvatar,
  });

  final String guestName;
  final double rating;
  final String comment;
  final String date;
  final String guestTenure;
  final String? guestAvatar;
}
