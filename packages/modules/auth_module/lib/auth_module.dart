import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'repository/auth_repository.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

/// Authentication module
class AuthModule extends AppModule {
  @override
  String get name => 'auth';

  @override
  String get version => '1.0.0';

  @override
  List<String> get dependencies => ['core'];

  @override
  Future<void> initialize() async {
    final sl = ServiceLocator.instance;

    // Register repository
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(
        apiClient: sl.get<ApiClient>(),
      ),
    );

    // Register service
    sl.registerLazySingleton<AuthService>(
      () => AuthService(
        authManager: sl.get<AuthManager>(),
        authRepository: sl.get<AuthRepository>(),
      ),
    );
  }

  @override
  Map<String, WidgetBuilder> registerRoutes() {
    return {
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
    };
  }

  @override
  void dispose() {
    // Cleanup if needed
  }
}
