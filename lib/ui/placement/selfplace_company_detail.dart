import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/attachment_response.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/service_locator.dart';
import '../../models/base_api_response.dart';
import '../../models/company_detail_response.dart';
import '../../models/hub_response.dart';
import '../../models/request/create_company_det_req.dart';
import '../../models/typeofsectoreresponse.dart';
import '../../utils/preference.dart';
import '../../utils/utils.dart';

class SelfPlaceCompanyDetail extends StatefulWidget {
  const SelfPlaceCompanyDetail({Key? key}) : super(key: key);

  @override
  State<SelfPlaceCompanyDetail> createState() => _SelfPlaceCompanyDetailState();
}

class _SelfPlaceCompanyDetailState extends State<SelfPlaceCompanyDetail> {
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
  String typeofValue = "1";
  String path = "", title = "";
  var logoData, loiData;
  String loiPath = "", loiTitle = "";
  List<Map<String, CreateCompanyDetailRequest>> list = [];
  final companyDetailRepository = getIt.get<ApiRepository>();
  bool fromEdit = false;
  List<BaseApiResponseWithSerializable<CompanyDetailResponse>>? companyDetailData = [];
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  String hubRecordId = "";

  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  var cloudinary;

  List<String> companyIdentificationTypeArr = <String>[
    strings_name.str_identification_type,
    strings_name.str_type_pan_number,
    strings_name.str_type_gst_number,
  ];
  String companyIdentificationTypeValue = strings_name.str_identification_type;

  List<String> companySlabArr = <String>[
    TableNames.COMPANY_SLAB_20,
    TableNames.COMPANY_SLAB_40,
    TableNames.COMPANY_SLAB_60,
    TableNames.COMPANY_SLAB_80,
    TableNames.COMPANY_SLAB_100,
  ];
  String companySlabValue = TableNames.COMPANY_SLAB_20;

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
    } else if (isLogin == 1) {
      hubRecordId = PreferenceUtils.getLoginData().hubIds!.first;
    }
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    initialization();
  }

  Future<void> initialization() async {
    if (Get.arguments != null) {
      companyDetailData?.add(Get.arguments);
      fromEdit = true;
      setState(() {});
    }
    if (companyDetailData?.isNotEmpty == true) {
      setState(() {
        nameofCompanyController.text = companyDetailData![0].fields!.companyName.toString();
        companyIdnoController.text = companyDetailData![0].fields!.companyIdentityNumber.toString();
        nameOfContactPController.text = companyDetailData![0].fields!.contactName.toString();
        contactPdesiController.text = companyDetailData![0].fields!.contactDesignation.toString();
        contactPnumberController.text = companyDetailData![0].fields!.contactNumber.toString();
        contactPWanumberController.text = companyDetailData![0].fields!.contactWhatsappNumber.toString();
        companyLandlineController.text = companyDetailData![0].fields!.company_landline.toString();
        emailContactperController.text = companyDetailData![0].fields!.contactEmail.toString();
        companyWebsiteController.text = companyDetailData![0].fields!.companyWebsite.toString();
        reportBranchController.text = companyDetailData![0].fields!.reporting_branch.toString();
        reportAddressController.text = companyDetailData![0].fields!.reporting_address.toString();
        cityController.text = companyDetailData![0].fields!.city.toString();
        companySlabValue = companyDetailData![0].fields!.existing_slab ?? TableNames.COMPANY_SLAB_20;
        if (companyDetailData![0].fields!.company_loi != null) {
          loiPath = companyDetailData![0].fields!.company_loi!.first.url!;
          loiTitle = companyDetailData![0].fields!.company_loi!.first.filename!;
        }
        if (companyDetailData![0].fields!.company_logo != null) {
          path = companyDetailData![0].fields!.company_logo!.first.url!;
          title = companyDetailData![0].fields!.company_logo!.first.filename!;
        }

        for (var i = 0; i < typeofResponseArray!.length; i++) {
          if (companyDetailData![0].fields!.companySector?.first == typeofResponseArray![i].id) {
            setState(() {
              typeOfResponse = typeofResponseArray![i];
              typeofValue = typeofResponseArray![i].id!.toString();
            });
            break;
          }
        }
        for (var i = 0; i < hubResponseArray!.length; i++) {
          if (companyDetailData![0].fields!.hubIds?.first == hubResponseArray![i].id) {
            setState(() {
              hubResponse = hubResponseArray![i];
              hubValue = hubResponseArray![i].fields!.hubId.toString();
              hubRecordId = hubResponseArray![i].id!;
            });
            break;
          }
        }
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
                  const custom_text(
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
                  const custom_text(
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
                  const custom_text(
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
                  const custom_text(
                    text: strings_name.str_company_size,
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
                            value: companySlabValue,
                            style: blackText16,
                            focusColor: Colors.white,
                            onChanged: (String? newValue) {
                              setState(() {
                                companySlabValue = newValue!;
                              });
                            },
                            items: companySlabArr.map<DropdownMenuItem<String>>((String value) {
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
                  SizedBox(height: 5.h),
                  Visibility(
                    visible: PreferenceUtils.getIsLogin() != 1,
                    child: Column(
                      children: [
                        SizedBox(height: 5.h),
                        const custom_text(
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
                  SizedBox(height: 5.h),
                  const custom_text(
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
                  const custom_text(
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
                  const custom_text(
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
                  const custom_text(
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
                  const custom_text(
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
                  const custom_text(
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
                  const custom_text(
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
                  const custom_text(
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
                  const custom_text(
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
                  const custom_text(
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
                      const custom_text(
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
                      const custom_text(
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
                  const custom_text(
                    text: strings_name.str_file_size_limit,
                    alignment: Alignment.topLeft,
                    maxLines: 3,
                    textStyles: primaryTextSemiBold14,
                    leftValue: 10,
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                      text: strings_name.str_save,
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
                        } else if (companySlabValue.toString().trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_company_size);
                        } else if (typeofValue.toString().trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_type_of);
                        } else if (hubRecordId.isEmpty) {
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
                          String updatedPath = path, loiFilePath = loiPath;
                          if (path.isNotEmpty && !path.contains("https")) {
                            if (kIsWeb) {
                              CloudinaryResponse response = await cloudinary.uploadFile(
                                CloudinaryFile.fromByteData(Utils.uint8ListToByteData(logoData.bytes!), resourceType: CloudinaryResourceType.Image, folder: TableNames.CLOUDARY_FOLDER_COMPANY_LOGO, identifier: logoData.name),
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
                                CloudinaryFile.fromByteData(Utils.uint8ListToByteData(loiData.bytes!), resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_LOI, identifier: loiData.name),
                              );
                              loiFilePath = response.secureUrl;
                            } else {
                              CloudinaryResponse response = await cloudinary.uploadFile(
                                CloudinaryFile.fromFile(loiPath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_LOI),
                              );
                              loiFilePath = response.secureUrl;
                            }
                          }

                          BaseApiResponseWithSerializable<CompanyDetailResponse>? data = BaseApiResponseWithSerializable<CompanyDetailResponse>();
                          if (fromEdit) {
                            data = companyDetailData?.last;
                          }
                          CompanyDetailResponse response = CompanyDetailResponse();
                          response.companyName = nameofCompanyController.text.trim().toString();
                          response.companyIdentityNumber = companyIdnoController.text.trim().toString();
                          response.companySector = Utils.getTypeOfIndustryId(typeofValue)!.split(",");
                          response.contactName = nameOfContactPController.text.trim().toString();
                          response.contactDesignation = contactPdesiController.text.trim().toString();
                          response.contactNumber = contactPnumberController.text.trim().toString();
                          response.contactWhatsappNumber = contactPWanumberController.text.trim().toString();
                          response.company_landline = companyLandlineController.text.trim().toString();
                          response.contactEmail = emailContactperController.text.trim().toString();
                          response.companyWebsite = companyWebsiteController.text.trim().toString();
                          response.reporting_branch = reportBranchController.text.trim().toString();
                          response.reporting_address = reportAddressController.text.trim().toString();
                          response.city = cityController.text.trim().toString();
                          response.existing_slab = companySlabValue.trim().toString();
                          response.probable_vacancy = 1;
                          response.hubIds = hubRecordId.split(",");

                          if (updatedPath.isNotEmpty) {
                            AttachmentResponse attachment = AttachmentResponse();
                            attachment.url = updatedPath;
                            attachment.filename = title;
                            List<AttachmentResponse> listData = [];
                            listData.add(attachment);
                            response.company_logo = listData;
                          }

                          if (loiFilePath.isNotEmpty) {
                            AttachmentResponse attachment = AttachmentResponse();
                            attachment.url = loiFilePath;
                            attachment.filename = loiTitle;
                            List<AttachmentResponse> listData = [];
                            listData.add(attachment);
                            response.company_loi = listData;
                          } else {
                            AttachmentResponse attachment = AttachmentResponse();
                            attachment.url = loiPath;
                            attachment.filename = loiTitle;
                            List<AttachmentResponse> listData = [];
                            listData.add(attachment);
                            response.company_loi = listData;
                          }

                          data?.fields = response;
                          Get.back(closeOverlays: true, result: data);
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
}
