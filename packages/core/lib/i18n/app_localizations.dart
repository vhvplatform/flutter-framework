/// Internationalization support
library i18n;

import 'package:flutter/widgets.dart';

/// Base class for app localizations
abstract class AppLocalizations {
  /// Get localized string by key
  String get(String key);

  /// Get localized string with parameters
  String getWithParams(String key, Map<String, String> params);

  /// Current locale
  Locale get locale;

  /// Get localizations from context
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

/// Default English localizations
class EnglishLocalizations extends AppLocalizations {
  @override
  final Locale locale = const Locale('en');

  static final Map<String, String> _localizedValues = {
    // Common
    'app_name': 'SaaS App',
    'ok': 'OK',
    'cancel': 'Cancel',
    'save': 'Save',
    'delete': 'Delete',
    'edit': 'Edit',
    'confirm': 'Confirm',
    'yes': 'Yes',
    'no': 'No',
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'retry': 'Retry',
    
    // Auth
    'login': 'Login',
    'logout': 'Logout',
    'register': 'Register',
    'email': 'Email',
    'password': 'Password',
    'forgot_password': 'Forgot Password?',
    'sign_in': 'Sign In',
    'sign_up': 'Sign Up',
    'sign_out': 'Sign Out',
    
    // Validation
    'field_required': 'This field is required',
    'invalid_email': 'Invalid email address',
    'password_too_short': 'Password is too short',
    
    // Messages
    'welcome_back': 'Welcome back',
    'no_data': 'No data available',
    'something_went_wrong': 'Something went wrong',
  };

  @override
  String get(String key) {
    return _localizedValues[key] ?? key;
  }

  @override
  String getWithParams(String key, Map<String, String> params) {
    var value = get(key);
    params.forEach((paramKey, paramValue) {
      value = value.replaceAll('{$paramKey}', paramValue);
    });
    return value;
  }
}

/// Localizations delegate
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
      default:
        return EnglishLocalizations();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
