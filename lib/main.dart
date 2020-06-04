import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart.dart';
import 'screens/cart_view.dart';
import 'screens/product_detail.dart';
import 'screens/product_overview.dart';
import 'providers/products.dart';
import 'providers/orders.dart';
import 'screens/orders_view.dart';
import 'screens/user_product.dart';
import 'screens/manage_product.dart';
import 'screens/auth_screen.dart';
import 'providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, prevProd) => Products(
            auth.token,
            auth.userId,
            prevProd == null ? [] : prevProd.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, auth, orders) => Orders(
            auth.token,
            auth.userId,
            orders == null ? [] : orders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: authData != null && authData.isAuth
              ? ProductOverview()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : AuthScreen(),
                ),
          routes: {
            ProductDetail.ROUTE: (_) => ProductDetail(),
            CartView.ROUTE: (_) => CartView(),
            OrdersView.ROUTE: (_) => OrdersView(),
            UserProduct.ROUTE: (_) => UserProduct(),
            ManageProduct.ROUTE: (_) => ManageProduct(),
          },
        ),
      ),
    );
  }
}
