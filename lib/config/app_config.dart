export '../core/config/app_env.dart';
import '../core/config/app_env.dart';

class AppConfig {
  final String appName;
  final String appLogo;
  final String baseUrl;
  final String flavor;
  final bool isDemoMode;
  final bool enableLogging;
  final AppEnvironment environment;
  final String? environmentLabel;
  final bool allowAddToCart;

  static const AppConfig current = AppConfig._(
    appName: AppEnv.appName,
    appLogo: AppEnv.appLogo,
    baseUrl: AppEnv.baseUrl,
    flavor: AppEnv.flavor,
    isDemoMode: AppEnv.isDemoMode,
    enableLogging: AppEnv.enableLogging,
    environment: AppEnv.environment,
    environmentLabel: AppEnv.environmentLabel,
    allowAddToCart: AppEnv.allowAddToCart,
  );

  static const AppConfig production = current;
  static const AppConfig dev = current;
  static const AppConfig demo = current;
  static const AppConfig uat = current;

  const AppConfig._({
    required this.appName,
    required this.appLogo,
    required this.baseUrl,
    required this.flavor,
    required this.isDemoMode,
    required this.enableLogging,
    required this.environment,
    required this.environmentLabel,
    required this.allowAddToCart,
  });
}
