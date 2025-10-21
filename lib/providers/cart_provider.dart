import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(0, (total, item) {
      return total + (item.price * item.quantity);
    });
  }

  int get totalItems {
    return _cartItems.fold(0, (total, item) => total + item.quantity);
  }

  void addToCart(Product product) {
    final existingIndex = _cartItems.indexWhere((item) => item.id == product.id);
    
    if (existingIndex >= 0) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + 1,
      );
    } else {
      _cartItems.add(product.copyWith(quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.id == productId);
    if (index >= 0) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
      );
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.id == productId);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index] = _cartItems[index].copyWith(
          quantity: _cartItems[index].quantity - 1,
        );
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}