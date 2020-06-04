import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product.dart';
import '../models/http_exception.dart';
import '../api.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  final String _authToken;
  final String _userId;

  Products(this._authToken, this._userId, this._products);

  List<Product> get items {
    return [..._products];
  }

  List<Product> get favorites {
    return _products.where((p) => p.isFavorite).toList();
  }

  Product findById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> deleteProduct(String id) async {
    final url = '$FIREBASE_URL/products/$id.json?auth=$_authToken';
    final index = _products.indexWhere((element) => element.id == id);
    var product = _products[index];
    _products.removeAt(index);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _products.insert(index, product);
      notifyListeners();
      throw HttpException('Could not delete. Please try again later :(');
    }
    product = null;
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : '';
    final url = '$FIREBASE_URL/products.json?auth=$_authToken&$filterString';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> data = json.decode(response.body);
      _products.clear();
      if (data == null) {
        return;
      }
      data.forEach((key, value) {
        final mapProdData = value as Map<String, dynamic>;
        final product = Product(
          id: key,
          title: mapProdData['title'] as String,
          description: mapProdData['description'] as String,
          price: mapProdData['price'] as double,
          imageUrl: mapProdData['imageUrl'] as String,
          isFavorite: mapProdData['isFavorite'] as bool,
        );
        _products.add(product);
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final index = _products.indexWhere((element) => element.id == product.id);
    if (index >= 0 && product.id != null) {
      final url = '$FIREBASE_URL/products/${product.id}.json?auth=$_authToken';
      await http.patch(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
          'creatorId': _userId,
        }),
      );
      _products[index] = product;
      notifyListeners();
    } else {
      final url = '$FIREBASE_URL/products.json?auth=$_authToken';
      try {
        final response = await http.post(
          url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          }),
        );

        final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
        );
        _products.add(newProduct);
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }
}
