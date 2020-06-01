import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class ProductDetail extends StatelessWidget {
  static const ROUTE = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments;
    final Product product = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(product.title),
            SizedBox(
              height: 8,
            ),
            Text(product.description),
            SizedBox(
              height: 8,
            ),
            Text('\$${product.price}'),
          ],
        ),
      ),
    );
  }
}
