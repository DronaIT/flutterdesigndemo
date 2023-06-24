import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
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

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;
  var cloudinary;

  List<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>? taskTypeResponse = [];
  BaseApiResponseWithSerializable<HelpDeskTypeResponse>? taskTypeResponses;

  TextEditingController taskNoteController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  int durationHrsController = 0, durationMinController = 0, taskTypeId = 0;
  String taskFilePath = "", taskFileTitle = "";

  List<String> assignedTo = [];
  List<String> authorityOf = [];

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
      hubName = loginData.hubIdFromHubIds;
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      hubName = loginData.hubIdFromHubIds;
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_add_task),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  custom_text(
                    text: strings_name.str_task_type,
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
                            value: taskTypeResponses,
                            elevation: 16,
                            style: blackText16,
                            focusColor: Colors.white,
                            onChanged: (BaseApiResponseWithSerializable<HelpDeskTypeResponse>? newValue) {
                              setState(() {
                                taskTypeId = newValue!.fields!.id!;
                                taskTypeResponses = newValue;
                              });
                            },
                            items: taskTypeResponse?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>>((BaseApiResponseWithSerializable<HelpDeskTypeResponse> value) {
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
                    text: strings_name.str_task_detail,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: taskNoteController,
                    topValue: 5,
                    maxLines: 5,
                    minLines: 4,
                    maxLength: 5000,
                  ),
                  SizedBox(height: 5.h),
                  custom_text(
                    text: strings_name.str_task_detail,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  InkWell(
                    child: IgnorePointer(
                      child: custom_edittext(
                        hintText: strings_name.str_required_duration,
                        type: TextInputType.none,
                        textInputAction: TextInputAction.next,
                        controller: durationController,
                        topValue: 0,
                      ),
                    ),
                    onTap: () {
                      onTap();
                    },
                  ),
                  SizedBox(height: 5.h),
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
                    visible: taskFilePath.isNotEmpty,
                    child: Column(
                      children: [
                        SizedBox(height: 3.h),
                        custom_text(text: taskFileTitle, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  CustomButton(
                    text: strings_name.str_submit,
                    click: () async {
                      if (taskTypeId == 0) {
                        Utils.showSnackBar(context, strings_name.str_empty_type_task);
                      } else if (taskNoteController.text.trim().toString().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_task_note);
                      } else {
                        setState(() {
                          isVisible = true;
                        });
                        if (taskFilePath.isNotEmpty) {
                          CloudinaryResponse response = await cloudinary.uploadFile(
                            CloudinaryFile.fromFile(taskFilePath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_HELP_DESK),
                          );
                          taskFilePath = response.secureUrl;
                        }
                        if (taskTypeResponses!.fields!.centerAutority != null) {
                          for (int j = 0; j < taskTypeResponses!.fields!.centerAutority!.length; j++) {
                            if (taskTypeResponses!.fields!.centerAuthorityHubId![j] == hubName[0]) {
                              if (authorityOf.isEmpty || !authorityOf.contains(taskTypeResponses!.fields!.centerAutority![j])) {
                                authorityOf.add(taskTypeResponses!.fields!.centerAutority![j]);
                              }
                            }
                          }
                        }

                        if (taskTypeResponses!.fields!.concernPerson != null) {
                          for (int j = 0; j < taskTypeResponses!.fields!.concernPerson!.length; j++) {
                            if (taskTypeResponses!.fields!.concernPersonHubId![j] == hubName[0]) {
                              if (assignedTo.isEmpty || !assignedTo.contains(taskTypeResponses!.fields!.concernPerson![j])) {
                                assignedTo.add(taskTypeResponses!.fields!.concernPerson![j]);
                              }
                            }
                          }
                        }

                        HelpDeskRequest helpDeskReq = HelpDeskRequest();
                        helpDeskReq.ticket_type_id = taskTypeResponses?.id?.split("|||");
                        helpDeskReq.Notes = taskNoteController.text.trim().toString();
                        if (isLogin == 1) {
                          helpDeskReq.createdByStudent = PreferenceUtils.getLoginRecordId().split(",");
                        } else if (isLogin == 2) {
                          helpDeskReq.createdByEmployee = PreferenceUtils.getLoginRecordId().split(",");
                        } else if (isLogin == 3) {
                          helpDeskReq.createdByOrganization = PreferenceUtils.getLoginRecordId().split(",");
                        }
                        if (taskFilePath.isNotEmpty) {
                          Map<String, dynamic> map = Map();
                          map["url"] = taskFilePath;
                          List<Map<String, dynamic>> listData = [];
                          listData.add(map);
                          helpDeskReq.attachments = listData;
                        }
                        helpDeskReq.assigned_to = assignedTo;
                        helpDeskReq.authority_of = authorityOf;
                        helpDeskReq.field_type = TableNames.HELPDESK_TYPE_TASK;
                        try {
                          var resp = await apiRepository.addHelpDeskApi(helpDeskReq);
                          if (resp.id != null) {
                            setState(() {
                              isVisible = false;
                            });
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
      var resp = await apiRepository.getHelpdesk();
      if (resp != null) {
        setState(() {
          isVisible = false;
          taskTypeResponse = resp.records;
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

  void onTap() {
    final timeData = [
      List.generate(250, (index) => (index + 1).toString()).toList(),
      List.generate(59, (index) => (index + 1).toString()).toList(),
    ];

    Pickers.showMultiPicker(
      context,
      data: timeData,
      suffix: [" Hour", " Minute"],
      onConfirm: (p, position) {
        durationHrsController = p[0];
        print(position.join(","));
      },
      pickerStyle: PickerStyle(
        title: custom_text(text: strings_name.str_required_duration, textStyles: blackTextSemiBold14, alignment: Alignment.center),
        cancelButton: custom_text(text: strings_name.str_cancle, textStyles: blackTextSemiBold14, alignment: Alignment.center),
        commitButton: custom_text(text: strings_name.str_confirm, textStyles: primaryTextSemiBold14, alignment: Alignment.center))
    );
  }

  picLOIFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        taskFileTitle = result.files.single.name;
        taskFilePath = result.files.single.path!;
      });
    }
  }
}
