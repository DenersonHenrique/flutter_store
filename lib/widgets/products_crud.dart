import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/utils/app_string.dart';
import 'package:flutter_store/utils/app_routes.dart';
import 'package:flutter_store/providers/products.dart';
import 'package:flutter_store/models/product_model.dart';
// import 'package:flutter_store/exceptions/http_exception.dart';

class ProductCrud extends StatelessWidget {
  final ProductModel productModel;

  ProductCrud(this.productModel);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading:
          CircleAvatar(backgroundImage: NetworkImage(productModel.imageUrl)),
      title: Text(productModel.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: productModel,
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(AppString.alertTitleConfirmDelete),
                    content: Text("Remover \'${productModel.title}'?"),
                    actions: <Widget>[
                      TextButton(
                        child: Text(AppString.alertActionLabelConfirm),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                      TextButton(
                        child: Text(AppString.alertActionLabelCancel),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                    ],
                  ),
                ).then(
                  (value) async {
                    if (value) {
                      try {
                        await Provider.of<ProductsProvider>(
                          context,
                          listen: false,
                        ).deleteProduct(
                          productModel.id,
                        );
                      } catch (error) {
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(
                              AppString.snackBarTextDeleteProdcutError,
                            ),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
