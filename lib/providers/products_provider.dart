import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_store/utils/app_urls.dart';
import 'package:flutter_store/utils/app_string.dart';
import 'package:flutter_store/models/product_model.dart';
import 'package:flutter_store/exceptions/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  final String _baseUrl = '${AppUrl.BASE_API}/products';
  List<ProductModel> _items = [];
  String _token;
  String _userId;

  ProductsProvider([this._token, this._userId, this._items = const []]);

  List<ProductModel> get items => [..._items]; // Return copy/clone of Items.

  int get itemsCount {
    return _items.length;
  }

  List<ProductModel> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  } // Return copy of Items.

  Future<void> loadProducts() async {
    final response = await http.get(
      Uri.parse('$_baseUrl.json?auth=$_token'),
    );
    final favoriteResponse = await http.get(
      Uri.parse('${AppUrl.BASE_API}/userFavorites/$_userId.json?auth=$_token'),
    );
    final favoriteMap = jsonDecode(favoriteResponse.body);

    Map<String, dynamic> data = json.decode(response.body);
    _items.clear();

    data.forEach((key, value) {
      final isFavorite =
          favoriteMap == null ? false : favoriteMap[key] ?? false;
      _items.add(
        ProductModel(
          id: key,
          name: value['name'],
          price: value['price'],
          description: value['description'],
          imageUrl: value['imageUrl'],
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
    return Future.value();
  }

  Future<void> addProduct(ProductModel product) async {
    final response = await http.post(
      Uri.parse('$_baseUrl.json?auth=$_token'),
      body: json.encode(
        {
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        },
      ),
    );

    _items.add(
      ProductModel(
        id: json.decode(response.body)['name'],
        name: product.name,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners(); // Notify components
  }

  Future<void> updateProducts(ProductModel product) async {
    final index = _items.indexWhere((item) => item.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$_baseUrl.json?auth=$_token'),
        body: json.encode({
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((item) => item.id == id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse('$_baseUrl/${product.id}.json?auth=$_token'),
      );
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
          msg: AppString.snackBarTextDeleteProdcutError,
          statusCode: response.statusCode,
        );
      }
    }
  }

  // bool _showFavoriteOnly = false;
  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }
}
