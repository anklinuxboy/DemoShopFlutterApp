import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart.dart';
import 'screens/cart_view.dart';
import 'screens/product_detail.dart';
import 'screens/product_overview.dart';
import 'providers/products.dart';
import 'providers/orders.dart';
import 'screens/orders_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductOverview(),
        routes: {
          ProductDetail.ROUTE: (_) => ProductDetail(),
          CartView.ROUTE: (_) => CartView(),
          OrdersView.ROUTE: (_) => OrdersView(),
        },
      ),
    );
  }
}
