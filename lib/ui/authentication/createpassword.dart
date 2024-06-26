import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/authentication/login.dart';
import 'package:flutterdesigndemo/ui/home.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../utils/preference.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({Key? key}) : super(key: key);

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  //List<AirtableRecordField> records = [];

  final userRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  //List<Records> loginRecords = [];

  @override
  Widget build(BuildContext context) {
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
                            Get.offAll(Login());
                          },
                        )),
                    Container(
                      alignment: Alignment.topLeft,
                      child: AppImage.load(AppImage.ic_launcher, width: 80.w, height: 80.h),
                    ),
                    custom_text(
                      text: strings_name.str_setup_password,
                      alignment: Alignment.topLeft,
                      textStyles: centerTextStyle30,
                    ),
                    SizedBox(height: 30.h),
                    custom_text(
                      text: strings_name.str_new_password,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(type: TextInputType.visiblePassword, textInputAction: TextInputAction.next, controller: passController, obscure: true, isPassword: true),
                    SizedBox(height: 8.h),
                    custom_text(
                      text: strings_name.str_confirm_password,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(type: TextInputType.visiblePassword, textInputAction: TextInputAction.next, controller: confirmPassController, obscure: true, isPassword: true),
                    SizedBox(height: 40.h),
                    CustomButton(
                        text: strings_name.str_proceed,
                        click: () async {
                          var passWord = FormValidator.validatePassword(passController.text.toString().trim());
                          var confirmPassword = FormValidator.validateCPassword(confirmPassController.text.toString().trim());
                          if (passWord.isNotEmpty) {
                            Utils.showSnackBar(context, passWord);
                          } else if (confirmPassword.isNotEmpty) {
                            Utils.showSnackBar(context, confirmPassword);
                          } else if (passController.text.toString() != confirmPassController.text.toString()) {
                            Utils.showSnackBar(context, strings_name.str_enter_pass_same);
                          } else {
                            setState(() {
                              isVisible = true;
                            });
                            String? deviceId = await Utils.getId();
                            var query = "(${TableNames.TB_USERS_PHONE}='${Get.arguments[0]["phone"].toString()}')";
                            if (!Get.arguments[1]["isFromEmployee"]) {
                              try {
                                var data = await userRepository.registerApi(query);
                                Map<String, String> password = {
                                  "password": passController.text.toString(),
                                  "token": deviceId.toString(),
                                };
                                if (data.records!.isNotEmpty) {
                                  var dataUpdate = await userRepository.createPasswordApi(password, data.records!.first.id!);
                                  if (dataUpdate != null) {
                                    setState(() {
                                      isVisible = false;
                                    });
                                    await PreferenceUtils.setIsLogin(1);
                                    await PreferenceUtils.setLoginData(dataUpdate.fields!);
                                    await PreferenceUtils.setLoginRecordId(dataUpdate.id!);
                                    Get.offAll(const Home());
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
                            } else {
                              try {
                                var dataPass = await userRepository.registerEmployeeApi(query);
                                if (dataPass.records!.isNotEmpty) {
                                  Map<String, String> password = {
                                    "password": passController.text.toString(),
                                    "token": deviceId.toString(),
                                  };
                                  var dataPassword = await userRepository.createPasswordEmpApi(password, dataPass.records!.first.id!);
                                  if (dataPassword != null) {
                                    setState(() {
                                      isVisible = false;
                                    });
                                    await PreferenceUtils.setIsLogin(2);
                                    await PreferenceUtils.setLoginDataEmployee(dataPassword.fields!);
                                    await PreferenceUtils.setLoginRecordId(dataPassword.id!);
                                    Get.offAll(const Home());
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
        ],
      ),
    );
  }
}
