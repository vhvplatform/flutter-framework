/// HTTP request optimization utilities
library http_optimization;

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Request priority levels
enum RequestPriority {
  /// Low priority - can be delayed
  low,
  
  /// Normal priority - default
  normal,
  
  /// High priority - process immediately
  high,
  
  /// Critical priority - bypass queue
  critical,
}

/// Optimized HTTP client with connection pooling and request prioritization
class OptimizedHttpClient {
  OptimizedHttpClient({
    required this.baseUrl,
    this.maxConcurrentRequests = 6,
    this.connectionTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectionTimeout,
        receiveTimeout: receiveTimeout,
        // Enable HTTP/2 and connection reuse
        persistentConnection: true,
        headers: {
          'Connection': 'keep-alive',
          'Keep-Alive': 'timeout=5, max=100',
        },
      ),
    );

    // Configure HTTP adapter for better performance
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.maxConnectionsPerHost = maxConcurrentRequests;
      client.idleTimeout = const Duration(seconds: 5);
      return client;
    };
  }

  /// Base URL
  final String baseUrl;

  /// Maximum concurrent requests
  final int maxConcurrentRequests;

  /// Connection timeout
  final Duration connectionTimeout;

  /// Receive timeout
  final Duration receiveTimeout;

  late final Dio _dio;
  final Map<RequestPriority, List<_QueuedRequest>> _requestQueue = {
    RequestPriority.low: [],
    RequestPriority.normal: [],
    RequestPriority.high: [],
    RequestPriority.critical: [],
  };
  int _activeRequests = 0;
  final Map<String, CancelToken> _cancelTokens = {};

  /// Get Dio instance
  Dio get dio => _dio;

  /// Execute request with priority
  Future<Response<T>> request<T>(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    RequestPriority priority = RequestPriority.normal,
    String? requestId,
  }) async {
    final cancelToken = CancelToken();
    if (requestId != null) {
      _cancelTokens[requestId] = cancelToken;
    }

    // Critical requests bypass queue
    if (priority == RequestPriority.critical) {
      return _executeRequest<T>(
        path: path,
        method: method,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    }

    // Queue request if at capacity
    if (_activeRequests >= maxConcurrentRequests) {
      final completer = Completer<Response<T>>();
      _requestQueue[priority]!.add(
        _QueuedRequest(
          path: path,
          method: method,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          completer: completer as Completer<Response>,
        ),
      );
      return completer.future;
    }

    return _executeRequest<T>(
      path: path,
      method: method,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> _executeRequest<T>({
    required String path,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required CancelToken cancelToken,
  }) async {
    _activeRequests++;

    try {
      final response = await _dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
        cancelToken: cancelToken,
      );
      return response;
    } finally {
      _activeRequests--;
      _processQueue();
    }
  }

  void _processQueue() {
    if (_activeRequests >= maxConcurrentRequests) return;

    // Process by priority
    for (final priority in [
      RequestPriority.high,
      RequestPriority.normal,
      RequestPriority.low,
    ]) {
      final queue = _requestQueue[priority]!;
      if (queue.isNotEmpty) {
        final request = queue.removeAt(0);
        _executeRequest(
          path: request.path,
          method: request.method,
          data: request.data,
          queryParameters: request.queryParameters,
          options: request.options,
          cancelToken: request.cancelToken,
        ).then((response) {
          request.completer.complete(response);
        }).catchError((error) {
          request.completer.completeError(error);
        });
        break;
      }
    }
  }

  /// Cancel request by ID
  void cancelRequest(String requestId) {
    final token = _cancelTokens[requestId];
    if (token != null && !token.isCancelled) {
      token.cancel('Request cancelled by user');
      _cancelTokens.remove(requestId);
    }
  }

  /// Cancel all pending requests
  void cancelAllRequests() {
    for (final token in _cancelTokens.values) {
      if (!token.isCancelled) {
        token.cancel('All requests cancelled');
      }
    }
    _cancelTokens.clear();

    // Clear queues
    for (final queue in _requestQueue.values) {
      for (final request in queue) {
        request.completer.completeError('Request cancelled');
      }
      queue.clear();
    }
  }

  /// Get queue statistics
  Map<String, int> getQueueStats() {
    return {
      'active': _activeRequests,
      'low': _requestQueue[RequestPriority.low]!.length,
      'normal': _requestQueue[RequestPriority.normal]!.length,
      'high': _requestQueue[RequestPriority.high]!.length,
      'critical': _requestQueue[RequestPriority.critical]!.length,
    };
  }
}

class _QueuedRequest {
  _QueuedRequest({
    required this.path,
    required this.method,
    this.data,
    this.queryParameters,
    this.options,
    required this.cancelToken,
    required this.completer,
  });

  final String path;
  final String method;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final Options? options;
  final CancelToken cancelToken;
  final Completer<Response> completer;
}

/// Performance-optimized interceptor
class PerformanceInterceptor extends Interceptor {
  PerformanceInterceptor({
    this.enableLogging = false,
    this.logSlowRequests = true,
    this.slowRequestThreshold = const Duration(seconds: 3),
  });

  /// Enable request/response logging
  final bool enableLogging;

  /// Log slow requests
  final bool logSlowRequests;

  /// Threshold for slow requests
  final Duration slowRequestThreshold;

  final Map<RequestOptions, DateTime> _requestTimes = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _requestTimes[options] = DateTime.now();

    if (enableLogging && kDebugMode) {
      debugPrint('→ ${options.method} ${options.uri}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = _requestTimes[response.requestOptions];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _requestTimes.remove(response.requestOptions);

      if (logSlowRequests && duration > slowRequestThreshold) {
        debugPrint(
          '⚠️ Slow request: ${response.requestOptions.method} '
          '${response.requestOptions.uri} took ${duration.inMilliseconds}ms',
        );
      }

      if (enableLogging && kDebugMode) {
        debugPrint(
          '← ${response.statusCode} ${response.requestOptions.uri} '
          '(${duration.inMilliseconds}ms)',
        );
      }
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = _requestTimes[err.requestOptions];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _requestTimes.remove(err.requestOptions);

      if (enableLogging && kDebugMode) {
        debugPrint(
          '✗ ${err.requestOptions.method} ${err.requestOptions.uri} '
          'failed after ${duration.inMilliseconds}ms: ${err.message}',
        );
      }
    }

    super.onError(err, handler);
  }
}

/// Response compression interceptor
class CompressionInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Request compression
    options.headers['Accept-Encoding'] = 'gzip, deflate, br';
    super.onRequest(options, handler);
  }
}

/// Request retry interceptor with exponential backoff
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryableStatusCodes = const [408, 429, 500, 502, 503, 504],
  });

  /// Maximum number of retries
  final int maxRetries;

  /// Initial retry delay
  final Duration retryDelay;

  /// HTTP status codes that should trigger a retry
  final List<int> retryableStatusCodes;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final retries = requestOptions.extra['retries'] as int? ?? 0;

    // Check if we should retry
    if (retries < maxRetries &&
        err.response?.statusCode != null &&
        retryableStatusCodes.contains(err.response!.statusCode)) {
      // Calculate exponential backoff
      final delay = retryDelay * (1 << retries); // 2^retries

      if (kDebugMode) {
        debugPrint(
          '🔄 Retrying request (${retries + 1}/$maxRetries) '
          'after ${delay.inSeconds}s: ${requestOptions.uri}',
        );
      }

      await Future.delayed(delay);

      // Increment retry counter
      requestOptions.extra['retries'] = retries + 1;

      try {
        final response = await Dio().fetch(requestOptions);
        return handler.resolve(response);
      } on DioException catch (e) {
        return super.onError(e, handler);
      }
    }

    super.onError(err, handler);
  }
}

/// Cache interceptor for GET requests
class CacheInterceptor extends Interceptor {
  CacheInterceptor({
    this.maxCacheSize = 100,
    this.defaultCacheDuration = const Duration(minutes: 5),
  });

  /// Maximum number of cached responses
  final int maxCacheSize;

  /// Default cache duration
  final Duration defaultCacheDuration;

  final Map<String, _CachedResponse> _cache = {};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only cache GET requests
    if (options.method.toUpperCase() != 'GET') {
      return super.onRequest(options, handler);
    }

    final cacheKey = _getCacheKey(options);
    final cached = _cache[cacheKey];

    if (cached != null && !cached.isExpired) {
      if (kDebugMode) {
        debugPrint('📦 Cache hit: ${options.uri}');
      }
      return handler.resolve(cached.response, true);
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Only cache successful GET requests
    if (response.requestOptions.method.toUpperCase() == 'GET' &&
        response.statusCode == 200) {
      final cacheKey = _getCacheKey(response.requestOptions);

      // Evict old entries if cache is full
      if (_cache.length >= maxCacheSize) {
        final oldestKey = _cache.keys.first;
        _cache.remove(oldestKey);
      }

      _cache[cacheKey] = _CachedResponse(
        response: response,
        expiresAt: DateTime.now().add(defaultCacheDuration),
      );
    }

    super.onResponse(response, handler);
  }

  String _getCacheKey(RequestOptions options) {
    return '${options.uri}';
  }

  /// Clear cache
  void clearCache() {
    _cache.clear();
  }

  /// Get cache statistics
  Map<String, int> getCacheStats() {
    final now = DateTime.now();
    final valid = _cache.values.where((c) => !c.isExpired).length;
    return {
      'total': _cache.length,
      'valid': valid,
      'expired': _cache.length - valid,
    };
  }
}

class _CachedResponse {
  _CachedResponse({
    required this.response,
    required this.expiresAt,
  });

  final Response response;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
