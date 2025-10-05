import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  static const String adminBaseUrl = 'http://localhost:5000/api/admin';
  
  late final Dio _dio;
  String? _token;
  String? _adminToken;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
    _loadTokens();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null && options.path.startsWith('/')) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            _clearTokens();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<void> _loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('user_token');
    _adminToken = prefs.getString('admin_token');
  }

  Future<void> _saveToken(String token, {bool isAdmin = false}) async {
    final prefs = await SharedPreferences.getInstance();
    if (isAdmin) {
      _adminToken = token;
      await prefs.setString('admin_token', token);
    } else {
      _token = token;
      await prefs.setString('user_token', token);
    }
  }

  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _token = null;
    _adminToken = null;
    await prefs.remove('user_token');
    await prefs.remove('admin_token');
  }

  // Authentication endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.data['success']) {
        final token = response.data['token'];
        await _saveToken(token);
        return response.data;
      } else {
        throw Exception(response.data['error']['message']);
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/auth/register', data: userData);

      if (response.data['success']) {
        final token = response.data['token'];
        await _saveToken(token);
        return response.data;
      } else {
        throw Exception(response.data['error']['message']);
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } finally {
      await _clearTokens();
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Properties endpoints
  Future<Map<String, dynamic>> getProperties({
    int page = 1,
    int limit = 12,
    String? search,
    String? category,
    double? minPrice,
    double? maxPrice,
    int? guests,
    int? bedrooms,
    int? bathrooms,
    String? amenities,
    double? latitude,
    double? longitude,
    double? radius,
    String? checkIn,
    String? checkOut,
    String? sort,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null) queryParams['search'] = search;
      if (category != null) queryParams['category'] = category;
      if (minPrice != null) queryParams['minPrice'] = minPrice;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
      if (guests != null) queryParams['guests'] = guests;
      if (bedrooms != null) queryParams['bedrooms'] = bedrooms;
      if (bathrooms != null) queryParams['bathrooms'] = bathrooms;
      if (amenities != null) queryParams['amenities'] = amenities;
      if (latitude != null) queryParams['latitude'] = latitude;
      if (longitude != null) queryParams['longitude'] = longitude;
      if (radius != null) queryParams['radius'] = radius;
      if (checkIn != null) queryParams['checkIn'] = checkIn;
      if (checkOut != null) queryParams['checkOut'] = checkOut;
      if (sort != null) queryParams['sort'] = sort;

      final response = await _dio.get('/properties', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getProperty(String id) async {
    try {
      final response = await _dio.get('/properties/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getPropertyCategories() async {
    try {
      final response = await _dio.get('/properties/categories');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAmenities() async {
    try {
      final response = await _dio.get('/properties/amenities');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Bookings endpoints
  Future<Map<String, dynamic>> getBookings({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) queryParams['status'] = status;

      final response = await _dio.get('/bookings', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getBooking(String id) async {
    try {
      final response = await _dio.get('/bookings/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await _dio.post('/bookings', data: bookingData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> cancelBooking(String id, {String? reason}) async {
    try {
      final response = await _dio.put('/bookings/$id/cancel', data: {
        'reason': reason,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Payments endpoints
  Future<Map<String, dynamic>> createPaymentIntent(Map<String, dynamic> paymentData) async {
    try {
      final response = await _dio.post('/payments/create-intent', data: paymentData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> confirmPayment(Map<String, dynamic> paymentData) async {
    try {
      final response = await _dio.post('/payments/confirm', data: paymentData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Support endpoints
  Future<Map<String, dynamic>> getSupportTickets({
    int page = 1,
    int limit = 10,
    String? status,
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) queryParams['status'] = status;
      if (category != null) queryParams['category'] = category;

      final response = await _dio.get('/support/tickets', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createSupportTicket(Map<String, dynamic> ticketData) async {
    try {
      final response = await _dio.post('/support/tickets', data: ticketData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> addSupportMessage(String ticketId, String message) async {
    try {
      final response = await _dio.post('/support/tickets/$ticketId/messages', data: {
        'message': message,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Admin endpoints
  Future<Map<String, dynamic>> adminLogin(String email, String password) async {
    try {
      final response = await _dio.post('$adminBaseUrl/login', data: {
        'email': email,
        'password': password,
      });

      if (response.data['success']) {
        final token = response.data['token'];
        await _saveToken(token, isAdmin: true);
        return response.data;
      } else {
        throw Exception(response.data['error']['message']);
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAdminDashboard() async {
    try {
      final response = await _dio.get('$adminBaseUrl/dashboard');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAdminUsers({
    int page = 1,
    int limit = 10,
    String? role,
    String? status,
    String? department,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (role != null) queryParams['role'] = role;
      if (status != null) queryParams['status'] = status;
      if (department != null) queryParams['department'] = department;

      final response = await _dio.get('$adminBaseUrl/users', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAllUsers({
    int page = 1,
    int limit = 10,
    String? search,
    bool? isVerified,
    bool? isHost,
    bool? isActive,
    bool? isBlocked,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null) queryParams['search'] = search;
      if (isVerified != null) queryParams['isVerified'] = isVerified;
      if (isHost != null) queryParams['isHost'] = isHost;
      if (isActive != null) queryParams['isActive'] = isActive;
      if (isBlocked != null) queryParams['isBlocked'] = isBlocked;

      final response = await _dio.get('/users', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAllProperties({
    int page = 1,
    int limit = 10,
    String? search,
    String? category,
    bool? isVerified,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (search != null) queryParams['search'] = search;
      if (category != null) queryParams['category'] = category;
      if (isVerified != null) queryParams['isVerified'] = isVerified;
      if (isActive != null) queryParams['isActive'] = isActive;

      final response = await _dio.get('/properties', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAllBookings({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) queryParams['status'] = status;
      if (search != null) queryParams['search'] = search;

      final response = await _dio.get('/bookings/admin/all', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAllPayments({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) queryParams['status'] = status;
      if (search != null) queryParams['search'] = search;

      final response = await _dio.get('/payments/admin/all', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAllSupportTickets({
    int page = 1,
    int limit = 10,
    String? status,
    String? category,
    String? priority,
    String? assignedTo,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) queryParams['status'] = status;
      if (category != null) queryParams['category'] = category;
      if (priority != null) queryParams['priority'] = priority;
      if (assignedTo != null) queryParams['assignedTo'] = assignedTo;
      if (search != null) queryParams['search'] = search;

      final response = await _dio.get('/support/admin/tickets', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Analytics endpoints
  Future<Map<String, dynamic>> getAnalyticsOverview() async {
    try {
      final response = await _dio.get('/analytics/overview');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getRevenueAnalytics({
    String period = 'month',
    int limit = 12,
  }) async {
    try {
      final response = await _dio.get('/analytics/revenue', queryParameters: {
        'period': period,
        'limit': limit,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getUserAnalytics({
    String period = 'month',
    int limit = 12,
  }) async {
    try {
      final response = await _dio.get('/analytics/users', queryParameters: {
        'period': period,
        'limit': limit,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getBookingAnalytics({
    String period = 'month',
    int limit = 12,
  }) async {
    try {
      final response = await _dio.get('/analytics/bookings', queryParameters: {
        'period': period,
        'limit': limit,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Utility methods
  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('error')) {
        return data['error']['message'] ?? 'An error occurred';
      }
    }
    
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    }
    
    if (error.type == DioExceptionType.connectionError) {
      return 'Unable to connect to server. Please check your internet connection.';
    }
    
    return 'An unexpected error occurred. Please try again.';
  }

  bool get isLoggedIn => _token != null;
  bool get isAdminLoggedIn => _adminToken != null;
}
