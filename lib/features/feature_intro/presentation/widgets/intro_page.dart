import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IntroPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const IntroPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    // get size device
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.15),
          // image
          Center(
            child: DelayedWidget(
              delayDuration: const Duration(milliseconds: 200),
              animationDuration: const Duration(milliseconds: 1500),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: SvgPicture.asset(image,
                  width: width * 0.6, height: width * 0.6),
            ),
          ),
          const SizedBox(height: 20),
          // title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: height * 0.03),
            child: DelayedWidget(
              delayDuration: const Duration(milliseconds: 200),
              animationDuration: const Duration(milliseconds: 1500),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          // description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: height * 0.03),
            child: DelayedWidget(
              delayDuration: const Duration(milliseconds: 200),
              animationDuration: const Duration(milliseconds: 1500),
              animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
