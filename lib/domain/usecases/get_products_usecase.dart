import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final IProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<Product>> call() async {
    return repository.fetchProducts();
  }
}
