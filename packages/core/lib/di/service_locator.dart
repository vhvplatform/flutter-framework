import 'package:get_it/get_it.dart';

/// Service locator singleton wrapper for GetIt
class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator _instance = ServiceLocator._();
  
  /// Singleton instance
  static ServiceLocator get instance => _instance;

  final GetIt _getIt = GetIt.instance;

  /// Register a singleton instance
  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
  }) {
    _getIt.registerSingleton<T>(instance, instanceName: instanceName);
  }

  /// Register a lazy singleton (created on first access)
  void registerLazySingleton<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
  }) {
    _getIt.registerLazySingleton<T>(factoryFunc, instanceName: instanceName);
  }

  /// Register a factory (new instance on each access)
  void registerFactory<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
  }) {
    _getIt.registerFactory<T>(factoryFunc, instanceName: instanceName);
  }

  /// Get an instance of a registered type
  T get<T extends Object>({String? instanceName}) {
    return _getIt.get<T>(instanceName: instanceName);
  }

  /// Check if a type is registered
  bool isRegistered<T extends Object>({String? instanceName}) {
    return _getIt.isRegistered<T>(instanceName: instanceName);
  }

  /// Unregister a type
  Future<void> unregister<T extends Object>({String? instanceName}) async {
    await _getIt.unregister<T>(instanceName: instanceName);
  }

  /// Reset all registrations
  Future<void> reset() async {
    await _getIt.reset();
  }
}
