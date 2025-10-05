import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _apiService.isLoggedIn && _user != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      if (response['success']) {
        _user = response['data'];
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

  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.register(userData);
      if (response['success']) {
        _user = response['data'];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['error']?['message'] ?? 'Registration failed';
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
      _user = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCurrentUser() async {
    if (!_apiService.isLoggedIn) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getCurrentUser();
      if (response['success']) {
        _user = response['data'];
      } else {
        _user = null;
      }
    } catch (e) {
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String get userFullName {
    if (_user == null) return '';
    return '${_user!['firstName'] ?? ''} ${_user!['lastName'] ?? ''}'.trim();
  }

  String get userEmail {
    return _user?['email'] ?? '';
  }

  String? get userProfileImage {
    return _user?['profileImage'];
  }

  bool get isHost {
    return _user?['isHost'] ?? false;
  }

  bool get isVerified {
    return _user?['isVerified'] ?? false;
  }
}
