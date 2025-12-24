import 'package:core/core.dart';
import '../repository/auth_repository.dart';

/// Service for authentication business logic
class AuthService {
  /// Creates an auth service
  AuthService({
    required this.authManager,
    required this.authRepository,
  });

  /// Authentication manager
  final AuthManager authManager;
  
  /// Authentication repository
  final AuthRepository authRepository;

  /// Login user
  Future<void> login({
    required String email,
    required String password,
    required String tenantId,
  }) async {
    await authManager.login(
      email: email,
      password: password,
      tenantId: tenantId,
    );
  }

  /// Register user
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String tenantId,
  }) async {
    await authManager.register(
      email: email,
      password: password,
      name: name,
      tenantId: tenantId,
    );
  }

  /// Logout user
  Future<void> logout() async {
    await authManager.logout();
  }
}
