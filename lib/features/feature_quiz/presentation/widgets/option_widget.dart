import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // required this.answersList,
    // required this.correctAnswersList,
    // required this.wrongAnswersList,
  });

  final QuestionModel questionModel;
  final double width;
  final int index;
  final int optionIndex;
  final List<String> optionsList;
  // final List<String> answersList;
  // final List<String> correctAnswersList;
  // final List<String> wrongAnswersList;

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
        width: width / 5.5,
        height: 40.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              questionModel.results![index].answer == optionsList[optionIndex]
                  ? primaryColor
                  : primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          optionsList[optionIndex],
          style: TextStyle(
            fontFamily: 'yekan',
            fontSize: 18.0,
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
