import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quiz_online/common/bloc/borrom_nav_cubit/change_index_cubit.dart';
import 'package:quiz_online/common/widgets/main_wrapper.dart';
import 'package:quiz_online/config/my_theme.dart';
import 'package:quiz_online/features/feature_home/presentation/screens/home_screen.dart';
import 'package:quiz_online/features/feature_quiz/presentation/screens/quiz_screen.dart';
import 'package:quiz_online/features/feature_quiz/presentation/screens/result_screen.dart';
import 'package:quiz_online/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // use from back4app.com
  const keyApplicationId = 'xul9v9enKgZxX7AziS31rjceue92DmJh8WVpZJvm';
  const keyClientKey = 'NYRDBZLwjZOY8KwFA4Y2QGP6qKleddjry5beN5Du';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  // init locator
  await initLocator();

  // init hive
  await Hive.initFlutter();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChangeIndexCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MyApp.changeColor(
      Theme.of(context).scaffoldBackgroundColor,
      Brightness.dark,
    );
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
        MainWrapper.routeName: (context) => MainWrapper(),
        HomeScreen.routeName: (context) => HomeScreen(),
        QuizScreen.routeName: (context) => const QuizScreen(),
        ResultScreen.routeName: (context) => const ResultScreen(),
      },
      home: MainWrapper(),
    );
  }

  static void changeColor(Color color, Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness,
        systemNavigationBarColor: color,
        systemNavigationBarIconBrightness: brightness,
      ),
    );
  }
}
