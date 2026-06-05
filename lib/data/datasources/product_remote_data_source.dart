import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.baseUrl, required this.client});

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final uri = Uri.parse('$baseUrl/products.json');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((j) => ProductModel.fromJson(j)).toList();
    } else {
      throw Exception(
          'Failed to load products (status: ${response.statusCode})');
    }
  }
}
