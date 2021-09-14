import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_store/providers/cart.dart';
import 'package:flutter_store/utils/app_urls.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.total,
    this.id,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  final String _baseUrl = '${AppUrl.BASE_API}/orders';
  List<Order> _items = [];
  String _token;
  String _userId;

  Orders([this._token, this._userId, this._items = const []]);

  List<Order> get orders {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];
    final response = await http.get('$_baseUrl/$_userId.json?auth=$_token');
    Map<String, dynamic> data = json.decode(response.body);

    // _items.clear();
    if (data != null) {
      data.forEach((key, value) {
        loadedItems.add(
          Order(
            id: key,
            total: value['total'],
            date: DateTime.parse(value['date']),
            products: (value['products'] as List<dynamic>).map((item) {
              return CartItem(
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
    }

    _items = loadedItems.reversed.toList();
    return Future.value();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      '$_baseUrl/$_userId.json?auth=$_token',
      body: json.encode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map(
              (item) => {
                'id': item.id,
                'productId': item.productId,
                'title': item.title,
                'quantity': item.quantity,
                'price': item.price
              },
            )
            .toList(),
      }),
    );

    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );

    notifyListeners();
  }
}
