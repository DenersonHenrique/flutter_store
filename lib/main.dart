import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/app/app_widget.dart';
import 'package:flutter_store/app/providers/auth_provider.dart';
import 'package:flutter_store/app/providers/cart_provider.dart';
import 'package:flutter_store/app/providers/orders_provider.dart';
import 'package:flutter_store/app/providers/products_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (_) => new ProductsProvider(),
          update: (ctx, auth, previousProducts) => ProductsProvider(
            auth.token ?? '',
            auth.userId ?? '',
            previousProducts?.items ?? [],
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderProvider>(
          create: (_) => new OrderProvider(),
          update: (ctx, auth, previousOrders) => OrderProvider(
            auth.token ?? '',
            auth.userId ?? '',
            previousOrders?.items ?? [],
          ),
        ),
      ],
      child: AppWidget(),
    );
  }
}
