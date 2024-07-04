import 'package:dio/dio.dart';
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
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../models/base_api_response.dart';
import '../../models/request/create_company_appr_req.dart';
import '../../models/typeofsectoreresponse.dart';
import '../../utils/preference.dart';

class CompanyApproach extends StatefulWidget {
  const CompanyApproach({Key? key}) : super(key: key);

  @override
  State<CompanyApproach> createState() => _CompanyApproachState();
}

class _CompanyApproachState extends State<CompanyApproach> {
  TextEditingController nameofCompanyController = TextEditingController();
  TextEditingController typeOfController = TextEditingController();
  TextEditingController nameOfContactPController = TextEditingController();
  TextEditingController contactPnumberController = TextEditingController();
  TextEditingController contactPWanumberController = TextEditingController();
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<TypeOfSectorResponse>>? typeofResponseArray = [];
  BaseApiResponseWithSerializable<TypeOfSectorResponse>? typeOfResponse;
  List<Map<String, CreateCompanyApproveRequest>> list = [];
  String typeofValue = "";
  final companyaRepository = getIt.get<ApiRepository>();

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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_company_approach),
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
                  text: strings_name.str_type_of_industry,
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
                        child: DropdownButtonFormField<BaseApiResponseWithSerializable<TypeOfSectorResponse>>(
                          elevation: 16,
                          style: blackText16,
                          isExpanded: true,
                          value: typeOfResponse,
                          focusColor: Colors.white,
                          onChanged: (BaseApiResponseWithSerializable<TypeOfSectorResponse>? newValue) {
                            setState(() {
                              typeofValue = newValue!.id!;
                              typeOfResponse = newValue;
                            });
                          },
                          items: typeofResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<TypeOfSectorResponse>>>((BaseApiResponseWithSerializable<TypeOfSectorResponse> value) {
                            return DropdownMenuItem<BaseApiResponseWithSerializable<TypeOfSectorResponse>>(
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
                  type: TextInputType.phone,
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
                  type: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  controller: contactPWanumberController,
                  maxLength: 10,
                  topValue: 5,
                ),
                SizedBox(height: 20.h),
                CustomButton(
                    text: strings_name.str_submit,
                    click: () async {
                      var phone = FormValidator.validatePhone(contactPnumberController.text.toString().trim());
                      if (nameofCompanyController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_company_name);
                      } else if (typeofValue.toString().trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_type_of);
                      } else if (nameOfContactPController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_contact_person_name);
                      } else if (phone.isNotEmpty) {
                        Utils.showSnackBar(context, phone);
                      } else {
                        setState(() {
                          isVisible = true;
                        });
                        CreateCompanyApproveRequest response = CreateCompanyApproveRequest();
                        response.company_name = nameofCompanyController.text.trim().toString();
                        response.contact_person_name = nameOfContactPController.text.trim().toString();
                        response.contact_person_no = contactPnumberController.text.trim().toString();
                        response.contact_person_whatsapp_no = contactPWanumberController.text.trim().toString();
                        response.type_of_industory = Utils.getTypeOfIndustryId(typeofValue)!.split(",");
                        Map<String, CreateCompanyApproveRequest> map = Map();
                        map["fields"] = response;
                        list.add(map);
                        try {
                          var resp = await companyaRepository.creCompanyApprochApi(list);
                          if (resp.records!.isNotEmpty) {
                            setState(() {
                              isVisible = false;
                            });
                            Utils.showSnackBar(context, strings_name.str_company_a_added);
                            await Future.delayed(const Duration(milliseconds: 2000));
                            Get.back(closeOverlays: true);
                          } else {
                            setState(() {
                              isVisible = false;
                            });
                          }
                        } on DioError catch (e) {
                          setState(() {
                            isVisible = false;
                          });
                          final errorMessage = DioExceptions.fromDioError(e).toString();
                          Utils.showSnackBarUsingGet(errorMessage);
                        }
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
