// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quiz_online/common/bloc/borrom_nav_cubit/change_index_cubit.dart';
import 'package:quiz_online/common/page_route/animation_pages.dart';
import 'package:quiz_online/features/feature_home/presentation/screens/home_screen.dart';
import 'package:quiz_online/features/feature_profile/presentation/screens/profile_screen.dart';

class BottomNav extends StatelessWidget {
  final PageController controller;
  const BottomNav({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // theme
    var primaryColor = Theme.of(context).primaryColor;
    // var textTheme = Theme.of(context).textTheme;

    return BottomAppBar(
      height: 63.0,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: BlocBuilder<ChangeIndexCubit, int>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomNavItem(
                controller: controller,
                primaryColor: primaryColor,
                state: state,
                index: 0,
                iconName: 'home',
                title: 'خانه',
              ),
              BottomNavItem(
                controller: controller,
                primaryColor: primaryColor,
                state: state,
                index: 1,
                iconName: 'user',
                title: 'حساب کاربری',
              ),
            ],
          );
        },
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.controller,
    required this.primaryColor,
    required this.state,
    required this.index,
    required this.iconName,
    required this.title,
  });

  final PageController controller;
  final Color primaryColor;
  final int state;
  final int index;
  final String iconName;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // // change index
        BlocProvider.of<ChangeIndexCubit>(context).changeIndexEvent(index);
        // // go to Home Screen
        // controller.jumpToPage(index);

        if (index == 0) {
          Navigator.push(
            context,
            SlideDownPageRoute(
              builder: (BuildContext context) => HomeScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            SlideDownPageRoute(
              builder: (BuildContext context) => ProfileScreen(),
            ),
          );
        }
      },
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              state == index
                  ? 'assets/images/${iconName}_on.svg'
                  : 'assets/images/${iconName}_off.svg',
              width: 22.0,
              color: state == index ? primaryColor : Colors.grey,
            ),
            const SizedBox(height: 4.0),
            Text(
              title,
              style: TextStyle(
                color: state == index ? primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
