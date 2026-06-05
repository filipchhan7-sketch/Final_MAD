import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../data/datasources/product_remote_data_source.dart';
import '../data/repositories/product_repository_impl.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/usecases/get_products_usecase.dart';
import '../providers/product_provider.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Register core
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Register data sources
  getIt.registerLazySingleton<ProductRemoteDataSource>(() =>
      ProductRemoteDataSourceImpl(
          baseUrl: AppConfig.current.baseUrl, client: getIt()));

  // Register repositories
  getIt.registerLazySingleton<IProductRepository>(
      () => ProductRepositoryImpl(remoteDataSource: getIt()));

  // Register use cases
  getIt.registerLazySingleton(() => GetProductsUseCase(getIt()));

  // Register providers (factories)
  getIt.registerFactory(() => ProductProvider(getIt()));
}
