// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_online/common/widgets/title_widget.dart';
import 'package:quiz_online/features/feature_home/presentation/widgets/property_box.dart';
import 'package:quiz_online/features/feature_profile/data/models/quiz_model.dart';
import 'package:quiz_online/features/feature_profile/presentation/bloc/quiz_list_length/quiz_list_length_cubit.dart';
import 'package:quiz_online/features/feature_profile/presentation/screens/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile_screen';

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

    // readDatafromDataBase();

    return BlocProvider(
      create: (context) => QuizListLengthCubit(),
      child: Builder(builder: (context) {
        // call quiz list length
        BlocProvider.of<QuizListLengthCubit>(context).callQuizListLengthEvent();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'حساب کاربری',
              style: textTheme.titleMedium,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_rounded,
                  color: secondaryHeaderColor,
                ),
              ),
              const SizedBox(width: 5.0),
            ],
            leading: IconButton(
              icon: Icon(
                Icons.settings,
                color: secondaryHeaderColor,
              ),
              onPressed: () {
                Navigator.pushNamed(context, SettingsScreen.routeName);
              },
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: width,
              child: Column(
                children: [
                  const SizedBox(height: 20.0),

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
                      child: Image.asset(
                        'assets/images/profile.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15.0),

                  Text(
                    'سجاد غلامیان',
                    style: textTheme.titleLarge,
                  ),

                  const SizedBox(height: 35.0),

                  const TitleWidget(title: 'آزمون های ثبت شده'),

                  const SizedBox(height: 20.0),

                  BlocBuilder<QuizListLengthCubit, int>(
                    builder: (context, state) {
                      if (state == 0) {
                        return Column(
                          children: [
                            SizedBox(height: height * 0.05),
                            SvgPicture.asset(
                              'assets/images/empty_quiz_list.svg',
                              width: 230.0,
                              height: 230.0,
                            ),
                            Text(
                              'شما تا کنون آزمونی ثبت نکرده اید !',
                              style: textTheme.labelMedium,
                            ),
                            const SizedBox(height: 50.0),
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
                                    margin: const EdgeInsets.only(bottom: 15.0),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(15.0),
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
                                                  style: textTheme.titleMedium,
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
                                                height: height, title: 'داخلی'),
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
        );
      }),
    );
  }

  // void readDatafromDataBase() {
  //   quizeList.clear();
  //   Hive.box<QuizModel>('quizBox').values.forEach(
  //     (value) {
  //       quizeList.add(value);
  //       // print(quizesList.length);
  //     },
  //   );
  // }
}
