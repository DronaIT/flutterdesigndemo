import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/authentication/login.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    var lWidth = MediaQuery.of(context).size.width - 20.h;
    var lHeight = MediaQuery.of(context).size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                SizedBox(height: 60.h),
                Container(alignment: Alignment.topLeft, child: AppImage.load(AppImage.ic_launcher, width: 80.w, height: 80.h)),
                custom_text(
                  text: strings_name.str_welcome,
                  alignment: Alignment.topLeft,
                  textStyles: centerTextStyle30,
                ),
                SizedBox(height: 5.h),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: AppWidgets.spannableText(strings_name.str_welcome_detail, strings_name.str_drona, primaryTextSemiBold16),
                ),
                SizedBox(height: 40.h),
                Lottie.asset(AppImage.ic_welcome, width: lWidth, height: lHeight),
                SizedBox(height: 40.h),
                CustomButton(
                    text: strings_name.str_get_started,
                    click: () {
                      Get.offAll(const Login());
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
