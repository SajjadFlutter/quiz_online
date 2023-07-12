import 'package:flutter/material.dart';

class CustomDialog2 extends StatelessWidget {
  const CustomDialog2({
    super.key,
    required this.textTheme,
    required this.primaryColor,
    required this.title,
    required this.action,
  });

  final TextTheme textTheme;
  final Color primaryColor;
  final String title;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text(
        title,
        style: textTheme.titleMedium,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'لغو',
            style: TextStyle(color: primaryColor, fontSize: 12.0),
          ),
        ),
        TextButton(
          onPressed: action,
          child: Text(
            'تایید',
            style: TextStyle(color: primaryColor, fontSize: 12.0),
          ),
        ),
      ],
    );
  }
}
