import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store/models/order_model.dart';

class OrderWidget extends StatefulWidget {
  final OrderModel order;

  OrderWidget(this.order);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              title: Text('R\$ ${widget.order.total}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
              ),
              trailing: IconButton(
                icon: Icon(Icons.expand_more),
                onPressed: () {
                  setState(() => _expanded = !_expanded);
                },
              ),
            ),
            if (_expanded)
              Container(
                height: (widget.order.products.length * 30.0) + 10.0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 4.0,
                ),
                child: ListView(
                  children: widget.order.products.map(
                    (product) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${product.quantity} X R\$ ${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
          ],
        ),
      );
}
