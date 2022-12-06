import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/home.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:dart_airtable/dart_airtable.dart';

import '../utils/prefrence.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({Key? key}) : super(key: key);

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  List<AirtableRecordField> records = [];
  bool isVisible = false;
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
                          width: 80.w, height: 80.h),
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
                    custom_edittext(
                        type: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        controller: passController,
                        obscure: true,
                        isPassword: true),
                    SizedBox(height: 8.h),
                    custom_text(
                      text: strings_name.str_confirm_password,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(
                        type: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        controller: confirmPassController,
                        obscure: true,
                        isPassword: true),
                    SizedBox(height: 40.h),
                    CustomButton(
                        text: strings_name.str_proceed,
                        click: ()  async {
                          var passWord = FormValidator.validatePassword(
                              passController.text.toString());
                          var confirmPassword = FormValidator.validateCPassword(
                              confirmPassController.text.toString());
                          if (passWord.isNotEmpty) {
                            Utils.showSnackBar(context, passWord);
                          } else if (confirmPassword.isNotEmpty) {
                            Utils.showSnackBar(context, confirmPassword);
                          } else if (passController.text.toString() !=
                              confirmPassController.text.toString()) {
                            Utils.showSnackBar(
                                context, strings_name.str_enter_pass_same);
                          } else {
                            setState(() {
                              isVisible = true;
                            });
                          //  print("phone=>${Get.arguments.toString()}");
                            var airtable =  Airtable(
                                apiKey: TableNames.APIKEY,
                                projectBase: TableNames.PROJECTBASE);
                            var getRecord = await airtable.getRecordsFilterByFormula(
                                TableNames.TB_USERS,
                                "(${TableNames.TB_USERS_PHONE}='${Get.arguments.toString()}')"
                                );

                            records.add(AirtableRecordField(
                                fieldName: "mobile_number", value:  Get.arguments.toString()));
                            records.add(AirtableRecordField(
                                fieldName: "password", value: passController.text.toString()));
                            getRecord!.first.fields = records;
                          // print("records==> ${getRecord}");
                            var record = await airtable.updateRecord(TableNames.TB_USERS, getRecord.first);
                           // print("recordsdd==> ${record?.toJSON()}");
                            if (records != null && records.isNotEmpty) {
                              setState(() {
                                isVisible = false;
                              });
                              await PreferenceUtils.setIsLogin(true);
                              Get.offAll(Home());
                            } else {
                              setState(() {
                                isVisible = false;
                              });
                              Utils.showSnackBar(
                                  context, strings_name.str_something_wrong);
                            }
                            //Get.to(const Home());
                          }
                        }),
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
