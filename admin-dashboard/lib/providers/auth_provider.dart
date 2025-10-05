import 'package:flutter/foundation.dart';
import '../models/auth.dart';

class AuthProvider extends ChangeNotifier {
  AuthState _state = const AuthState();

  AuthState get state => _state;
  AuthUser? get user => _state.user;
  bool get isAuthenticated => _state.isAuthenticated;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;

  Future<bool> login(String email, String password) async {
    _updateState(_state.copyWith(isLoading: true, error: null));
    
    try {
      final user = await AuthRepository.login(email, password);
      if (user != null) {
        _updateState(AuthState(
          user: user,
          isAuthenticated: true,
          isLoading: false,
        ));
        return true;
      }
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
    
    return false;
  }

  Future<void> logout() async {
    _updateState(_state.copyWith(isLoading: true));
    
    try {
      await AuthRepository.logout();
      _updateState(const AuthState());
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void clearError() {
    if (_state.error != null) {
      _updateState(_state.copyWith(error: null));
    }
  }

  bool hasPermission(Permission permission) {
    return _state.user?.hasPermission(permission) ?? false;
  }

  bool hasAnyPermission(List<Permission> permissions) {
    return _state.user?.hasAnyPermission(permissions) ?? false;
  }

  bool hasAllPermissions(List<Permission> permissions) {
    return _state.user?.hasAllPermissions(permissions) ?? false;
  }

  bool canAccessFeature(Permission permission) {
    if (!isAuthenticated || user == null) return false;
    return hasPermission(permission);
  }

  void _updateState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }
}
