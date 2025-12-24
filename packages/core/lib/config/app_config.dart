/// Enumeration of application environments
enum Environment {
  /// Development environment
  development,
  
  /// Staging environment
  staging,
  
  /// Production environment
  production,
}

/// Application configuration class
class AppConfig {
  /// Creates an application configuration
  const AppConfig({
    required this.apiBaseUrl,
    required this.environment,
    required this.appName,
    required this.version,
  });

  /// Base URL for API endpoints
  final String apiBaseUrl;
  
  /// Current environment
  final Environment environment;
  
  /// Application name
  final String appName;
  
  /// Application version
  final String version;

  /// Whether the app is in development mode
  bool get isDevelopment => environment == Environment.development;
  
  /// Whether the app is in staging mode
  bool get isStaging => environment == Environment.staging;
  
  /// Whether the app is in production mode
  bool get isProduction => environment == Environment.production;
}
