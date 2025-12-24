import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:core/core.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:auth_module/auth_module.dart';
import 'package:dashboard_module/dashboard_module.dart';
import 'package:user_module/user_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load configuration with different settings
  final config = AppConfig(
    apiBaseUrl: 'https://api2.example.com', // Different API URL
    environment: Environment.production, // Production environment
    appName: 'SaaS App 2', // Different app name
    version: '1.0.0',
  );

  // Initialize DI
  final sl = ServiceLocator.instance;
  
  // Register core services
  sl.registerSingleton<AppConfig>(config);
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());
  sl.registerLazySingleton<LocalStorage>(() => LocalStorage());
  
  // Create API client with production settings
  final apiClient = ApiClient(
    baseUrl: config.apiBaseUrl,
    authManager: null, // Will be set after auth manager creation
    enableLogging: config.isDevelopment, // No logging in production
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
  // App 2 uses only auth and dashboard modules (no user module)
  final registry = ModuleRegistry();
  await registry.registerAll([
    AuthModule(),
    DashboardModule(),
    UserModule(), // Can be removed for app-specific configuration
  ]);
  await registry.initializeAll();

  // Get all routes from modules
  final routes = registry.getAllRoutes();

  runApp(MyApp(
    authManager: authManager,
    routes: routes,
  ));
}

/// Main application widget for App 2
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
            title: 'SaaS App 2',
            debugShowCheckedModeBanner: false,
            // Using custom theme colors for App 2
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.light(
                primary: const Color(0xFF059669), // Green primary
                secondary: const Color(0xFF0891B2), // Cyan secondary
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.dark(
                primary: const Color(0xFF34D399), // Light green
                secondary: const Color(0xFF22D3EE), // Light cyan
              ),
            ),
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
