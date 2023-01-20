import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';

class CompanyApproch extends StatefulWidget {
  const CompanyApproch({Key? key}) : super(key: key);

  @override
  State<CompanyApproch> createState() => _CompanyApprochState();
}

class _CompanyApprochState extends State<CompanyApproch> {
  TextEditingController nameofCompanyController = TextEditingController();
  TextEditingController typeOfController = TextEditingController();
  TextEditingController nameOfContactPController = TextEditingController();
  TextEditingController contactPnumberController = TextEditingController();
  TextEditingController contactPWanumberController = TextEditingController();
  bool isVisible = false;

  List<String> typeofResponseArray = <String>["1", "2", "3", "4", "5", "6"];
  String typeofValue = "1";

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_company_approch),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                custom_text(
                  text: strings_name.str_name_of_company,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: nameofCompanyController,
                  topValue: 5,
                ),
                SizedBox(height: 5.h),

                custom_text(
                  text: strings_name.str_type_of_inducstry,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                // custom_edittext(
                //   type: TextInputType.text,
                //   textInputAction: TextInputAction.next,
                //   controller: typeOfController,
                //   topValue: 5,
                // ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<String>(
                          elevation: 16,
                          style: blackText16,
                          value: typeofValue,
                          focusColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              typeofValue = newValue!;
                            });
                          },
                          items: typeofResponseArray.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text("Semester $value"),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5.h),

                custom_text(
                  text: strings_name.str_contact_person,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: nameOfContactPController,
                  topValue: 5,
                ),
                SizedBox(height: 3.h),

                custom_text(
                  text: strings_name.str_contact_person_number,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: contactPnumberController,
                  topValue: 5,
                ),
                SizedBox(height: 3.h),

                custom_text(
                  text: strings_name.str_contact_person_wanumber,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: contactPWanumberController,
                  topValue: 5,
                ),
                SizedBox(height: 20.h),
                CustomButton(
                    text: strings_name.str_submit,
                    click: () {
                      if (nameofCompanyController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_company_name);
                      } else if (typeofValue.toString().trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_type_of);
                      } else if (nameOfContactPController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_contact_person_name);
                      } else if (contactPnumberController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_contact_person_num);
                      } else if (contactPWanumberController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_contact_person_wnum);
                      }else{

                      }
                    })
              ],
            ),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
