import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_view.dart';
import '../widgets/product_overview_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/side_drawer.dart';
import '../providers/products.dart';

class ProductOverview extends StatefulWidget {
  static const ROUTE = '/product-overview';

  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _showFavs = false;
  var _isLoading = false;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.FAVORITES) {
                  _showFavs = true;
                } else {
                  _showFavs = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.FAVORITES,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.ALL,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartView.ROUTE);
              },
            ),
          )
        ],
      ),
      drawer: SideDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductOverviewGrid(_showFavs),
    );
  }
}

enum FilterOptions { FAVORITES, ALL }
