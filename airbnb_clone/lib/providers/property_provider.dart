import 'package:flutter/foundation.dart';
import '../models/api_property.dart';
import '../services/api_service.dart';

class PropertyProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ApiProperty> _properties = [];
  List<ApiProperty> _filteredProperties = [];
  List<PropertyCategory> _categories = [];
  List<PropertyAmenity> _amenities = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;
  int _totalProperties = 0;

  // Getters
  List<ApiProperty> get properties => _filteredProperties.isNotEmpty ? _filteredProperties : _properties;
  List<PropertyCategory> get categories => _categories;
  List<PropertyAmenity> get amenities => _amenities;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;
  int get totalProperties => _totalProperties;

  // Filter parameters
  String? _searchQuery;
  String? _selectedCategory;
  double? _minPrice;
  double? _maxPrice;
  int? _guests;
  int? _bedrooms;
  int? _bathrooms;
  List<String> _selectedAmenities = [];
  String? _sortBy;

  String? get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  int? get guests => _guests;
  int? get bedrooms => _bedrooms;
  int? get bathrooms => _bathrooms;
  List<String> get selectedAmenities => _selectedAmenities;
  String? get sortBy => _sortBy;

  Future<void> loadProperties({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _properties.clear();
      _filteredProperties.clear();
      _hasMore = true;
    }

    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getProperties(
        page: _currentPage,
        limit: 12,
        search: _searchQuery,
        category: _selectedCategory,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        guests: _guests,
        bedrooms: _bedrooms,
        bathrooms: _bathrooms,
        amenities: _selectedAmenities.isNotEmpty ? _selectedAmenities.join(',') : null,
        sort: _sortBy,
      );

      if (response['success']) {
        final List<dynamic> propertiesData = response['data'] ?? [];
        final List<ApiProperty> newProperties = propertiesData
            .map((property) => ApiProperty.fromJson(property))
            .toList();

        if (refresh) {
          _properties = newProperties;
        } else {
          _properties.addAll(newProperties);
        }

        _totalProperties = response['pagination']?['total'] ?? 0;
        _currentPage++;
        
        final pagination = response['pagination'];
        _hasMore = pagination != null && 
                   pagination['page'] < pagination['pages'];

        _applyFilters();
      } else {
        _error = response['error']?['message'] ?? 'Failed to load properties';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories() async {
    try {
      final response = await _apiService.getPropertyCategories();
      if (response['success']) {
        final List<dynamic> categoriesData = response['data'] ?? [];
        _categories = categoriesData
            .map((category) => PropertyCategory.fromJson(category))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  Future<void> loadAmenities() async {
    try {
      final response = await _apiService.getAmenities();
      if (response['success']) {
        final List<dynamic> amenitiesData = response['data'] ?? [];
        _amenities = amenitiesData
            .map((amenity) => PropertyAmenity.fromJson(amenity))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading amenities: $e');
    }
  }

  Future<ApiProperty?> getProperty(String id) async {
    try {
      final response = await _apiService.getProperty(id);
      if (response['success']) {
        return ApiProperty.fromJson(response['data']);
      }
    } catch (e) {
      debugPrint('Error loading property: $e');
    }
    return null;
  }

  void setSearchQuery(String? query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setPriceRange(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  void setGuests(int? guests) {
    _guests = guests;
    _applyFilters();
  }

  void setBedrooms(int? bedrooms) {
    _bedrooms = bedrooms;
    _applyFilters();
  }

  void setBathrooms(int? bathrooms) {
    _bathrooms = bathrooms;
    _applyFilters();
  }

  void setAmenities(List<String> amenities) {
    _selectedAmenities = amenities;
    _applyFilters();
  }

  void setSortBy(String? sortBy) {
    _sortBy = sortBy;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = null;
    _selectedCategory = null;
    _minPrice = null;
    _maxPrice = null;
    _guests = null;
    _bedrooms = null;
    _bathrooms = null;
    _selectedAmenities.clear();
    _sortBy = null;
    _filteredProperties.clear();
    notifyListeners();
  }

  void _applyFilters() {
    if (_searchQuery == null && 
        _selectedCategory == null && 
        _minPrice == null && 
        _maxPrice == null && 
        _guests == null && 
        _bedrooms == null && 
        _bathrooms == null && 
        _selectedAmenities.isEmpty && 
        _sortBy == null) {
      _filteredProperties.clear();
      notifyListeners();
      return;
    }

    _filteredProperties = _properties.where((property) {
      // Search query filter
      if (_searchQuery != null && _searchQuery!.isNotEmpty) {
        final query = _searchQuery!.toLowerCase();
        if (!property.title.toLowerCase().contains(query) &&
            !property.description.toLowerCase().contains(query) &&
            !property.location.city.toLowerCase().contains(query) &&
            !property.location.address.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategory != null && property.category.id != _selectedCategory) {
        return false;
      }

      // Price filter
      if (_minPrice != null && property.price.basePrice < _minPrice!) {
        return false;
      }
      if (_maxPrice != null && property.price.basePrice > _maxPrice!) {
        return false;
      }

      // Capacity filters
      if (_guests != null && property.capacity.maxGuests < _guests!) {
        return false;
      }
      if (_bedrooms != null && property.capacity.bedrooms < _bedrooms!) {
        return false;
      }
      if (_bathrooms != null && property.capacity.bathrooms < _bathrooms!) {
        return false;
      }

      // Amenities filter
      if (_selectedAmenities.isNotEmpty) {
        final propertyAmenityIds = property.amenities.map((a) => a.id).toList();
        if (!_selectedAmenities.every((amenityId) => propertyAmenityIds.contains(amenityId))) {
          return false;
        }
      }

      return true;
    }).toList();

    // Apply sorting
    if (_sortBy != null) {
      switch (_sortBy) {
        case 'price-low':
          _filteredProperties.sort((a, b) => a.price.basePrice.compareTo(b.price.basePrice));
          break;
        case 'price-high':
          _filteredProperties.sort((a, b) => b.price.basePrice.compareTo(a.price.basePrice));
          break;
        case 'rating':
          _filteredProperties.sort((a, b) => b.ratings.overall.compareTo(a.ratings.overall));
          break;
        case 'newest':
          _filteredProperties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
      }
    }

    notifyListeners();
  }

  void refresh() {
    loadProperties(refresh: true);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
