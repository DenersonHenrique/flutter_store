import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/providers/auth.dart';
import 'package:flutter_store/utils/app_routes.dart';
import 'package:flutter_store/utils/app_string.dart';
import 'package:flutter_store/models/product_model.dart';
import 'package:flutter_store/providers/cart_provider.dart';

class ProductItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of(context, listen: false);
    final CartProvider cartProvider = Provider.of(context, listen: false);
    final ProductModel productModel = Provider.of(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: productModel,
            );

            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (ctx) => ProductDetailPage(productModel),
            // ));
          },
          child: Image.network(
            productModel.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<ProductModel>(
            builder: (ctx, productModel, _) => IconButton(
              icon: Icon(productModel.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () => productModel.toggleFavorite(
                auth.token,
                auth.userId,
              ),
            ),
          ),
          title: Text(
            productModel.name,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppString.addedProduct),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                    onPressed: () {
                      cartProvider.removeSingleItem(productModel.id);
                    },
                    label: AppString.labelUndo,
                  ),
                ),
              );
              cartProvider.addItem(productModel);
            },
          ),
        ),
      ),
    );
  }
}
