import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfrontend/features/auth/provider/cart_provider.dart';
import 'package:myfrontend/data/model/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  double _discount = 0.0;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    double subTotal = cart.totalPrice;
    double deliveryFee = cart.items.isEmpty ? 0 : 25.0;
    double discount = _discount;
    double totalCost = subTotal + deliveryFee - discount;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header (no back button)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: const [
                  SizedBox(width: 40), // No back button, just a spacer
                  Expanded(
                    child: Text(
                      'My Cart',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 40), // For balance
                ],
              ),
            ),
            // Rest of the cart content
            Expanded(
              child: cart.items.isEmpty
                  ? const Center(child: Text('Your cart is empty'))
                  : ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Dismissible(
                    key: ValueKey(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red[100],
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: const Icon(Icons.delete, color: Colors.red, size: 32),
                    ),
                    confirmDismiss: (_) async {
                      return await showDialog(
                        context: context,
                        builder: (_) => _buildRemoveDialog(context, item),
                      );
                    },
                    onDismissed: (_) => cart.removeFromCart(item.id),
                    child: _buildCartItem(context, item, cart),
                  );
                },
              ),
            ),
            _buildCartSummary(subTotal, deliveryFee, discount, totalCost, cart),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item, CartProvider cart) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Size: ${item.size}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text('\$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (item.quantity > 1) {
                      cart.updateQuantity(item.id, item.quantity - 1);
                    }
                  },
                ),
                Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    cart.updateQuantity(item.id, item.quantity + 1);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoveDialog(BuildContext context, CartItem item) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Remove from Cart?'),
      content: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Size: ${item.size}'),
                Text('\$${item.price.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Yes, Remove'),
        ),
      ],
    );
  }

  Widget _buildCartSummary(double subTotal, double deliveryFee, double discount, double totalCost, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Promo Code
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promoController,
                  decoration: InputDecoration(
                    hintText: 'Promo Code',
                    filled: true,
                    fillColor: const Color(0xFFF8F5F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Example: Apply a fixed discount for any code
                    _discount = _promoController.text.isNotEmpty ? 35.0 : 0.0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5C2A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Summary
          _buildSummaryRow('Sub-Total', '\$${subTotal.toStringAsFixed(2)}'),
          _buildSummaryRow('Delivery Fee', '\$${deliveryFee.toStringAsFixed(2)}'),
          _buildSummaryRow('Discount', '-\$${discount.toStringAsFixed(2)}'),
          const Divider(height: 24),
          _buildSummaryRow('Total Cost', '\$${totalCost.toStringAsFixed(2)}', isBold: true),
          const SizedBox(height: 16),
          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: cart.items.isEmpty ? null : () {
                // TODO: Implement checkout logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checkout not implemented')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5C2A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[700], fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}