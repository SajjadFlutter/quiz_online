import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_online/common/prefs/prefs_operator.dart';
import 'package:quiz_online/common/widgets/main_wrapper.dart';
import 'package:quiz_online/features/feature_intro/presentation/bloc/intro_cubit/intro_cubit.dart';
import 'package:quiz_online/features/feature_intro/presentation/widgets/intro_btn.dart';
import 'package:quiz_online/features/feature_intro/presentation/widgets/intro_page.dart';
import 'package:quiz_online/locator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding_screen';

  OnboardingScreen({super.key});

  final PageController pageController = PageController();

  final List<Widget> introPages = const [
    IntroPage(
      title: 'سلام رفیق!',
      description:
          'به آزمون آنلاین خوش اومدی!',
      image: "assets/images/intro_1.svg",
    ),
    IntroPage(
      title: 'داستان چیه؟',
      description: 'اینجا میتونی خودت رو با آزمون های سال های قبل کنکور آماده کنی',
      image: "assets/images/intro_2.svg",
    ),
    IntroPage(
      title: 'خب!',
      description: 'حالا که فهمیدی داستان از چه قراره وقتشه که شروع کنی\nچیزی تا موفقیت نمونده!',
      image: "assets/images/intro_3.svg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // get divice size
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    // theme
    var primaryColor = Theme.of(context).primaryColor;
    return BlocProvider(
      create: (context) => IntroCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: Stack(
            children: [
              // page view
              Directionality(
                textDirection: TextDirection.ltr,
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: pageController,
                  children: introPages,
                  onPageChanged: (page) {
                    if (page == 2) {
                      BlocProvider.of<IntroCubit>(context).changeGetStart(true);
                    } else {
                      BlocProvider.of<IntroCubit>(context)
                          .changeGetStart(false);
                    }
                  },
                ),
              ),

              // page indicator
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: height * 0.3),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: introPages.length,
                      effect: ExpandingDotsEffect(
                        dotWidth: width * 0.02,
                        dotHeight: width * 0.02,
                        spacing: 5.0,
                        activeDotColor: primaryColor,
                      ),
                    ),
                  ),
                ),
              ),

              // btn
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: height * 0.2),
                  child: BlocBuilder<IntroCubit, IntroState>(
                    builder: (context, state) {
                      if (state.showGetStart) {
                        return IntroBtn(
                          pageController: pageController,
                          text: 'شروع کن',
                          onPressed: () {
                            PrefsOperator prefsOperator =
                                locator<PrefsOperator>();
                            prefsOperator.changeIntroState();

                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              MainWrapper.routeName,
                              ModalRoute.withName('/main_wrapper'),
                            );
                          },
                        );
                      } else {
                        return IntroBtn(
                          pageController: pageController,
                          text: 'ورق بزن',
                          onPressed: () {
                            if (pageController.page!.toInt() < 2) {
                              if (pageController.page!.toInt() == 1) {
                                BlocProvider.of<IntroCubit>(context)
                                    .changeGetStart(true);
                              }
                              pageController.animateToPage(
                                pageController.page!.toInt() + 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
