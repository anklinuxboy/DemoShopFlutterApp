import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart';

class OrdersViewItem extends StatelessWidget {
  final OrderItem item;

  const OrdersViewItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${item.amount.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd MM yyyy hh:mm').format(item.date)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
