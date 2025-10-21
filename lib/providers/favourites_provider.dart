import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class FavouritesProvider with ChangeNotifier {
  final List<Product> _favouriteProducts = [];

  List<Product> get favouriteProducts => _favouriteProducts;

  void toggleFavourite(Product product) {
    final existingIndex = _favouriteProducts.indexWhere((item) => item.id == product.id);
    
    if (existingIndex >= 0) {
      _favouriteProducts.removeAt(existingIndex);
    } else {
      _favouriteProducts.add(product.copyWith(isFavourite: true));
    }
    notifyListeners();
  }

  bool isFavourite(String productId) {
    return _favouriteProducts.any((item) => item.id == productId);
  }

  void removeFromFavourites(String productId) {
    _favouriteProducts.removeWhere((item) => item.id == productId);
    notifyListeners();
  }
}