import 'package:core/core.dart';

/// Repository for authentication operations
class AuthRepository {
  /// Creates an auth repository
  AuthRepository({required this.apiClient});

  /// API client
  final ApiClient apiClient;

  /// Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String tenantId,
  }) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
        'tenant_id': tenantId,
      },
      parser: (json) => json as Map<String, dynamic>,
    );
    return response.data;
  }

  /// Register user
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String tenantId,
  }) async {
    final response = await apiClient.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'name': name,
        'tenant_id': tenantId,
      },
      parser: (json) => json as Map<String, dynamic>,
    );
    return response.data;
  }
}
