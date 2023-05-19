import 'package:flutter/material.dart';
import 'package:quiz_online/common/widgets/bottom_nav.dart';
import 'package:quiz_online/features/feature_home/presentation/screens/home_screen.dart';
import 'package:quiz_online/features/feature_profile/presentation/screens/profile_screen.dart';


class MainWrapper extends StatelessWidget {
  static const String routeName = '/main_wrapper';
  MainWrapper({super.key});

  final PageController pageController = PageController();

  final List<Widget> topLevelScreens = [
    HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: topLevelScreens,
        ),
      ),
      bottomNavigationBar: BottomNav(controller: pageController),
    );
  }
}
