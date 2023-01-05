import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/main.dart';
import 'package:get/get.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () async {
      Get.to(const WelcomeScreen());
    });
    super.initState();
  }

  initScreen(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        // child: Image(image: AssetImage(AppImage.ic_splash)),
        child: Container(color: colors_name.colorPrimary),
      ),
    );
  }
}
