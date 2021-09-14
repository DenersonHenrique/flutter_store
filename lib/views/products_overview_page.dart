import 'package:flutter/material.dart';
import 'package:flutter_store/utils/app_routes.dart';
import 'package:flutter_store/utils/app_string.dart';

import 'package:provider/provider.dart';
import 'package:flutter_store/providers/cart.dart';
import 'package:flutter_store/providers/products.dart';

import 'package:flutter_store/widgets/badge.dart';
import 'package:flutter_store/widgets/product_grid.dart';
import 'package:flutter_store/widgets/app_drawer_widget.dart';

enum FilterOptions { Favorite, All }

class ProductOverviewPage extends StatefulWidget {
  @override
  _ProductOverviewPageState createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductsProvider>(context, listen: false)
        .loadProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.appTitle),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite)
                  _showFavoriteOnly = true;
                else
                  _showFavoriteOnly = false;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(AppString.popUpMenuFavorite),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text(AppString.popUpMenuAll),
                value: FilterOptions.All,
              )
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
            ),
            builder: (_, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child,
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavoriteOnly),
      drawer: AppDrawerWidget(),
    );
  }
}
