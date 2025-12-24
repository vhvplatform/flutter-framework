import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper for shared_preferences
class LocalStorage {
  LocalStorage();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Get a string value
  Future<String?> getString(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }

  /// Set a string value
  Future<bool> setString(String key, String value) async {
    final prefs = await _instance;
    return prefs.setString(key, value);
  }

  /// Get an int value
  Future<int?> getInt(String key) async {
    final prefs = await _instance;
    return prefs.getInt(key);
  }

  /// Set an int value
  Future<bool> setInt(String key, int value) async {
    final prefs = await _instance;
    return prefs.setInt(key, value);
  }

  /// Get a bool value
  Future<bool?> getBool(String key) async {
    final prefs = await _instance;
    return prefs.getBool(key);
  }

  /// Set a bool value
  Future<bool> setBool(String key, bool value) async {
    final prefs = await _instance;
    return prefs.setBool(key, value);
  }

  /// Remove a value
  Future<bool> remove(String key) async {
    final prefs = await _instance;
    return prefs.remove(key);
  }

  /// Clear all values
  Future<bool> clear() async {
    final prefs = await _instance;
    return prefs.clear();
  }
}
