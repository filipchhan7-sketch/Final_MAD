import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements IProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> fetchProducts() async {
    final models = await remoteDataSource.fetchProducts();
    return models.map((m) => m.toEntity()).toList();
  }
}
