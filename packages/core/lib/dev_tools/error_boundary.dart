import 'package:flutter/material.dart';
import '../utils/app_logger.dart';

/// Error boundary widget that catches and displays errors in a user-friendly way
/// This helps developers identify issues quickly during development
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, FlutterErrorDetails details)? errorBuilder;
  final void Function(FlutterErrorDetails details)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  FlutterErrorDetails? _errorDetails;

  @override
  void initState() {
    super.initState();
    
    // Set up error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      if (mounted) {
        setState(() {
          _errorDetails = details;
        });
      }
      
      // Log error
      AppLogger.instance.error(
        'ErrorBoundary caught error',
        error: details.exception,
        stackTrace: details.stack,
      );
      
      // Call custom error handler
      widget.onError?.call(details);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_errorDetails != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, _errorDetails!);
      }
      return _buildDefaultErrorWidget(context);
    }
    
    return widget.child;
  }

  Widget _buildDefaultErrorWidget(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _errorDetails!.exception.toString(),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorDetails!.stack.toString(),
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _errorDetails = null;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension to wrap any widget with error boundary
extension ErrorBoundaryExtension on Widget {
  Widget withErrorBoundary({
    Widget Function(BuildContext context, FlutterErrorDetails details)? errorBuilder,
    void Function(FlutterErrorDetails details)? onError,
  }) {
    return ErrorBoundary(
      errorBuilder: errorBuilder,
      onError: onError,
      child: this,
    );
  }
}
