import 'package:flutter/material.dart';

class FilterModel {
  const FilterModel({
    this.priceRange = const RangeValues(0, 1000),
    this.propertyTypes = const <String>[],
    this.amenities = const <String>[],
    this.guestCount = 1,
    this.selectedDates = const <DateTime?>[null, null],
  });

  final RangeValues priceRange;
  final List<String> propertyTypes;
  final List<String> amenities;
  final int guestCount;
  final List<DateTime?> selectedDates;

  FilterModel copyWith({
    RangeValues? priceRange,
    List<String>? propertyTypes,
    List<String>? amenities,
    int? guestCount,
    List<DateTime?>? selectedDates,
  }) {
    return FilterModel(
      priceRange: priceRange ?? this.priceRange,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      amenities: amenities ?? this.amenities,
      guestCount: guestCount ?? this.guestCount,
      selectedDates: selectedDates ?? this.selectedDates,
    );
  }

  bool get hasActiveFilters {
    return priceRange.start > 0 ||
        priceRange.end < 1000 ||
        propertyTypes.isNotEmpty ||
        amenities.isNotEmpty ||
        guestCount > 1 ||
        selectedDates[0] != null ||
        selectedDates[1] != null;
  }

  void clearFilters() {
    // This would be used to reset all filters
  }
}

class PropertyType {
  const PropertyType({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final String icon;

  static const List<PropertyType> all = <PropertyType>[
    PropertyType(id: 'apartment', name: 'Apartment', icon: '🏢'),
    PropertyType(id: 'house', name: 'House', icon: '🏠'),
    PropertyType(id: 'cabin', name: 'Cabin', icon: '🏡'),
    PropertyType(id: 'villa', name: 'Villa', icon: '🏰'),
    PropertyType(id: 'condo', name: 'Condo', icon: '🏢'),
    PropertyType(id: 'loft', name: 'Loft', icon: '🏙️'),
  ];
}

class Amenity {
  const Amenity({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final String icon;

  static const List<Amenity> all = <Amenity>[
    Amenity(id: 'wifi', name: 'Wi-Fi', icon: '📶'),
    Amenity(id: 'kitchen', name: 'Kitchen', icon: '🍳'),
    Amenity(id: 'parking', name: 'Free parking', icon: '🅿️'),
    Amenity(id: 'ac', name: 'Air conditioning', icon: '❄️'),
    Amenity(id: 'tv', name: 'TV', icon: '📺'),
    Amenity(id: 'balcony', name: 'Balcony', icon: '🏞️'),
    Amenity(id: 'pool', name: 'Pool', icon: '🏊'),
    Amenity(id: 'gym', name: 'Gym', icon: '💪'),
    Amenity(id: 'hot_tub', name: 'Hot tub', icon: '♨️'),
    Amenity(id: 'fireplace', name: 'Fireplace', icon: '🔥'),
    Amenity(id: 'washer', name: 'Washer', icon: '🧺'),
    Amenity(id: 'dryer', name: 'Dryer', icon: '🌪️'),
  ];
}
