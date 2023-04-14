import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_online/common/widgets/title_widget.dart';
import 'package:quiz_online/features/feature_home/presentation/screens/home_screen.dart';
import 'package:quiz_online/features/feature_home/presentation/widgets/property_box.dart';
import 'package:quiz_online/features/feature_quiz/presentation/screens/quiz_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile_screen';

  static List<Widget> quizesList = [];

  @override
  Widget build(BuildContext context) {
    // get divice size
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    // theme
    var primaryColor = Theme.of(context).primaryColor;
    var cardColor = Theme.of(context).cardColor;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'حساب کاربری',
          style: textTheme.titleMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SizedBox(
        width: width,
        child: Column(
          children: [
            const SizedBox(height: 30.0),

            // image profile
            Container(
              width: 105.0,
              height: 105.0,
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

            const SizedBox(height: 30.0),

            quizesList.isEmpty
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: List.generate(
                        quizesList.length,
                        (index) {
                          return Container(
                            width: width,
                            padding: const EdgeInsets.symmetric(
                              vertical: 18.0,
                              horizontal: 15.0,
                            ),
                            margin: const EdgeInsets.only(bottom: 15.0),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        RichText(
                                          text: TextSpan(
                                            text: QuizScreen.quizTitle,
                                            style: textTheme.titleMedium,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: ' ${HomeScreen.quizYear}',
                                                style: TextStyle(
                                                  fontFamily: 'yekan',
                                                  color: Colors.grey.shade800,
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              // TextSpan(
                                              //   text: ' (داخلی)',
                                              //   style: textTheme.bodyMedium,
                                              // ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                        const Text(
                                          'روز جمعه در تاریخ 1402/02/22',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    PropertyBox(height: height, title: 'داخلی'),
                                    const SizedBox(width: 5.0),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
