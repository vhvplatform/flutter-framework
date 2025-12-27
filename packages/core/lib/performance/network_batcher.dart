/// Network request batching utilities
library network_batcher;

import 'dart:async';
import 'package:dio/dio.dart';

/// Batch multiple network requests together
class NetworkBatcher {
  /// Creates a network batcher
  NetworkBatcher({
    required this.dio,
    this.batchDelay = const Duration(milliseconds: 50),
    this.maxBatchSize = 10,
  });

  /// Dio instance
  final Dio dio;
  
  /// Delay before executing batch
  final Duration batchDelay;
  
  /// Maximum number of requests in a batch
  final int maxBatchSize;

  final List<_BatchedRequest> _pendingRequests = [];
  Timer? _batchTimer;

  /// Add request to batch
  Future<Response> addRequest({
    required String path,
    required String method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final completer = Completer<Response>();
    
    _pendingRequests.add(_BatchedRequest(
      path: path,
      method: method,
      data: data,
      queryParameters: queryParameters,
      completer: completer,
    ));

    _scheduleBatch();

    return completer.future;
  }

  void _scheduleBatch() {
    _batchTimer?.cancel();

    if (_pendingRequests.length >= maxBatchSize) {
      _executeBatch();
    } else {
      _batchTimer = Timer(batchDelay, _executeBatch);
    }
  }

  Future<void> _executeBatch() async {
    if (_pendingRequests.isEmpty) return;

    final batch = List<_BatchedRequest>.from(_pendingRequests);
    _pendingRequests.clear();

    // Execute requests in parallel
    await Future.wait(
      batch.map((request) => _executeRequest(request)),
    );
  }

  Future<void> _executeRequest(_BatchedRequest request) async {
    try {
      final response = await dio.request(
        request.path,
        data: request.data,
        queryParameters: request.queryParameters,
        options: Options(method: request.method),
      );
      request.completer.complete(response);
    } catch (e) {
      request.completer.completeError(e);
    }
  }

  /// Dispose the batcher
  void dispose() {
    _batchTimer?.cancel();
    _batchTimer = null;
    
    // Complete pending requests with error
    for (final request in _pendingRequests) {
      if (!request.completer.isCompleted) {
        request.completer.completeError('NetworkBatcher disposed');
      }
    }
    _pendingRequests.clear();
  }
}

class _BatchedRequest {
  _BatchedRequest({
    required this.path,
    required this.method,
    this.data,
    this.queryParameters,
    required this.completer,
  });

  final String path;
  final String method;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? queryParameters;
  final Completer<Response> completer;
}

/// Request deduplication to avoid duplicate requests
class RequestDeduplicator {
  final Map<String, Future<Response>> _inFlightRequests = {};
  static const int _maxCachedRequests = 100; // Prevent unbounded growth

  /// Execute request with deduplication
  Future<Response> execute({
    required String key,
    required Future<Response> Function() request,
  }) async {
    // Check if request is already in flight
    if (_inFlightRequests.containsKey(key)) {
      return _inFlightRequests[key]!;
    }

    // Clean up old requests if too many cached
    if (_inFlightRequests.length >= _maxCachedRequests) {
      _inFlightRequests.clear();
    }

    // Execute request
    final future = request();
    _inFlightRequests[key] = future;

    try {
      final response = await future;
      return response;
    } finally {
      _inFlightRequests.remove(key);
    }
  }

  /// Clear all in-flight requests
  void clear() {
    _inFlightRequests.clear();
  }
  
  /// Get count of in-flight requests
  int get inFlightCount => _inFlightRequests.length;
}
