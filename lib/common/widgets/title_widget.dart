import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // get device size
    var width = MediaQuery.of(context).size.width;
    // theme
    // var primaryColor = Theme.of(context).primaryColor;
    var cardColor = Theme.of(context).cardColor;
    var textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 15.0,
              color: Colors.grey.shade200,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10.0),
            Text(
              title,
              style: textTheme.titleMedium,
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20.0,
              color: Colors.grey.shade800,
            ),
          ],
        ),
      ),
    );
  }
}
