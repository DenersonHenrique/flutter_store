import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/app/utils/app_string.dart';
import 'package:flutter_store/app/providers/orders_provider.dart';
import 'package:flutter_store/app/widgets/app_drawer_widget.dart';
import 'package:flutter_store/app/widgets/order_item_widget.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool _isLoading = true;

  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false).loadOrders().then((_) {
      setState(() => _isLoading = false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.titleMyOrders),
      ),
      drawer: AppDrawerWidget(),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderProvider.itemsCount,
              itemBuilder: (context, index) => OrderWidget(
                orderProvider.items[index],
              ),
            ),
    );
  }
}
