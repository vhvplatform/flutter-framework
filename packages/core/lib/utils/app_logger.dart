/// Enhanced logger utility with different log levels
library logger;

import 'package:logger/logger.dart';

/// Application logger with context and structured logging
class AppLogger {
  AppLogger._();

  static final AppLogger _instance = AppLogger._();
  
  /// Singleton instance
  static AppLogger get instance => _instance;

  late Logger _logger;
  bool _isInitialized = false;

  /// Initialize logger with configuration
  void init({
    Level level = Level.debug,
    bool enableInRelease = false,
  }) {
    if (_isInitialized) return;

    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: level,
    );
    _isInitialized = true;
  }

  /// Log debug message
  void debug(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    if (!_isInitialized) init();
    _logger.d(
      _formatMessage(message, context),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log info message
  void info(
    dynamic message, {
    Map<String, dynamic>? context,
  }) {
    if (!_isInitialized) init();
    _logger.i(_formatMessage(message, context));
  }

  /// Log warning message
  void warning(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    if (!_isInitialized) init();
    _logger.w(
      _formatMessage(message, context),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log error message
  void error(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    if (!_isInitialized) init();
    _logger.e(
      _formatMessage(message, context),
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log fatal error
  void fatal(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    if (!_isInitialized) init();
    _logger.f(
      _formatMessage(message, context),
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _formatMessage(dynamic message, Map<String, dynamic>? context) {
    if (context == null || context.isEmpty) {
      return message.toString();
    }
    return '$message | Context: $context';
  }
}
