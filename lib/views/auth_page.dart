import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_store/utils/app_string.dart';
import 'package:flutter_store/widgets/auth_form_card.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(215, 117, 255, 0.5),
                    Color.fromRGBO(255, 188, 177, 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 70.0,
                        ),
                        transform: Matrix4.rotationZ(-8 * pi / 180.0)
                          ..translate(-10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.deepOrange.shade900,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8.0,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          AppString.appTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45.0,
                            fontFamily: 'Anton',
                          ),
                        ),
                      ),
                      AuthCardWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
