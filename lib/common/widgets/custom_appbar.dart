import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.width,
    required this.secondaryHeaderColor,
    required this.textTheme,
    required this.iconData,
    required this.onPressed,
    required this.title,
  });

  final double width;
  final Color secondaryHeaderColor;
  final TextTheme textTheme;
  final String title;
  final IconData iconData;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: IconButton(
                icon: Icon(
                  iconData,
                  color: secondaryHeaderColor,
                ),
                onPressed: onPressed,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                title,
                style: textTheme.titleMedium,
              ),
            ),
            const SizedBox(
              width: 52.0,
            ),
          ],
        ),
      ),
    );
  }
}
