// lib/providers/product_provider.dart
//
// Manages the product list state using ChangeNotifier (Provider pattern).
// Handles loading, error states, and search filtering.

import 'package:flutter/foundation.dart';
import '../domain/entities/product.dart';
import '../domain/usecases/get_products_usecase.dart';

class ProductProvider extends ChangeNotifier {
  final GetProductsUseCase _getProductsUseCase;

  ProductProvider(this._getProductsUseCase);

  // ─── State Fields ──────────────────────────────────────────────────────────
  List<Product> _allProducts = []; // Full list from API
  List<Product> _filtered = []; // After search filter applied
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  // ─── Getters (read-only access for UI) ────────────────────────────────────
  List<Product> get products => _filtered;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  // ─── Load Products from API ───────────────────────────────────────────────
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allProducts = await _getProductsUseCase();
      _applySearch(); // Apply any existing search after reload
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── Search ───────────────────────────────────────────────────────────────
  void search(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.trim().isEmpty) {
      _filtered = List.from(_allProducts);
    } else {
      final q = _searchQuery.toLowerCase();
      _filtered =
          _allProducts.where((p) => p.title.toLowerCase().contains(q)).toList();
    }
  }
}
