import 'package:flutter/widgets.dart';

/// Base class for application modules
abstract class AppModule {
  /// Module name
  String get name;

  /// Module version
  String get version => '1.0.0';

  /// List of module dependencies (module names)
  List<String> get dependencies => const [];

  /// Module configuration
  Map<String, dynamic> get config => const {};

  /// Initialize the module
  Future<void> initialize();

  /// Register routes for the module
  Map<String, WidgetBuilder> registerRoutes() => {};

  /// Dispose module resources
  void dispose() {}
}

/// Module registry for managing and initializing modules
class ModuleRegistry {
  final Map<String, AppModule> _modules = {};
  final List<String> _initializedModules = [];

  /// Register a single module
  void register(AppModule module) {
    if (_modules.containsKey(module.name)) {
      throw Exception('Module ${module.name} is already registered');
    }
    _modules[module.name] = module;
  }

  /// Register multiple modules
  Future<void> registerAll(List<AppModule> modules) async {
    for (final module in modules) {
      register(module);
    }
  }

  /// Initialize all modules with dependency resolution
  Future<void> initializeAll() async {
    // Topological sort to resolve dependencies
    final sortedModules = _topologicalSort();

    // Initialize modules in dependency order
    for (final moduleName in sortedModules) {
      final module = _modules[moduleName]!;
      await module.initialize();
      _initializedModules.add(moduleName);
    }
  }

  /// Get all registered routes
  Map<String, WidgetBuilder> getAllRoutes() {
    final routes = <String, WidgetBuilder>{};
    for (final module in _modules.values) {
      routes.addAll(module.registerRoutes());
    }
    return routes;
  }

  /// Get a specific module
  T? getModule<T extends AppModule>() {
    return _modules.values.whereType<T>().firstOrNull;
  }

  /// Check if a module is initialized
  bool isInitialized(String moduleName) {
    return _initializedModules.contains(moduleName);
  }

  /// Dispose all modules
  void disposeAll() {
    for (final module in _modules.values) {
      module.dispose();
    }
    _modules.clear();
    _initializedModules.clear();
  }

  /// Topological sort for dependency resolution
  List<String> _topologicalSort() {
    final visited = <String>{};
    final tempMarked = <String>{};
    final result = <String>[];

    void visit(String moduleName) {
      if (tempMarked.contains(moduleName)) {
        throw Exception('Circular dependency detected: $moduleName');
      }
      if (visited.contains(moduleName)) {
        return;
      }

      final module = _modules[moduleName];
      if (module == null) {
        throw Exception('Module not found: $moduleName');
      }

      tempMarked.add(moduleName);

      // Visit dependencies first
      for (final dependency in module.dependencies) {
        if (!_modules.containsKey(dependency)) {
          throw Exception(
            'Missing dependency: $dependency required by $moduleName',
          );
        }
        visit(dependency);
      }

      tempMarked.remove(moduleName);
      visited.add(moduleName);
      result.add(moduleName);
    }

    // Visit all modules
    for (final moduleName in _modules.keys) {
      if (!visited.contains(moduleName)) {
        visit(moduleName);
      }
    }

    return result;
  }
}

/// Extension to safely get first element or null
extension _FirstWhereOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      return iterator.current;
    }
    return null;
  }
}
