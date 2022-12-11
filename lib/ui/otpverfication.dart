import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/createpassword.dart';
import 'package:flutterdesigndemo/utils/prefrence.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({Key? key}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  String _otp = "";

  @override
  Widget build(BuildContext context) {
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
                  child: AppImage.load(AppImage.ic_launcher,
                      width: 80.w, height: 80.h),
                ),
                custom_text(
                  text: strings_name.str_verify_phone,
                  alignment: Alignment.topLeft,
                  textStyles: centerTextStyle30,
                ),
                SizedBox(height: 30.h),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: AppWidgets.spannableText(strings_name.str_otp,
                      "+91-${Get.arguments[0]["phone"].toString()}", primaryTextSemiBold16),
                ),
                SizedBox(height: 15.h),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: PinCodeTextField(
                    textStyle: centerTextStyleBlack18,
                    keyboardType: TextInputType.number,
                    backgroundColor: Colors.transparent,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      activeFillColor: Colors.transparent,
                      inactiveColor: colors_name.colorgraylight,
                      selectedColor: colors_name.colorPrimary,
                      activeColor: colors_name.colorPrimary,
                      selectedFillColor: Colors.transparent,
                      inactiveFillColor: Colors.transparent,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onCompleted: (v) {
                      _otp = v;
                    },
                    onChanged: (value) {},
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                    appContext: context,
                  ),
                ),
                SizedBox(height: 40.h),
                CustomButton(
                    text: strings_name.str_confirm,
                    click: () {
                      //print("otp=>${_otp}");
                      if(_otp.isEmpty){
                        Utils.showSnackBar(
                            context, strings_name.str_enter_otp);
                      }else{
                        Get.to(const CreatePassword() , arguments:[{"phone": Get.arguments[0]["phone"]},
                            {"isFromEmployee": Get.arguments[1]["isFromEmployee"]}]);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
