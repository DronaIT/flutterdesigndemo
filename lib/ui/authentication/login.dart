import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/authentication/forgotpassword.dart';
import 'package:flutterdesigndemo/ui/authentication/register.dart';
import 'package:flutterdesigndemo/ui/home.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/dio_exception.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isVisible = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final loginRepository = getIt.get<ApiRepository>();
  bool value = false;

  List<String> loginRole = <String>[TableNames.LOGIN_ROLE_EMPLOYEE, TableNames.LOGIN_ROLE_STUDENT, TableNames.LOGIN_ROLE_ORGANIZATION];
  String loginValue = TableNames.LOGIN_ROLE_EMPLOYEE;

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    SizedBox(height: 60.h),
                    Container(alignment: Alignment.topLeft, child: AppImage.load(AppImage.ic_launcher, width: 80.w, height: 80.h)),
                    custom_text(
                      text: strings_name.str_lest_started,
                      alignment: Alignment.topLeft,
                      textStyles: centerTextStyle30,
                    ),
                    custom_text(
                      text: strings_name.str_select_login_role,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 0),
                            width: viewWidth,
                            child: DropdownButtonFormField<String>(
                              elevation: 16,
                              style: blackText16,
                              focusColor: Colors.white,
                              value: loginValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  loginValue = newValue!;
                                });
                              },
                              items: loginRole.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
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
                    SizedBox(height: 8.h),
                    custom_text(
                      text: strings_name.str_password,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(type: TextInputType.visiblePassword, textInputAction: TextInputAction.next, controller: passController, obscure: true, isPassword: true),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      child: custom_text(
                        text: strings_name.str_forgot_password,
                        alignment: Alignment.topRight,
                        textStyles: blackTextSemiBold16,
                      ),
                      onTap: () {
                        Get.to(const ForgotPassword());
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: value,
                          activeColor: colors_name.colorPrimary,
                          onChanged: (bool? value) {
                            setState(() {
                              this.value = value!;
                            });
                          },
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child:
                              // custom_text(text: strings_name.str_terms_privacy_policy, textStyles: blackTextSemiBold14, topValue: 5, maxLines: 1000, bottomValue: 5, leftValue: 5)
                              Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'I hereby accept the ',
                                  style: blackTextSemiBold14,
                                ),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: linkTextSemiBold14,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      await launchUrl(Uri.parse("https://pastebin.com/raw/HAHds12N"), mode: LaunchMode.inAppWebView);
                                    },
                                ),
                                const TextSpan(
                                  text: ' and ',
                                  style: blackTextSemiBold14,
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: linkTextSemiBold14,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      await launchUrl(Uri.parse("https://pastebin.com/raw/QwwednCb"), mode: LaunchMode.inAppWebView);
                                    },
                                ),
                              ],
                            ),
                          ), //Text
                        )
                      ],
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                        text: strings_name.str_signin,
                        click: () async {
                          var phone = FormValidator.validatePhone(phoneController.text.toString().trim());
                          var password = FormValidator.validatePassword(passController.text.toString().trim());
                          if (phone.isNotEmpty) {
                            Utils.showSnackBar(context, phone);
                          } else if (password.isNotEmpty) {
                            Utils.showSnackBar(context, password);
                          } else if (!value) {
                            Utils.showSnackBar(context, strings_name.str_accept_terms);
                          } else {
                            setState(() {
                              isVisible = true;
                            });

                            var query = "OR(${TableNames.TB_USERS_PHONE}='${phoneController.text.toString()}',AND(${TableNames.TB_USERS_PHONE}='${phoneController.text.toString()}',${TableNames.TB_USERS_PASSWORD}='${passController.text.toString()}'))";
                            try {
                              if (loginValue == TableNames.LOGIN_ROLE_STUDENT) {
                                var data = await loginRepository.loginApi(query);
                                if (data.records!.isNotEmpty) {
                                  setState(() {
                                    isVisible = false;
                                  });
                                  if (data.records!.first.fields?.password == null) {
                                    Utils.showSnackBar(context, strings_name.str_invalide_mobile_password);
                                  } else if (data.records!.first.fields?.password != passController.text.toString()) {
                                    Utils.showSnackBar(context, strings_name.str_invalide_password);
                                  } else {
                                    String? deviceId = await Utils.getId();
                                    Map<String, dynamic> query = {"token": deviceId};
                                    await loginRepository.addToken(query, data.records!.first.id!);
                                    await PreferenceUtils.setIsLogin(1);
                                    await PreferenceUtils.setLoginData(data.records!.first.fields!);
                                    await PreferenceUtils.setLoginRecordId(data.records!.first.id!);
                                    Get.offAll(() => const Home());
                                  }
                                } else if (data.records!.length == 0) {
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
                              } else if(loginValue == TableNames.LOGIN_ROLE_EMPLOYEE){
                                var dataEmployee = await loginRepository.loginEmployeeApi(query);
                                if (dataEmployee.records!.isNotEmpty) {
                                  setState(() {
                                    isVisible = false;
                                  });
                                  if (dataEmployee.records!.first.fields?.password == null) {
                                    Utils.showSnackBar(context, strings_name.str_invalide_mobile_password);
                                  } else if (dataEmployee.records!.first.fields?.password != passController.text.toString()) {
                                    Utils.showSnackBar(context, strings_name.str_invalide_password);
                                  } else {
                                    String? deviceId = await Utils.getId();
                                    Map<String, dynamic> query = {"token": deviceId};
                                    await loginRepository.addTokenEmployee(query, dataEmployee.records!.first.id!);
                                    await PreferenceUtils.setIsLogin(2);
                                    await PreferenceUtils.setLoginDataEmployee(dataEmployee.records!.first.fields!);
                                    await PreferenceUtils.setLoginRecordId(dataEmployee.records!.first.id!);
                                    Get.offAll(() => const Home());
                                  }
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
                              } else if(loginValue == TableNames.LOGIN_ROLE_ORGANIZATION){
                                var queryOrg = "OR(${TableNames.TB_CONTACT_NUMBER}='${phoneController.text.toString()}',AND(${TableNames.TB_CONTACT_NUMBER}='${phoneController.text.toString()}',${TableNames.TB_USERS_PASSWORD}='${passController.text.toString()}'))";
                                var dataOrg = await loginRepository.getCompanyDetailApi(queryOrg);
                                if (dataOrg.records!.isNotEmpty) {
                                  setState(() {
                                    isVisible = false;
                                  });
                                  if (dataOrg.records!.first.fields?.password == null) {
                                    Utils.showSnackBar(context, strings_name.str_invalide_mobile_password);
                                  } else if (dataOrg.records!.first.fields?.password != passController.text.toString()) {
                                    Utils.showSnackBar(context, strings_name.str_invalide_password);
                                  } else {
                                    String? deviceId = await Utils.getId();
                                    Map<String, dynamic> query = {"token": deviceId};
                                    await loginRepository.addTokenOrganization(query, dataOrg.records!.first.id!);
                                    await PreferenceUtils.setIsLogin(3);
                                    await PreferenceUtils.setLoginDataOrganization(dataOrg.records!.first.fields!);
                                    await PreferenceUtils.setLoginRecordId(dataOrg.records!.first.id!);
                                    Get.offAll(() => const Home());
                                  }
                                } else if (dataOrg.records!.length == 0) {
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
                              }
                            } on DioError catch (e) {
                              setState(() {
                                isVisible = false;
                              });
                              final errorMessage = DioExceptions.fromDioError(e).toString();
                              Utils.showSnackBarUsingGet(errorMessage);
                            }

                            /*var data = await loginRepository.loginApi(query);
                            try {
                              if (data.records!.isNotEmpty) {
                                setState(() {
                                  isVisible = false;
                                });
                                if (data.records!.first.fields?.password == null) {
                                  Utils.showSnackBar(context, strings_name.str_invalide_mobile_password);
                                } else if (data.records!.first.fields?.password != passController.text.toString()) {
                                  Utils.showSnackBar(context, strings_name.str_invalide_password);
                                } else {
                                  String? deviceId = await Utils.getId();
                                  Map<String, dynamic> query = {"token": deviceId};
                                  await loginRepository.addToken(query, data.records!.first.id!);
                                  await PreferenceUtils.setIsLogin(1);
                                  await PreferenceUtils.setLoginData(data.records!.first.fields!);
                                  await PreferenceUtils.setLoginRecordId(data.records!.first.id!);
                                  Get.offAll(() => const Home());
                                }
                              } else if (data.records!.length == 0) {
                                try {
                                  var dataEmployee = await loginRepository.loginEmployeeApi(query);
                                  if (dataEmployee.records!.isNotEmpty) {
                                    setState(() {
                                      isVisible = false;
                                    });
                                    if (dataEmployee.records!.first.fields?.password == null) {
                                      Utils.showSnackBar(context, strings_name.str_invalide_mobile_password);
                                    } else if (dataEmployee.records!.first.fields?.password != passController.text.toString()) {
                                      Utils.showSnackBar(context, strings_name.str_invalide_password);
                                    } else {
                                      String? deviceId = await Utils.getId();
                                      Map<String, dynamic> query = {"token": deviceId};
                                      await loginRepository.addTokenEmployee(query, dataEmployee.records!.first.id!);
                                      await PreferenceUtils.setIsLogin(2);
                                      await PreferenceUtils.setLoginDataEmployee(dataEmployee.records!.first.fields!);
                                      await PreferenceUtils.setLoginRecordId(dataEmployee.records!.first.id!);
                                      Get.offAll(() => const Home());
                                    }
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
                                } on DioError catch (e) {
                                  final errorMessage = DioExceptions.fromDioError(e).toString();
                                  Utils.showSnackBarUsingGet(errorMessage);
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
                            }*/
                          }
                        }),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      child: AppWidgets.spannableText(strings_name.str_donot_signup, strings_name.str_signup, primaryTextSemiBold16),
                      onTap: () {
                        Get.to(const Register());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    );
  }
}
