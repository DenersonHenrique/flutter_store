import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/providers/auth.dart';
import 'package:flutter_store/views/auth_page.dart';
import 'package:flutter_store/views/products_overview_page.dart';

class AuthHomePage extends StatelessWidget {
  const AuthHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuth ? ProductOverviewPage() : AuthPage();
  }
}
