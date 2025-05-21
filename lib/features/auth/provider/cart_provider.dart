// lib/features/cart/provider/cart_provider.dart
import 'package:flutter/material.dart';
import 'package:myfrontend/data/model/cart_item.dart';
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/provider/auth_provider.dart';
import 'package:myfrontend/utils/navigator_key.dart';
import 'package:provider/provider.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  double get totalPrice =>
      _items.values.fold(0, (sum, item) => sum + item.price * item.quantity);

  void addToCart(Product product, {String size = 'M', String color = 'Black'}) {
    final authProvider = Provider.of<AuthProvider>(navigatorKey.currentContext!, listen: false);

    // Check if user is logged in
    if (!authProvider.isLoggedIn) {
      throw Exception('User must be logged in to add items to cart');
    }

    // Check if user is trying to add their own product
    if (authProvider.userData?.id == product.userId) {
      throw Exception('Cannot add your own product to cart');
    }

    final id = '${product.id}-$size-$color';
    if (_items.containsKey(id)) {
      _items[id]!.quantity += 1;
    } else {
      _items[id] = CartItem(
        id: id,
        productId: product.id,
        name: product.name,
        imageUrl: product.imageUrl,
        price: product.price,
        size: size,
        color: color,
        quantity: 1,
      );
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity = quantity;
      if (quantity <= 0) _items.remove(id);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}