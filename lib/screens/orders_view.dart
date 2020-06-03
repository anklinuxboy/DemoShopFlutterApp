import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/orders_view_item.dart';
import '../widgets/side_drawer.dart';

class OrdersView extends StatefulWidget {
  static const ROUTE = '/orders';

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
        (_) => Provider.of<Orders>(context, listen: false).fetchAndSetOrders());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: SideDrawer(),
      body: ListView.builder(
        itemBuilder: (_, index) => OrdersViewItem(item: orders[index]),
        itemCount: orders.length,
      ),
    );
  }
}
