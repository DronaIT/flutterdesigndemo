import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/helpdesk_responses.dart';
import 'package:flutterdesigndemo/models/request/help_desk_req.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/ui/task/employee_selection.dart';
import 'package:flutterdesigndemo/utils/push_notification_service.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  TextEditingController deadlineController = TextEditingController();
  TextEditingController actualDurationController = TextEditingController();
  TextEditingController actualFinishedOnController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  List<String> taskImportanceArray = <String>[TableNames.TASK_IMPORTANCE_HIGH, TableNames.TASK_IMPORTANCE_MEDIUM, TableNames.TASK_IMPORTANCE_LOW];
  String taskImportanceValue = TableNames.TASK_IMPORTANCE_MEDIUM;

  int taskTypeId = 0;
  String taskFilePath = "", taskFileTitle = "";
  var taskFileData;

  List<String> assignedTo = [];
  List<String> authorityOf = [];

  var hubName;
  var isLogin = 0;

  var fromUpdate = false;
  HelpdeskResponses? helpDeskTypeResponse;
  String? helpDeskTypeResponseId;

  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? employeeData = [];
  String offset = "";

  @override
  void initState() {
    super.initState();
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

    if (Get.arguments != null) {
      helpDeskTypeResponse = Get.arguments[0]["fields"];
      fromUpdate = Get.arguments[1]["fromUpdate"];
      helpDeskTypeResponseId = Get.arguments[2]["recordId"];

      taskNoteController.text = helpDeskTypeResponse?.notes ?? "";
      durationController.text = helpDeskTypeResponse?.required_time ?? "";
      taskImportanceValue = helpDeskTypeResponse?.task_importance ?? TableNames.TASK_IMPORTANCE_MEDIUM;
      if (helpDeskTypeResponse?.deadline != null && helpDeskTypeResponse?.deadline?.isNotEmpty == true) {
        deadlineController.text = DateFormat("yyyy-MM-dd hh:mm aa").format(DateTime.parse(helpDeskTypeResponse!.deadline!).toLocal());
      }

      if (helpDeskTypeResponse?.assignedTo != null && helpDeskTypeResponse?.assignedTo?.isNotEmpty == true) {
        if (helpDeskTypeResponse?.assignedTo![0] != PreferenceUtils.getLoginRecordId()) {
          getEmployeeData();
        }
      }
    }
  }

  getEmployeeData() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });

    var query = "OR(";
    for (int i = 0; i < helpDeskTypeResponse!.assignedMobileNumber!.length; i++) {
      query += "${TableNames.TB_USERS_PHONE}='${helpDeskTypeResponse!.assignedMobileNumber![i]}'";
      if (i + 1 < helpDeskTypeResponse!.assignedMobileNumber!.length) query += ",";
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getEmployeeListApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          employeeData?.clear();
        }
        employeeData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<ViewEmployeeResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getEmployeeData();
        } else {
          employeeData?.sort((a, b) {
            var adate = a.fields!.employeeName;
            var bdate = b.fields!.employeeName;
            return adate!.compareTo(bdate!);
          });
          for (var j = 0; j < employeeData!.length; j++) {
            employeeData![j].fields!.selected = true;
          }
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(fromUpdate ? strings_name.str_update_task : strings_name.str_add_task),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Column(
                children: [
                  PreferenceUtils.getIsLogin() == 2 && PreferenceUtils.getLoginDataEmployee().mobileNumber == "8735943527"
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            custom_text(
                              text: strings_name.str_assigned_to,
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                            ),
                            GestureDetector(
                              child: custom_text(
                                text: employeeData?.isEmpty == true ? strings_name.str_add : strings_name.str_update,
                                alignment: Alignment.topLeft,
                                textStyles: primaryTextSemiBold16,
                              ),
                              onTap: () {
                                Get.to(const EmployeeSelection(), arguments: employeeData)?.then((result) {
                                  if (result != null) {
                                    setState(() {
                                      employeeData = result;
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                  employeeData!.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: employeeData?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 2,
                              child: GestureDetector(
                                child: Container(
                                  color: colors_name.colorWhite,
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text("${employeeData![index].fields!.employeeName}", textAlign: TextAlign.start, style: blackText16)),
                                      const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  // Get.to(const SpecializationDetail(), arguments: employeeData![index].fields?.id);
                                },
                              ),
                            );
                          })
                      : Container(),
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
                    text: strings_name.str_required_duration,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  InkWell(
                    child: IgnorePointer(
                      child: custom_edittext(
                        hintText: strings_name.str_select_duration,
                        type: TextInputType.none,
                        textInputAction: TextInputAction.next,
                        controller: durationController,
                        topValue: 0,
                      ),
                    ),
                    onTap: () {
                      onTap(1);
                    },
                  ),
                  SizedBox(height: 5.h),
                  custom_text(
                    text: strings_name.str_set_deadline,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  InkWell(
                    child: IgnorePointer(
                      child: custom_edittext(
                        hintText: strings_name.str_set_deadline,
                        type: TextInputType.none,
                        textInputAction: TextInputAction.next,
                        controller: deadlineController,
                        topValue: 0,
                      ),
                    ),
                    onTap: () {
                      DateTime dateSelected = DateTime.now();
                      TimeOfDay timeSelected = TimeOfDay.now();
                      if (deadlineController.text.isNotEmpty || false) {
                        dateSelected = DateFormat("yyyy-MM-dd").parse(deadlineController.text);
                        DateTime time = DateFormat("hh:mm aa").parse(deadlineController.text);
                        timeSelected = TimeOfDay.fromDateTime(time);
                      }
                      showDatePicker(context: context, initialDate: dateSelected, firstDate: DateTime.now(), lastDate: DateTime(2100)).then((pickedDate) {
                        if (pickedDate == null) {
                          return;
                        }
                        setState(() {
                          showTimePicker(context: context, initialTime: timeSelected).then((pickedTime) {
                            if (pickedTime == null) {
                              return;
                            }
                            setState(() {
                              var dateTime = pickedDate;
                              var formatter = DateFormat('yyyy-MM-dd hh:mm aa');
                              var time = DateTime(dateTime.year, dateTime.month, dateTime.day, pickedTime.hour, pickedTime.minute);
                              deadlineController.text = formatter.format(time);
                            });
                          });
                        });
                      });
                    },
                  ),
                  SizedBox(height: 5.h),
                  custom_text(
                    text: strings_name.str_task_importance,
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
                          width: MediaQuery.of(context).size.width,
                          child: DropdownButtonFormField<String>(
                            elevation: 16,
                            style: blackText16,
                            value: taskImportanceValue,
                            focusColor: Colors.white,
                            onChanged: (String? newValue) {
                              setState(() {
                                taskImportanceValue = newValue!;
                              });
                            },
                            items: taskImportanceArray.map<DropdownMenuItem<String>>((String value) {
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
                  fromUpdate
                      ? Column(
                          children: [
                            SizedBox(height: 5.h),
                            custom_text(
                              text: strings_name.str_actual_duration,
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                            ),
                            InkWell(
                              child: IgnorePointer(
                                child: custom_edittext(
                                  hintText: strings_name.str_select_duration,
                                  type: TextInputType.none,
                                  textInputAction: TextInputAction.next,
                                  controller: actualDurationController,
                                  topValue: 0,
                                ),
                              ),
                              onTap: () {
                                onTap(2);
                              },
                            ),
                            SizedBox(height: 5.h),
                            custom_text(
                              text: strings_name.str_actual_date,
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                            ),
                            InkWell(
                              child: IgnorePointer(
                                child: custom_edittext(
                                  hintText: strings_name.str_actual_date,
                                  type: TextInputType.none,
                                  textInputAction: TextInputAction.next,
                                  controller: actualFinishedOnController,
                                  topValue: 0,
                                ),
                              ),
                              onTap: () {
                                DateTime dateSelected = DateTime.now();
                                TimeOfDay timeSelected = TimeOfDay.now();
                                if (actualFinishedOnController.text.isNotEmpty) {
                                  dateSelected = DateFormat("yyyy-MM-dd").parse(actualFinishedOnController.text);
                                  DateTime time = DateFormat("hh:mm aa").parse(actualFinishedOnController.text);
                                  timeSelected = TimeOfDay.fromDateTime(time);
                                }
                                showDatePicker(context: context, initialDate: dateSelected, firstDate: DateTime(2005), lastDate: DateTime(2100)).then((pickedDate) {
                                  if (pickedDate == null) {
                                    return;
                                  }
                                  setState(() {
                                    showTimePicker(context: context, initialTime: timeSelected).then((pickedTime) {
                                      if (pickedTime == null) {
                                        return;
                                      }
                                      setState(() {
                                        var dateTime = pickedDate;
                                        var formatter = DateFormat('yyyy-MM-dd hh:mm aa');
                                        var time = DateTime(dateTime.year, dateTime.month, dateTime.day, pickedTime.hour, pickedTime.minute);
                                        actualFinishedOnController.text = formatter.format(time);
                                      });
                                    });
                                  });
                                });
                              },
                            ),
                            custom_edittext(
                              type: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              controller: commentController,
                              topValue: 5,
                              maxLines: 5,
                              minLines: 4,
                              hintText: strings_name.str_type_remarks,
                              maxLength: 5000,
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(height: 5.h),
                  PreferenceUtils.getIsLogin() == 2 && PreferenceUtils.getLoginDataEmployee().mobileNumber == "8735943527"
                      ? Container()
                      : Row(
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
                    visible: taskFileTitle.isNotEmpty,
                    child: Column(
                      children: [
                        SizedBox(height: 3.h),
                        // custom_text(text: taskFileTitle, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0),
                        custom_text(text: taskFileTitle, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0),
                      ],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  CustomButton(
                    text: strings_name.str_submit,
                    click: () async {
                      if (taskNoteController.text.trim().toString().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_task_note);
                      } else if (durationController.text.trim().toString().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_duration);
                      } else if (deadlineController.text.trim().toString().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_deadline);
                      } else if (taskImportanceValue.isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_task_importance);
                      } else if (fromUpdate && actualDurationController.text.trim().toString().isNotEmpty) {
                        if (actualFinishedOnController.text.trim().toString().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_actual_date);
                        } else {
                          addMultipleTask();
                        }
                      } else if (fromUpdate && actualFinishedOnController.text.trim().toString().isNotEmpty) {
                        if (actualDurationController.text.trim().toString().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_actual_duration);
                        } else {
                          addMultipleTask();
                        }
                      } else {
                        addMultipleTask();
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

  void addMultipleTask() {
    if (employeeData?.isNotEmpty == true) {
      for (var i = 0; i < employeeData!.length; i++) {
        updateTask(employeeData![i].id.toString().split("..."), employeeData![i].fields?.token?.split("..") ?? [], i == employeeData!.length - 1);
      }
    } else {
      updateTask(PreferenceUtils.getLoginRecordId().split("..."), [], true);
    }
  }

  /*
  *   durationType values
  *   1 = deadlineDuration, 2 = actualDuration
  */
  void onTap(int durationType) {
    var hourList = List.generate(250, (index) => (index).toString()).toList();
    var minuteList = List.generate(59, (index) => (index).toString()).toList();

    final timeData = [hourList, minuteList];

    Pickers.showMultiPicker(
      context,
      data: timeData,
      suffix: [" Hour", " Minute"],
      onConfirm: (p, position) {
        if (position[0] != 0 || position[1] != 0) {
          var durationHrsController = hourList[position[0]].split(" ").first;
          var durationMinController = minuteList[position[1]].split(" ").first;

          setState(() {
            if (durationType == 1) {
              durationController.text = "$durationHrsController:$durationMinController";
            } else if (durationType == 2) {
              actualDurationController.text = "$durationHrsController:$durationMinController";
            }
          });
        }
      },
      pickerStyle: PickerStyle(
          title: custom_text(text: strings_name.str_required_duration, textStyles: blackTextSemiBold14, alignment: Alignment.center),
          cancelButton: custom_text(text: strings_name.str_cancle, textStyles: blackTextSemiBold14, alignment: Alignment.center),
          commitButton: custom_text(text: strings_name.str_confirm, textStyles: primaryTextSemiBold14, alignment: Alignment.center)),
    );
  }

  picLOIFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      taskFileTitle = result.files.single.name;
      if (kIsWeb) {
        setState(() {
          taskFilePath = result.files.single.bytes.toString();
          taskFileData = result.files.single;
        });
      } else {
        setState(() {
          taskFilePath = result.files.single.path!;
        });
      }
    }
  }

  updateTask(List<String> assignedTo, List<String> assignedToToken, bool canClose) async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    if (taskFileTitle.isNotEmpty) {
      if (kIsWeb) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromByteData(Utils.uint8ListToByteData(taskFileData.bytes!),
              resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_HELP_DESK, identifier: taskFileData.name),
        );
        taskFilePath = response.secureUrl;
      } else {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(taskFilePath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_HELP_DESK),
        );
        taskFilePath = response.secureUrl;
      }
    }

    HelpDeskRequest helpDeskReq = HelpDeskRequest();
    helpDeskReq.Notes = taskNoteController.text.trim().toString();
    helpDeskReq.task_importance = taskImportanceValue;
    if (!fromUpdate) {
      if (isLogin == 1) {
        helpDeskReq.createdByStudent = PreferenceUtils.getLoginRecordId().split(",");
      } else if (isLogin == 2) {
        helpDeskReq.createdByEmployee = PreferenceUtils.getLoginRecordId().split(",");
      } else if (isLogin == 3) {
        helpDeskReq.createdByOrganization = PreferenceUtils.getLoginRecordId().split(",");
      }
      helpDeskReq.Status = TableNames.TICKET_STATUS_OPEN;
      helpDeskReq.field_type = TableNames.HELPDESK_TYPE_TASK;
    } else {
      if (commentController.text.trim().isNotEmpty) {
        helpDeskReq.remarks = commentController.text.trim();
      }
      var updatedBy = PreferenceUtils.getLoginRecordId();
      if (helpDeskTypeResponse?.status_updated_by?.isNotEmpty == true) {
        if (helpDeskTypeResponse?.status_updated_by?.contains(PreferenceUtils.getLoginRecordId()) == true) {
          helpDeskTypeResponse?.status_updated_by?.remove(PreferenceUtils.getLoginRecordId());
        }
        if (helpDeskTypeResponse?.status_updated_by?.isNotEmpty == true) {
          updatedBy = "$updatedBy,${helpDeskTypeResponse!.status_updated_by!.join(",")}";
        }
      }
      helpDeskReq.status_updated_by = updatedBy.split(",");
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
    helpDeskReq.deadline = deadlineController.text;
    helpDeskReq.required_time = durationController.text;
    if (actualDurationController.text.trim().toString().isNotEmpty) {
      helpDeskReq.actual_time_taken = actualDurationController.text;
    }
    if (actualFinishedOnController.text.trim().toString().isNotEmpty) {
      helpDeskReq.actual_finished_on = actualFinishedOnController.text;
      helpDeskReq.Status = TableNames.TICKET_STATUS_COMPLETED;
    }
    try {
      if (fromUpdate) {
        var json = helpDeskReq.toJson();
        json.removeWhere((key, value) => value == null);

        var resp = await apiRepository.updateTicket(json, helpDeskTypeResponseId!);
        if (resp.id != null) {
          if (canClose) {
            setState(() {
              isVisible = false;
            });
            String msg = "";
            if (helpDeskReq.Status == TableNames.TICKET_STATUS_COMPLETED) {
              msg = strings_name.str_push_desc_task_completed;
            } else {
              msg = strings_name.str_push_desc_task_status_updated;
            }
            if (assignedToToken.isNotEmpty) {
              PushNotificationService.sendNotificationToMultipleDevices(assignedToToken, "", msg);
            }
            if (helpDeskTypeResponse?.createdByStudentToken?.isNotEmpty == true) {
              PushNotificationService.sendNotificationToMultipleDevices(helpDeskTypeResponse!.createdByStudentToken ?? [], "", msg);
            }
            if (helpDeskTypeResponse?.createdByEmployeeToken?.isNotEmpty == true) {
              PushNotificationService.sendNotificationToMultipleDevices(helpDeskTypeResponse!.createdByEmployeeToken ?? [], "", msg);
            }
            if (helpDeskTypeResponse?.createdByOrganizationToken?.isNotEmpty == true) {
              PushNotificationService.sendNotificationToMultipleDevices(helpDeskTypeResponse!.createdByOrganizationToken ?? [], "", msg);
            }
            Utils.showSnackBar(context, strings_name.str_update_task_message);
            await Future.delayed(const Duration(milliseconds: 2000));
            Get.back(result: true);
          }
        } else {
          setState(() {
            isVisible = false;
          });
        }
      } else {
        var resp = await apiRepository.addHelpDeskApi(helpDeskReq);
        if (resp.id != null) {
          if (canClose) {
            setState(() {
              isVisible = false;
            });
            if (assignedToToken.isNotEmpty) {
              PushNotificationService.sendNotificationToMultipleDevices(assignedToToken, "", strings_name.str_push_desc_new_task_assigned);
            }
            Utils.showSnackBar(context, strings_name.str_create_task_message);
            await Future.delayed(const Duration(milliseconds: 2000));
            Get.back(result: true);
          }
        } else {
          setState(() {
            isVisible = false;
          });
        }
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
