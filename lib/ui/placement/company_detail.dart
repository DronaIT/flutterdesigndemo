import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/service_locator.dart';
import '../../models/base_api_response.dart';
import '../../models/company_detail_response.dart';
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
  TextEditingController reportBranchController = TextEditingController();
  TextEditingController reportAddressController = TextEditingController();
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<TypeOfsectoreResponse>>? typeofResponseArray = [];
  BaseApiResponseWithSerializable<TypeOfsectoreResponse>? typeOfResponse;
  String typeofValue = "1";
  String path = "", title = "";
  String loiPath = "", loiTitle = "";
  List<Map<String, CreateCompanyDetailRequest>> list = [];
  final companyDetailRepository = getIt.get<ApiRepository>();
  bool fromEdit = false;
  List<BaseApiResponseWithSerializable<CompanyDetailResponse>>? compnayDetailData = [];

  var cloudinary;

  @override
  void initState() {
    super.initState();
    typeofResponseArray = PreferenceUtils.getTypeOFSectoreList().records;
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    initialization();
  }

  Future<void> initialization() async {
    if (Get.arguments != null) {
      setState(() {
        isVisible = true;
      });
      var query = "FIND('${Get.arguments}', ${TableNames.CLM_COMPANY_CODE}, 0)";
      var data = await companyDetailRepository.getCompanyDetailApi(query);
      if (data.records?.isNotEmpty == true) {
        setState(() {
          fromEdit = true;
        });
        compnayDetailData = data.records;
        if (compnayDetailData?.isNotEmpty == true) {
          setState(() {
            nameofCompanyController.text = compnayDetailData![0].fields!.companyName.toString();
            companyIdnoController.text = compnayDetailData![0].fields!.companyIdentityNumber.toString();
            nameOfContactPController.text = compnayDetailData![0].fields!.contactName.toString();
            contactPdesiController.text = compnayDetailData![0].fields!.contactDesignation.toString();
            contactPnumberController.text = compnayDetailData![0].fields!.contactNumber.toString();
            contactPWanumberController.text = compnayDetailData![0].fields!.contactWhatsappNumber.toString();
            companyLandlineController.text = compnayDetailData![0].fields!.company_landline.toString();
            emailContactperController.text = compnayDetailData![0].fields!.contactEmail.toString();
            companyWebsiteController.text = compnayDetailData![0].fields!.companyWebsite.toString();
            reportBranchController.text = compnayDetailData![0].fields!.reporting_branch.toString();
            reportAddressController.text = compnayDetailData![0].fields!.reporting_address.toString();
            cityController.text = compnayDetailData![0].fields!.city.toString();
            for (var i = 0; i < typeofResponseArray!.length; i++) {
              if (compnayDetailData![0].fields!.id == typeofResponseArray![i].fields!.id) {
                setState(() {
                  typeOfResponse = typeofResponseArray![i];
                  typeofValue = typeofResponseArray![i].id!.toString();
                });
                break;
              }
            }
          });
        }
      } else {
        Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
      setState(() {
        isVisible = false;
      });
    }
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
                    text: strings_name.str_type_of_industry,
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
                    controller: reportBranchController,
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
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      custom_text(
                        text: strings_name.str_logo_of_company,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        leftValue: 10,
                      ),
                      GestureDetector(
                        child: Container(margin: const EdgeInsets.only(right: 10), child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black)),
                        onTap: () {
                          picImage();
                        },
                      ),
                    ],
                  ),
                  Visibility(
                    visible: title.isNotEmpty,
                    child: Column(
                      children: [
                        SizedBox(height: 3.h),
                        custom_text(text: title, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      custom_text(
                        text: strings_name.str_letter_of_intent,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        leftValue: 10,
                      ),
                      GestureDetector(
                        child: Container(margin: const EdgeInsets.only(right: 10), child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black)),
                        onTap: () {
                          picLOIFile();
                        },
                      ),
                    ],
                  ),
                  Visibility(
                    visible: loiPath.isNotEmpty,
                    child: Column(
                      children: [
                        SizedBox(height: 3.h),
                        custom_text(text: loiTitle, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                      text: strings_name.str_submit,
                      click: () async {
                        var phone = FormValidator.validatePhone(contactPnumberController.text.toString().trim());
                        if (nameofCompanyController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_company_name);
                        } else if (companyIdnoController.text.toString().trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_company_id_no);
                        } else if (typeofValue.toString().trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_type_of);
                        } else if (nameOfContactPController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_contact_person_name);
                        } else if (contactPdesiController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empaty_contact_desi);
                        } else if (phone.isNotEmpty) {
                          Utils.showSnackBar(context, phone);
                        } else if (emailContactperController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_company_email);
                        } else if (reportBranchController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_reporting_branch);
                        } else if (reportAddressController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_reporting_address);
                        } else if (cityController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_city);
                        } else if (loiPath.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_letter_of_intent);
                        } else {
                          setState(() {
                            isVisible = true;
                          });
                          var updatedPath = "", loiFilePath = "";
                          if (path.isNotEmpty) {
                            CloudinaryResponse response = await cloudinary.uploadFile(
                              CloudinaryFile.fromFile(path, resourceType: CloudinaryResourceType.Image, folder: TableNames.CLOUDARY_FOLDER_COMPANY_LOGO),
                            );
                            updatedPath = response.secureUrl;
                          }
                          if (loiPath.isNotEmpty) {
                            CloudinaryResponse response = await cloudinary.uploadFile(
                              CloudinaryFile.fromFile(loiPath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_LOI),
                            );
                            loiFilePath = response.secureUrl;
                          }
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
                          response.reporting_branch = reportBranchController.text.trim().toString();
                          response.reporting_address = reportAddressController.text.trim().toString();
                          response.city = cityController.text.trim().toString();

                          if (updatedPath.isNotEmpty) {
                            Map<String, dynamic> map = Map();
                            map["url"] = updatedPath;
                            List<Map<String, dynamic>> listData = [];
                            listData.add(map);

                            response.company_logo = listData;
                          }

                          if (loiFilePath.isNotEmpty) {
                            Map<String, dynamic> map = Map();
                            map["url"] = loiFilePath;
                            List<Map<String, dynamic>> listData = [];
                            listData.add(map);

                            response.company_loi = listData;
                          }

                          Map<String, CreateCompanyDetailRequest> map = Map();
                          map["fields"] = response;
                          list.add(map);

                          if (!fromEdit) {
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
                          } else {
                            var resp = await companyDetailRepository.updateCompanyDetailApi(response.toJson(), compnayDetailData![0].id.toString());
                            if (resp.id!.isNotEmpty) {
                              setState(() {
                                isVisible = false;
                              });
                              Utils.showSnackBar(context, strings_name.str_company_updated);
                              await Future.delayed(const Duration(milliseconds: 2000));
                              Get.back(closeOverlays: true, result: true);
                            } else {
                              setState(() {
                                isVisible = false;
                              });
                            }
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

  picImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        title = result.files.single.name;
        path = result.files.single.path!;
      });
    }
  }

  picLOIFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        loiTitle = result.files.single.name;
        loiPath = result.files.single.path!;
      });
    }
  }
}
