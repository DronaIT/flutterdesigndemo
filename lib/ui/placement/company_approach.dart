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

import '../../models/base_api_response.dart';
import '../../models/typeofsectoreresponse.dart';
import '../../utils/preference.dart';

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
  List<BaseApiResponseWithSerializable<TypeOfsectoreResponse>>? typeofResponseArray = [];
  BaseApiResponseWithSerializable<TypeOfsectoreResponse>? typeOfResponse;

  String typeofValue = "1";

  @override
  void initState() {
    super.initState();
    typeofResponseArray = PreferenceUtils.getTypeOFSectoreList().records;
  }

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
                        child: DropdownButtonFormField<BaseApiResponseWithSerializable<TypeOfsectoreResponse>>(
                          elevation: 16,
                          style: blackText16,
                          value: typeOfResponse,
                          focusColor: Colors.white,
                          onChanged: (BaseApiResponseWithSerializable<TypeOfsectoreResponse>? newValue) {
                            setState(() {
                              typeofValue = newValue!.id!;
                              typeOfResponse = newValue;
                            });
                          },
                          items: typeofResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<TypeOfsectoreResponse>>>((BaseApiResponseWithSerializable<TypeOfsectoreResponse> value) {
                            return DropdownMenuItem<BaseApiResponseWithSerializable<TypeOfsectoreResponse>>(
                              value: value,
                              child: Text(value.fields!.sectorTitle!.toString()),
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
                  type: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: contactPnumberController,
                  maxLength: 10,
                  topValue: 5,
                ),
                SizedBox(height: 3.h),

                custom_text(
                  text: strings_name.str_contact_person_wanumber,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: contactPWanumberController,
                  maxLength: 10,
                  topValue: 5,
                ),
                SizedBox(height: 20.h),
                CustomButton(
                    text: strings_name.str_submit,
                    click: () {
                      var phone = FormValidator.validatePhone(contactPnumberController.text.toString().trim());
                      if (nameofCompanyController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_company_name);
                      } else if (typeofValue.toString().trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_type_of);
                      } else if (nameOfContactPController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_contact_person_name);
                      } else if (phone.isNotEmpty) {
                        Utils.showSnackBar(context,phone);
                      }
                      //
                      // else if (contactPWanumberController.text.trim().isEmpty) {
                      //   Utils.showSnackBar(context, strings_name.str_contact_person_wnum);
                      // }

                      else{

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
