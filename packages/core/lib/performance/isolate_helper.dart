/// Isolate utilities for heavy computations
library isolate_helper;

import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';

/// Helper for running computations in isolates
class IsolateHelper {
  IsolateHelper._();

  /// Run a computation in an isolate
  static Future<R> compute<Q, R>(
    ComputeCallback<Q, R> callback,
    Q message, {
    String? debugLabel,
  }) async {
    return compute(callback, message, debugLabel: debugLabel);
  }

  /// Run multiple computations in parallel
  static Future<List<R>> computeParallel<Q, R>(
    ComputeCallback<Q, R> callback,
    List<Q> messages, {
    String? debugLabel,
  }) async {
    return Future.wait(
      messages.map(
        (message) => compute(callback, message, debugLabel: debugLabel),
      ),
    );
  }
}

/// Pool of reusable isolates for frequent computations
class IsolatePool<Q, R> {
  /// Creates an isolate pool
  IsolatePool({
    required this.callback,
    this.poolSize = 2,
  }) {
    _initialize();
  }

  /// Computation callback
  final ComputeCallback<Q, R> callback;
  
  /// Number of isolates in pool
  final int poolSize;

  final List<_IsolateWorker<Q, R>> _workers = [];
  int _currentWorker = 0;

  void _initialize() {
    for (var i = 0; i < poolSize; i++) {
      _workers.add(_IsolateWorker<Q, R>(callback));
    }
  }

  /// Run computation using pool
  Future<R> run(Q message) async {
    final worker = _workers[_currentWorker];
    _currentWorker = (_currentWorker + 1) % poolSize;
    return worker.compute(message);
  }

  /// Dispose all isolates
  Future<void> dispose() async {
    for (final worker in _workers) {
      await worker.dispose();
    }
    _workers.clear();
  }
}

class _IsolateWorker<Q, R> {
  _IsolateWorker(this.callback);

  final ComputeCallback<Q, R> callback;
  Isolate? _isolate;
  SendPort? _sendPort;
  final _completerMap = <int, Completer<R>>{};
  int _nextId = 0;

  Future<R> compute(Q message) async {
    await _ensureInitialized();
    
    final id = _nextId++;
    final completer = Completer<R>();
    _completerMap[id] = completer;

    _sendPort!.send([id, message]);

    return completer.future;
  }

  Future<void> _ensureInitialized() async {
    if (_isolate != null) return;

    final receivePort = ReceivePort();
    
    _isolate = await Isolate.spawn(
      _isolateEntry,
      [receivePort.sendPort, callback],
    );

    final completer = Completer<SendPort>();
    
    receivePort.listen((message) {
      if (message is SendPort) {
        completer.complete(message);
      } else if (message is List && message.length >= 2) {
        final id = message[0] as int;
        final result = message[1] as R?;
        
        // Check if error information is included
        if (message.length > 2 && result == null) {
          final error = message[2];
          _completerMap[id]?.completeError(error);
        } else {
          _completerMap[id]?.complete(result as R);
        }
        _completerMap.remove(id);
      }
    });

    _sendPort = await completer.future;
  }

  static void _isolateEntry<Q, R>(List<dynamic> args) {
    final sendPort = args[0] as SendPort;
    final callback = args[1] as ComputeCallback<Q, R>;
    
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      if (message is List && message.length == 2) {
        final id = message[0] as int;
        final data = message[1] as Q;
        
        try {
          final result = callback(data);
          sendPort.send([id, result]);
        } catch (e, stackTrace) {
          // Send error information back (limit stack trace to 10 frames)
          final limitedStack = stackTrace.toString().split('\n').take(10).join('\n');
          sendPort.send([id, null, e.toString(), limitedStack]);
        }
      }
    });
  }

  Future<void> dispose() async {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _sendPort = null;
    
    // Complete any pending operations with error
    for (final completer in _completerMap.values) {
      if (!completer.isCompleted) {
        completer.completeError('Isolate disposed');
      }
    }
    _completerMap.clear();
  }
}

/// Common compute callbacks for data processing
class ComputeCallbacks {
  ComputeCallbacks._();

  /// Parse JSON list in isolate
  static List<Map<String, dynamic>> parseJsonList(String jsonString) {
    // Implement JSON parsing
    return [];
  }

  /// Sort large list in isolate
  static List<T> sortList<T>(List<T> list) {
    final copy = List<T>.from(list);
    copy.sort();
    return copy;
  }

  /// Filter large list in isolate
  static List<T> filterList<T>({
    required List<T> list,
    required bool Function(T) predicate,
  }) {
    return list.where(predicate).toList();
  }
}
