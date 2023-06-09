// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:quiz_online/common/widgets/title_widget.dart';
import 'package:quiz_online/features/feature_home/presentation/screens/home_screen.dart';
import 'package:quiz_online/features/feature_profile/presentation/screens/profile_screen.dart';
import 'package:quiz_online/features/feature_quiz/presentation/screens/quiz_screen.dart';
import 'package:quiz_online/features/feature_quiz/presentation/widgets/quiz_title_widget.dart';

class ResultScreen extends StatelessWidget {
  static String routeName = '/result_screen';
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get divice size
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    // theme
    var primaryColor = Theme.of(context).primaryColor;
    // var secondaryHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // appbar
              SizedBox(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 11.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 52.0,
                        height: 35.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          'نتیجه آزمون',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(
                        width: 52.0,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15.0),

              // result animation
              Container(
                width: 130.0,
                height: 130.0,
                padding: const EdgeInsets.all(5.0),
                child: Lottie.asset(
                  'assets/images/result_animation.json',
                  repeat: false,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20.0),

              QuizTitleWidget(textTheme: textTheme),

              const SizedBox(height: 25.0),

              const TitleWidget(title: 'مشاهده درصد ها'),

              const SizedBox(height: 20.0),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                width: width,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5.0,
                      color: Colors.grey.shade200,
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(
                    HomeScreen.lessonsList.length,
                    (index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 20.0,
                                      height: 20.0,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: const Icon(
                                        Icons.done_rounded,
                                        color: Colors.white,
                                        size: 14.0,
                                      ),
                                    ),
                                    const SizedBox(width: 15.0),
                                    Text(
                                      HomeScreen.lessonsList[index],
                                      style: textTheme.labelMedium,
                                    ),
                                  ],
                                ),
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(
                                    '${QuizScreen.quizPercentages[index]} %'
                                        .toPersianDigit(),
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          index < HomeScreen.lessonsList.length - 1
                              ? const Divider()
                              : Container(),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30.0),

              // home button
              // Container(
              //   width: width,
              //   height: 50.0,
              //   margin: const EdgeInsets.symmetric(horizontal: 15.0),
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: primaryColor,
              //       elevation: 0.0,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15.0),
              //       ),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         SvgPicture.asset(
              //           'assets/images/home_on.svg',
              //           width: 22.0,
              //           color: Colors.white,
              //         ),
              //         const SizedBox(width: 10.0),
              //         const Text(
              //           'صفحه اصلی',
              //           style:
              //               TextStyle(fontSize: 12.0, fontFamily: 'iransans'),
              //         ),
              //       ],
              //     ),
              //     onPressed: () {
              //       Navigator.pushReplacementNamed(
              //           context, HomeScreen.routeName);
              //     },
              //   ),
              // ),

              // const SizedBox(height: 15.0),

              // profile button
              Container(
                width: width,
                height: 50.0,
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/user_on.svg',
                        width: 18.0,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        'حساب کاربری',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'iransans',
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, ProfileScreen.routeName);
                  },
                ),
              ),

              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
