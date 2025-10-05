import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AdminProvider with ChangeNotifier {
  final AdminApiService _apiService = AdminApiService();

  Map<String, dynamic>? _currentAdmin;
  Map<String, dynamic>? _dashboardData;
  List<dynamic> _users = [];
  List<dynamic> _properties = [];
  List<dynamic> _bookings = [];
  List<dynamic> _payments = [];
  List<dynamic> _supportTickets = [];
  List<dynamic> _adminUsers = [];
  
  bool _isLoading = false;
  String? _error;

  // Getters
  Map<String, dynamic>? get currentAdmin => _currentAdmin;
  Map<String, dynamic>? get dashboardData => _dashboardData;
  List<dynamic> get users => _users;
  List<dynamic> get properties => _properties;
  List<dynamic> get bookings => _bookings;
  List<dynamic> get payments => _payments;
  List<dynamic> get supportTickets => _supportTickets;
  List<dynamic> get adminUsers => _adminUsers;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _apiService.isLoggedIn;

  // Authentication
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      if (response['success']) {
        _currentAdmin = response['data'];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['error']?['message'] ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.logout();
    } finally {
      _currentAdmin = null;
      _dashboardData = null;
      _users.clear();
      _properties.clear();
      _bookings.clear();
      _payments.clear();
      _supportTickets.clear();
      _adminUsers.clear();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCurrentAdmin() async {
    if (!_apiService.isLoggedIn) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getCurrentAdmin();
      if (response['success']) {
        _currentAdmin = response['data'];
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Dashboard
  Future<void> loadDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getDashboard();
      if (response['success']) {
        _dashboardData = response['data'];
      } else {
        _error = response['error']?['message'] ?? 'Failed to load dashboard';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Users Management
  Future<void> loadUsers({
    int page = 1,
    int limit = 10,
    String? search,
    bool? isVerified,
    bool? isHost,
    bool? isActive,
    bool? isBlocked,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getUsers(
        page: page,
        limit: limit,
        search: search,
        isVerified: isVerified,
        isHost: isHost,
        isActive: isActive,
        isBlocked: isBlocked,
      );
      
      if (response['success']) {
        _users = response['data'] ?? [];
      } else {
        _error = response['error']?['message'] ?? 'Failed to load users';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyUser(String userId) async {
    try {
      final response = await _apiService.verifyUser(userId);
      if (response['success']) {
        // Update the user in the list
        final index = _users.indexWhere((user) => user['_id'] == userId);
        if (index != -1) {
          _users[index] = response['data'];
          notifyListeners();
        }
      } else {
        _error = response['error']?['message'] ?? 'Failed to verify user';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> blockUser(String userId) async {
    try {
      final response = await _apiService.blockUser(userId);
      if (response['success']) {
        // Update the user in the list
        final index = _users.indexWhere((user) => user['_id'] == userId);
        if (index != -1) {
          _users[index] = response['data'];
          notifyListeners();
        }
      } else {
        _error = response['error']?['message'] ?? 'Failed to block user';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Properties Management
  Future<void> loadProperties({
    int page = 1,
    int limit = 10,
    String? search,
    String? category,
    bool? isVerified,
    bool? isActive,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getProperties(
        page: page,
        limit: limit,
        search: search,
        category: category,
        isVerified: isVerified,
        isActive: isActive,
      );
      
      if (response['success']) {
        _properties = response['data'] ?? [];
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

  Future<void> verifyProperty(String propertyId) async {
    try {
      final response = await _apiService.verifyProperty(propertyId);
      if (response['success']) {
        // Update the property in the list
        final index = _properties.indexWhere((property) => property['_id'] == propertyId);
        if (index != -1) {
          _properties[index] = response['data'];
          notifyListeners();
        }
      } else {
        _error = response['error']?['message'] ?? 'Failed to verify property';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Bookings Management
  Future<void> loadBookings({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getBookings(
        page: page,
        limit: limit,
        status: status,
        search: search,
      );
      
      if (response['success']) {
        _bookings = response['data'] ?? [];
      } else {
        _error = response['error']?['message'] ?? 'Failed to load bookings';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Payments Management
  Future<void> loadPayments({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getPayments(
        page: page,
        limit: limit,
        status: status,
        search: search,
      );
      
      if (response['success']) {
        _payments = response['data'] ?? [];
      } else {
        _error = response['error']?['message'] ?? 'Failed to load payments';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> processRefund(String paymentId, double amount, String reason) async {
    try {
      final response = await _apiService.processRefund(paymentId, amount, reason);
      if (response['success']) {
        // Update the payment in the list
        final index = _payments.indexWhere((payment) => payment['_id'] == paymentId);
        if (index != -1) {
          _payments[index] = response['data'];
          notifyListeners();
        }
      } else {
        _error = response['error']?['message'] ?? 'Failed to process refund';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Support Tickets Management
  Future<void> loadSupportTickets({
    int page = 1,
    int limit = 10,
    String? status,
    String? category,
    String? priority,
    String? assignedTo,
    String? search,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getSupportTickets(
        page: page,
        limit: limit,
        status: status,
        category: category,
        priority: priority,
        assignedTo: assignedTo,
        search: search,
      );
      
      if (response['success']) {
        _supportTickets = response['data'] ?? [];
      } else {
        _error = response['error']?['message'] ?? 'Failed to load support tickets';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> assignTicket(String ticketId, String assignedTo) async {
    try {
      final response = await _apiService.assignTicket(ticketId, assignedTo);
      if (response['success']) {
        // Update the ticket in the list
        final index = _supportTickets.indexWhere((ticket) => ticket['_id'] == ticketId);
        if (index != -1) {
          _supportTickets[index] = response['data'];
          notifyListeners();
        }
      } else {
        _error = response['error']?['message'] ?? 'Failed to assign ticket';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> resolveTicket(String ticketId) async {
    try {
      final response = await _apiService.resolveTicket(ticketId);
      if (response['success']) {
        // Update the ticket in the list
        final index = _supportTickets.indexWhere((ticket) => ticket['_id'] == ticketId);
        if (index != -1) {
          _supportTickets[index] = response['data'];
          notifyListeners();
        }
      } else {
        _error = response['error']?['message'] ?? 'Failed to resolve ticket';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> closeTicket(String ticketId) async {
    try {
      final response = await _apiService.closeTicket(ticketId);
      if (response['success']) {
        // Update the ticket in the list
        final index = _supportTickets.indexWhere((ticket) => ticket['_id'] == ticketId);
        if (index != -1) {
          _supportTickets[index] = response['data'];
          notifyListeners();
        }
      } else {
        _error = response['error']?['message'] ?? 'Failed to close ticket';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Analytics
  Future<Map<String, dynamic>?> loadAnalytics() async {
    try {
      final response = await _apiService.getAnalyticsOverview();
      if (response['success']) {
        return response['data'];
      } else {
        _error = response['error']?['message'] ?? 'Failed to load analytics';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> loadRevenueAnalytics({String period = 'month', int limit = 12}) async {
    try {
      final response = await _apiService.getRevenueAnalytics(period: period, limit: limit);
      if (response['success']) {
        return response['data'];
      } else {
        _error = response['error']?['message'] ?? 'Failed to load revenue analytics';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> loadUserAnalytics({String period = 'month', int limit = 12}) async {
    try {
      final response = await _apiService.getUserAnalytics(period: period, limit: limit);
      if (response['success']) {
        return response['data'];
      } else {
        _error = response['error']?['message'] ?? 'Failed to load user analytics';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Map<String, dynamic>?> loadBookingAnalytics({String period = 'month', int limit = 12}) async {
    try {
      final response = await _apiService.getBookingAnalytics(period: period, limit: limit);
      if (response['success']) {
        return response['data'];
      } else {
        _error = response['error']?['message'] ?? 'Failed to load booking analytics';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Admin Users Management
  Future<void> loadAdminUsers({
    int page = 1,
    int limit = 10,
    String? role,
    String? status,
    String? department,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getAdminUsers(
        page: page,
        limit: limit,
        role: role,
        status: status,
        department: department,
      );
      
      if (response['success']) {
        _adminUsers = response['data'] ?? [];
      } else {
        _error = response['error']?['message'] ?? 'Failed to load admin users';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAdminUser(Map<String, dynamic> adminData) async {
    try {
      final response = await _apiService.createAdminUser(adminData);
      if (response['success']) {
        // Add the new admin user to the list
        _adminUsers.add(response['data']);
        notifyListeners();
      } else {
        _error = response['error']?['message'] ?? 'Failed to create admin user';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateAdminUser(String adminId, Map<String, dynamic> adminData) async {
    try {
      final response = await _apiService.updateAdminUser(adminId, adminData);
      if (response['success']) {
        // Update the admin user in the list
        final index = _adminUsers.indexWhere((admin) => admin['_id'] == adminId);
        if (index != -1) {
          _adminUsers[index] = response['data'];
          notifyListeners();
        }
      } else {
        _error = response['error']?['message'] ?? 'Failed to update admin user';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteAdminUser(String adminId) async {
    try {
      final response = await _apiService.deleteAdminUser(adminId);
      if (response['success']) {
        // Remove the admin user from the list
        _adminUsers.removeWhere((admin) => admin['_id'] == adminId);
        notifyListeners();
      } else {
        _error = response['error']?['message'] ?? 'Failed to delete admin user';
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Utility methods
  void clearError() {
    _error = null;
    notifyListeners();
  }

  String get adminFullName {
    if (_currentAdmin == null) return '';
    return '${_currentAdmin!['firstName'] ?? ''} ${_currentAdmin!['lastName'] ?? ''}'.trim();
  }

  String get adminEmail {
    return _currentAdmin?['email'] ?? '';
  }

  String get adminRole {
    return _currentAdmin?['role'] ?? '';
  }

  String get adminDepartment {
    return _currentAdmin?['department'] ?? '';
  }
}
