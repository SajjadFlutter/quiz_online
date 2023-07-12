import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quiz_online/common/bloc/borrom_nav_cubit/change_index_cubit.dart';
import 'package:quiz_online/common/bloc/user_info_cubit/change_username_cubit.dart';
import 'package:quiz_online/common/bloc/user_info_cubit/changle_profile_image_cubit.dart';
import 'package:quiz_online/config/my_theme.dart';
import 'package:quiz_online/common/bloc/visible_cubit/visible_cubit.dart';
import 'package:quiz_online/features/feature_home/presentation/screens/home_screen.dart';
import 'package:quiz_online/features/feature_intro/presentation/bloc/splash_cubit/splash_cubit.dart';
import 'package:quiz_online/features/feature_intro/presentation/screens/onboarding.dart';
import 'package:quiz_online/features/feature_intro/presentation/screens/set_profile_screen.dart';
import 'package:quiz_online/features/feature_intro/presentation/screens/splash_screen.dart';
import 'package:quiz_online/features/feature_profile/data/models/quiz_model.dart';
import 'package:quiz_online/features/feature_profile/presentation/screens/profile_screen.dart';
import 'package:quiz_online/features/feature_profile/presentation/screens/settings_screen.dart';
import 'package:quiz_online/features/feature_quiz/presentation/screens/quiz_screen.dart';
import 'package:quiz_online/features/feature_quiz/presentation/screens/result_screen.dart';
import 'package:quiz_online/locator.dart';
import 'package:tapsell_plus/tapsell_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // use from back4app.com
  const keyApplicationId = 'xul9v9enKgZxX7AziS31rjceue92DmJh8WVpZJvm';
  const keyClientKey = 'NYRDBZLwjZOY8KwFA4Y2QGP6qKleddjry5beN5Du';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  // Tapsell
  const appId = "kbjipdajdmeifcprspgskcfqbsgrdsoimeendlkhfnoikdcphpjfpthojtdmqrihkkrico";
  TapsellPlus.instance.initialize(appId);
  TapsellPlus.instance.setGDPRConsent(true);

  // init locator
  await initLocator();

  // init hive
  await Hive.initFlutter();
  Hive.registerAdapter(QuizModelAdapter());
  await Hive.openBox<QuizModel>('quizBox');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashCubit()),
        BlocProvider(create: (_) => ChangeIndexCubit()),
        BlocProvider(create: (_) => ChangeProfileImageCubit()),
        BlocProvider(create: (_) => ChangeUsernameCubit()),
        BlocProvider(create: (_) => VisibleCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('fa', ''),
      supportedLocales: const [
        Locale('fa', ''), // persian
        Locale('en', ''), // English
      ],
      initialRoute: '/',
      routes: {
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        SetProfileScreen.routeName: (context) => const SetProfileScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        QuizScreen.routeName: (context) => const QuizScreen(),
        ResultScreen.routeName: (context) => const ResultScreen(),
      },
      title: 'آزمون آنلاین',
      home: const SplashScreen(),
    );
  }

  static void changeColor(
    Color statusBarColor,
    Color systemNavigationBarColor,
    Brightness brightness,
  ) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: brightness,
        systemNavigationBarColor: systemNavigationBarColor,
        systemNavigationBarIconBrightness: brightness,
      ),
    );
  }
}
