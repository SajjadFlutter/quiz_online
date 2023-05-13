// ignore_for_file: unused_field

import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({
    super.key,
    required this.primaryColor,
    required GlobalKey<FormState> formKey,
    required this.title,
    required this.onPressed,
  }) : _formKey = formKey;

  final Color primaryColor;
  final GlobalKey<FormState> _formKey;
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
