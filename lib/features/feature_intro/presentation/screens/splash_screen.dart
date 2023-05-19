// ignore_for_file: deprecated_member_use

import 'package:delayed_widget/delayed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_online/common/prefs/prefs_operator.dart';
import 'package:quiz_online/common/widgets/main_wrapper.dart';
import 'package:quiz_online/common/widgets/small_btn.dart';
import 'package:quiz_online/features/feature_intro/presentation/bloc/splash_cubit/splash_cubit.dart';
import 'package:quiz_online/features/feature_intro/presentation/screens/onboarding.dart';
import 'package:quiz_online/locator.dart';
import 'package:quiz_online/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<SplashCubit>(context).checkConnectionEvent();
  }

  @override
  Widget build(BuildContext context) {
    // get divice size
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    // theme
    var primaryColor = Theme.of(context).primaryColor;
    // var secondaryHeaderColor = Theme.of(context).secondaryHeaderColor;
    // var cardColor = Theme.of(context).cardColor;
    var textTheme = Theme.of(context).textTheme;

    MyApp.changeColor(
      Theme.of(context).scaffoldBackgroundColor,
      Brightness.dark,
    );

    return Scaffold(
      body: Container(
        width: width,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: DelayedWidget(
                delayDuration: const Duration(milliseconds: 200),
                animationDuration: const Duration(milliseconds: 1500),
                animation: DelayedAnimations.SLIDE_FROM_BOTTOM,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo_icon.svg',
                      width: 110.0,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10.0),
                        Text('آزمون آنلاین', style: textTheme.titleLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BlocConsumer<SplashCubit, SplashState>(
              listener: (context, state) {
                if (state.connectionStatus is ConnectionOn) {
                  goToHome();
                }
              },
              builder: (context, state) {
                if (state.connectionStatus is ConnectionInitial ||
                    state.connectionStatus is ConnectionOn) {
                  return CircularProgressIndicator(color: primaryColor);
                }

                if (state.connectionStatus is ConnectionOff) {
                  return Column(
                    children: [
                      const Text(
                        'اتصال خود به اینترنت را چک کنید!',
                        style:
                            TextStyle(fontSize: 14.0, color: Colors.redAccent),
                      ),
                      const SizedBox(height: 12.0),
                      SmallBtn(
                        onPressed: () {
                          BlocProvider.of<SplashCubit>(context)
                              .checkConnectionEvent();
                        },
                        child: const SizedBox(
                          width: 100.0,
                          child: Row(
                            children: [
                              SizedBox(width: 5.0),
                              Text(
                                'تلاش مجدد',
                                style: TextStyle(
                                  fontFamily: 'iransans',
                                  fontSize: 12.0,
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Icon(
                                Icons.replay,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Future<void> goToHome() async {
    PrefsOperator prefsOperator = locator<PrefsOperator>();
    final isShowIntroScreen = await prefsOperator.getShowState();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (isShowIntroScreen) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            OnboardingScreen.routeName,
            ModalRoute.withName('/onboarding_screen'),
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            MainWrapper.routeName,
            ModalRoute.withName('/main_wrapper'),
          );
        }
      },
    );
  }
}
