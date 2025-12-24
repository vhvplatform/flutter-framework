import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'repository/user_repository.dart';
import 'services/user_service.dart';
import 'screens/user_list_screen.dart';
import 'screens/user_detail_screen.dart';

/// User module
class UserModule extends AppModule {
  @override
  String get name => 'user';

  @override
  String get version => '1.0.0';

  @override
  List<String> get dependencies => ['core', 'auth'];

  @override
  Future<void> initialize() async {
    final sl = ServiceLocator.instance;

    // Register repository
    sl.registerLazySingleton<UserRepository>(
      () => UserRepository(
        apiClient: sl.get<ApiClient>(),
      ),
    );

    // Register service
    sl.registerLazySingleton<UserService>(
      () => UserService(
        userRepository: sl.get<UserRepository>(),
      ),
    );
  }

  @override
  Map<String, WidgetBuilder> registerRoutes() {
    return {
      '/users': (context) => const UserListScreen(),
      '/users/:id': (context) {
        // Extract user ID from route arguments
        final args = ModalRoute.of(context)?.settings.arguments;
        final userId = args is Map ? args['id'] as String? ?? '' : '';
        return UserDetailScreen(userId: userId);
      },
    };
  }

  @override
  void dispose() {
    // Cleanup if needed
  }
}
