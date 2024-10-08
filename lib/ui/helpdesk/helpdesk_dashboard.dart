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
import 'package:flutterdesigndemo/ui/helpdesk/helpdesk.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import 'helpdesk_details.dart';

class HelpdeskDashboard extends StatefulWidget {
  const HelpdeskDashboard({Key? key}) : super(key: key);

  @override
  State<HelpdeskDashboard> createState() => _HelpdeskDashboardState();
}

class _HelpdeskDashboardState extends State<HelpdeskDashboard> {
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false, fromFilter = false, toggleMyTicket = true, toggleOthersTicket = true;

  bool canViewOther = false, canUpdateTicketStatus = false, canUpdateTicketCategory = false, canUpdateTicketAssignee = false;

  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? ticketList = [];
  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? mainList = [];
  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? myTicketList = [];
  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? othersTicketList = [];
  String offset = "";
  var loginId = "";
  var isLogin = 0;

  var controllerSearch = TextEditingController();
  var filterHubName = "", filterSpecialization = "", filterSemester = "", filterDivision = "", filterTicketValue = "";
  var filterTicketTypeId = 0;

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
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_TICKET_ASSIGNEE) {
            canUpdateTicketAssignee = true;
          }
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
    } finally {
      getRecords();
    }
  }

  getRecords() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });
    var query = "AND(${TableNames.CLM_FIELD_TYPE}='${TableNames.HELPDESK_TYPE_TICKET}', OR(";
    if (isLogin == 1) {
      query += "${TableNames.CLM_CREATED_BY_STUDENT}='${PreferenceUtils.getLoginData().mobileNumber}'";
    } else if (isLogin == 2) {
      query += "${TableNames.CLM_CREATED_BY_EMPLOYEE_NUMBER}='${PreferenceUtils.getLoginDataEmployee().mobileNumber}'";
    } else if (isLogin == 3) {
      query += "${TableNames.CLM_CREATED_BY_ORGANIZATION}='$loginId'";
    }

    if (canViewOther) {
      query += ", SEARCH('${PreferenceUtils.getLoginDataEmployee().mobileNumber}', ARRAYJOIN(${TableNames.CLM_AUTHORITY_OF_NUMBER}))";
    }

    query += ")";

    if (fromFilter) {
      if (filterHubName.isNotEmpty) query += ", FIND('$filterHubName', ${TableNames.CLM_STUDENT_HUBNAME}, 0)";
      if (filterSpecialization.isNotEmpty) query += ", FIND('$filterSpecialization', ${TableNames.CLM_STUDENT_SPENAME}, 0)";
      if (filterSemester.isNotEmpty) query += ", FIND('$filterSemester', ${TableNames.CLM_STUDENT_SEMESTER}, 0)";
      if (filterDivision.isNotEmpty) query += ", FIND('$filterDivision', ${TableNames.CLM_STUDENT_DIVISION}, 0)";
      if (filterTicketTypeId != 0) query += ", SEARCH('$filterTicketTypeId', ${TableNames.CLM_TICKET_TYPEID})";
      if (filterTicketValue.isNotEmpty) query += ", FIND('$filterTicketValue', ${TableNames.CLM_TICKET_STATUS}, 0)";
    }
    query += ")";
    debugPrint(query);

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
          ticketList = [];
          ticketList = List.from(mainList!);
          differentiateTickets();
          debugPrint("Result size: ${ticketList?.length}");

          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            mainList = [];
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

  differentiateTickets() {
    myTicketList?.clear();
    othersTicketList?.clear();

    ticketList?.sort((a, b) {
      var adate = a.fields!.createdOn;
      var bdate = b.fields!.createdOn;
      return bdate!.compareTo(adate!);
    });
    if (ticketList?.isNotEmpty == true) {
      for (int i = 0; i < ticketList!.length; i++) {
        bool isChecked = true;
        if (filterTicketValue.isEmpty && PreferenceUtils.getIsLogin() == 2) {
          if (ticketList![i].fields!.status == TableNames.TICKET_STATUS_COMPLETED || ticketList![i].fields!.status == TableNames.TICKET_STATUS_RESOLVED || ticketList![i].fields!.status == TableNames.TICKET_STATUS_SUGGESTION) {
            isChecked = false;
          }
        }
        if (isChecked) {
          if (isLogin == 1 && ticketList![i].fields!.createdByStudent?[0] == PreferenceUtils.getLoginRecordId()) {
            myTicketList?.add(ticketList![i]);
          } else if (isLogin == 2 && ticketList![i].fields!.createdByEmployee?[0] == PreferenceUtils.getLoginRecordId()) {
            myTicketList?.add(ticketList![i]);
          } else if (isLogin == 3 && ticketList![i].fields!.createdByOrganization?[0] == PreferenceUtils.getLoginRecordId()) {
            myTicketList?.add(ticketList![i]);
          } else {
            othersTicketList?.add(ticketList![i]);
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_help_desk),
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
                      hintText: "Search by ticket notes..",
                      textInputAction: TextInputAction.done,
                      controller: controllerSearch,
                      onChanges: (value) {
                        if (value.isEmpty) {
                          ticketList = [];
                          ticketList = List.from(mainList!);
                          differentiateTickets();
                          setState(() {});
                        } else {
                          ticketList = [];
                          for (var i = 0; i < mainList!.length; i++) {
                            if (mainList![i].fields!.notes!.toLowerCase().contains(value.toLowerCase())) {
                              ticketList?.add(mainList![i]);
                            }
                          }
                          differentiateTickets();
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
                          Get.to(const FilterScreenHelpdesk(), arguments: false)?.then((value) {
                            if (value != null) {
                              ticketList?.clear();
                              myTicketList?.clear();
                              othersTicketList?.clear();

                              fromFilter = true;
                              filterHubName = value[0]["hubName"];
                              filterSpecialization = value[1]["specializationName"];
                              filterSemester = value[2]["semester"];
                              filterDivision = value[3]["division"];
                              filterTicketTypeId = value[4]["helpdeskTypeId"];
                              filterTicketValue = value[5]["ticketValue"];

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
                        children: [Text("${strings_name.str_my_tickets}(${myTicketList?.length ?? 0})", textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(toggleMyTicket ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                      ),
                    ),
                  ),
                  onTap: () {
                    if (myTicketList?.isNotEmpty == true) {
                      toggleMyTicket = !toggleMyTicket;
                      setState(() {});
                    }
                  },
                ),
                myTicketList?.isNotEmpty == true
                    ? Visibility(
                        visible: toggleMyTicket,
                        child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: myTicketList!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(const HelpdeskDetail(), arguments: [
                                    {"fields": myTicketList?[index].fields},
                                    {"canUpdateTicketStatus": false},
                                    {"canUpdateTicketCategory": false},
                                    {"recordId": myTicketList?[index].id},
                                    {"title": strings_name.str_help_desk_detail},
                                    {"canUpdateTicketAssignee": canUpdateTicketAssignee},
                                  ]);
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
                                                  custom_text(text: myTicketList![index].fields!.ticketId.toString(), rightValue: 0, textStyles: blackTextSemiBold16, leftValue: 5),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                decoration: const BoxDecoration(color: colors_name.colorAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                padding: const EdgeInsets.all(1),
                                                child: custom_text(text: myTicketList![index].fields!.ticketTitle![0].toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3)),
                                          ],
                                        ),
                                        custom_text(text: myTicketList![index].fields!.notes.toString().trim(), textStyles: blackText16, topValue: 0, bottomValue: 5, leftValue: 5, maxLines: 2),
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
                                                child: custom_text(text: myTicketList![index].fields!.status!.toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3)),
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
                canViewOther
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
                                    Expanded(child: custom_text(text: "${strings_name.str_others_tickets}(${othersTicketList?.length ?? 0})", textAlign: TextAlign.start, textStyles: blackTextSemiBold16, rightValue: 0, leftValue: 0, maxLines: 2, topValue: 0, bottomValue: 0)),
                                    Icon(toggleOthersTicket ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              if (othersTicketList?.isNotEmpty == true) {
                                toggleOthersTicket = !toggleOthersTicket;
                                setState(() {});
                              }
                            },
                          ),
                          othersTicketList?.isNotEmpty == true
                              ? Visibility(
                                  visible: toggleOthersTicket,
                                  child: ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount: othersTicketList!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(const HelpdeskDetail(), arguments: [
                                              {"fields": othersTicketList?[index].fields},
                                              {"canUpdateTicketStatus": canUpdateTicketStatus},
                                              {"canUpdateTicketCategory": canUpdateTicketCategory},
                                              {"recordId": othersTicketList?[index].id},
                                              {"title": strings_name.str_help_desk_detail},
                                              {"canUpdateTicketAssignee": canUpdateTicketAssignee},
                                            ]);
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
                                                            custom_text(text: othersTicketList![index].fields!.ticketId.toString(), rightValue: 0, textStyles: blackTextSemiBold16, leftValue: 5),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                          decoration: const BoxDecoration(color: colors_name.colorAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                          padding: const EdgeInsets.all(1),
                                                          child: custom_text(text: othersTicketList![index].fields!.ticketTitle![0].toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3)),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      custom_text(text: strings_name.str_created_by, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                                                      Expanded(
                                                        child: custom_text(
                                                            text: othersTicketList![index].fields!.studentName?.isNotEmpty == true
                                                                ? othersTicketList![index].fields!.studentName![0].toString()
                                                                : (othersTicketList![index].fields!.employeeName?.isNotEmpty == true
                                                                    ? othersTicketList![index].fields!.employeeName![0].toString()
                                                                    : (othersTicketList![index].fields!.companyName?.isNotEmpty == true ? othersTicketList![index].fields!.companyName![0].toString() : "")),
                                                            textStyles: blackTextSemiBold16,
                                                            leftValue: 5,
                                                            maxLines: 2,
                                                            topValue: 0),
                                                      ),
                                                    ],
                                                  ),
                                                  custom_text(text: othersTicketList![index].fields!.notes.toString().trim(), textStyles: blackText16, topValue: 5, bottomValue: 10, leftValue: 5, maxLines: 2),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      custom_text(text: strings_name.str_assigned_to, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                                                      Expanded(child: custom_text(text: othersTicketList![index].fields!.assignedEmployeeName?.join(",").replaceAll(" ,", ", ").trim() ?? "", textStyles: blackTextSemiBold16, leftValue: 5, topValue: 0, rightValue: 5, maxLines: 5000)),
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
                                                          child: custom_text(text: othersTicketList![index].fields!.status!.toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3)),
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
            Get.to(const HelpDesk())?.then((value) {
              if (value != null && value) {
                ticketList?.clear();
                myTicketList?.clear();
                othersTicketList?.clear();

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
