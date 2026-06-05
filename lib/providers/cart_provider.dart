// lib/providers/cart_provider.dart
//
// Manages the shopping cart state using ChangeNotifier (Provider pattern).
// Handles add, remove, increment, decrement, and checkout logic.

import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  // Internal map: productId → CartItem (map for O(1) lookup)
  final Map<int, CartItem> _items = {};

  // ─── Getters ───────────────────────────────────────────────────────────────
  List<CartItem> get items => _items.values.toList();

  int get totalItemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool containsProduct(int productId) => _items.containsKey(productId);

  // ─── Add to Cart ──────────────────────────────────────────────────────────
  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      // Already in cart → increase quantity
      _items[product.id]!.quantity++;
    } else {
      // New product → add with qty = 1
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  // ─── Increase / Decrease Quantity ────────────────────────────────────────
  void increaseQuantity(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(int productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity--;
      } else {
        _items.remove(productId); // Remove if quantity reaches 0
      }
      notifyListeners();
    }
  }

  // ─── Remove Item ──────────────────────────────────────────────────────────
  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // ─── Clear Cart (used after checkout) ────────────────────────────────────
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
