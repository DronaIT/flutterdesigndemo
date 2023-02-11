import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/ui/splash_screen.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:get/get.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Drona foundation',
      home: SplashScreen(),
      theme: ThemeData(
          primarySwatch: primaryColor,
          buttonTheme: ButtonTheme.of(context).copyWith(
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          )),
    );
  }

  static const MaterialColor primaryColor = MaterialColor(
    _redPrimaryValue,
    <int, Color>{
      50: Color(0xFF800000),
      100: Color(0xFF800000),
      200: Color(0xFF800000),
      300: Color(0xFF800000),
      400: Color(0xFF800000),
      500: Color(_redPrimaryValue),
      600: Color(0xFF800000),
      700: Color(0xFF800000),
      800: Color(0xFF800000),
      900: Color(0xFF800000),
    },
  );
  static const int _redPrimaryValue = 0xFF70d7070;
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
