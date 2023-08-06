import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/helpdesk_responses.dart';
import 'package:flutterdesigndemo/ui/helpdesk/filter_screen_helpdesk.dart';
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
  bool isVisible = false, fromFilter = false, toggleTaskAssigned = true, toggleMyTask = true, toggleTaskAssignedByMe = true;

  bool canViewOther = false, canUpdateTicketStatus = false, canUpdateTicketCategory = false;

  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? mainList = [];
  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? taskList = [];
  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? myTaskList = [];
  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? taskAssignedList = [];
  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? taskAssignedByMeList = [];
  String offset = "";
  var loginId = "";
  var isLogin = 0;

  var controllerSearch = TextEditingController();
  var filterHubName = "", filterSpecialization = "", filterSemester = "", filterDivision = "", filterTicketValue = "";
  var filterTicketTypeId = 0;
  var filterOnlyTask = false;

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
    var query = "AND(OR(";
    if (isLogin == 1) {
      query += "${TableNames.CLM_CREATED_BY_STUDENT}='${PreferenceUtils.getLoginData().mobileNumber}'";
    } else if (isLogin == 2) {
      query += "${TableNames.CLM_CREATED_BY_EMPLOYEE_NUMBER}='${PreferenceUtils.getLoginDataEmployee().mobileNumber}'";
    } else if (isLogin == 3) {
      query += "${TableNames.CLM_CREATED_BY_ORGANIZATION}='$loginId'";
    }

    query += ", SEARCH('${PreferenceUtils.getLoginDataEmployee().mobileNumber}', ARRAYJOIN(${TableNames.CLM_ASSIGNED_NUMBER}))";
    query += ", SEARCH('${PreferenceUtils.getLoginDataEmployee().mobileNumber}', ARRAYJOIN(${TableNames.CLM_AUTHORITY_OF_NUMBER}))";

    query += ")";

    if (fromFilter) {
      if (filterHubName.isNotEmpty) query += ", FIND('$filterHubName', ${TableNames.CLM_STUDENT_HUBNAME}, 0)";
      if (filterSpecialization.isNotEmpty) query += ", FIND('$filterSpecialization', ${TableNames.CLM_STUDENT_SPENAME}, 0)";
      if (filterSemester.isNotEmpty) query += ", FIND('$filterSemester', ${TableNames.CLM_STUDENT_SEMESTER}, 0)";
      if (filterDivision.isNotEmpty) query += ", FIND('$filterDivision', ${TableNames.CLM_STUDENT_DIVISION}, 0)";
      if (filterTicketTypeId != 0) query += ", FIND('$filterTicketTypeId', ${TableNames.CLM_TICKET_TYPEID}, 0)";
      if (filterTicketValue.isNotEmpty) query += ", FIND('$filterTicketValue', ${TableNames.CLM_TICKET_STATUS}, 0)";
      if (filterOnlyTask) query += ", FIND('${TableNames.HELPDESK_TYPE_TASK}', ${TableNames.CLM_FIELD_TYPE}, 0)";
    }

    query += ")";
    print(query);

    try {
      var data = await apiRepository.getTicketsApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mainList?.clear();
        }
        mainList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<HelpdeskResponses>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          taskList = [];
          taskList = List.from(mainList!);
          differentiateTasks();

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

  differentiateTasks() {
    myTaskList?.clear();
    taskAssignedList?.clear();

    taskList?.sort((a, b) {
      var adate = a.fields!.createdOn;
      var bdate = b.fields!.createdOn;
      return bdate!.compareTo(adate!);
    });
    if (taskList?.isNotEmpty == true) {
      for (int i = 0; i < taskList!.length; i++) {
        bool isChecked = true;
        if (filterTicketValue.isEmpty) {
          if (taskList![i].fields!.status == TableNames.TICKET_STATUS_COMPLETED || taskList![i].fields!.status == TableNames.TICKET_STATUS_RESOLVED || taskList![i].fields!.status == TableNames.TICKET_STATUS_SUGGESTION) {
            isChecked = false;
          }
        }
        if (isChecked) {
          if (taskList![i].fields!.assignedTo?.contains(PreferenceUtils.getLoginRecordId()) == true) {
            myTaskList?.add(taskList![i]);
          } else if (taskList![i].fields!.createdByEmployee?.contains(PreferenceUtils.getLoginRecordId()) == true) {
            taskAssignedByMeList?.add(taskList![i]);
          } else {
            taskAssignedList?.add(taskList![i]);
          }
        }
      }
    }
    setState(() {});
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
                Row(children: [
                  Flexible(
                    flex: 1,
                    child: CustomEditTextSearch(
                      type: TextInputType.text,
                      hintText: "Search by name..",
                      textInputAction: TextInputAction.done,
                      controller: controllerSearch,
                      onChanges: (value) {
                        if (value.isEmpty) {
                          taskList = [];
                          taskList = List.from(mainList!);
                          setState(() {});
                        } else {
                          taskList = [];
                          for (var i = 0; i < mainList!.length; i++) {
                            if (mainList![i].fields!.assignedEmployeeName?.isNotEmpty == true) {
                              for (var j = 0; j < mainList![i].fields!.assignedEmployeeName!.length; j++) {
                                if (mainList![i].fields!.assignedEmployeeName![j].toLowerCase().contains(value.toLowerCase())) {
                                  taskList?.add(mainList![i]);
                                }
                              }
                            }
                          }
                          differentiateTasks();
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: isLogin == 2,
                    child: IconButton(
                        iconSize: 28,
                        onPressed: () {
                          Get.to(const FilterScreenHelpdesk(), arguments: true)?.then((value) {
                            if (value != null) {
                              taskList?.clear();
                              myTaskList?.clear();
                              taskAssignedList?.clear();
                              taskAssignedByMeList?.clear();

                              fromFilter = true;
                              filterHubName = value[0]["hubName"];
                              filterSpecialization = value[1]["specializationName"];
                              filterSemester = value[2]["semester"];
                              filterDivision = value[3]["division"];
                              filterTicketTypeId = value[4]["helpdeskTypeId"];
                              filterTicketValue = value[5]["ticketValue"];
                              filterOnlyTask = value[6]["onlyTask"];

                              getRecords();
                            }
                          });
                        },
                        icon: const Icon(Icons.filter_alt, color: colors_name.colorPrimary)),
                  )
                ]),
                SizedBox(height: 5.h),
                GestureDetector(
                  child: Card(
                    elevation: 5,
                    child: Container(
                      color: colors_name.lightGrayColor,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("${strings_name.str_my_task}(${myTaskList?.length ?? 0})", textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(toggleMyTask ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                      ),
                    ),
                  ),
                  onTap: () {
                    if (myTaskList?.isNotEmpty == true) {
                      toggleMyTask = !toggleMyTask;
                      setState(() {});
                    }
                  },
                ),
                myTaskList?.isNotEmpty == true
                    ? Visibility(
                        visible: toggleMyTask,
                        child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: myTaskList!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  if (myTaskList![index].fields!.fieldType == TableNames.HELPDESK_TYPE_TASK) {
                                    Get.to(const TaskDetail(), arguments: [
                                      {"fields": myTaskList?[index].fields},
                                      {"canUpdateTask": true},
                                      {"recordId": myTaskList?[index].id}
                                    ])?.then((value) {
                                      if(value) {
                                        taskList?.clear();
                                        myTaskList?.clear();
                                        taskAssignedList?.clear();
                                        taskAssignedByMeList?.clear();

                                        getRecords();
                                      }
                                    });
                                  } else {
                                    Get.to(const HelpdeskDetail(), arguments: [
                                      {"fields": myTaskList?[index].fields},
                                      {"canUpdateTicketStatus": true},
                                      {"canUpdateTicketCategory": false},
                                      {"recordId": myTaskList?[index].id},
                                      {"title": strings_name.str_task_detail},
                                    ])?.then((value) {
                                      if(value) {
                                        taskList?.clear();
                                        myTaskList?.clear();
                                        taskAssignedList?.clear();
                                        taskAssignedByMeList?.clear();

                                        getRecords();
                                      }
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
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  custom_text(text: strings_name.str_ticket_id, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5),
                                                  custom_text(text: myTaskList![index].fields!.ticketId.toString(), rightValue: 0, textStyles: blackTextSemiBold16, leftValue: 5),
                                                ],
                                              ),
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
                                                  Expanded(
                                                    child: custom_text(
                                                        text: myTaskList![index].fields!.studentName?.isNotEmpty == true
                                                            ? myTaskList![index].fields!.studentName![0].toString()
                                                            : (myTaskList![index].fields!.employeeName?.isNotEmpty == true
                                                                ? myTaskList![index].fields!.employeeName![0].toString()
                                                                : (myTaskList![index].fields!.companyName?.isNotEmpty == true ? myTaskList![index].fields!.companyName![0].toString() : "")),
                                                        textStyles: blackTextSemiBold16,
                                                        leftValue: 5,
                                                        maxLines: 2,
                                                        topValue: 0),
                                                  ),
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
                            }),
                      )
                    : custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
                taskAssignedByMeList?.isNotEmpty == true
                    ? Column(
                        children: [
                          SizedBox(height: 3.h),
                          GestureDetector(
                            child: Card(
                              elevation: 5,
                              child: Container(
                                color: colors_name.lightGrayColor,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${strings_name.str_task_assigned_byme}(${taskAssignedByMeList?.length ?? 0})", textAlign: TextAlign.center, style: blackTextSemiBold16),
                                    Icon(toggleTaskAssignedByMe ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              if (taskAssignedByMeList?.isNotEmpty == true) {
                                toggleTaskAssignedByMe = !toggleTaskAssignedByMe;
                                setState(() {});
                              }
                            },
                          ),
                          taskAssignedByMeList?.isNotEmpty == true
                              ? Visibility(
                                  visible: toggleTaskAssignedByMe,
                                  child: ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: taskAssignedByMeList!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(const TaskDetail(), arguments: [
                                              {"fields": taskAssignedByMeList?[index].fields},
                                              {"canUpdateTask": true},
                                              {"recordId": taskAssignedByMeList?[index].id}
                                            ])?.then((value) {
                                              if (value) {
                                                taskList?.clear();
                                                myTaskList?.clear();
                                                taskAssignedList?.clear();
                                                taskAssignedByMeList?.clear();

                                                getRecords();
                                              }
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
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            custom_text(text: strings_name.str_ticket_id, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5),
                                                            custom_text(text: taskAssignedByMeList![index].fields!.ticketId.toString(), rightValue: 0, textStyles: blackTextSemiBold16, leftValue: 5),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                          decoration: const BoxDecoration(color: colors_name.colorAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                          padding: const EdgeInsets.all(1),
                                                          child: custom_text(
                                                            text: taskAssignedByMeList![index].fields!.ticketTitle != null && taskAssignedByMeList![index].fields!.ticketTitle?.isNotEmpty == true ? taskAssignedByMeList![index].fields!.ticketTitle![0].toString() : strings_name.str_task,
                                                            textStyles: whiteTextSemiBold16,
                                                            alignment: Alignment.centerRight,
                                                            topValue: 1,
                                                            bottomValue: 1,
                                                            leftValue: 3,
                                                            rightValue: 3,
                                                          )),
                                                    ],
                                                  ),
                                                  custom_text(text: taskAssignedByMeList![index].fields!.notes.toString(), textStyles: blackText16, topValue: 0, bottomValue: 10, leftValue: 5, maxLines: 2),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      custom_text(text: strings_name.str_assigned_to, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                                                      Expanded(
                                                        child: custom_text(text: taskAssignedByMeList![index].fields!.assignedEmployeeName?.join(",").replaceAll(" ,", ", ") ?? "", textStyles: blackTextSemiBold16, leftValue: 5, maxLines: 5000, topValue: 0),
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
                                                          child: custom_text(text: taskAssignedByMeList![index].fields!.status!.toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 0), color: colors_name.lightGreyColor, padding: const EdgeInsets.all(0.5)),
                                          ]),
                                        );
                                      }),
                                )
                              : custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
                        ],
                      )
                    : Container(),
                taskAssignedList?.isNotEmpty == true
                    ? Column(
                        children: [
                          SizedBox(height: 3.h),
                          GestureDetector(
                            child: Card(
                              elevation: 5,
                              child: Container(
                                color: colors_name.lightGrayColor,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${strings_name.str_others_task}(${taskAssignedList?.length ?? 0})", textAlign: TextAlign.center, style: blackTextSemiBold16),
                                    Icon(toggleTaskAssigned ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              if (taskAssignedList?.isNotEmpty == true) {
                                toggleTaskAssigned = !toggleTaskAssigned;
                                setState(() {});
                              }
                            },
                          ),
                          taskAssignedList?.isNotEmpty == true
                              ? Visibility(
                                  visible: toggleTaskAssigned,
                                  child: ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: taskAssignedList!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (taskAssignedList![index].fields!.fieldType == TableNames.HELPDESK_TYPE_TASK) {
                                              Get.to(const TaskDetail(), arguments: [
                                                {"fields": taskAssignedList?[index].fields},
                                                {"canUpdateTask": true},
                                                {"recordId": taskAssignedList?[index].id}
                                              ])?.then((value) {
                                                if(value) {
                                                  taskList?.clear();
                                                  myTaskList?.clear();
                                                  taskAssignedList?.clear();
                                                  taskAssignedByMeList?.clear();

                                                  getRecords();
                                                }
                                              });
                                            } else {
                                              Get.to(const HelpdeskDetail(), arguments: [
                                                {"fields": taskAssignedList?[index].fields},
                                                {"canUpdateTicketStatus": true},
                                                {"canUpdateTicketCategory": true},
                                                {"recordId": taskAssignedList?[index].id},
                                                {"title": strings_name.str_task_detail},
                                              ])?.then((value) {
                                                if(value) {
                                                  taskList?.clear();
                                                  myTaskList?.clear();
                                                  taskAssignedList?.clear();
                                                  taskAssignedByMeList?.clear();

                                                  getRecords();
                                                }
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
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            custom_text(text: strings_name.str_ticket_id, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5),
                                                            custom_text(text: taskAssignedList![index].fields!.ticketId.toString(), rightValue: 0, textStyles: blackTextSemiBold16, leftValue: 5),
                                                          ],
                                                        ),
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
                                                        child: custom_text(text: taskAssignedList![index].fields!.assignedEmployeeName?.join(",").replaceAll(" ,", ", ") ?? "", textStyles: blackTextSemiBold16, leftValue: 5, maxLines: 5000, topValue: 0),
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
                                      }),
                                )
                              : custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
                        ],
                      )
                    : Container(),
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
              if(value) {
                taskList?.clear();
                myTaskList?.clear();
                taskAssignedList?.clear();
                taskAssignedByMeList?.clear();

                getRecords();
              }
            });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    ));
  }
}
