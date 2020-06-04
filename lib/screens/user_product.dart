import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/side_drawer.dart';
import '../screens/manage_product.dart';

class UserProduct extends StatelessWidget {
  static const ROUTE = '/user-product';

  Future<void> _refreshProducts(BuildContext ctx) async {
    try {
      await Provider.of<Products>(ctx, listen: false).fetchAndSetProducts(true);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, data) => data.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (ctx, products, _) => Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemBuilder: (_, index) => Column(
                        children: <Widget>[
                          UserProductItem(
                            product: products.items[index],
                          ),
                          Divider(),
                        ],
                      ),
                      itemCount: products.items.length,
                    ),
                  ),
                ),
              ),
      ),
      drawer: SideDrawer(),
    );
  }
}
