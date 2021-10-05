import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_store/app/utils/app_urls.dart';

class ProductModel with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(
    String? token,
    String? userId,
  ) async {
    _toggleFavorite();

    try {
      final String _baseUrl =
          '${AppUrl.BASE_API}/userFavorites/$userId/$id.json?auth=$token';

      final response = await http.put(
        Uri.parse(_baseUrl),
        body: json.encode(isFavorite),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (_) {
      _toggleFavorite();
    }
  }
}