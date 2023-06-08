import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.textTheme,
    required this.primaryColor,
    required this.title,
    required this.subTitle,
    required this.action,
  });

  final TextTheme textTheme;
  final Color primaryColor;
  final String title;
  final String subTitle;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        title,
        style: textTheme.titleMedium,
      ),
      content: Text(
        textAlign: TextAlign.justify,
        subTitle,
        style: textTheme.labelMedium,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'لغو',
            style: TextStyle(color: primaryColor),
          ),
        ),
        TextButton(
          onPressed: action,
          child:  Text(
            'تایید',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }
}
