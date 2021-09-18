import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_store/models/product_model.dart';
import 'package:flutter_store/models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (element) => CartItemModel(
          id: element.id,
          productId: product.id,
          name: element.name,
          price: element.price,
          quantity: element.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItemModel(
          id: Random().nextDouble().toString(),
          productId: product.id,
          name: product.name,
          price: product.price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) {
      return;
    }

    if (_items[productID]?.quantity == 1) {
      _items.remove(productID);
    } else {
      _items.update(
        productID,
        (element) => CartItemModel(
          id: element.id,
          productId: productID,
          name: element.name,
          price: element.price,
          quantity: element.quantity - 1,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
