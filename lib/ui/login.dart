import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/forgotpassword.dart';
import 'package:flutterdesigndemo/ui/home.dart';
import 'package:flutterdesigndemo/ui/register.dart';
import 'package:flutterdesigndemo/utils/prefrence.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

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
                        alignment: Alignment.topLeft,
                        child: AppImage.load(AppImage.ic_launcher,
                            width: 80.w, height: 80.h)),
                    custom_text(
                      text: strings_name.str_lest_started,
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
                    SizedBox(height: 8.h),
                    custom_text(
                      text: strings_name.str_password,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(
                        type: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        controller: passController,
                        obscure: true,
                        isPassword: true),
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
                    SizedBox(height: 40.h),
                    CustomButton(
                        text: strings_name.str_signin,
                        click: () async {
                          var phone = FormValidator.validatePhone(
                              phoneController.text.toString().trim());
                          var password = FormValidator.validatePassword(
                              passController.text.toString().trim());
                          if (phone.isNotEmpty) {
                            Utils.showSnackBar(context, phone);
                          } else if (password.isNotEmpty) {
                            Utils.showSnackBar(context, password);
                          } else {
                            setState(() {
                              isVisible = true;
                            });
                           // var query = "AND(${TableNames.TB_USERS_PHONE}='${phoneController.text.toString()}',${TableNames.TB_USERS_PASSWORD}='${passController.text.toString()}')";
                            var query = "OR(${TableNames.TB_USERS_PHONE}='${phoneController.text.toString()}',AND(${TableNames.TB_USERS_PHONE}='${phoneController.text.toString()}',${TableNames.TB_USERS_PASSWORD}='${passController.text.toString()}'))";
                            var data = await loginRepository.loginApi(query);
                            if (data.records!.isNotEmpty) {
                              setState(() {
                                isVisible = false;
                              });
                              if(data.records!.first.fields?.password == null){
                                Utils.showSnackBar(context, strings_name.str_invalide_mobile_password);
                              }else if(data.records!.first.fields?.password != passController.text.toString()){
                                Utils.showSnackBar(context, strings_name.str_invalide_password);
                              } else{
                                await PreferenceUtils.setIsLogin(true);
                                Get.offAll(Home());
                              }
                            } else if (data.records!.length == 0) {
                              setState(() {
                                isVisible = false;
                              });
                              Utils.showSnackBar(context, strings_name.str_user_not_verified);
                            } else {
                              setState(() {
                                isVisible = false;
                              });
                              Utils.showSnackBar(context, strings_name.str_something_wrong);
                            }
                          }
                        }),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      child: AppWidgets.spannableText(
                          strings_name.str_donot_signup,
                          strings_name.str_signup,
                          primaryTextSemiBold16),
                      onTap: () {
                        Get.to(Register());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Visibility(
                child: const CircularProgressIndicator(
                    strokeWidth: 5.0,
                    backgroundColor: colors_name.colorPrimary),
                visible: isVisible),
          )
        ],
      ),
    );
  }
}
