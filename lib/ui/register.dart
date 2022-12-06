import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/otpverfication.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:dart_airtable/dart_airtable.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController phoneController = TextEditingController();
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
                      text: strings_name.str_lest_setup,
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
                        text: strings_name.str_verify,
                        click: ()  async {
                          var phone = FormValidator.validatePhone(
                              phoneController.text.toString());
                          if (phone.isNotEmpty) {
                            Utils.showSnackBar(context, phone);
                          }  else {
                            setState(() {
                              isVisible = true;
                            });
                            var airtable = Airtable(
                                apiKey: TableNames.APIKEY,
                                projectBase: TableNames.PROJECTBASE);
                            var query = "(${TableNames.TB_USERS_PHONE}='${phoneController.text.toString()}')";
                            var records = await airtable.getRecordsFilterByFormula(TableNames.TB_USERS, query);
                            // print("object ==> ${records!.first.toJSON().entries.first.value}");
                            // print("object1 ==> ${records.first.fields[2].value}");
                            if (records != null && records.isNotEmpty) {
                              setState(() {
                                isVisible = false;
                              });
                              var pass= -1;
                              for (var i = 0; i < records.first.fields.length; i++) {
                                if(records.first.fields[i].fieldName == "password") {
                                  pass = i;
                                  break;
                                }
                              }
                              if(records.first.fields.isNotEmpty && pass != -1){
                                Get.to(const OtpVerification(),
                                  arguments: phoneController.text);
                              }else{
                                Utils.showSnackBar(
                                    context, strings_name.str_user_already_verified);
                              }
                            } else {
                              setState(() {
                                isVisible = false;
                              });
                              Utils.showSnackBar(
                                  context, strings_name.str_something_wrong);
                            }
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
