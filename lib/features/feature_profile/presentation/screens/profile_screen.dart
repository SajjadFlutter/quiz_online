// ignore_for_file: unnecessary_null_comparison, deprecated_member_use, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:quiz_online/common/bloc/user_info_cubit/change_username_cubit.dart';
import 'package:quiz_online/common/bloc/user_info_cubit/changle_profile_image_cubit.dart';
import 'package:quiz_online/common/bloc/visible_cubit/visible_cubit.dart';
import 'package:quiz_online/common/widgets/bottom_nav.dart';
import 'package:quiz_online/common/widgets/custom_appbar.dart';
import 'package:quiz_online/common/widgets/custom_dialog_2.dart';
import 'package:quiz_online/common/widgets/title_widget.dart';
import 'package:quiz_online/features/feature_home/presentation/screens/home_screen.dart';
import 'package:quiz_online/features/feature_home/presentation/widgets/property_box.dart';
import 'package:quiz_online/features/feature_profile/data/models/quiz_model.dart';
import 'package:quiz_online/features/feature_profile/presentation/bloc/quiz_list_length/quiz_list_length_cubit.dart';
import 'package:quiz_online/features/feature_profile/presentation/screens/settings_screen.dart';
import 'package:quiz_online/locator.dart';
import 'package:quiz_online/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsell_plus/tapsell_plus.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  static const String routeName = '/profile_screen';

  final PageController pageController = PageController();
  static List<QuizModel> quizesList = [];

  @override
  Widget build(BuildContext context) {
    MyApp.changeColor(Colors.transparent,
        Theme.of(context).scaffoldBackgroundColor, Brightness.dark);

    // تبلیغ
    if (HomeScreen.tablighResponseId == null ||
        HomeScreen.tablighIconUrl == null ||
        HomeScreen.tablighTitle == null) {
      BlocProvider.of<VisibleCubit>(context).changeStateVisible(false);
    } else {
      BlocProvider.of<VisibleCubit>(context).changeStateVisible(true);
    }

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
            child: Stack(
              children: [
                SingleChildScrollView(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  children: List.generate(
                                    quizesList.length,
                                    (index) {
                                      return GestureDetector(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (_context) =>
                                                CustomDialog2(
                                              textTheme: textTheme,
                                              primaryColor: primaryColor,
                                              title:
                                                  'آیا از حذف آن اطمینان دارید؟',
                                              action: () async {
                                                await Hive.box<QuizModel>(
                                                        'quizBox')
                                                    .deleteAt(index);

                                                BlocProvider.of<
                                                            QuizListLengthCubit>(
                                                        context)
                                                    .callQuizListLengthEvent();

                                                Navigator.pop(_context);
                                              },
                                            ),
                                          );
                                        },
                                        onTap: () {
                                          percentagesBottomSheet(
                                              context, index);
                                          // print(quizesList[3].quizPercentages);
                                          // print(quizesList[3].quizLessons);
                                        },
                                        child: Container(
                                          width: width,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 20.0),
                                          margin: const EdgeInsets.only(
                                              bottom: 10.0),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        quizesList[index]
                                                            .title!,
                                                        style: textTheme
                                                            .titleMedium,
                                                      ),
                                                      const SizedBox(
                                                          height: 5.0),
                                                      Text(
                                                        '${quizesList[index].date}',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          HomeScreen.tablighIconUrl!,
                                          width: 75.0,
                                          height: 75.0,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(HomeScreen.tablighTitle!,
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
                                              .nativeBannerAdClicked(HomeScreen
                                                  .tablighResponseId!);
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
      }),
    );
  }

  percentagesBottomSheet(
    BuildContext context,
    int index,
  ) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        // theme
        var primaryColor = Theme.of(context).primaryColor;
        var textTheme = Theme.of(context).textTheme;
        // get divice size
        // var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;

        return Container(
          height: quizesList[index].title!.contains('ریاضی')
              ? height * 0.34
              : quizesList[index].title!.contains('تجربی')
                  ? height * 0.5
                  : height * 0.8,
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
            children: [
              // title
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
                    quizesList[index].title!,
                    style: textTheme.labelLarge,
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              // perecentages
              Column(
                children: List.generate(
                  quizesList[index].quizLessons!.length,
                  (_index) {
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
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: const Icon(
                                      Icons.done_rounded,
                                      color: Colors.white,
                                      size: 14.0,
                                    ),
                                  ),
                                  const SizedBox(width: 15.0),
                                  Text(
                                    quizesList[index].quizLessons![_index],
                                    style: textTheme.labelMedium,
                                  ),
                                ],
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  '${quizesList[index].quizPercentages![_index]} %'
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
                        _index < quizesList[index].quizLessons!.length - 1
                            ? const Divider()
                            : Container(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
