import 'package:flutter/material.dart';

class SmallBtn extends StatelessWidget {
  const SmallBtn({super.key, required this.child, required this.onPressed});

  final Widget child;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    // theme
    var primaryColor = Theme.of(context).primaryColor;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 9.0),
          backgroundColor: primaryColor,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          )),
      onPressed: onPressed,
      child: child,
    );
  }
}
