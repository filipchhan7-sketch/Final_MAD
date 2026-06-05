// lib/screens/home_screen.dart
//
// The main product listing screen.
// Features:
//  - Fetches products from the API on load
//  - Search bar to filter products by name
//  - Grid of product cards
//  - Cart badge icon in AppBar (hidden in Demo mode)
//  - Environment label shown in AppBar subtitle

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_config.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_badge.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load products when the screen first opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = context.read<AppConfig>();
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(config.appName),
            // Show environment label (DEV / UAT / DEMO) below the title
            if (config.environmentLabel != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: _envLabelColor(config.environment),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  config.environmentLabel!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          // Cart icon only shown if addToCart is allowed (not Demo mode)
          if (config.allowAddToCart) CartBadge(onTap: () => _goToCart(context)),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) =>
                  context.read<ProductProvider>().search(value),
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<ProductProvider>().search('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),

          // ── Product Grid or State Messages ───────────────────────────────
          Expanded(child: _buildBody(productProvider)),
        ],
      ),
    );
  }

  Widget _buildBody(ProductProvider provider) {
    // Loading state
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state
    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              'Failed to load products',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.read<ProductProvider>().loadProducts(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Empty search result
    if (provider.products.isEmpty) {
      return const Center(
        child: Text('No products found.', style: TextStyle(fontSize: 16)),
      );
    }

    // Product Grid
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: provider.products.length,
      itemBuilder: (context, index) =>
          ProductCard(product: provider.products[index]),
    );
  }

  // Returns a colour based on the environment for the label badge
  Color _envLabelColor(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.dev:
        return Colors.green;
      case AppEnvironment.uat:
        return Colors.orange;
      case AppEnvironment.demo:
        return Colors.purple;
      case AppEnvironment.production:
        return Colors.blue;
    }
  }
}
