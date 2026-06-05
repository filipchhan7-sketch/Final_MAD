enum AppEnvironment { dev, uat, demo, production }

/// A compile-time environment configuration class backed by Dart defines.
///
/// Use `--dart-define-from-file=env/<flavor>.json` to provide values.
class AppEnv {
  static const String appName =
      String.fromEnvironment('APP_NAME', defaultValue: 'ITE Store Dev');

  static const String appLogo =
      String.fromEnvironment('APP_LOGO', defaultValue: 'assets/images/dev.jpg');

  static const String baseUrl =
      String.fromEnvironment('BASE_URL', defaultValue: 'http://localhost:3000');

  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static const bool isDemoMode =
      bool.fromEnvironment('DEMO_MODE', defaultValue: false);

  static const bool enableLogging =
      bool.fromEnvironment('ENABLE_LOGGING', defaultValue: true);
  static const bool isProduction = flavor == 'prod';

  static const AppEnvironment environment = flavor == 'dev'
      ? AppEnvironment.dev
      : flavor == 'uat'
          ? AppEnvironment.uat
          : flavor == 'demo'
              ? AppEnvironment.demo
              : AppEnvironment.production;

  static const String? environmentLabel = flavor == 'prod'
      ? null
      : flavor == 'dev'
          ? 'DEV'
          : flavor == 'uat'
              ? 'UAT'
              : flavor == 'demo'
                  ? 'DEMO'
                  : null;

  static const bool allowAddToCart = !isDemoMode;
}
