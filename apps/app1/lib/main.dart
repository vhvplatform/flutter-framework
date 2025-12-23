import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core/core.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:auth_module/auth_module.dart';
import 'package:dashboard_module/dashboard_module.dart';
import 'package:user_module/user_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load configuration
  final config = AppConfig(
    apiBaseUrl: 'https://api.example.com',
    environment: Environment.development,
    appName: 'SaaS App 1',
    version: '1.0.0',
  );

  // Initialize DI
  final sl = ServiceLocator.instance;
  
  // Register core services
  sl.registerSingleton<AppConfig>(config);
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());
  sl.registerLazySingleton<LocalStorage>(() => LocalStorage());
  
  // Create API client
  final apiClient = ApiClient(
    baseUrl: config.apiBaseUrl,
    authManager: null, // Will be set after auth manager creation
    enableLogging: config.isDevelopment,
  );
  sl.registerSingleton<ApiClient>(apiClient);
  
  // Create and register auth manager
  final authManager = AuthManager(
    apiClient: apiClient,
    storage: sl.get<SecureStorage>(),
  );
  sl.registerSingleton<AuthManager>(authManager);
  
  // Initialize auth manager
  await authManager.init();

  // Register and initialize modules
  final registry = ModuleRegistry();
  await registry.registerAll([
    AuthModule(),
    DashboardModule(),
    UserModule(),
  ]);
  await registry.initializeAll();

  // Get all routes from modules
  final routes = registry.getAllRoutes();

  runApp(MyApp(
    authManager: authManager,
    routes: routes,
  ));
}

/// Main application widget
class MyApp extends StatelessWidget {
  /// Creates the main app
  const MyApp({
    required this.authManager,
    required this.routes,
    super.key,
  });

  /// Authentication manager
  final AuthManager authManager;
  
  /// Application routes
  final Map<String, WidgetBuilder> routes;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthManager>.value(
      value: authManager,
      child: Consumer<AuthManager>(
        builder: (context, authManager, child) {
          return MaterialApp(
            title: 'SaaS App 1',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routes: routes,
            home: authManager.isAuthenticated
                ? routes['/dashboard']!(context)
                : routes['/login']!(context),
          );
        },
      ),
    );
  }
}
