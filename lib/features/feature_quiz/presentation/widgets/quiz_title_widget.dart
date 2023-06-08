import 'package:flutter/material.dart';
import 'package:quiz_online/features/feature_quiz/presentation/screens/quiz_screen.dart';

class QuizTitleWidget extends StatelessWidget {
  const QuizTitleWidget({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: QuizScreen.quizTitle,
        style: textTheme.labelLarge,
        children: <TextSpan>[
          TextSpan(text: ' (داخلی)', style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
