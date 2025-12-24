import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'screens/dashboard_screen.dart';

/// Dashboard module
class DashboardModule extends AppModule {
  @override
  String get name => 'dashboard';

  @override
  String get version => '1.0.0';

  @override
  List<String> get dependencies => ['core', 'auth'];

  @override
  Future<void> initialize() async {
    // Register services if needed
  }

  @override
  Map<String, WidgetBuilder> registerRoutes() {
    return {
      '/dashboard': (context) => const DashboardScreen(),
    };
  }

  @override
  void dispose() {
    // Cleanup if needed
  }
}
