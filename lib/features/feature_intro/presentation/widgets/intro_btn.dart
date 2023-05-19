import 'package:flutter/material.dart';

class IntroBtn extends StatelessWidget {
  final PageController pageController;
  final String text;
  final Function() onPressed;

  const IntroBtn({
    super.key,
    required this.pageController,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // get divice size
    var width = MediaQuery.of(context).size.width;
    // theme
    var primaryColor = Theme.of(context).primaryColor;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          backgroundColor: primaryColor,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          )),
      onPressed: onPressed,
      child: SizedBox(
        width: width / 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_back_rounded),
            const SizedBox(width: 5.0),
            Text(text, style: const TextStyle(fontSize: 14.0)),
            const SizedBox(width: 10.0),
          ],
        ),
      ),
    );
  }
}
