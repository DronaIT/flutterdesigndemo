import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController phoneController = TextEditingController();

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
                  text: strings_name.str_forgot_password,
                  alignment: Alignment.topLeft,
                  textStyles: centerTextStyle30,
                ),
                SizedBox(height: 30.h),
                custom_text(
                  text: strings_name.str_phone,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: custom_edittext(
                        type: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        controller: TextEditingController(),
                        readOnly: true,
                        hintText: "+91",
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 8,
                      child: custom_edittext(
                        type: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        controller: phoneController,
                        maxLength: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                CustomButton(
                    text: strings_name.str_proceed,
                    click: () {
                      Get.back();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
