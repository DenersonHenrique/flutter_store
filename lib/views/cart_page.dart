import 'package:flutter/material.dart';
import 'package:flutter_store/providers/cart.dart';
import 'package:flutter_store/providers/orders.dart';
import 'package:flutter_store/widgets/cart_item_widget.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cartProvider = Provider.of(context);
    final cartItems = cartProvider.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Chip(
                    label: Text(
                      'R\$${cartProvider.totalAmount}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  OrderButtonWidget(cartProvider: cartProvider)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
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
  const OrderButtonWidget({
    Key key,
    @required this.cartProvider,
  }) : super(key: key);

  final Cart cartProvider;

  @override
  _OrderButtonWidgetState createState() => _OrderButtonWidgetState();
}

class _OrderButtonWidgetState extends State<OrderButtonWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cartProvider.totalAmount == 0
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              await Provider.of<Orders>(context, listen: false)
                  .addOrder(widget.cartProvider);

              setState(() {
                _isLoading = false;
              });

              widget.cartProvider.clear();
            },
      child: _isLoading ? CircularProgressIndicator() : Text('COMPRAR'),
    );
  }
}
