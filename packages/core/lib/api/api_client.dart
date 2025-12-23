import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// API response wrapper
class ApiResponse<T> {
  /// Creates an API response
  const ApiResponse({
    required this.data,
    this.message,
    this.metadata,
  });

  /// Response data
  final T data;
  
  /// Response message
  final String? message;
  
  /// Additional metadata
  final Map<String, dynamic>? metadata;
}

/// API exception for error handling
class ApiException implements Exception {
  /// Creates an API exception
  const ApiException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  /// Error message
  final String message;
  
  /// HTTP status code
  final int? statusCode;
  
  /// Field-specific errors
  final Map<String, dynamic>? errors;

  @override
  String toString() => 'ApiException: $message (${statusCode ?? "unknown"})';
}

/// HTTP client using Dio with automatic token injection and error handling
class ApiClient {
  /// Creates an API client
  ApiClient({
    required this.baseUrl,
    this.authManager,
    bool enableLogging = true,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _setupInterceptors(enableLogging);
  }

  /// Base URL for API
  final String baseUrl;
  
  /// Authentication manager for token injection
  final dynamic authManager;
  
  final Dio _dio;
  final Logger _logger = Logger();

  void _setupInterceptors(bool enableLogging) {
    // Request interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authorization token
          if (authManager != null) {
            final token = await authManager.getAccessToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            
            // Add tenant ID
            final tenantId = await authManager.getTenantId();
            if (tenantId != null) {
              options.headers['X-Tenant-ID'] = tenantId;
            }
          }

          if (enableLogging) {
            _logger.d('REQUEST[${options.method}] => ${options.path}');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (enableLogging) {
            _logger.d(
              'RESPONSE[${response.statusCode}] => ${response.requestOptions.path}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          if (enableLogging) {
            _logger.e(
              'ERROR[${error.response?.statusCode}] => ${error.requestOptions.path}',
            );
          }

          // Handle 401 errors with token refresh
          if (error.response?.statusCode == 401 && authManager != null) {
            try {
              await authManager.refreshToken();
              
              // Retry the request
              final opts = error.requestOptions;
              final token = await authManager.getAccessToken();
              opts.headers['Authorization'] = 'Bearer $token';
              
              final response = await _dio.fetch(opts);
              return handler.resolve(response);
            } catch (e) {
              // If refresh fails, logout
              await authManager.logout();
            }
          }

          handler.next(error);
        },
      ),
    );
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return _parseResponse(response, parser);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _parseResponse(response, parser);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return _parseResponse(response, parser);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );
      return _parseResponse(response, parser);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload file
  Future<ApiResponse<T>> upload<T>(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? data,
    required T Function(dynamic json) parser,
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        ...?data,
        fieldName: await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: onProgress,
      );
      return _parseResponse(response, parser);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiResponse<T> _parseResponse<T>(
    Response response,
    T Function(dynamic json) parser,
  ) {
    final responseData = response.data as Map<String, dynamic>;
    return ApiResponse<T>(
      data: parser(responseData['data']),
      message: responseData['message'] as String?,
      metadata: responseData['metadata'] as Map<String, dynamic>?,
    );
  }

  ApiException _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic>) {
        return ApiException(
          message: data['message'] as String? ?? 'An error occurred',
          statusCode: error.response!.statusCode,
          errors: data['errors'] as Map<String, dynamic>?,
        );
      }
    }

    return ApiException(
      message: error.message ?? 'Network error',
      statusCode: error.response?.statusCode,
    );
  }
}
