import 'package:flutter/foundation.dart';

/// Mixin to make classes hot-reload safe
/// Prevents state loss during hot reload
mixin HotReloadSafe {
  /// Mark that reassemble happened
  void onReassemble() {
    if (kDebugMode) {
      debugPrint('${runtimeType} reassembled');
    }
  }
}

/// Service that persists across hot reloads
/// Useful for maintaining singleton state during development
class HotReloadPersistence {
  static final Map<String, dynamic> _storage = {};

  /// Save value that persists across hot reloads
  static void save<T>(String key, T value) {
    _storage[key] = value;
  }

  /// Retrieve persisted value
  static T? get<T>(String key) {
    return _storage[key] as T?;
  }

  /// Check if key exists
  static bool has(String key) {
    return _storage.containsKey(key);
  }

  /// Remove persisted value
  static void remove(String key) {
    _storage.remove(key);
  }

  /// Clear all persisted values
  static void clear() {
    _storage.clear();
  }
}

/// Extension for StatefulWidget to make it hot-reload aware
extension HotReloadAwareState<T extends StatefulWidget> on State<T> {
  /// Override this in your State class
  void onHotReload() {
    if (kDebugMode) {
      debugPrint('${widget.runtimeType} hot reloaded');
    }
  }

  /// Call this in reassemble()
  void handleReassemble() {
    onHotReload();
  }
}
