import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/utils/app_string.dart';
import 'package:flutter_store/utils/app_routes.dart';

import 'package:flutter_store/views/cart_page.dart';
import 'package:flutter_store/views/orders_page.dart';
import 'package:flutter_store/views/products_page.dart';
import 'package:flutter_store/views/auth_home_page.dart';
import 'package:flutter_store/views/product_form_page.dart';
import 'package:flutter_store/views/product_detail_page.dart';

import 'package:flutter_store/providers/auth_provider.dart';
import 'package:flutter_store/providers/cart_provider.dart';
import 'package:flutter_store/providers/orders_provider.dart';
import 'package:flutter_store/providers/products_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      fontFamily: 'Lato',
    );
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
      child: MaterialApp(
        title: AppString.appTitle,
        theme: themeData.copyWith(
          colorScheme: themeData.colorScheme.copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 8.0,
              ),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.AUTH_HOME: (ctx) => AuthHomePage(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailPage(),
          AppRoutes.CART: (ctx) => CartPage(),
          AppRoutes.ORDERS: (ctx) => OrderPage(),
          AppRoutes.PRODUCTS: (ctx) => ProductsPage(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormPage(),
        },
      ),
    );
  }
}
