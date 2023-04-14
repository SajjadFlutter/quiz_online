import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class QuizLoading extends StatelessWidget {
  const QuizLoading({
    super.key,
    required this.height,
    required this.width,
    required this.optionsList,
  });

  final double height;
  final double width;
  final List<String> optionsList;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Column(
              children: List.generate(
                10,
                (index) {
                  return Column(
                    children: [
                      Container(
                        width: width,
                        height: 160.0,
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          optionsList.length,
                          (optionIndex) {
                            return Container(
                              width: width / 5.5,
                              height: 40.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            );
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Divider(color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
