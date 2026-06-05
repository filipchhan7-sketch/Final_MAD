// lib/screens/cart_screen.dart
//
// The shopping cart screen.
// Features:
//  - List of cart items with image, title, price, quantity controls
//  - Running total at the bottom
//  - Checkout button → shows success dialog → clears cart → goes back to Home

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // Shows the checkout success dialog, then clears the cart and returns home
  Future<void> _handleCheckout(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // User must tap the button
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Order Placed!'),
          ],
        ),
        content: const Text(
          'Your order has been placed successfully.\nThank you for shopping at ITE Store! 🎉',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Back to Shop'),
          ),
        ],
      ),
    );

    // After dialog is dismissed: clear cart and pop back to Home
    if (context.mounted) {
      context.read<CartProvider>().clearCart();
      Navigator.of(context).pop(); // Return to HomeScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${cart.totalItemCount} items)'),
      ),

      body:
          cart.items.isEmpty ? _buildEmptyCart(context) : _buildCartList(cart),

      // ── Checkout Bottom Bar ─────────────────────────────────────────────
      bottomNavigationBar: cart.items.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Total price display
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total',
                              style: TextStyle(color: Colors.grey)),
                          Text(
                            '\$${cart.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Checkout button
                    ElevatedButton.icon(
                      onPressed: () => _handleCheckout(context),
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text('Checkout'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Shown when cart is empty
  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('Your cart is empty', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  // List of cart items
  Widget _buildCartList(CartProvider cart) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: cart.items.length,
      itemBuilder: (context, index) => CartItemTile(item: cart.items[index]),
    );
  }
}
