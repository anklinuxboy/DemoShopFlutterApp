import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders.dart';

class OrdersViewItem extends StatefulWidget {
  final OrderItem item;

  const OrdersViewItem({Key key, this.item}) : super(key: key);

  @override
  _OrdersViewItemState createState() => _OrdersViewItemState();
}

class _OrdersViewItemState extends State<OrdersViewItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.item.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY)
                  .format(widget.item.date),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min((widget.item.items.length * 20.0 + 100), 180),
              child: ListView.builder(
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(widget.item.items[index].title),
                      Text(
                          '\$${widget.item.items[index].price.toStringAsFixed(2)}'),
                      Text(widget.item.items[index].quantity.toString()),
                    ],
                  ),
                ),
                itemCount: widget.item.items.length,
              ),
            )
        ],
      ),
    );
  }
}
