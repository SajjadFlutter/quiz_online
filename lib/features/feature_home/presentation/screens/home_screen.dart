// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:quiz_online/common/bloc/user_info_cubit/changle_profile_image_cubit.dart';
import 'package:quiz_online/common/widgets/bottom_nav.dart';
import 'package:quiz_online/common/widgets/title_widget.dart';
import 'package:quiz_online/features/feature_home/presentation/bloc/cubits/quiz_type_cubit.dart';
import 'package:quiz_online/features/feature_home/presentation/bloc/cubits/quiz_year_cubit.dart';
import 'package:quiz_online/common/bloc/visible_cubit/visible_cubit.dart';
import 'package:quiz_online/features/feature_home/presentation/widgets/category_box.dart';
import 'package:quiz_online/features/feature_quiz/data/data_source/remote/quiz_api_provider.dart';
import 'package:quiz_online/features/feature_quiz/presentation/screens/quiz_screen.dart';
import 'package:quiz_online/locator.dart';
import 'package:quiz_online/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsell_plus/tapsell_plus.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home_screen';
  final PageController pageController = PageController();

  HomeScreen({super.key});

  final List<int> konkurYears = [1401, 1400, 1399];

  static String quizType = 'داخلی';
  static int quizYear = 1401;
  // lessons list
  static List<String> lessonsList = [];

  // categories
  static List<String> categoryList = ['ریاضی', 'علوم تجربی', 'علوم انسانی'];

  // تبلیغ
  static String? tablighResponseId;
  static String? tablighIconUrl;
  static String? tablighTitle;

  static bool isVisibleTabligh = true;

  @override
  Widget build(BuildContext context) {
    MyApp.changeColor(Colors.transparent,
        Theme.of(context).scaffoldBackgroundColor, Brightness.dark);

    // تبلیغ
    if (tablighResponseId == null ||
        tablighIconUrl == null ||
        tablighTitle == null) {
      BlocProvider.of<VisibleCubit>(context).changeStateVisible(false);
    } else {
      BlocProvider.of<VisibleCubit>(context).changeStateVisible(true);
    }

    const zoneId = "648d67c6b3ead908e75fd64b";
    TapsellPlus.instance.requestNativeAd(zoneId).then((responseId) {
      // SAVE the responseId
      TapsellPlus.instance.showNativeAd(responseId, onOpened: (nativeAd) {
        // Use the NativeAd object to display an ad

        tablighResponseId = nativeAd.responseId;
        tablighIconUrl = nativeAd.iconUrl;
        tablighTitle = nativeAd.title;
      }, onError: (errorPayload) {
        // Error when getting ad info
      });
    }).catchError((error) {
      // Error requesting for an ad
    });

    int defualtIndex = 0;

    // get divice size
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    // theme
    var primaryColor = Theme.of(context).primaryColor;
    var cardColor = Theme.of(context).cardColor;
    var textTheme = Theme.of(context).textTheme;

    return Builder(builder: (context) {
      SharedPreferences sharedPreferences = locator<SharedPreferences>();

      sharedPreferences.getString('imagePath') != null
          ? BlocProvider.of<ChangeProfileImageCubit>(context)
              .changeUserInfoEvent(sharedPreferences.getString('imagePath')!)
          : null;

      return Scaffold(
        extendBody: true,
        body: SafeArea(
          child: Stack(
            children: [
              // home screen widgets
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 46.0,
                                height: 46.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: BlocBuilder<ChangeProfileImageCubit,
                                      String>(
                                    builder: (context, state) {
                                      if (state ==
                                          'assets/images/profile.svg') {
                                        return SvgPicture.asset(
                                          state,
                                          fit: BoxFit.cover,
                                          color: Colors.grey.shade400,
                                        );
                                      } else {
                                        return Image.file(File(state),
                                            fit: BoxFit.cover);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'سلام ${sharedPreferences.getString('username')}',
                                        style: textTheme.titleMedium,
                                      ),
                                      const SizedBox(width: 6.0),
                                      Image.asset(
                                        'assets/images/hand_emoji.png',
                                        width: 17.0,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 1.0),
                                  Text(
                                    'روز خوبی داشته باشی',
                                    style: textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(11.0),
                            ),
                            child: Text(
                              DateTime.now().toPersianDateStr(strMonth: true),
                              style: TextStyle(
                                color: primaryColor,
                                fontFamily: 'iransans',
                                fontSize: 10.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20.0),

                    const TitleWidget(title: 'آزمون های در دسترس'),

                    // categories
                    const SizedBox(height: 20.0),
                    CategoryBox(
                      height: height,
                      image: 'assets/images/riyazi.svg',
                      title: 'ریاضی',
                      onTap: () {
                        homeBottomSheet(context, height, width, defualtIndex,
                            categoryList[0]);
                      },
                    ),
                    CategoryBox(
                      height: height,
                      image: 'assets/images/tajrobi.svg',
                      title: 'علوم تجربی',
                      onTap: () {
                        homeBottomSheet(context, height, width, defualtIndex,
                            categoryList[1]);
                      },
                    ),
                    CategoryBox(
                      height: height,
                      image: 'assets/images/ensani.svg',
                      title: 'علوم انسانی',
                      onTap: () {
                        homeBottomSheet(context, height, width, defualtIndex,
                            categoryList[2]);
                      },
                    ),
                    const SizedBox(height: 25.0),
                  ],
                ),
              ),

              // تبلیغ
              BlocBuilder<VisibleCubit, bool>(
                builder: (context, state) {
                  if (state) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: width,
                        margin: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5.0,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        tablighIconUrl!,
                                        width: 75.0,
                                        height: 75.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(tablighTitle!,
                                        style: textTheme.titleMedium),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(width: 5.0),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        TapsellPlus.instance
                                            .nativeBannerAdClicked(
                                                tablighResponseId!);
                                      },
                                      child: const Text(
                                        'مشاهده',
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                    ),
                                    const SizedBox(width: 35.0),
                                  ],
                                ),
                              ],
                            ),

                            // close button
                            Positioned(
                              left: 0.0,
                              child: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<VisibleCubit>(context)
                                      .changeStateVisible(false);
                                },
                                child: Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Icon(Icons.close_rounded,
                                      size: 20.0, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNav(controller: pageController),
      );
    });
  }

  homeBottomSheet(
    BuildContext context,
    double height,
    double width,
    int defaultIndex,
    String categoryTitle,
  ) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        // theme
        var primaryColor = Theme.of(context).primaryColor;
        var textTheme = Theme.of(context).textTheme;

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => QuizTypeCubit()),
            BlocProvider(create: (context) => QuizYearCubit()),
          ],
          child: Container(
            height: width > 500 ? height * 0.76 : height * 0.38,
            padding: const EdgeInsets.only(
                top: 10.0, left: 20.0, bottom: 20.0, right: 20.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: 25.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    Text(
                      'انتخاب سال آزمون',
                      style: textTheme.labelLarge,
                    ),
                  ],
                ),

                // select test type
                // BlocBuilder<QuizTypeCubit, int>(
                //   builder: (context, state) {
                //     return Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Row(
                //           children: [
                //             Radio(
                //               value: 0,
                //               groupValue: state,
                //               onChanged: (value) {
                //                 BlocProvider.of<QuizTypeCubit>(context)
                //                     .changeIndexEvent(value!);
                //
                //                 quizType = 'داخلی';
                //               },
                //               activeColor: primaryColor,
                //             ),
                //             Text(
                //               'داخلی',
                //               style: textTheme.titleMedium,
                //             ),
                //           ],
                //         ),
                //         SizedBox(width: height * 0.03),
                //         Row(
                //           children: [
                //             Radio(
                //               value: 1,
                //               groupValue: state,
                //               onChanged: (value) {
                //                 BlocProvider.of<QuizTypeCubit>(context)
                //                     .changeIndexEvent(value!);
                //
                //                 quizType = 'خارجی';
                //               },
                //               activeColor: primaryColor,
                //             ),
                //             Text(
                //               'خارجی',
                //               style: textTheme.titleMedium,
                //             ),
                //           ],
                //         ),
                //       ],
                //     );
                //   },
                // ),

                // select test year
                BlocBuilder<QuizYearCubit, int>(
                  builder: (context, state) {
                    return SizedBox(
                      width: 305.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          konkurYears.length,
                          (index) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // call change index
                                    BlocProvider.of<QuizYearCubit>(context)
                                        .changeIndexEvent(index);

                                    quizYear = konkurYears[index];
                                  },
                                  child: Container(
                                    width: 90,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: index == state
                                          ? primaryColor
                                          : primaryColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'سراسری',
                                          style: TextStyle(
                                            color: index == state
                                                ? Colors.white
                                                : primaryColor,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
                                        Text(
                                          '${konkurYears[index]}'
                                              .toPersianDigit(),
                                          style: TextStyle(
                                            color: index == state
                                                ? Colors.white
                                                : primaryColor,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                index == konkurYears.length - 1
                                    ? Container()
                                    : SizedBox(width: height * 0.02),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                Column(
                  children: [
                    const SizedBox(height: 5.0),
                    SizedBox(
                      width: 305,
                      height: 50.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: const Text(
                          'شروع کن',
                          style:
                              TextStyle(fontSize: 12.0, fontFamily: 'iransans'),
                        ),
                        onPressed: () {
                          QuizScreen.categoryTitle = categoryTitle;
                          QuizScreen.quizTitle =
                              'کنکور $categoryTitle ${quizYear.toString().toPersianDigit()}';
                          // ریاضی
                          if (categoryTitle == 'ریاضی') {
                            // lessons list
                            HomeScreen.lessonsList = [
                              'ریاضیات',
                              'فیریک',
                              'شیمی',
                            ];

                            if (quizYear == 1399) {
                              QuizScreen.numberQuestions = ['50', '40', '30'];
                            } else {
                              QuizScreen.numberQuestions = ['40', '35', '30'];
                            }

                            // if (quizType == 'داخلی') {
                            switch (quizYear) {
                              case 1399:
                                QuizApiProvider.className =
                                    'Riyazi_1399_Dakheli';
                                break;
                              case 1400:
                                QuizApiProvider.className =
                                    'Riyazi_1400_Dakheli';
                                break;
                              case 1401:
                                QuizApiProvider.className =
                                    'Riyazi_1401_Dakheli';
                                break;
                              default:
                                null;
                                break;
                            }
                            // }
                          }

                          // علوم تجربی
                          if (categoryTitle == 'علوم تجربی') {
                            if (quizYear == 1399) {
                              // lessons list
                              HomeScreen.lessonsList = [
                                'ریاضی',
                                'زیست شناسی',
                                'فیریک',
                                'شیمی',
                                'زمین شناسی',
                              ];

                              QuizScreen.numberQuestions = [
                                '30',
                                '50',
                                '30',
                                '35',
                                '20'
                              ];
                            } else {
                              // lessons list
                              HomeScreen.lessonsList = [
                                'زیست شناسی',
                                'فیریک',
                                'شیمی',
                                'ریاضی',
                                'زمین شناسی',
                              ];

                              QuizScreen.numberQuestions = [
                                '45',
                                '30',
                                '35',
                                '30',
                                '15'
                              ];
                            }

                            // if (quizType == 'داخلی') {
                            switch (quizYear) {
                              case 1399:
                                QuizApiProvider.className =
                                    'Tajrobi_1399_Dakheli';
                                break;
                              case 1400:
                                QuizApiProvider.className =
                                    'Tajrobi_1400_Dakheli';
                                break;
                              case 1401:
                                QuizApiProvider.className =
                                    'Tajrobi_1401_Dakheli';
                                break;
                              default:
                                null;
                                break;
                            }
                            // }
                          }

                          // علوم انسانی
                          if (categoryTitle == 'علوم انسانی') {
                            if (quizYear == 1399) {
                              // lessons list
                              HomeScreen.lessonsList = [
                                'ریاضی',
                                'اقتصاد',
                                'زبان و ادبیات فارسی',
                                'علوم اجتماعی',
                                'زبان عربی',
                                'تاریخ',
                                'جغرافیا',
                                'فلسفه و منطق',
                                'روانشناسی',
                              ];

                              QuizScreen.numberQuestions = [
                                '20',
                                '15',
                                '30',
                                '20',
                                '20',
                                '15',
                                '15',
                                '20',
                                '20'
                              ];
                            } else {
                              // lessons list
                              HomeScreen.lessonsList = [
                                'ریاضی',
                                'زبان و ادبیات فارسی',
                                'علوم اجتماعی',
                                'روانشناسی',
                                'زبان عربی',
                                'تاریخ',
                                'جغرافیا',
                                'فلسفه و منطق',
                                'اقتصاد',
                              ];

                              QuizScreen.numberQuestions = [
                                '20',
                                '30',
                                '15',
                                '15',
                                '20',
                                '13',
                                '12',
                                '20',
                                '15'
                              ];
                            }

                            // if (quizType == 'داخلی') {
                            switch (quizYear) {
                              case 1399:
                                QuizApiProvider.className =
                                    'Ensani_1399_Dakheli';
                                break;
                              case 1400:
                                QuizApiProvider.className =
                                    'Ensani_1400_Dakheli';
                                break;
                              case 1401:
                                QuizApiProvider.className =
                                    'Ensani_1401_Dakheli';
                                break;
                              default:
                                null;
                                break;
                            }
                            // }
                          }
                          //
                          Navigator.pushReplacementNamed(
                            context,
                            QuizScreen.routeName,
                          );
                          // print(QuizScreen.quizTitle);
                          // print(QuizApiProvider.className);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
