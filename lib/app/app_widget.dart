import 'package:flutter/material.dart';
import 'package:flutter_store/app/utils/app_routes.dart';
import 'package:flutter_store/app/utils/app_string.dart';
import 'package:flutter_store/app/views/cart_page.dart';
import 'package:flutter_store/app/views/orders_page.dart';
import 'package:flutter_store/app/views/products_page.dart';
import 'package:flutter_store/app/views/auth_home_page.dart';
import 'package:flutter_store/app/views/product_form_page.dart';
import 'package:flutter_store/app/views/product_detail_page.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
      fontFamily: 'Lato',
    );
    return MaterialApp(
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
    );
  }
}
