// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:quiz_online/features/feature_profile/data/models/quiz_model.dart';
import 'package:quiz_online/features/feature_quiz/data/models/question_model.dart';
import 'package:quiz_online/features/feature_quiz/presentation/bloc/quiz_cubit/quiz_cubit.dart';
import 'package:quiz_online/features/feature_quiz/presentation/bloc/select_option_cubit/change_option_index_cubit.dart';
import 'package:quiz_online/features/feature_quiz/presentation/screens/result_screen.dart';
import 'package:quiz_online/features/feature_quiz/presentation/widgets/option_widget.dart';
import 'package:quiz_online/features/feature_quiz/presentation/widgets/quiz_title_widget.dart';
import 'package:quiz_online/features/feature_quiz/repository/quiz_repository.dart';
import 'package:quiz_online/locator.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  static const String routeName = '/quiz_screen';
  static String quizTitle = '';
  static String categoryTitle = '';

  static List<String> quizPercentages = [];

  // lessons list
  static List<String> lossonsList = [];

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // options
  List<String> optionsList = ['4', '3', '2', '1'];

  @override
  Widget build(BuildContext context) {
    // get divice size
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    // theme
    var primaryColor = Theme.of(context).primaryColor;
    var cardColor = Theme.of(context).cardColor;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.edit_note_rounded, color: primaryColor, size: 28.0),
            const SizedBox(width: 10.0),
            QuizTitleWidget(textTheme: textTheme),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => QuizCubit(locator<QuizRepository>()),
          ),
          BlocProvider(create: (context) => ChangeOptionIndexCubit()),
        ],
        child: Builder(builder: (context) {
          // call api
          BlocProvider.of<QuizCubit>(context).callQuizDataEvent();

          return BlocBuilder<QuizCubit, QuizState>(
            buildWhen: (previous, current) {
              if (previous.quizDataStatus == current.quizDataStatus) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              // Loading
              if (state.quizDataStatus is QuizDataLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: primaryColor,
                        strokeWidth: 3.0,
                      ),
                      const SizedBox(height: 25.0),
                      Text(
                        'در حال دریافت اطلاعات ...',
                        style: textTheme.labelMedium,
                      ),
                    ],
                  ),
                );
              }
              // Completed
              if (state.quizDataStatus is QuizDataCompleted) {
                QuizDataCompleted quizDataCompleted =
                    state.quizDataStatus as QuizDataCompleted;
                QuestionModel questionModel = quizDataCompleted.questionModel;

                return Scaffold(
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 10.0),
                        Column(
                          children: List.generate(
                            questionModel.results!.length,
                            (index) {
                              return Container(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 30.0,
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 3.0),
                                width: width,
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 15.0,
                                      color: Colors.grey.shade200,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20.0),
                                    // question
                                    CachedNetworkImage(
                                      imageUrl: questionModel
                                          .results![index].imageQuestion!.url
                                          .toString(),
                                      placeholder: (context, url) {
                                        return const CircularProgressIndicator(
                                          strokeWidth: 3.0,
                                        );
                                      },
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.fill,
                                      useOldImageOnUrlChange: true,
                                    ),

                                    const SizedBox(height: 15.0),

                                    // options
                                    BlocBuilder<ChangeOptionIndexCubit, int>(
                                      builder: (context, state) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Column(
                                            children: [
                                              // حالت هیچدام
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 10.0),
                                                    child: Text(
                                                      'هیچکدام',
                                                      style:
                                                          textTheme.labelMedium,
                                                    ),
                                                  ),
                                                  Switch(
                                                    activeColor: primaryColor,
                                                    value: questionModel
                                                                .results![index]
                                                                .answer ==
                                                            'هیچکدام'
                                                        ? true
                                                        : false,
                                                    onChanged: (value) {
                                                      questionModel
                                                          .results![index]
                                                          .answer = 'هیچکدام';

                                                      BlocProvider.of<
                                                                  ChangeOptionIndexCubit>(
                                                              context)
                                                          .changeOptionIndexEvent(
                                                              -1);
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12.0),
                                              // options
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: List.generate(
                                                  optionsList.length,
                                                  (optionIndex) {
                                                    return OptionWidget(
                                                      questionModel:
                                                          questionModel,
                                                      width: width,
                                                      index: index,
                                                      optionIndex: optionIndex,
                                                      optionsList: optionsList,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 200.0),
                      ],
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.startFloat,
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: primaryColor,
                    elevation: 0.0,
                    child: const Icon(Icons.done_rounded),
                    onPressed: () async {
                      // var correctAnswersList = [];
                      // for (var i = 0; i < questionModel.results!.length; i++) {
                      //   correctAnswersList
                      //       .add(questionModel.results![i].correctAnswer);
                      // }

                      QuizScreen.quizPercentages.clear();

                      if (QuizScreen.categoryTitle == 'علوم انسانی') {
                        percentCalculator(questionModel, 0, 1);
                        percentCalculator(questionModel, 1, 2);
                        percentCalculator(questionModel, 2, 3);
                        percentCalculator(questionModel, 3, 4);
                        percentCalculator(questionModel, 4, 5);
                        percentCalculator(questionModel, 5, 6);
                        percentCalculator(questionModel, 6, 7);
                        percentCalculator(questionModel, 7, 8);
                        percentCalculator(questionModel, 8, 9);
                      }

                      // add quiz to database for profile screen
                      await Hive.box<QuizModel>('quizBox').add(
                        QuizModel(
                          title: QuizScreen.quizTitle,
                          date: DateTime.now().toPersianDateStr(strMonth: true),
                        ),
                      );

                      // go to Result Screen
                      Navigator.pushReplacementNamed(
                          context, ResultScreen.routeName);
                    },
                  ),
                );
              }
              // Error
              if (state.quizDataStatus is QuizDataError) {
                final QuizDataError quizDataError =
                    state.quizDataStatus as QuizDataError;

                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        color: primaryColor,
                        size: 70.0,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        quizDataError.errorMessage,
                        style: textTheme.labelMedium,
                      ),
                      const SizedBox(height: 15.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            backgroundColor: primaryColor,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            )),
                        child: const Text(
                          'تلاش مجدد',
                          style: TextStyle(
                            fontFamily: 'iransans',
                            fontSize: 12.0,
                          ),
                        ),
                        onPressed: () {
                          // call api
                          BlocProvider.of<QuizCubit>(context)
                              .callQuizDataEvent();
                        },
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          );
        }),
      ),
    );
  }

  percentCalculator(QuestionModel questionModel, int start, int end) {
    List lessonQuestions = [];
    // answers
    // List<String> answersList = [];
    List<String> correctAnswersList = [];
    List<String> wrongAnswersList = [];

    double percent = 0;

    lessonQuestions = questionModel.results!.sublist(start, end);

    for (var i = 0; i < lessonQuestions.length; i++) {
      if (lessonQuestions[i].answer != 'هیچکدام') {
        if (lessonQuestions[i].answer == lessonQuestions[i].correctAnswer) {
          correctAnswersList.add(lessonQuestions[i].answer);
        } else {
          wrongAnswersList.add(lessonQuestions[i].answer);
        }
      }
    }

    percent = ((((correctAnswersList.length * 3) - wrongAnswersList.length) /
            (lessonQuestions.length * 3)) *
        100);

    // QuizScreen.quizPercentages.clear();

    if (percent % 10 == 0) {
      QuizScreen.quizPercentages.add(percent.toStringAsFixed(0));
    } else {
      QuizScreen.quizPercentages.add(percent.toStringAsFixed(1));
    }

    // print(correctAnswersList);
    // print(wrongAnswersList);
    // print('---------------');
  }
}
