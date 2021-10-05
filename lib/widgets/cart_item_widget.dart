import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/utils/app_string.dart';
import 'package:flutter_store/models/cart_item_model.dart';
import 'package:flutter_store/providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;

  const CartItemWidget(this.cartItem);

  @override
  Widget build(BuildContext context) => Dismissible(
        confirmDismiss: (_) {
          return showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppString.alertTitleConfirmDelete),
              content: Text(AppString.alertTextRemoveItemCart),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(AppString.alertActionLabelCancel),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(AppString.alertActionLabelConfirm),
                ),
              ],
            ),
          );
        },
        onDismissed: (_) {
          Provider.of<CartProvider>(context, listen: false).removeItem(
            cartItem.productId,
          );
        },
        background: Container(
          color: Theme.of(context).colorScheme.onError,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40.0,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 4.0,
          ),
        ),
        key: ValueKey(cartItem.id),
        direction: DismissDirection.endToStart,
        child: Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 4.0,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      '${cartItem.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6?.color,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(cartItem.name),
              subtitle: Text(
                '${AppString.labelTotal}: R\$ ${cartItem.price.toStringAsFixed(2) * cartItem.quantity}',
              ),
              trailing: Text('${cartItem.quantity}x'),
            ),
          ),
        ),
      );
}
