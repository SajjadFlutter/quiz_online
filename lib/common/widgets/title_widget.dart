import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // theme
    // var primaryColor = Theme.of(context).primaryColor;
    var cardColor = Theme.of(context).cardColor;
    var textTheme = Theme.of(context).textTheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          width: 200,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 5.0,
                color: Colors.grey.shade200,
              ),
            ],
          ),
          child: Text(
            title,
            style: textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
