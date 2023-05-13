import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_online/features/feature_home/presentation/widgets/property_box.dart';

class CategoryBox extends StatelessWidget {
  const CategoryBox({
    super.key,
    required this.height,
    required this.image,
    required this.title,
    required this.onTap,
  });

  final double height;
  final String image;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    // theme
    // var primaryColor = Theme.of(context).primaryColor;
    var textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 15.0,
              color: Colors.grey.shade200,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              image,
              width: 125.0,
              height: 125.0,
            ),
            const SizedBox(width: 15.0),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'کنکور $title',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5.0),
                  Text('شامل سوالات اختصاصی کنکور',
                      style: TextStyle(color: Colors.grey.shade800)),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PropertyBox(height: height, title: 'داخلی'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
