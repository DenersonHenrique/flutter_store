import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/views/auth_page.dart';
import 'package:flutter_store/utils/app_string.dart';
import 'package:flutter_store/providers/auth_provider.dart';
import 'package:flutter_store/views/products_overview_page.dart';

class AuthHomePage extends StatelessWidget {
  const AuthHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.autoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(
            child: Text(
              AppString.titleAlertError,
            ),
          );
        } else {
          return auth.isAuth ? ProductOverviewPage() : AuthPage();
        }
      },
    );
  }
}
