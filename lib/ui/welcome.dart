import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/home.dart';
import 'package:flutterdesigndemo/ui/login.dart';
import 'package:flutterdesigndemo/utils/prefrence.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await PreferenceUtils.init();
  setup();
  runApp(GetMaterialApp(debugShowCheckedModeBanner: false, home: WelcomeScreen()));
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var isLogin = 0;
  @override
  void initState() {
    super.initState();
    initialization();
    isLogin = PreferenceUtils.getIsLogin();

  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
    if (isLogin == 1 || isLogin  == 2 ) {
      Get.offAll(const Home());
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                SizedBox(height: 60.h),
                Container(
                    alignment: Alignment.topLeft,
                    child: AppImage.load(AppImage.ic_launcher, width: 80.w, height: 80.h)),
                custom_text(
                  text: strings_name.str_welcome,
                  alignment: Alignment.topLeft,
                  textStyles: centerTextStyle30,
                ),
                // custom_text(
                //   text: strings_name.str_welcome_detail,
                //   size: 16.sp,
                //   fontWeight: FontWeight.w600,
                //   alignment: Alignment.topLeft,
                //   textStyles: blackText16,
                // ),
                SizedBox(height: 5.h),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: AppWidgets.spannableText(strings_name.str_welcome_detail,
                      strings_name.str_drona, primaryTextSemiBold16),
                ),
                SizedBox(height: 40.h),
                Lottie.asset(AppImage.ic_welcome),
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

//   body: Stack(
//           fit: StackFit.loose,
//           children: [
//             Image.asset("${AppImage.ic_welcome}"),
//             Container(
//               decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: <Color>[
//                     colors_name.searchFieldTextColor,
//                     colors_name.colorPrimary,
//                     colors_name.colorPrimary
//                   ])),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Image.asset("${AppImage.ic_avtar}", width: 200, height: 200),
//                 custom_text(
//                   text: strings_name.str_welcome,
//                   size: 30,
//                   fontWeight: FontWeight.w600,
//                   alignment: Alignment.center,
//                   textStyles: centerTextStyleWhite,
//                 ),
//
//               ],
//             ),
//           ],
//         ),
