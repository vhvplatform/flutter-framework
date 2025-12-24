import '../repository/user_repository.dart';

/// User service for business logic
class UserService {
  /// Creates a user service
  UserService({required this.userRepository});

  /// User repository
  final UserRepository userRepository;

  /// Get all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    return userRepository.getUsers();
  }

  /// Get user by ID
  Future<Map<String, dynamic>> getUserById(String id) async {
    return userRepository.getUserById(id);
  }

  /// Update user
  Future<Map<String, dynamic>> updateUser(
    String id,
    Map<String, dynamic> data,
  ) async {
    return userRepository.updateUser(id, data);
  }

  /// Delete user
  Future<void> deleteUser(String id) async {
    await userRepository.deleteUser(id);
  }
}
