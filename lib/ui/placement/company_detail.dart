import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/service_locator.dart';
import '../../models/base_api_response.dart';
import '../../models/request/create_company_appr_req.dart';
import '../../models/request/create_company_det_req.dart';
import '../../models/typeofsectoreresponse.dart';
import '../../utils/preference.dart';
import '../../utils/utils.dart';

class CompanyDetail extends StatefulWidget {
  const CompanyDetail({Key? key}) : super(key: key);

  @override
  State<CompanyDetail> createState() => _CompanyDetailState();
}

class _CompanyDetailState extends State<CompanyDetail> {
  TextEditingController nameofCompanyController = TextEditingController();
  TextEditingController companyIdnoController = TextEditingController();
  TextEditingController nameOfContactPController = TextEditingController();
  TextEditingController contactPnumberController = TextEditingController();
  TextEditingController contactPWanumberController = TextEditingController();
  TextEditingController contactPdesiController = TextEditingController();
  TextEditingController companyLandlineController = TextEditingController();
  TextEditingController emailContactperController = TextEditingController();
  TextEditingController companyWebsiteController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  TextEditingController repotBranchController = TextEditingController();
  TextEditingController reportAddressController = TextEditingController();
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<TypeOfsectoreResponse>>? typeofResponseArray = [];
  BaseApiResponseWithSerializable<TypeOfsectoreResponse>? typeOfResponse;
  String typeofValue = "1";
  String path="test";
  List<Map<String, CreateCompanyDetailRequest>> list = [];
  final companyDetailRepository = getIt.get<ApiRepository>();

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
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_company_detail),
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
                    text: strings_name.str_company_id_no,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: companyIdnoController,
                    topValue: 5,
                  ),
                  SizedBox(height: 5.h),

                  custom_text(
                    text: strings_name.str_type_of_inducstry,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
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
                    text: strings_name.str_contact_person_designation,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: contactPdesiController,
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
                    maxLength: 10,
                    textInputAction: TextInputAction.next,
                    controller: contactPWanumberController,
                    topValue: 5,
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_company_lan_num,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    controller: companyLandlineController,

                    topValue: 5,
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_contact_person_email,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: emailContactperController,
                    topValue: 5,
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_company_website,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: companyWebsiteController,
                    topValue: 5,
                  ),
                  SizedBox(height: 3.h),

                  custom_text(
                    text: strings_name.str_reporting_branch,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: repotBranchController,
                    topValue: 5,
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_reporting_address,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: reportAddressController,
                    topValue: 5,
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_city,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: cityController,
                    topValue: 5,
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      custom_text(
                        text: strings_name.str_logo_of_company,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        leftValue: 10,
                      ),
                      Container(
                          margin: const EdgeInsets.only(right: 30),
                          child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black)),

                    ],
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                      text: path,
                      alignment: Alignment.topLeft,
                      textStyles: grayTextstyle,
                      topValue: 0,bottomValue: 0
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(text: strings_name.str_submit, click: () async {
                    var phone = FormValidator.validatePhone(contactPnumberController.text.toString().trim());
                    if (nameofCompanyController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_company_name);
                    } else if (companyIdnoController.text.toString().trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_company_id_no);
                    } else if (typeofValue.toString().trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_type_of);
                    } else if (nameOfContactPController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_contact_person_name);
                    }  else if (contactPdesiController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empaty_contact_desi);
                    } else if (phone.isNotEmpty) {
                      Utils.showSnackBar(context, phone);
                    } else if (emailContactperController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_company_email);
                    } else if (repotBranchController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_reporting_branch);
                    } else if (reportAddressController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_reporting_address);
                    } else if (cityController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_city);
                    } else{
                      setState(() {
                        isVisible = true;
                      });

                      CreateCompanyDetailRequest response = CreateCompanyDetailRequest();
                      response.company_name = nameofCompanyController.text.trim().toString();
                      response.company_identity_number = companyIdnoController.text.trim().toString();
                      response.company_sector = Utils.getTypeOfIndustryId(typeofValue)!.split(",");
                      response.contact_name = nameOfContactPController.text.trim().toString();
                      response.contact_designation = contactPdesiController.text.trim().toString();
                      response.contact_number = contactPnumberController.text.trim().toString();
                      response.contact_whatsapp_number = contactPWanumberController.text.trim().toString();
                      response.company_landline = companyLandlineController.text.trim().toString();
                      response.contact_email = emailContactperController.text.trim().toString();
                      response.company_website = companyWebsiteController.text.trim().toString();
                      response.reporting_branch = repotBranchController.text.trim().toString();
                      response.reporting_address = reportAddressController.text.trim().toString();
                      response.city = cityController.text.trim().toString();
                      Map<String, CreateCompanyDetailRequest> map = Map();
                      map["fields"] = response;
                      list.add(map);
                      var resp = await companyDetailRepository.createCopmanyDetailApi(list);
                      if (resp.records!.isNotEmpty) {
                        setState(() {
                          isVisible = false;
                        });
                        Utils.showSnackBar(context, strings_name.str_company_det_added);
                        await Future.delayed(const Duration(milliseconds: 2000));
                        Get.back(closeOverlays: true);
                      } else {
                        setState(() {
                          isVisible = false;
                        });
                      }
                    }

                  }),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
            Center(
              child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
            )
          ],
        ),
      ),
    );
  }
}
