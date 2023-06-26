import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/helpdesk_responses.dart';
import 'package:flutterdesigndemo/ui/helpdesk/helpdesk_details.dart';
import 'package:flutterdesigndemo/ui/task/add_task.dart';
import 'package:flutterdesigndemo/ui/task/task_details.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class TaskDashboard extends StatefulWidget {
  const TaskDashboard({Key? key}) : super(key: key);

  @override
  State<TaskDashboard> createState() => _TaskDashboardState();
}

class _TaskDashboardState extends State<TaskDashboard> {
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  bool canViewOther = false, canUpdateTicketStatus = false, canUpdateTicketCategory = false;

  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? taskList = [];
  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? myTaskList = [];
  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? taskAssignedList = [];
  String offset = "";
  var loginId = "";
  var isLogin = 0;

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  Future<void> getPermission() async {
    setState(() {
      isVisible = true;
    });
    var roleId = "";
    isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      roleId = TableNames.STUDENT_ROLE_ID;
      loginId = PreferenceUtils.getLoginData().studentId.toString();
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      roleId = loginData.roleIdFromRoleIds!.join(',');
      loginId = loginData.employeeId.toString();
    } else if (isLogin == 3) {
      roleId = TableNames.ORGANIZATION_ROLE_ID;
      loginId = PreferenceUtils.getLoginDataOrganization().id.toString();
    }

    var query = "AND(FIND('$roleId',role_ids)>0,module_ids='${TableNames.MODULE_HELP_DESK}')";
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_OTHER_TICKET) {
            canViewOther = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_TICKET_STATUS) {
            canUpdateTicketStatus = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_TICKET_CATEGORY) {
            canUpdateTicketCategory = true;
          }
        }
      } else {
        setState(() {
          isVisible = false;
        });
        // Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    } finally {
      getRecords();
    }
  }

  getRecords() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });
    var query = "OR(";
    if (isLogin == 1) {
      query += "${TableNames.CLM_CREATED_BY_STUDENT}='${PreferenceUtils.getLoginData().mobileNumber}'";
    } else if (isLogin == 2) {
      query += "${TableNames.CLM_CREATED_BY_EMPLOYEE}='$loginId'";
    } else if (isLogin == 3) {
      query += "${TableNames.CLM_CREATED_BY_ORGANIZATION}='$loginId'";
    }

    query += ", FIND('$loginId', ${TableNames.CLM_ASSIGNED_TO}, 0)";
    // query += ", FIND('$loginId', ${TableNames.CLM_AUTHORITY_OF}, 0)";

    query += ")";
    print(query);

    try {
      var data = await apiRepository.getTicketsApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          taskList?.clear();
        }
        taskList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<HelpdeskResponses>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          taskList?.sort((a, b) {
            var adate = a.fields!.createdOn;
            var bdate = b.fields!.createdOn;
            return bdate!.compareTo(adate!);
          });
          if (taskList?.isNotEmpty == true) {
            for (int i = 0; i < taskList!.length; i++) {
              if (taskList![i].fields!.assignedTo?.contains(PreferenceUtils.getLoginRecordId()) == true) {
                myTaskList?.add(taskList![i]);
              } else {
                taskAssignedList?.add(taskList![i]);
              }
            }
          }
          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            taskList = [];
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_task),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 5.h),
                Card(
                  elevation: 5,
                  child: Container(
                    color: colors_name.lightGrayColor,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(strings_name.str_my_task, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                    ),
                  ),
                ),
                myTaskList?.isNotEmpty == true
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: myTaskList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if(myTaskList![index].fields!.fieldType == TableNames.HELPDESK_TYPE_TASK){
                                Get.to(const TaskDetail(), arguments: [
                                  {"fields": myTaskList?[index].fields},
                                  {"canUpdateTask": true},
                                  {"recordId": myTaskList?[index].id}
                                ])?.then((value) {
                                  taskList?.clear();
                                  myTaskList?.clear();
                                  taskAssignedList?.clear();

                                  getRecords();
                                });
                              } else {
                                Get.to(const HelpdeskDetail(), arguments: [
                                  {"fields": myTaskList?[index].fields},
                                  {"canUpdateTicketStatus": true},
                                  {"canUpdateTicketCategory": false},
                                  {"recordId": myTaskList?[index].id},
                                  {"title": strings_name.str_task_detail},
                                ])?.then((value) {
                                  taskList?.clear();
                                  myTaskList?.clear();
                                  taskAssignedList?.clear();

                                  getRecords();
                                });
                              }
                            },
                            child: Column(children: [
                              Container(
                                color: colors_name.colorWhite,
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            custom_text(text: strings_name.str_task_id, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5),
                                            custom_text(text: myTaskList![index].fields!.ticketId.toString(), textStyles: blackTextSemiBold16, leftValue: 5),
                                          ],
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(color: colors_name.colorAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                                          padding: const EdgeInsets.all(1),
                                          child: custom_text(
                                              text: myTaskList![index].fields!.ticketTitle != null && myTaskList![index].fields!.ticketTitle?.isNotEmpty == true ? myTaskList![index].fields!.ticketTitle![0].toString() : strings_name.str_task,
                                              textStyles: whiteTextSemiBold16,
                                              alignment: Alignment.centerRight,
                                              topValue: 1,
                                              bottomValue: 1,
                                              leftValue: 3,
                                              rightValue: 3),
                                        ),
                                      ],
                                    ),
                                    isLogin == 2 && myTaskList![index].fields!.employeeName?.isNotEmpty == true && myTaskList![index].fields!.employeeMobileNumber![0] != PreferenceUtils.getLoginDataEmployee().mobileNumber
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              custom_text(text: strings_name.str_assigned_by, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                                              custom_text(
                                                  text: myTaskList![index].fields!.studentName?.isNotEmpty == true
                                                      ? myTaskList![index].fields!.studentName![0].toString()
                                                      : (myTaskList![index].fields!.employeeName?.isNotEmpty == true ? myTaskList![index].fields!.employeeName![0].toString() : (myTaskList![index].fields!.companyName?.isNotEmpty == true ? myTaskList![index].fields!.companyName![0].toString() : "")),
                                                  textStyles: blackTextSemiBold16,
                                                  leftValue: 5,
                                                  topValue: 0),
                                            ],
                                          )
                                        : Container(),
                                    custom_text(text: myTaskList![index].fields!.notes.toString(), textStyles: blackText16, topValue: 0, bottomValue: 5, leftValue: 5, maxLines: 2),
                                    Row(
                                      children: [
                                        custom_text(
                                          text: strings_name.str_status,
                                          textStyles: primaryTextSemiBold16,
                                          topValue: 5,
                                          bottomValue: 5,
                                          leftValue: 5,
                                          alignment: Alignment.center,
                                        ),
                                        Container(
                                            decoration: const BoxDecoration(color: colors_name.presentColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                                            padding: const EdgeInsets.all(1),
                                            margin: const EdgeInsets.only(right: 5),
                                            child: custom_text(text: myTaskList![index].fields!.status!.toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 0), color: colors_name.lightGreyColor, padding: const EdgeInsets.all(0.5)),
                            ]),
                          );
                        })
                    : custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
                taskAssignedList?.isNotEmpty == true
                    ? Column(
                        children: [
                          SizedBox(height: 15.h),
                          Card(
                            elevation: 5,
                            child: Container(
                              color: colors_name.lightGrayColor,
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [Text(strings_name.str_others_task, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                              ),
                            ),
                          ),
                          taskAssignedList?.isNotEmpty == true
                              ? ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: taskAssignedList!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(const TaskDetail(), arguments: [
                                          {"fields": taskAssignedList?[index].fields},
                                          {"canUpdateTask": true},
                                          {"recordId": taskAssignedList?[index].id}
                                        ])?.then((value) {
                                          taskList?.clear();
                                          myTaskList?.clear();
                                          taskAssignedList?.clear();

                                          getRecords();
                                        });
                                      },
                                      child: Column(children: [
                                        Container(
                                          color: colors_name.colorWhite,
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      custom_text(text: strings_name.str_ticket_id, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5),
                                                      custom_text(text: taskAssignedList![index].fields!.ticketId.toString(), textStyles: blackTextSemiBold16, leftValue: 5),
                                                    ],
                                                  ),
                                                  Container(
                                                      decoration: const BoxDecoration(color: colors_name.colorAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                      padding: const EdgeInsets.all(1),
                                                      child: custom_text(
                                                        text: taskAssignedList![index].fields!.ticketTitle != null && taskAssignedList![index].fields!.ticketTitle?.isNotEmpty == true ? taskAssignedList![index].fields!.ticketTitle![0].toString() : strings_name.str_task,
                                                        textStyles: whiteTextSemiBold16,
                                                        alignment: Alignment.centerRight,
                                                        topValue: 1,
                                                        bottomValue: 1,
                                                        leftValue: 3,
                                                        rightValue: 3,
                                                      )),
                                                ],
                                              ),
                                              custom_text(text: taskAssignedList![index].fields!.notes.toString(), textStyles: blackText16, topValue: 0, bottomValue: 10, leftValue: 5, maxLines: 2),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  custom_text(text: strings_name.str_assigned_to, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                                                  Expanded(
                                                    child: custom_text(
                                                        text: taskAssignedList![index].fields!.assignedEmployeeName?.join(",").replaceAll(" ,", ", ") ?? "",
                                                        textStyles: blackTextSemiBold16,
                                                        leftValue: 5,
                                                        maxLines: 5000,
                                                        topValue: 0),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  custom_text(
                                                    text: strings_name.str_status,
                                                    textStyles: primaryTextSemiBold16,
                                                    topValue: 5,
                                                    bottomValue: 5,
                                                    leftValue: 5,
                                                    alignment: Alignment.center,
                                                  ),
                                                  Container(
                                                      decoration: const BoxDecoration(color: colors_name.presentColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                      padding: const EdgeInsets.all(1),
                                                      margin: const EdgeInsets.only(right: 5),
                                                      child: custom_text(text: taskAssignedList![index].fields!.status!.toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 0), color: colors_name.lightGreyColor, padding: const EdgeInsets.all(0.5)),
                                      ]),
                                    );
                                  })
                              : custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: colors_name.colorPrimary,
          onPressed: () {
            Get.to(const AddTask())?.then((value) {
              taskList?.clear();
              myTaskList?.clear();
              taskAssignedList?.clear();

              getRecords();
            });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    ));
  }
}
