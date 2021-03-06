import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/utils/app_routes.dart';
import 'package:flutter_store/utils/app_string.dart';
import 'package:flutter_store/widgets/products_crud.dart';
import 'package:flutter_store/widgets/app_drawer_widget.dart';
import 'package:flutter_store/providers/products_provider.dart';

class ProductsPage extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<ProductsProvider>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = productsProvider.items;

    return Scaffold(
      drawer: AppDrawerWidget(),
      appBar: AppBar(
        title: Text(AppString.titleProducts),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: productsProvider.itemsCount,
            itemBuilder: (ctx, index) => Column(
              children: <Widget>[
                ProductCrudWidget(products[index]),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
