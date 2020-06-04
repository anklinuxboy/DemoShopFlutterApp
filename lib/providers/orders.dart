import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cart.dart';
import '../api.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String _authToken;

  Orders(this._authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = '$FIREBASE_URL/orders.json?auth=$_authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data == null) {
      return;
    }
    data.forEach((key, value) {
      loadedOrders.add(OrderItem(
          id: key,
          amount: value['amount'],
          items: (value['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
          date: DateTime.parse(value['dateTime'])));
    });

    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final url = '$FIREBASE_URL/orders.json?auth=$_authToken';
    final dateTime = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': dateTime.toIso8601String(),
        'products': cartItems
            .map((item) => {
                  'id': item.id,
                  'title': item.title,
                  'quantity': item.quantity,
                  'price': item.price,
                })
            .toList(),
      }),
    );

    final data = json.decode(response.body);

    _orders.insert(
      0,
      OrderItem(
        id: data['name'],
        amount: total,
        items: cartItems,
        date: dateTime,
      ),
    );
    notifyListeners();
  }
}

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> items;
  final DateTime date;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.items,
    @required this.date,
  });
}
