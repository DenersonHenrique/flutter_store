import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_store/utils/app_urls.dart';
import 'package:flutter_store/models/order_model.dart';
import 'package:flutter_store/models/cart_item_model.dart';
import 'package:flutter_store/providers/cart_provider.dart';

class OrderProvider with ChangeNotifier {
  final String _baseUrl = '${AppUrl.BASE_API}/orders';
  List<OrderModel> _items = [];
  String _token;
  String _userId;

  OrderProvider([this._token, this._userId, this._items = const []]);

  List<OrderModel> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<OrderModel> loadedItems = [];
    final response = await http.get(
      Uri.parse('$_baseUrl/$_userId.json?auth=$_token'),
    );
    Map<String, dynamic> data = json.decode(response.body);

    // _items.clear();
    data.forEach((key, value) {
      loadedItems.add(
        OrderModel(
          id: key,
          total: value['total'],
          date: DateTime.parse(value['date']),
          products: (value['products'] as List<dynamic>).map((item) {
            return CartItemModel(
              id: item['id'],
              price: item['price'],
              productId: item['productId'],
              quantity: item['quantity'],
              title: item['title'],
            );
          }).toList(),
        ),
      );
    });
    notifyListeners();

    _items = loadedItems.reversed.toList();
    return Future.value();
  }

  Future<void> addOrder(CartProvider cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse('$_baseUrl/$_userId.json?auth=$_token'),
      body: json.encode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((item) => {
                  'id': item.id,
                  'productId': item.productId,
                  'title': item.title,
                  'quantity': item.quantity,
                  'price': item.price
                })
            .toList(),
      }),
    );

    _items.insert(
      0,
      OrderModel(
        id: json.decode(response.body)['name'],
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }
}
