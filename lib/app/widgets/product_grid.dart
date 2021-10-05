import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/app/models/product_model.dart';
import 'package:flutter_store/app/widgets/product_item.dart';
import 'package:flutter_store/app/providers/products_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  ProductGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final List<ProductModel> productsList = showFavoriteOnly
        ? Provider.of<ProductsProvider>(context).favoriteItems
        : Provider.of<ProductsProvider>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: productsList.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: productsList[index],
        child: ProductItemWidget(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
    );
  }
}
