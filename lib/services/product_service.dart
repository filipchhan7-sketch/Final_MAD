// lib/services/product_service.dart
//
// Handles all API calls related to products.
// Uses the public FakeStore API for demo data.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  // Fetch all products from the API
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products (status: ${response.statusCode})');
    }
  }
}
