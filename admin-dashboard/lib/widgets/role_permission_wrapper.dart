import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/auth.dart';

class RolePermissionWrapper extends StatelessWidget {
  const RolePermissionWrapper({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  final Permission permission;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.canAccessFeature(permission)) {
          return this.child;
        }
        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}

class RolePermissionWrapperAny extends StatelessWidget {
  const RolePermissionWrapperAny({
    super.key,
    required this.permissions,
    required this.child,
    this.fallback,
  });

  final List<Permission> permissions;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.hasAnyPermission(permissions)) {
          return this.child;
        }
        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}

class RolePermissionWrapperAll extends StatelessWidget {
  const RolePermissionWrapperAll({
    super.key,
    required this.permissions,
    required this.child,
    this.fallback,
  });

  final List<Permission> permissions;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.hasAllPermissions(permissions)) {
          return this.child;
        }
        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}

class RoleBasedRoute extends StatelessWidget {
  const RoleBasedRoute({
    super.key,
    required this.permission,
    required this.allowedRoute,
    this.deniedRoute,
  });

  final Permission permission;
  final Widget allowedRoute;
  final Widget? deniedRoute;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.canAccessFeature(permission)) {
          return allowedRoute;
        }
        return deniedRoute ?? const _AccessDeniedScreen();
      },
    );
  }
}

class _AccessDeniedScreen extends StatelessWidget {
  const _AccessDeniedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.block,
              size: 80,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'Access Denied',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You don\'t have permission to access this page.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE31C5F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
