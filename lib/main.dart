import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'Config/theme.dart';
import './Config/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import './Providers/MyPlanProvider.dart';
import 'Providers/User.dart';
import 'Screens/SplashScreen.dart';

AppThemeData theme = AppThemeData();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp();
  theme.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AppThemeData(),
        ),
        ChangeNotifierProvider(
          create: (_) => MyPlanProvider(),
        ),
        // MyPlanProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppThemeData(),
      child: Consumer<AppThemeData>(
        builder: (context, value, child) {
          var _theme = ThemeData(
            fontFamily: 'Inter',
            primarySwatch: theme.primarySwatch,
          );

          if (theme.darkMode) {
            _theme = ThemeData(
              fontFamily: 'Inter',
              brightness: Brightness.dark,
              unselectedWidgetColor: Colors.white,
              primarySwatch: theme.primarySwatch,
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: _theme,
            title: 'Parentpreneur App',
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
