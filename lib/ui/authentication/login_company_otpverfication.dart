import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/authentication/createpassword.dart';
import 'package:flutterdesigndemo/ui/home.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginCompanyOtpVerification extends StatefulWidget {
  const LoginCompanyOtpVerification({Key? key}) : super(key: key);

  @override
  State<LoginCompanyOtpVerification> createState() => _LoginCompanyOtpVerificationState();
}

class _LoginCompanyOtpVerificationState extends State<LoginCompanyOtpVerification> {
  String _otp = "";
  var counter = 300;

  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      counter--;
      if (counter == 0) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        iconSize: 30,
                        icon: Icon(
                          Icons.arrow_circle_left_rounded,
                          color: colors_name.colorPrimary,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      )),
                  Container(
                    alignment: Alignment.topLeft,
                    child: AppImage.load(AppImage.ic_launcher, width: 80.w, height: 80.h),
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
                    child: AppWidgets.spannableText(strings_name.str_otp, "+91-${Get.arguments[0]["phone"].toString()}", primaryTextSemiBold16),
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
                        debugPrint("Allowing to paste $text");
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
                      click: () async {
                        if (_otp.isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_enter_otp);
                        } else if (counter <= 0) {
                          Utils.showSnackBar(context, strings_name.str_otp_expired);
                        } else if (_otp.toString() == Get.arguments[2]["otp"].toString()) {
                          var query = "AND(${TableNames.TB_CONTACT_NUMBER}='${Get.arguments[0]["phone"]}')";
                          var dataOrg = await apiRepository.getCompanyDetailApi(query);
                          if (dataOrg.records!.isNotEmpty) {
                            setState(() {
                              isVisible = false;
                            });
                            String? deviceId = await Utils.getId();
                            Map<String, dynamic> query = {"token": deviceId};
                            await apiRepository.addTokenOrganization(query, dataOrg.records!.first.id!);
                            await PreferenceUtils.setIsLogin(3);
                            await PreferenceUtils.setLoginDataOrganization(dataOrg.records!.first.fields!);
                            await PreferenceUtils.setLoginRecordId(dataOrg.records!.first.id!);
                            Get.offAll(() => const Home());
                          } else if (dataOrg.records!.isEmpty) {
                            setState(() {
                              isVisible = false;
                            });
                            Utils.showSnackBar(context, strings_name.str_organization_not_found);
                          } else {
                            setState(() {
                              isVisible = false;
                            });
                            Utils.showSnackBar(context, strings_name.str_something_wrong);
                          }
                        } else {
                          Utils.showSnackBar(context, strings_name.str_enter_otp);
                        }
                      }),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Container(
              color: colors_name.colorWhite,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
