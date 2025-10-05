import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  static const String adminBaseUrl = 'http://localhost:5000/api/admin';
  
  late final Dio _dio;
  String? _adminToken;

  AdminApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: adminBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
    _loadToken();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_adminToken != null) {
            options.headers['Authorization'] = 'Bearer $_adminToken';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            _clearToken();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _adminToken = prefs.getString('admin_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    _adminToken = token;
    await prefs.setString('admin_token', token);
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    _adminToken = null;
    await prefs.remove('admin_token');
  }

  // Admin Authentication
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
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

  Future<void> logout() async {
    try {
      await _dio.post('/logout');
    } finally {
      await _clearToken();
    }
  }

  Future<Map<String, dynamic>> getCurrentAdmin() async {
    try {
      final response = await _dio.get('/me');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Dashboard
  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await _dio.get('/dashboard');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Users Management
  Future<Map<String, dynamic>> getUsers({
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

      final response = await _dio.get('$baseUrl/users', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await _dio.get('$baseUrl/users/stats/overview');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyUser(String userId) async {
    try {
      final response = await _dio.post('$baseUrl/users/$userId/verify');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> blockUser(String userId) async {
    try {
      final response = await _dio.post('$baseUrl/users/$userId/block');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Properties Management
  Future<Map<String, dynamic>> getProperties({
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

      final response = await _dio.get('$baseUrl/properties', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getPropertyStats() async {
    try {
      final response = await _dio.get('$baseUrl/properties/stats/overview');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> verifyProperty(String propertyId) async {
    try {
      final response = await _dio.post('$baseUrl/properties/$propertyId/verify');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Bookings Management
  Future<Map<String, dynamic>> getBookings({
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

      final response = await _dio.get('$baseUrl/bookings/admin/all', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getBookingStats() async {
    try {
      final response = await _dio.get('$baseUrl/bookings/stats/overview');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Payments Management
  Future<Map<String, dynamic>> getPayments({
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

      final response = await _dio.get('$baseUrl/payments/admin/all', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getPaymentStats() async {
    try {
      final response = await _dio.get('$baseUrl/payments/stats/overview');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> processRefund(String paymentId, double amount, String reason) async {
    try {
      final response = await _dio.post('$baseUrl/payments/refund', data: {
        'paymentId': paymentId,
        'refundAmount': amount,
        'reason': reason,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Analytics
  Future<Map<String, dynamic>> getAnalyticsOverview() async {
    try {
      final response = await _dio.get('$baseUrl/analytics/overview');
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
      final response = await _dio.get('$baseUrl/analytics/revenue', queryParameters: {
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
      final response = await _dio.get('$baseUrl/analytics/users', queryParameters: {
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
      final response = await _dio.get('$baseUrl/analytics/bookings', queryParameters: {
        'period': period,
        'limit': limit,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Support Tickets
  Future<Map<String, dynamic>> getSupportTickets({
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

      final response = await _dio.get('$baseUrl/support/admin/tickets', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getSupportStats() async {
    try {
      final response = await _dio.get('$baseUrl/support/admin/stats');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> assignTicket(String ticketId, String assignedTo) async {
    try {
      final response = await _dio.post('$baseUrl/support/admin/tickets/$ticketId/assign', data: {
        'assignedTo': assignedTo,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> resolveTicket(String ticketId) async {
    try {
      final response = await _dio.post('$baseUrl/support/admin/tickets/$ticketId/resolve');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> closeTicket(String ticketId) async {
    try {
      final response = await _dio.post('$baseUrl/support/admin/tickets/$ticketId/close');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Admin Users Management
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

      final response = await _dio.get('/users', queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createAdminUser(Map<String, dynamic> adminData) async {
    try {
      final response = await _dio.post('/users', data: adminData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateAdminUser(String adminId, Map<String, dynamic> adminData) async {
    try {
      final response = await _dio.put('/users/$adminId', data: adminData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> deleteAdminUser(String adminId) async {
    try {
      final response = await _dio.delete('/users/$adminId');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getAdminUserStats() async {
    try {
      final response = await _dio.get('/users/stats');
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

  bool get isLoggedIn => _adminToken != null;
}
