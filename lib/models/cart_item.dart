// lib/models/cart_item.dart
//
// Represents a single item in the shopping cart.
// Wraps a Product with a quantity field.

import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  // Convenience: total price for this line item
  double get totalPrice => product.price * quantity;
}
