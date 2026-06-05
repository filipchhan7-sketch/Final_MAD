// lib/models/product.dart
//
// Data model representing a product fetched from the API.
// Uses the public FakeStore API: https://fakestoreapi.com/products

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double ratingRate;
  final int ratingCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.ratingRate,
    required this.ratingCount,
  });

  // Factory constructor to create a Product from JSON (API response)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      ratingRate: (json['rating']?['rate'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['rating']?['count'] as num?)?.toInt() ?? 0,
    );
  }
}
