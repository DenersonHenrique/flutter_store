import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  BadgeWidget({
    required this.child,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          child,
          Positioned(
            right: 8.0,
            top: 8.0,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: color ?? Theme.of(context).colorScheme.secondary,
              ),
              constraints: BoxConstraints(
                minHeight: 16.0,
                minWidth: 16.0,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.0,
                ),
              ),
            ),
          ),
        ],
      );
}
