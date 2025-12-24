import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper for flutter_secure_storage
class SecureStorage {
  SecureStorage() : _storage = const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Read a value from secure storage
  Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  /// Write a value to secure storage
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Delete a value from secure storage
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Clear all values from secure storage
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
