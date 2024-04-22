import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/manage_user/hub_selection.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../models/base_api_response.dart';
import '../../models/company_detail_response.dart';
import '../../models/hub_response.dart';
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
  List<BaseApiResponseWithSerializable<TypeOfSectorResponse>>? typeofResponseArray = [];
  BaseApiResponseWithSerializable<TypeOfSectorResponse>? typeOfResponse;
  String typeofValue = "";
  String path = "", title = "";
  var logoData, loiData;
  String loiPath = "", loiTitle = "";
  List<Map<String, CreateCompanyDetailRequest>> list = [];
  final companyDetailRepository = getIt.get<ApiRepository>();
  bool fromEdit = false;
  List<BaseApiResponseWithSerializable<CompanyDetailResponse>>? compnayDetailData = [];
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  String hubRecordId = "";

  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];
  List<BaseApiResponseWithSerializable<HubResponse>>? accessibleHubsData = [];

  var cloudinary;

  List<String> companyIdentificationTypeArr = <String>[
    strings_name.str_identification_type,
    strings_name.str_type_pan_number,
    strings_name.str_type_gst_number,
  ];
  String companyIdentificationTypeValue = strings_name.str_identification_type;

  @override
  void initState() {
    super.initState();
    typeofResponseArray = PreferenceUtils.getTypeOFSectoreList().records;
    hubResponseArray = PreferenceUtils.getHubList().records;
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      if ((loginData.accessible_hub_ids?.length ?? 0) > 0) {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          var isAccessible = false;
          for (var j = 0; j < loginData.accessible_hub_ids!.length; j++) {
            if (loginData.accessible_hub_ids![j] == hubResponseArray![i].id) {
              isAccessible = true;
              break;
            }
            if (loginData.hubIdFromHubIds?.first == hubResponseArray![i].fields?.hubId) {
              isAccessible = true;
              break;
            }
          }
          if (!isAccessible) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      } else {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          if (loginData.hubIdFromHubIds?.first != hubResponseArray![i].fields?.hubId) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      }
    }
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    initialization();
  }

  Future<void> initialization() async {
    if (Get.arguments != null) {
      setState(() {
        isVisible = true;
      });
      var query = "FIND('${Get.arguments}', ${TableNames.CLM_COMPANY_CODE}, 0)";
      try {
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
              if (compnayDetailData![0].fields!.company_loi != null) {
                loiPath = compnayDetailData![0].fields!.company_loi!.first.url!;
                loiTitle = compnayDetailData![0].fields!.company_loi!.first.filename!;
              }

              for (var i = 0; i < typeofResponseArray!.length; i++) {
                if (compnayDetailData![0].fields!.companySector?.first == typeofResponseArray![i].id) {
                  setState(() {
                    typeOfResponse = typeofResponseArray![i];
                    typeofValue = typeofResponseArray![i].id!.toString();
                  });
                  break;
                }
              }
              for (var i = 0; i < hubResponseArray!.length; i++) {
                if (compnayDetailData![0].fields!.hubIds?.contains(hubResponseArray![i].id) == true) {
                  // setState(() {
                  //   hubResponse = hubResponseArray![i];
                  //   hubValue = hubResponseArray![i].fields!.hubId.toString();
                  //   hubRecordId = hubResponseArray![i].id!;
                  // });
                  // break;
                  accessibleHubsData!.add(hubResponseArray![i]);
                }
              }
            });
          }
        } else {
          Utils.showSnackBar(context, strings_name.str_something_wrong);
        }
      } on DioError catch (e) {
        setState(() {
          isVisible = false;
        });
        final errorMessage = DioExceptions.fromDioError(e).toString();
        Utils.showSnackBarUsingGet(errorMessage);
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
                            value: companyIdentificationTypeValue,
                            style: blackText16,
                            focusColor: Colors.white,
                            onChanged: (String? newValue) {
                              setState(() {
                                companyIdentificationTypeValue = newValue!;
                              });
                            },
                            items: companyIdentificationTypeArr.map<DropdownMenuItem<String>>((String value) {
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
                  custom_edittext(
                    type: TextInputType.text,
                    capitalization: TextCapitalization.characters,
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
                          child: DropdownButtonFormField<BaseApiResponseWithSerializable<TypeOfSectorResponse>>(
                            elevation: 16,
                            style: blackText16,
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
                  Visibility(
                    visible: false,
                    child: Column(
                      children: [
                        custom_text(
                          text: strings_name.str_select_hub,
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                          bottomValue: 0,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                          width: MediaQuery.of(context).size.width,
                          child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                            value: hubResponse,
                            elevation: 16,
                            style: blackText16,
                            focusColor: Colors.white,
                            onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                              setState(() {
                                hubValue = newValue!.fields!.hubId!.toString();
                                hubRecordId = newValue.id!;
                                hubResponse = newValue;
                              });
                            },
                            items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
                              return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                                value: value,
                                child: Text(value.fields!.hubName!.toString()),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        custom_text(
                          text: strings_name.str_select_hub,
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                        ),
                        GestureDetector(
                          child: custom_text(
                            text: accessibleHubsData?.isEmpty == true ? strings_name.str_add : strings_name.str_update,
                            alignment: Alignment.topLeft,
                            textStyles: primaryTextSemiBold16,
                          ),
                          onTap: () {
                            Get.to(const HubSelection(), arguments: accessibleHubsData)?.then((result) {
                              if (result != null) {
                                setState(() {
                                  accessibleHubsData = result;
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  accessibleHubsData!.isNotEmpty
                      ? ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: accessibleHubsData?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 5,
                              child: GestureDetector(
                                child: Container(
                                  color: colors_name.colorWhite,
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text("${accessibleHubsData![index].fields!.hubName}", textAlign: TextAlign.start, style: blackText16)),
                                      const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // Get.to(const (), arguments: unitsData![index].fields?.ids);
                                },
                              ),
                            );
                          })
                      : Container(),
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
                    maxLength: 5000,
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
                  custom_text(
                    text: strings_name.str_file_size_limit,
                    alignment: Alignment.topLeft,
                    maxLines: 3,
                    textStyles: primaryTextSemiBold14,
                    leftValue: 10,
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                      text: strings_name.str_submit,
                      click: () async {
                        var phone = FormValidator.validatePhone(contactPnumberController.text.toString().trim());
                        var cinNumber = FormValidator.validateCompanyNumber(companyIdnoController.text.toString().trim().toUpperCase(), companyIdentificationTypeValue);
                        if (nameofCompanyController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_company_name);
                        } else if (companyIdentificationTypeValue == strings_name.str_identification_type) {
                          Utils.showSnackBar(context, strings_name.str_identification_type);
                        } else if (companyIdnoController.text.toString().trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_company_id_no);
                        } else if (cinNumber.isNotEmpty) {
                          Utils.showSnackBar(context, cinNumber);
                        } else if (typeofValue.toString().trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_type_of);
                          // } else if (hubValue.toString().trim().isEmpty) {
                        } else if (accessibleHubsData!.isEmpty == true) {
                          Utils.showSnackBar(context, strings_name.str_empty_hub);
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
                            if (kIsWeb) {
                              CloudinaryResponse response = await cloudinary.uploadFile(
                                CloudinaryFile.fromByteData(Utils.uint8ListToByteData(logoData.bytes!),
                                    resourceType: CloudinaryResourceType.Image, folder: TableNames.CLOUDARY_FOLDER_COMPANY_LOGO, identifier: logoData.name),
                              );
                              updatedPath = response.secureUrl;
                            } else {
                              CloudinaryResponse response = await cloudinary.uploadFile(
                                CloudinaryFile.fromFile(path, resourceType: CloudinaryResourceType.Image, folder: TableNames.CLOUDARY_FOLDER_COMPANY_LOGO),
                              );
                              updatedPath = response.secureUrl;
                            }
                          }
                          if (loiPath.isNotEmpty && !loiPath.contains("https")) {
                            if (kIsWeb) {
                              CloudinaryResponse response = await cloudinary.uploadFile(
                                CloudinaryFile.fromByteData(Utils.uint8ListToByteData(loiData.bytes!),
                                    resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_LOI, identifier: loiData.name),
                              );
                              loiFilePath = response.secureUrl;
                            } else {
                              CloudinaryResponse response = await cloudinary.uploadFile(
                                CloudinaryFile.fromFile(loiPath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_LOI),
                              );
                              loiFilePath = response.secureUrl;
                            }
                          }
                          CreateCompanyDetailRequest response = CreateCompanyDetailRequest();
                          response.company_name = nameofCompanyController.text.trim().toString();
                          response.company_identity_number = companyIdnoController.text.trim().toUpperCase().toString();
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
                          // response.hub_id = hubRecordId.split(",");

                          List<String> accessibleHubList = [];
                          for (var i = 0; i < accessibleHubsData!.length; i++) {
                            accessibleHubList.add(accessibleHubsData![i].id.toString());
                          }
                          response.hub_id = accessibleHubList;

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
                          } else {
                            Map<String, dynamic> map = Map();
                            map["url"] = loiPath;
                            List<Map<String, dynamic>> listData = [];
                            listData.add(map);
                            response.company_loi = listData;
                          }

                          Map<String, CreateCompanyDetailRequest> map = Map();
                          map["fields"] = response;
                          list.add(map);

                          if (!fromEdit) {
                            try {
                              var resp = await companyDetailRepository.createCompanyDetailApi(list);
                              if (resp.records!.isNotEmpty) {
                                setState(() {
                                  isVisible = false;
                                });
                                if (resp.records?.last.id?.isNotEmpty == true) {
                                  assignCompany(resp.records?.last.id ?? "");
                                } else {
                                  Utils.showSnackBar(context, strings_name.str_company_det_added);
                                  await Future.delayed(const Duration(milliseconds: 2000));
                                  Get.back(closeOverlays: true);
                                }
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
                          } else {
                            try {
                              var json = response.toJson();
                              json.removeWhere((key, value) => value == null);

                              var resp = await companyDetailRepository.updateCompanyDetailApi(json, compnayDetailData![0].id.toString());
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
                  SizedBox(height: 20.h),
                ],
              ),
            ),
            Visibility(
              visible: isVisible,
              child: Container(
                color: colors_name.colorWhite,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  picImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      title = result.files.single.name;
      if (kIsWeb) {
        setState(() {
          path = result.files.single.bytes.toString();
          logoData = result.files.single;
        });
      } else {
        setState(() {
          path = result.files.single.path!;
        });
      }
    }
  }

  picLOIFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      if (result.files.single.size / (1024 * 1024) < 2) {
        loiTitle = result.files.single.name;
        if (kIsWeb) {
          setState(() {
            loiData = result.files.single;
            loiPath = result.files.single.bytes.toString();
          });
        } else {
          setState(() {
            loiPath = result.files.single.path!;
          });
        }
      } else {
        Utils.showSnackBar(context, strings_name.str_file_size_limit);
      }
    }
  }

  assignCompany(String id) async {
    try {
      setState(() {
        isVisible = true;
      });
      List<String> studentData = [];
      studentData.addAll(PreferenceUtils.getLoginDataEmployee().assigned_company ?? []);
      if (id.isNotEmpty) {
        studentData.add(id);
      }

      Map<String, dynamic> mapRequest = {"assigned_company": studentData};
      var resp = await companyDetailRepository.updateEmployeeApi(mapRequest, PreferenceUtils.getLoginRecordId());
      if (resp.id!.isNotEmpty) {
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
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }
}
