/// Debouncing and throttling utilities
library debounce;

import 'dart:async';

/// Debouncer for delaying function execution
class Debouncer {
  /// Creates a debouncer with specified duration
  Debouncer({required this.duration});

  /// Duration to wait before executing
  final Duration duration;
  
  Timer? _timer;

  /// Run the action after the debounce duration
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Cancel pending action
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose the debouncer
  void dispose() {
    _timer?.cancel();
  }
}

/// Throttler for limiting function execution frequency
class Throttler {
  /// Creates a throttler with specified duration
  Throttler({required this.duration});

  /// Minimum duration between executions
  final Duration duration;
  
  Timer? _timer;
  bool _isThrottled = false;

  /// Run the action if not currently throttled
  void run(void Function() action) {
    if (_isThrottled) return;

    action();
    _isThrottled = true;
    
    _timer = Timer(duration, () {
      _isThrottled = false;
    });
  }

  /// Cancel throttling
  void cancel() {
    _timer?.cancel();
    _isThrottled = false;
  }

  /// Dispose the throttler
  void dispose() {
    _timer?.cancel();
  }
}

/// Extension on Function for easy debouncing
extension DebouncedFunction on Function {
  /// Create a debounced version of this function
  void Function() debounced(Duration duration) {
    final debouncer = Debouncer(duration: duration);
    return () {
      debouncer.run(() => this());
    };
  }

  /// Create a throttled version of this function
  void Function() throttled(Duration duration) {
    final throttler = Throttler(duration: duration);
    return () {
      throttler.run(() => this());
    };
  }
}
