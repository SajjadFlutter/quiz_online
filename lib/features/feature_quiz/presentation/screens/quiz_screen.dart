// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:quiz_online/common/widgets/custom_dialog.dart';
import 'package:quiz_online/features/feature_home/presentation/screens/home_screen.dart';
import 'package:quiz_online/features/feature_profile/data/models/quiz_model.dart';
import 'package:quiz_online/features/feature_quiz/data/models/question_model.dart';
import 'package:quiz_online/features/feature_quiz/presentation/bloc/quiz_cubit/quiz_cubit.dart';
import 'package:quiz_online/features/feature_quiz/presentation/bloc/select_option_cubit/change_option_index_cubit.dart';
import 'package:quiz_online/features/feature_quiz/presentation/bloc/show_fab_cubit/show_fab_cubit_cubit.dart';
import 'package:quiz_online/features/feature_quiz/presentation/screens/result_screen.dart';
import 'package:quiz_online/features/feature_quiz/presentation/widgets/option_widget.dart';
import 'package:quiz_online/features/feature_quiz/presentation/widgets/quiz_title_widget.dart';
import 'package:quiz_online/features/feature_quiz/repository/quiz_repository.dart';
import 'package:quiz_online/locator.dart';
import 'package:quiz_online/main.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  static const String routeName = '/quiz_screen';
  static String quizTitle = '';
  static String categoryTitle = '';

  static List<String> numberQuestions = [];

  static List<String> quizPercentages = [];

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void dispose() {
    super.dispose();
    // تغییر جهت گوشی به حالت عمودی
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

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

    if (width < 500) {
      // تغییر جهت گوشی به حالت افقی
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    MyApp.changeColor(Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).scaffoldBackgroundColor, Brightness.dark);

    return WillPopScope(
      onWillPop: () async {
        // MyApp.changeColor(
        //     Colors.transparent, Colors.transparent, Brightness.dark);

        showDialog(
          useSafeArea: false,
          context: context,
          builder: (context) {
            // theme
            var primaryColor = Theme.of(context).primaryColor;
            var textTheme = Theme.of(context).textTheme;

            return CustomDialog(
              textTheme: textTheme,
              primaryColor: primaryColor,
              title: 'آیا می خواهید از این آزمون خارج شوید؟',
              subTitle:
                  'توجه : در صورت خارج شدن از صفحه و نزدن دکمه تایید، این آزمون برای شما ثبت نخواهد شد!',
              action: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomeScreen.routeName,
                  ModalRoute.withName('/home_screen'),
                );
              },
            );
          },
        );
        return false;
      },
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // appbar
            SliverAppBar(
              floating: true,
              snap: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit_note_rounded,
                          color: primaryColor, size: 28.0),
                      const SizedBox(width: 10.0),
                      QuizTitleWidget(textTheme: textTheme),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color: Colors.grey.shade800,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            title: QuizTitleWidget(textTheme: textTheme),
                            content: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  HomeScreen.lessonsList.length,
                                  (index) {
                                    print(HomeScreen.lessonsList.length);
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 20.0,
                                                    height: 20.0,
                                                    decoration: BoxDecoration(
                                                      color: primaryColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                    child: const Icon(
                                                      Icons.done_rounded,
                                                      color: Colors.white,
                                                      size: 14.0,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15.0),
                                                  Text(
                                                    HomeScreen
                                                        .lessonsList[index],
                                                    style:
                                                        textTheme.labelMedium,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '${QuizScreen.numberQuestions[index].toPersianDigit()} سوال',
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        index <
                                                HomeScreen.lessonsList.length -
                                                    1
                                            ? const Divider()
                                            : Container(),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'تایید',
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 12.0),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0.0,
              automaticallyImplyLeading: false,
            )
          ],
          body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => QuizCubit(locator<QuizRepository>()),
              ),
              BlocProvider(create: (context) => ChangeOptionIndexCubit()),
              BlocProvider(create: (context) => ShowFabCubit()),
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
                          const SizedBox(height: 60.0),
                        ],
                      ),
                    );
                  }
                  // Completed
                  if (state.quizDataStatus is QuizDataCompleted) {
                    QuizDataCompleted quizDataCompleted =
                        state.quizDataStatus as QuizDataCompleted;
                    QuestionModel questionModel =
                        quizDataCompleted.questionModel;

                    return Scaffold(
                      body: NotificationListener<UserScrollNotification>(
                        onNotification: (notification) {
                          if (notification.direction ==
                              ScrollDirection.forward) {
                            BlocProvider.of<ShowFabCubit>(context)
                                .showFabEvent(true);
                          }
                          if (notification.direction ==
                              ScrollDirection.reverse) {
                            BlocProvider.of<ShowFabCubit>(context)
                                .showFabEvent(false);
                          }
                          return true;
                        },
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              const SizedBox(height: 10.0),
                              Column(
                                children: List.generate(
                                  questionModel.results!.length,
                                  (index) {
                                    print(questionModel.results!.length);
                                    return Container(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 30.0,
                                      ),
                                      margin: const EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        bottom: 10.0,
                                      ),
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                                                .results![index]
                                                .imageQuestion!
                                                .url
                                                .toString(),
                                            placeholder: (context, url) {
                                              return const CircularProgressIndicator(
                                                strokeWidth: 3.0,
                                              );
                                            },
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                            fit: BoxFit.fill,
                                            useOldImageOnUrlChange: true,
                                          ),

                                          const SizedBox(height: 15.0),

                                          // options
                                          BlocBuilder<ChangeOptionIndexCubit,
                                              int>(
                                            builder: (context, state) {
                                              return Column(
                                                children: [
                                                  // حالت هیچدام
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10.0),
                                                          child: Text(
                                                            'هیچکدام',
                                                            style: textTheme
                                                                .labelMedium,
                                                          ),
                                                        ),
                                                        Switch(
                                                          activeColor:
                                                              primaryColor,
                                                          value: questionModel
                                                                      .results![
                                                                          index]
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
                                                  ),
                                                  const SizedBox(height: 15.0),
                                                  // options
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: List.generate(
                                                      optionsList.length,
                                                      (optionIndex) {
                                                        return OptionWidget(
                                                          questionModel:
                                                              questionModel,
                                                          width: width,
                                                          index: index,
                                                          optionIndex:
                                                              optionIndex,
                                                          optionsList:
                                                              optionsList,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
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
                      ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.startFloat,
                      floatingActionButton: BlocBuilder<ShowFabCubit, bool>(
                        builder: (context, state) {
                          return Visibility(
                            visible: state,
                            child: DelayedWidget(
                              delayDuration: const Duration(milliseconds: 0),
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              animation: state
                                  ? DelayedAnimations.SLIDE_FROM_BOTTOM
                                  : DelayedAnimations.SLIDE_FROM_TOP,
                              child: FloatingActionButton(
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

                                  // in 1399
                                  if (HomeScreen.quizYear == 1399) {
                                    if (QuizScreen.categoryTitle == 'ریاضی') {
                                      percentCalculator(
                                          questionModel, 0, 50); // ریاضیات
                                      percentCalculator(
                                          questionModel, 50, 90); // فیزیک
                                      percentCalculator(
                                          questionModel, 90, 120); // شیمی
                                    }

                                    if (QuizScreen.categoryTitle ==
                                        'علوم تجربی') {
                                      percentCalculator(
                                          questionModel, 0, 30); // ریاضی
                                      percentCalculator(
                                          questionModel, 30, 80); // زیست شناسی
                                      percentCalculator(
                                          questionModel, 80, 110); // فیزیک
                                      percentCalculator(
                                          questionModel, 110, 145); // شیمی
                                      percentCalculator(questionModel, 145,
                                          165); // زمین شناسی
                                    }

                                    if (QuizScreen.categoryTitle ==
                                        'علوم انسانی') {
                                      percentCalculator(
                                          questionModel, 0, 20); // ریاضی
                                      percentCalculator(
                                          questionModel, 20, 35); // اقتصاد
                                      percentCalculator(questionModel, 35,
                                          65); // زبان و ادبیات فارسی
                                      percentCalculator(questionModel, 65,
                                          85); // علوم اجتماعی
                                      percentCalculator(
                                          questionModel, 85, 105); // زبان عربی
                                      percentCalculator(
                                          questionModel, 105, 120); // تاریخ
                                      percentCalculator(
                                          questionModel, 120, 135); // جغرافیا
                                      percentCalculator(questionModel, 135,
                                          155); // فلسفه و منطق
                                      percentCalculator(questionModel, 155,
                                          175); // روان شناسی
                                    }
                                  } else {
                                    if (QuizScreen.categoryTitle == 'ریاضی') {
                                      percentCalculator(
                                          questionModel, 0, 40); // ریاضیات
                                      percentCalculator(
                                          questionModel, 40, 75); // فیزیک
                                      percentCalculator(
                                          questionModel, 75, 105); // شیمی
                                    }

                                    if (QuizScreen.categoryTitle ==
                                        'علوم تجربی') {
                                      percentCalculator(
                                          questionModel, 0, 45); // زیست شناسی
                                      percentCalculator(
                                          questionModel, 45, 75); // فیزیک
                                      percentCalculator(
                                          questionModel, 75, 110); // شیمی
                                      percentCalculator(
                                          questionModel, 110, 140); // ریاضی
                                      percentCalculator(questionModel, 140,
                                          155); // زمین شناسی
                                    }

                                    if (QuizScreen.categoryTitle ==
                                        'علوم انسانی') {
                                      percentCalculator(
                                          questionModel, 0, 20); // ریاضی
                                      percentCalculator(questionModel, 20,
                                          50); // زبان و ادبیات فارسی
                                      percentCalculator(questionModel, 50,
                                          65); // علوم اجتماعی
                                      percentCalculator(
                                          questionModel, 65, 80); // روان شناسی
                                      percentCalculator(
                                          questionModel, 80, 100); // زبان عربی
                                      percentCalculator(
                                          questionModel, 100, 113); // تاریخ
                                      percentCalculator(
                                          questionModel, 113, 125); // جغرافیا
                                      percentCalculator(questionModel, 125,
                                          145); // فلسفه و منطق
                                      percentCalculator(
                                          questionModel, 145, 160); // اقتصاد
                                    }
                                  }

                                  // add quiz to database for profile screen
                                  await Hive.box<QuizModel>('quizBox').add(
                                    QuizModel(
                                      title: QuizScreen.quizTitle,
                                      date: DateTime.now()
                                          .toPersianDateStr(strMonth: true),
                                      quizLessons: HomeScreen.lessonsList,
                                      quizPercentages:
                                          QuizScreen.quizPercentages,
                                    ),
                                  );

                                  // go to Result Screen
                                  Navigator.pushReplacementNamed(
                                      context, ResultScreen.routeName);
                                },
                              ),
                            ),
                          );
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
        ),
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
