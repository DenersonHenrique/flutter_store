import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/utils/app_routes.dart';
import 'package:flutter_store/utils/app_string.dart';
import 'package:flutter_store/providers/auth_provider.dart';

class AppDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(AppString.drawerTitleUser),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(AppString.drawerLabelStore),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.AUTH_HOME,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text(AppString.drawerLabelOrders),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.ORDERS,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(AppString.drawerLabelProducts),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.PRODUCTS,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(AppString.drawerLabelLogout),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.AUTH_HOME,
              );
            },
          ),
        ],
      ),
    );
  }
}
