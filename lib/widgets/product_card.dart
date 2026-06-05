// lib/widgets/product_card.dart
//
// A reusable card widget that displays a single product.
// Shows image, title, price, rating, and an Add to Cart button.
// The button is hidden in Demo mode (controlled by AppConfig).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../config/app_config.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final config = context.read<AppConfig>();
    final cart = context.watch<CartProvider>();
    final isInCart = cart.containsProduct(product.id);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product Image ──────────────────────────────────────────────
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey.shade100,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 48, color: Colors.grey),
              ),
            ),
          ),

          // ── Product Info ───────────────────────────────────────────────
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (max 2 lines)
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, size: 13, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        '${product.ratingRate} (${product.ratingCount})',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Price + Add to Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),

                      // ── Add to Cart (hidden in Demo mode) ────────────
                      if (config.allowAddToCart)
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: isInCart
                                ? null // Already added
                                : () => cart.addToCart(product),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              isInCart ? 'Added ✓' : 'Add',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
