import 'package:ite_store/models/product.dart' as domain;

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double ratingRate;
  final int ratingCount;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.ratingRate,
    required this.ratingCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
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

  domain.Product toEntity() {
    return domain.Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      ratingRate: ratingRate,
      ratingCount: ratingCount,
    );
  }
}
