import 'package:flutter/material.dart';

class PropertyBox extends StatelessWidget {
  const PropertyBox({
    super.key,
    required this.height,
    required this.title,
  });

  final double height;
  final String title;

  @override
  Widget build(BuildContext context) {
    // theme
    var primaryColor = Theme.of(context).primaryColor;
    // var textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(
        top: 5.0,
        bottom: 5.0,
        right: 6.0,
        left: 10.0,
      ),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.done_rounded,
            color: primaryColor,
            size: 20.0,
          ),
          const SizedBox(width: 3.0),
          Text(
            title,
            style: TextStyle(color: primaryColor),
          ),
        ],
      ),
    );
  }
}
