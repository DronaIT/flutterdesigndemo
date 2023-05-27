import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/request/help_desk_req.dart';
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
  var cloudinary;
  List<String> hub_ids = [];
  var hubName;

  @override
  void initState() {
    super.initState();
    helpDeskType();
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      var loginData = PreferenceUtils.getLoginData();
      hubName = loginData.hubIdFromHubIds;
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      hubName = loginData.hubIdFromHubIds;
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_help_desk),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
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
                            items: helpDeskTypeResponse?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>>((BaseApiResponseWithSerializable<HelpDeskTypeResponse> value) {
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
                  SizedBox(height: 10.h),
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
                        child: Container(margin: const EdgeInsets.only(right: 10), child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black)),
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
                        setState(() {
                          isVisible = true;
                        });
                        if (helpPath.isNotEmpty) {
                          CloudinaryResponse response = await cloudinary.uploadFile(
                            CloudinaryFile.fromFile(helpPath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_HELP_DESK),
                          );
                          helpPath = response.secureUrl;
                        }
                        if (helpDeskTypeResponses!.fields!.centerAutority != null) {
                          for (int j = 0; j < helpDeskTypeResponses!.fields!.centerAutority!.length; j++) {
                            if (helpDeskTypeResponses!.fields!.centerAuthorityHubId![j] == hubName[0]) {
                              if (hub_ids.isEmpty || !hub_ids.contains(helpDeskTypeResponses!.fields!.centerAutority![j])) {
                                hub_ids.add(helpDeskTypeResponses!.fields!.centerAutority![j]);
                              }
                            }
                          }
                        }

                        if (helpDeskTypeResponses!.fields!.concernPerson != null) {
                          for (int j = 0; j < helpDeskTypeResponses!.fields!.concernPerson!.length; j++) {
                            if (helpDeskTypeResponses!.fields!.concernPersonHubId![j] == hubName[0]) {
                              if (hub_ids.isEmpty || !hub_ids.contains(helpDeskTypeResponses!.fields!.concernPerson![j])) {
                                hub_ids.add(helpDeskTypeResponses!.fields!.concernPerson![j]);
                              }
                            }
                          }
                        }

                        HelpDeskRequest helpDeskReq = HelpDeskRequest();
                        helpDeskReq.ticket_type_id = helpDeskTypeResponses?.id?.split("|||");
                        helpDeskReq.Notes = helpNoteController.text.trim().toString();
                        if (helpPath.isNotEmpty) {
                          Map<String, dynamic> map = Map();
                          map["url"] = helpPath;
                          List<Map<String, dynamic>> listData = [];
                          listData.add(map);
                          helpDeskReq.attachments = listData;
                        }
                        helpDeskReq.assigned_to = hub_ids;
                        try {
                          var resp = await helpRepository.addHelpDeskApi(helpDeskReq);
                          if (resp.id != null) {
                            setState(() {
                              isVisible = false;
                            });
                            Utils.showSnackBar(context, strings_name.str_company_updated);
                            await Future.delayed(const Duration(milliseconds: 2000));
                            Get.back();
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

  Future<void> helpDeskType() async {
    setState(() {
      isVisible = true;
    });
    try {
      var resp = await helpRepository.getHelpdesk();
      if (resp != null) {
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
        helpPath = result.files.single.path!;
      });
    }
  }
}
