import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:quiz_online/features/feature_quiz/data/models/question_model.dart';
import 'package:quiz_online/features/feature_quiz/presentation/bloc/select_option_cubit/change_option_index_cubit.dart';

class OptionWidget extends StatelessWidget {
  const OptionWidget({
    super.key,
    required this.questionModel,
    required this.width,
    required this.index,
    required this.optionIndex,
    required this.optionsList,
  });

  final QuestionModel questionModel;
  final double width;
  final int index;
  final int optionIndex;
  final List<String> optionsList;

  @override
  Widget build(BuildContext context) {
    // theme
    var primaryColor = Theme.of(context).primaryColor;
    // var textTheme = Theme.of(context).textTheme;

    var questions = questionModel.results;

    return GestureDetector(
      onTap: () {
        // select action
        questions![index].answer = optionsList[optionIndex];

        BlocProvider.of<ChangeOptionIndexCubit>(context)
            .changeOptionIndexEvent(optionIndex);

        // lists
        // answersList.clear();
        // correctAnswersList.clear();
        // wrongAnswersList.clear();

        // for (var i = 0; i < questions.length; i++) {
        //   answersList.add(questions[i].answer);

        //   if (questions[i].answer != 'هیچکدام') {
        //     if (questions[i].answer == questions[i].correctAnswer) {
        //       correctAnswersList.add(questions[i].answer);
        //     } else {
        //       wrongAnswersList.add(questions[i].answer);
        //     }
        //   }
        // }
      },
      child: Container(
        // margin: const EdgeInsets.all(8.0),
        width: width / 5,
        height: 45.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              questionModel.results![index].answer == optionsList[optionIndex]
                  ? primaryColor
                  : primaryColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          optionsList[optionIndex].toPersianDigit(),
          style: TextStyle(
            fontSize: 15.0,
            color:
                questionModel.results![index].answer == optionsList[optionIndex]
                    ? Colors.white
                    : primaryColor,
          ),
        ),
      ),
    );
  }
}
