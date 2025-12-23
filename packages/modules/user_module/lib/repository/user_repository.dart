import 'package:core/core.dart';

/// User repository for API operations
class UserRepository {
  /// Creates a user repository
  UserRepository({required this.apiClient});

  /// API client
  final ApiClient apiClient;

  /// Get list of users
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await apiClient.get<List<dynamic>>(
      '/users',
      parser: (json) => json as List<dynamic>,
    );
    return response.data.cast<Map<String, dynamic>>();
  }

  /// Get user by ID
  Future<Map<String, dynamic>> getUserById(String id) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      '/users/$id',
      parser: (json) => json as Map<String, dynamic>,
    );
    return response.data;
  }

  /// Update user
  Future<Map<String, dynamic>> updateUser(
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await apiClient.put<Map<String, dynamic>>(
      '/users/$id',
      data: data,
      parser: (json) => json as Map<String, dynamic>,
    );
    return response.data;
  }

  /// Delete user
  Future<void> deleteUser(String id) async {
    await apiClient.delete<void>(
      '/users/$id',
      parser: (json) => null,
    );
  }
}
