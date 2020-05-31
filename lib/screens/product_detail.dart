import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetail extends StatelessWidget {
  static const ROUTE = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
