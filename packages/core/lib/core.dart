/// Core framework library for Flutter SaaS applications
library core;

// Config
export 'config/app_config.dart';

// Storage
export 'storage/secure_storage.dart';
export 'storage/local_storage.dart';

// Auth
export 'auth/auth_manager.dart';
export 'auth/models/user.dart';
export 'auth/models/tokens.dart';

// API
export 'api/api_client.dart';

// Dependency Injection
export 'di/service_locator.dart';

// Modules
export 'modules/module.dart';

// Navigation
export 'navigation/router.dart';

// Utilities
export 'utils/app_logger.dart';
export 'utils/validators.dart';

// Internationalization
export 'i18n/app_localizations.dart';
