import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/request/help_desk_req.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_edittext.dart';
import '../../customwidget/custom_text.dart';
import '../../models/help_desk_type_response.dart';
import '../../utils/preference.dart';
import '../../utils/push_notification_service.dart';
import '../../utils/tablenames.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class HelpDesk extends StatefulWidget {
  const HelpDesk({Key? key}) : super(key: key);

  @override
  State<HelpDesk> createState() => _HelpDeskState();
}

class _HelpDeskState extends State<HelpDesk> {
  final helpRepository = getIt.get<ApiRepository>();
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>? helpDeskTypeResponse = [];
  BaseApiResponseWithSerializable<HelpDeskTypeResponse>? helpDeskTypeResponses;
  TextEditingController helpNoteController = TextEditingController();
  int helpDeskId = 0;
  String helpPath = "", helpTitle = "";
  late PlatformFile helpAttechmentData;
  var cloudinary;
  List<String> assigned_to = [];
  List<String> assigned_to_token = [];
  List<String> authority_of = [];
  var hubName;
  var isLogin = 0;

  @override
  void initState() {
    super.initState();
    helpDeskType();
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      var loginData = PreferenceUtils.getLoginData();
      hubName = loginData.hubIds;
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      hubName = loginData.hubIds;
    } else if (isLogin == 3) {
      var loginData = PreferenceUtils.getLoginDataOrganization();
      hubName = [""];
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_add_help_desk),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  custom_text(
                    text: strings_name.str_help_desk_type,
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
                          child: DropdownButtonFormField<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>(
                            value: helpDeskTypeResponses,
                            elevation: 16,
                            style: blackText16,
                            focusColor: Colors.white,
                            onChanged: (BaseApiResponseWithSerializable<HelpDeskTypeResponse>? newValue) {
                              setState(() {
                                helpDeskId = newValue!.fields!.id!;
                                helpDeskTypeResponses = newValue;
                              });
                            },
                            items: helpDeskTypeResponse?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>>(
                                (BaseApiResponseWithSerializable<HelpDeskTypeResponse> value) {
                              return DropdownMenuItem<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>(
                                value: value,
                                child: Text(value.fields!.title.toString()),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  custom_text(
                    text: strings_name.str_help_note,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: helpNoteController,
                    topValue: 5,
                    maxLines: 5,
                    minLines: 4,
                    maxLength: 5000,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      custom_text(
                        text: strings_name.str_attachments,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        leftValue: 10,
                      ),
                      GestureDetector(
                        child: Container(
                            margin: const EdgeInsets.only(right: 10), child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black)),
                        onTap: () {
                          picLOIFile();
                        },
                      ),
                    ],
                  ),
                  Visibility(
                    visible: helpPath.isNotEmpty,
                    child: Column(
                      children: [
                        SizedBox(height: 3.h),
                        custom_text(text: helpTitle, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  CustomButton(
                    text: strings_name.str_submit,
                    click: () async {
                      if (helpDeskId == 0) {
                        Utils.showSnackBar(context, strings_name.str_empty_type_help);
                      } else if (helpNoteController.text.trim().toString().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_help_note);
                      } else {
                        createTicket();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }

  ByteData uint8ListToByteData(Uint8List uint8List) {
    final buffer = uint8List.buffer;
    return ByteData.view(buffer);
  }

  createTicket() async {
    authority_of.clear();
    if (helpDeskTypeResponses!.fields!.centerAutority != null) {
      await getEmployeeData(1);
    }

    assigned_to.clear();
    assigned_to_token.clear();
    if (helpDeskTypeResponses!.fields!.concernPerson != null) {
      await getEmployeeData(2);
    }

    setState(() {
      isVisible = true;
    });
    if (helpPath.isNotEmpty) {
      if (!kIsWeb) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(helpPath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_HELP_DESK),
        );
        helpPath = response.secureUrl;
      } else {
        try {
          CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromByteData(uint8ListToByteData(helpAttechmentData.bytes!),
                resourceType: CloudinaryResourceType.Auto,
                folder: TableNames.CLOUDARY_FOLDER_HELP_DESK,
                identifier: helpAttechmentData.name.toString()),
          );
          helpPath = response.secureUrl;
        } catch (e) {
          debugPrint('../ error helpPath $e');
        }
      }
    }

    HelpDeskRequest helpDeskReq = HelpDeskRequest();
    helpDeskReq.ticket_type_id = helpDeskTypeResponses?.id?.split("|||");
    helpDeskReq.Notes = helpNoteController.text.trim().toString();
    if (isLogin == 1) {
      helpDeskReq.createdByStudent = PreferenceUtils.getLoginRecordId().split(",");
    } else if (isLogin == 2) {
      helpDeskReq.createdByEmployee = PreferenceUtils.getLoginRecordId().split(",");
    } else if (isLogin == 3) {
      helpDeskReq.createdByOrganization = PreferenceUtils.getLoginRecordId().split(",");
    }
    if (helpPath.isNotEmpty) {
      Map<String, dynamic> map = Map();
      map["url"] = helpPath;
      List<Map<String, dynamic>> listData = [];
      listData.add(map);
      helpDeskReq.attachments = listData;
    }
    helpDeskReq.assigned_to = assigned_to;
    helpDeskReq.authority_of = authority_of;
    helpDeskReq.field_type = TableNames.HELPDESK_TYPE_TICKET;
    helpDeskReq.Status = TableNames.TICKET_STATUS_OPEN;
    try {
      var resp = await helpRepository.addHelpDeskApi(helpDeskReq);
      if (resp.id != null) {
        setState(() {
          isVisible = false;
        });
        debugPrint(assigned_to_token.length.toString());
        if (assigned_to_token.isNotEmpty) {
          PushNotificationService.sendNotificationToMultipleDevices(assigned_to_token, "", strings_name.str_push_desc_new_ticket_assigned);
        }
        Utils.showSnackBar(context, strings_name.str_create_ticket_message);
        await Future.delayed(const Duration(milliseconds: 2000));
        Get.back(result: true);
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

  Future<void> helpDeskType() async {
    setState(() {
      isVisible = true;
    });
    try {
      var resp = await helpRepository.getHelpdesk();
      if (resp.records != null) {
        setState(() {
          isVisible = false;
          helpDeskTypeResponse = resp.records;
        });
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

  picLOIFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        helpTitle = result.files.single.name;
        if (kIsWeb) {
          helpPath = result.files.single.bytes.toString();
          helpAttechmentData = result.files.single;
        } else {
          helpPath = result.files.single.path!;
        }
      });
    }
  }

  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? employeeData = [];
  String offset = "";

  /*
  * type : 1=authority, 2=assignee
  */
  getEmployeeData(int type) async {
    setState(() {
      if (!isVisible) isVisible = true;
    });

    var query = "";
    if (type == 1) {
      if (helpDeskTypeResponses!.fields!.centerAuthorityMobileNumber != null) {
        query += "OR(";
        for (int j = 0; j < helpDeskTypeResponses!.fields!.centerAuthorityMobileNumber!.length; j++) {
          query += "${TableNames.TB_USERS_PHONE}='${helpDeskTypeResponses!.fields?.centerAuthorityMobileNumber![j]}'";
          if (j + 1 < helpDeskTypeResponses!.fields!.centerAuthorityMobileNumber!.length) query += ",";
        }
        query += ")";
      }
    } else if (type == 2) {
      if (helpDeskTypeResponses!.fields!.concernPersonMobileNumber != null) {
        query += "OR(";
        for (int j = 0; j < helpDeskTypeResponses!.fields!.concernPersonMobileNumber!.length; j++) {
          query += "${TableNames.TB_USERS_PHONE}='${helpDeskTypeResponses!.fields?.concernPersonMobileNumber![j]}'";
          if (j + 1 < helpDeskTypeResponses!.fields!.concernPersonMobileNumber!.length) query += ",";
        }
        query += ")";
      }
    }
    debugPrint(query);

    try {
      var data = await helpRepository.getEmployeeListApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          employeeData?.clear();
        }
        employeeData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<ViewEmployeeResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getEmployeeData(type);
        } else {
          for (var j = 0; j < employeeData!.length; j++) {
            if (employeeData![j].fields!.accessible_hub_ids?.contains(hubName[0]) == true ||
                employeeData![j].fields!.hubIds?.contains(hubName[0]) == true) {
              if (type == 1) {
                authority_of.add(employeeData![j].id.toString());
              } else {
                assigned_to.add(employeeData![j].id.toString());
                if (employeeData![j].fields?.token?.isNotEmpty == true) {
                  assigned_to_token.add(employeeData![j].fields!.token.toString());
                }
              }
            }
          }
          employeeData = [];
          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            employeeData = [];
          }
        });
        offset = "";
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
