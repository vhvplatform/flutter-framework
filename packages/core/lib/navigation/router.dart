import 'package:flutter/widgets.dart';

/// Route model
class AppRoute {
  /// Creates a route
  const AppRoute({
    required this.path,
    required this.name,
    required this.builder,
    this.guards = const [],
  });

  /// Route path
  final String path;
  
  /// Route name
  final String name;
  
  /// Route builder
  final WidgetBuilder builder;
  
  /// Route guards (middleware)
  final List<bool Function(BuildContext)> guards;
}

/// Application router for managing routes
class AppRouter {
  final Map<String, AppRoute> _routes = {};

  /// Add a route
  void addRoute(AppRoute route) {
    _routes[route.path] = route;
  }

  /// Add multiple routes
  void addRoutes(Map<String, WidgetBuilder> routes) {
    routes.forEach((path, builder) {
      addRoute(
        AppRoute(
          path: path,
          name: path,
          builder: builder,
        ),
      );
    });
  }

  /// Generate route
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final route = _routes[settings.name];
    
    if (route == null) {
      return null;
    }

    return MaterialPageRoute(
      builder: route.builder,
      settings: settings,
    );
  }

  /// Get all routes
  Map<String, WidgetBuilder> get routes {
    return Map.fromEntries(
      _routes.entries.map(
        (entry) => MapEntry(entry.key, entry.value.builder),
      ),
    );
  }
}

/// Material page route wrapper
class MaterialPageRoute<T> extends PageRoute<T> {
  /// Creates a material page route
  MaterialPageRoute({
    required this.builder,
    RouteSettings? settings,
  }) : super(settings: settings);

  /// Widget builder
  final WidgetBuilder builder;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
