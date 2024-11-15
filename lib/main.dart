import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/ui/splash_screen.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/push_notification_service.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:get/get.dart';

final _pushMessagingNotification = PushNotificationService();

void main() async {
  if (!kIsWeb) {
    await ScreenUtil.ensureScreenSize();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCD4tKcvsOm2Axz6YQCgaLlbt0Eu9iOVD4',
        appId: '1:694081930115:web:5016bfc419949837716cb6',
        messagingSenderId: '694081930115',
        projectId: 'dronaapp-36d3c',
      ),
    );
  } else {
    await Firebase.initializeApp();
    String? deviceId = await Utils.getId();
  }

  await _pushMessagingNotification.initialize();
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  await PreferenceUtils.init();
  setup();
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint("testHandleback=>${message.notification?.title}");
  final payload = message.data; //jsonDecode(message.data);
  _pushMessagingNotification.handleScreenRedirection(payload);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GetMaterialApp(
          scrollBehavior: MyCustomScrollBehavior(),
          debugShowCheckedModeBanner: false,
          title: 'Drona Foundation',
          home: SplashScreen(),
          theme: ThemeData(
              primarySwatch: primaryColor,
              buttonTheme: ButtonTheme.of(context).copyWith(
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              )),
        );
      },
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
