import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/authentication/otpverfication.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../api/dio_exception.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController phoneController = TextEditingController();

  bool isVisible = false;
  final registerRepository = getIt.get<ApiRepository>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  Container(
                    alignment: Alignment.topLeft,
                    child: AppImage.load(AppImage.ic_launcher, width: 80.w, height: 80.h),
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
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: custom_edittext(
                            type: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            controller: TextEditingController(),
                            readOnly: true,
                            hintText: "+91",
                            textalign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
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
                      click: () async {
                        var phone = FormValidator.validatePhone(phoneController.text.toString().trim());
                        if (phone.isNotEmpty) {
                          Utils.showSnackBar(context, phone);
                        } else {
                          setState(() {
                            isVisible = true;
                          });
                          var query = "(${TableNames.TB_USERS_PHONE}='${phoneController.text.toString()}')";
                          try {
                            var data = await registerRepository.registerApi(query);
                            if (data.records!.isNotEmpty) {
                              setState(() {
                                isVisible = false;
                              });
                              sendOTP(phoneController.text, false);
                            } else if (data.records!.isEmpty) {
                              var dataEmployee = await registerRepository.registerEmployeeApi(query);
                              if (dataEmployee.records!.isNotEmpty) {
                                setState(() {
                                  isVisible = false;
                                });
                                sendOTP(phoneController.text, true);
                              } else if (dataEmployee.records!.length == 0) {
                                setState(() {
                                  isVisible = false;
                                });
                                Utils.showSnackBar(context, strings_name.str_user_not_found);
                              } else {
                                setState(() {
                                  isVisible = false;
                                });
                                Utils.showSnackBar(context, strings_name.str_something_wrong);
                              }
                            } else {
                              setState(() {
                                isVisible = false;
                              });
                              Utils.showSnackBar(context, strings_name.str_something_wrong);
                            }
                          } on DioError catch (e) {
                            setState(() {
                              isVisible = false;
                            });
                            final errorMessage = DioExceptions.fromDioError(e).toString();
                            Utils.showSnackBarUsingGet(errorMessage);
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: Visibility(child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary), visible: isVisible),
        )
      ]),
    );
  }

  Future<void> sendOTP(String phone, bool fromEmployee) async {
    try {
      var otp = Random().nextInt(900000) + 100000;
      var headers = {'Content-Type': 'application/json', 'api-key': TableNames.KALEYRA_APIKEY};
      var request = http.MultipartRequest('POST', Uri.parse('https://api.kaleyra.io/v1/HXIN1756562868IN/messages'));
      request.fields.addAll({'to': '+91$phone', 'type': 'OTP', 'sender': TableNames.KALEYRA_SENDER, 'template': TableNames.TEMPLATE_ID_FORGOT_PASSWORD, 'body': 'Your OTP for Drona Foundation Mobile App login is $otp. The OTP is valid for 5 minutes.'});

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 202) {
        Get.to(const OtpVerification(), arguments: [
          {"phone": phoneController.text},
          {"isFromEmployee": fromEmployee},
          {"otp": otp},
        ]);
      } else {
        Utils.showSnackBar(context, response.reasonPhrase.toString());
      }
    } on SocketException catch (e) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBarUsingGet("No Internet");
    }
  }
}
