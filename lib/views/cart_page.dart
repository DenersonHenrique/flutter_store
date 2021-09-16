import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/utils/app_string.dart';
import 'package:flutter_store/providers/cart_provider.dart';
import 'package:flutter_store/widgets/cart_item_widget.dart';
import 'package:flutter_store/providers/orders_provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of(context);
    final cartItems = cartProvider.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.titleCart),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 15.0,
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    AppString.labelTotal,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Chip(
                    label: Text(
                      'R\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6?.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  OrderButtonWidget(cartProvider: cartProvider)
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.itemsCount,
              itemBuilder: (context, index) => CartItemWidget(cartItems[index]),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButtonWidget extends StatefulWidget {
  final CartProvider cartProvider;

  const OrderButtonWidget({
    Key key,
    required this.cartProvider,
  }) : super(key: key);

  @override
  _OrderButtonWidgetState createState() => _OrderButtonWidgetState();
}

class _OrderButtonWidgetState extends State<OrderButtonWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) => TextButton(
        style: TextButton.styleFrom(
          textStyle: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        onPressed: widget.cartProvider.totalAmount == 0
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });

                await Provider.of<OrderProvider>(
                  context,
                  listen: false,
                ).addOrder(widget.cartProvider);

                setState(() {
                  _isLoading = false;
                });

                widget.cartProvider.clear();
              },
        child:
            _isLoading ? CircularProgressIndicator() : Text(AppString.labelBuy),
      );
}
