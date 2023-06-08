// ignore_for_file: unnecessary_null_comparison, deprecated_member_use, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_online/common/bloc/user_info_cubit/change_username_cubit.dart';
import 'package:quiz_online/common/bloc/user_info_cubit/changle_profile_image_cubit.dart';
import 'package:quiz_online/common/widgets/bottom_nav.dart';
import 'package:quiz_online/common/widgets/custom_appbar.dart';
import 'package:quiz_online/common/widgets/title_widget.dart';
import 'package:quiz_online/features/feature_home/presentation/widgets/property_box.dart';
import 'package:quiz_online/features/feature_profile/data/models/quiz_model.dart';
import 'package:quiz_online/features/feature_profile/presentation/bloc/quiz_list_length/quiz_list_length_cubit.dart';
import 'package:quiz_online/features/feature_profile/presentation/screens/settings_screen.dart';
import 'package:quiz_online/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  static const String routeName = '/profile_screen';

  final PageController pageController = PageController();
  static List<QuizModel> quizeList = [];

  @override
  Widget build(BuildContext context) {
    // get divice size
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    // theme
    var primaryColor = Theme.of(context).primaryColor;
    var secondaryHeaderColor = Theme.of(context).secondaryHeaderColor;
    var cardColor = Theme.of(context).cardColor;
    var textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => QuizListLengthCubit(),
      child: Builder(builder: (context) {
        // call quiz list length
        BlocProvider.of<QuizListLengthCubit>(context).callQuizListLengthEvent();

        SharedPreferences sharedPreferences = locator<SharedPreferences>();

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: width,
                child: Column(
                  children: [
                    // appbar
                    CustomAppbar(
                      width: width,
                      secondaryHeaderColor: secondaryHeaderColor,
                      textTheme: textTheme,
                      title: 'حساب کاربری',
                      iconData: Icons.settings,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          SettingsScreen.routeName,
                        );
                      },
                    ),
                    const SizedBox(height: 35.0),

                    // image profile
                    Container(
                      width: 100.0,
                      height: 100.0,
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: BlocBuilder<ChangeProfileImageCubit, String>(
                          builder: (context, state) {
                            if (sharedPreferences.getString('imagePath') !=
                                null) {
                              return Image.file(
                                  File(sharedPreferences
                                      .getString('imagePath')!),
                                  fit: BoxFit.cover);
                            } else {
                              return SvgPicture.asset(
                                'assets/images/profile.svg',
                                fit: BoxFit.cover,
                                color: Colors.grey.shade400,
                              );
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 15.0),

                    BlocBuilder<ChangeUsernameCubit, String>(
                      builder: (context, state) {
                        if (state != null) {
                          return Text(
                            sharedPreferences.getString('username')!,
                            style: textTheme.labelLarge,
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),

                    const SizedBox(height: 30.0),

                    const TitleWidget(title: 'آزمون های ثبت شده'),

                    const SizedBox(height: 20.0),

                    BlocBuilder<QuizListLengthCubit, int>(
                      builder: (context, state) {
                        if (state == 0) {
                          return Column(
                            children: [
                              SizedBox(height: height * 0.08),
                              SvgPicture.asset(
                                'assets/images/empty_list.svg',
                                width: 170.0,
                                height: 170.0,
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                'شما تا کنون آزمونی ثبت نکرده اید!',
                                style: textTheme.labelMedium,
                              ),
                            ],
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: List.generate(
                                quizeList.length,
                                (index) {
                                  return GestureDetector(
                                    onLongPress: () async {
                                      await Hive.box<QuizModel>('quizBox')
                                          .deleteAt(index);

                                      BlocProvider.of<QuizListLengthCubit>(
                                              context)
                                          .callQuizListLengthEvent();
                                    },
                                    child: Container(
                                      width: width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 20.0),
                                      margin:
                                          const EdgeInsets.only(bottom: 10.0),
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 15.0,
                                            color: Colors.grey.shade200,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.edit_note_rounded,
                                                color: primaryColor,
                                                size: 28.0,
                                              ),
                                              const SizedBox(width: 15.0),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    quizeList[index].title!,
                                                    style:
                                                        textTheme.titleMedium,
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  Text(
                                                    '${quizeList[index].date}',
                                                    style: const TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              PropertyBox(
                                                  height: height,
                                                  title: 'داخلی'),
                                              const SizedBox(width: 5.0),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNav(controller: pageController),
        );
      }),
    );
  }
}
