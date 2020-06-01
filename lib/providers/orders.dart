import 'package:flutter/foundation.dart';

import 'cart.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        items: cartItems,
        date: DateTime.now(),
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
