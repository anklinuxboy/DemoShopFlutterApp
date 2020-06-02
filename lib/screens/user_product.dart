import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/side_drawer.dart';
import '../screens/manage_product.dart';

class UserProduct extends StatelessWidget {
  static const ROUTE = '/user-product';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(ManageProduct.ROUTE);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (_, index) => Column(
            children: <Widget>[
              UserProductItem(
                product: products[index],
              ),
              Divider(),
            ],
          ),
          itemCount: products.length,
        ),
      ),
      drawer: SideDrawer(),
    );
  }
}
