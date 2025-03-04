import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
import '../api.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token) async {
    final url = '$FIREBASE_URL/products/$id.json?auth=$token';
    isFavorite = !isFavorite;
    notifyListeners();
    final response = await http.patch(
      url,
      body: json.encode({
        'isFavorite': isFavorite,
      }),
    );

    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Could not favorite. Please try again later :(');
    }
  }
}
