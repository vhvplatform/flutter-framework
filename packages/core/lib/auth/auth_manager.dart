import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../storage/secure_storage.dart';
import 'models/user.dart';
import 'models/tokens.dart';

/// Authentication manager with state management
class AuthManager extends ChangeNotifier {
  /// Creates an authentication manager
  AuthManager({
    required ApiClient apiClient,
    required this.storage,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;
  
  /// Secure storage for tokens
  final SecureStorage storage;

  User? _currentUser;
  Tokens? _tokens;
  String? _tenantId;

  /// Current authenticated user
  User? get currentUser => _currentUser;
  
  /// Current tokens
  Tokens? get tokens => _tokens;
  
  /// Current tenant ID
  String? get tenantId => _tenantId;
  
  /// Whether user is authenticated
  bool get isAuthenticated => _currentUser != null && _tokens != null;

  /// Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyTenantId = 'tenant_id';
  static const String _keyUser = 'user';

  /// Initialize auth manager and load saved session
  Future<void> init() async {
    try {
      final accessToken = await storage.read(_keyAccessToken);
      final refreshToken = await storage.read(_keyRefreshToken);
      final tenantId = await storage.read(_keyTenantId);
      final userJson = await storage.read(_keyUser);

      if (accessToken != null && 
          refreshToken != null && 
          userJson != null && 
          tenantId != null) {
        _tokens = Tokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresIn: 0, // Will be refreshed if expired
        );
        _tenantId = tenantId;
        _currentUser = User.fromJson(
          json.decode(userJson) as Map<String, dynamic>,
        );
        notifyListeners();
      }
    } catch (e) {
      // Failed to load session, continue as unauthenticated
      await logout();
    }
  }

  /// Login with email, password, and tenant ID
  Future<void> login({
    required String email,
    required String password,
    required String tenantId,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
        'tenant_id': tenantId,
      },
      parser: (json) => json as Map<String, dynamic>,
    );

    _tokens = Tokens.fromJson(response.data['tokens'] as Map<String, dynamic>);
    _currentUser = User.fromJson(response.data['user'] as Map<String, dynamic>);
    _tenantId = tenantId;

    // Save session
    await _saveSession();
    
    notifyListeners();
  }

  /// Register new user
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String tenantId,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'name': name,
        'tenant_id': tenantId,
      },
      parser: (json) => json as Map<String, dynamic>,
    );

    _tokens = Tokens.fromJson(response.data['tokens'] as Map<String, dynamic>);
    _currentUser = User.fromJson(response.data['user'] as Map<String, dynamic>);
    _tenantId = tenantId;

    // Save session
    await _saveSession();
    
    notifyListeners();
  }

  /// Logout and clear session
  Future<void> logout() async {
    try {
      // Optionally call logout endpoint
      if (_tokens != null) {
        await _apiClient.post(
          '/auth/logout',
          data: {},
          parser: (json) => null,
        );
      }
    } catch (e) {
      // Ignore errors on logout
    }

    _currentUser = null;
    _tokens = null;
    _tenantId = null;

    await storage.clear();
    
    notifyListeners();
  }

  /// Refresh access token
  Future<void> refreshToken() async {
    if (_tokens?.refreshToken == null) {
      throw ApiException(message: 'No refresh token available');
    }

    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {
        'refresh_token': _tokens!.refreshToken,
      },
      parser: (json) => json as Map<String, dynamic>,
    );

    _tokens = Tokens.fromJson(response.data as Map<String, dynamic>);
    
    await _saveSession();
    
    notifyListeners();
  }

  /// Load current user data
  Future<void> loadCurrentUser() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/auth/me',
      parser: (json) => json as Map<String, dynamic>,
    );

    _currentUser = User.fromJson(response.data);
    
    await _saveSession();
    
    notifyListeners();
  }

  /// Get current access token
  Future<String?> getAccessToken() async {
    return _tokens?.accessToken;
  }

  /// Get current tenant ID
  Future<String?> getTenantId() async {
    return _tenantId;
  }

  Future<void> _saveSession() async {
    if (_tokens != null && _currentUser != null && _tenantId != null) {
      await storage.write(_keyAccessToken, _tokens!.accessToken);
      await storage.write(_keyRefreshToken, _tokens!.refreshToken);
      await storage.write(_keyTenantId, _tenantId!);
      await storage.write(_keyUser, json.encode(_currentUser!.toJson()));
    }
  }
}
