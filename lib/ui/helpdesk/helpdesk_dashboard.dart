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
  bool isVisible = false;

  bool canViewOther = false, canUpdateTicketStatus = false, canUpdateTicketCategory = false;

  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? ticketList = [];
  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? myTicketList = [];
  List<BaseApiResponseWithSerializable<HelpdeskResponses>>? othersTicketList = [];
  String offset = "";
  var loginId = "";

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
    var isLogin = PreferenceUtils.getIsLogin();
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
        getRecords();
      } else {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    var query = "";
    if (canViewOther) {
      query = "OR(FIND('$loginId', ${TableNames.CLM_ASSIGNED_TO}, 0), ${TableNames.CLM_CREATED_BY_EMPLOYEE}='$loginId')";
    } else {
      query = "${TableNames.CLM_CREATED_BY_EMPLOYEE}='$loginId'";
    }

    try {
      var data = await apiRepository.getTicketsApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          ticketList?.clear();
        }
        ticketList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<HelpdeskResponses>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          ticketList?.sort((a, b) {
            var adate = a.fields!.createdOn;
            var bdate = b.fields!.createdOn;
            return bdate!.compareTo(adate!);
          });
          if (ticketList?.isNotEmpty == true) {
            for (int i = 0; i < ticketList!.length; i++) {
              if (ticketList![i].fields!.createdByEmployee?[0] == loginId) {
                myTicketList?.add(ticketList![i]);
              } else {
                othersTicketList?.add(ticketList![i]);
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
            ticketList = [];
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
            appBar: AppWidgets.appBarWithoutBack(strings_name.str_help_desk),
            body: Stack(
              children: [
                canViewOther
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 10.h),
                            Card(
                              elevation: 5,
                              child: Container(
                                color: colors_name.colorWhite,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [Text(strings_name.str_my_tickets, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                                ),
                              ),
                            ),
                            myTicketList?.isNotEmpty == true
                                ? ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: myTicketList!.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Column(children: [
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
                                                      custom_text(text: myTicketList![index].fields!.ticketId.toString(), textStyles: blackTextSemiBold16, leftValue: 5),
                                                    ],
                                                  ),
                                                  Container(
                                                      decoration: const BoxDecoration(color: colors_name.colorAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                      padding: const EdgeInsets.all(1),
                                                      child: custom_text(text: myTicketList![index].fields!.ticketTitle![0].toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3)),
                                                ],
                                              ),
                                              custom_text(text: myTicketList![index].fields!.notes.toString(), textStyles: blackText16, topValue: 0, bottomValue: 5, leftValue: 5),
                                            ],
                                          ),
                                        ),
                                        Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 0), color: colors_name.lightGreyColor, padding: EdgeInsets.all(0.5)),
                                      ]);
                                    })
                                : custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
                            SizedBox(height: 5.h),
                            Card(
                              elevation: 5,
                              child: Container(
                                color: colors_name.colorWhite,
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [Text(strings_name.str_others_tickets, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                                ),
                              ),
                            ),
                            othersTicketList?.isNotEmpty == true
                                ? ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: othersTicketList!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: (){
                                      Get.to(const HelpdeskDetail(),
                                          arguments: [
                                            {"fields":  othersTicketList?[index].fields},
                                            {"canUpdateTicketStatus": canUpdateTicketStatus},
                                            {"canUpdateTicketCategory": canUpdateTicketCategory}
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
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    custom_text(text: strings_name.str_ticket_id, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5),
                                                    custom_text(text: othersTicketList![index].fields!.ticketId.toString(), textStyles: blackTextSemiBold16, leftValue: 5),
                                                  ],
                                                ),
                                                Container(
                                                    decoration: const BoxDecoration(color: colors_name.colorAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                    padding: const EdgeInsets.all(1),
                                                    child: custom_text(text: othersTicketList![index].fields!.ticketTitle![0].toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3)),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                custom_text(text: strings_name.str_created_by, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                                                custom_text(text: othersTicketList![index].fields!.employeeName?[0].toString() ?? "", textStyles: blackTextSemiBold16, leftValue: 5, topValue: 0),
                                              ],
                                            ),
                                            custom_text(text: othersTicketList![index].fields!.notes.toString(), textStyles: blackText16, topValue: 0, bottomValue: 5, leftValue: 5),
                                          ],
                                        ),
                                      ),
                                      Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 0), color: colors_name.lightGreyColor, padding: EdgeInsets.all(0.5)),
                                    ]),
                                  );
                                })
                                : custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
                          ],
                        ),
                      )
                    : Container(
                        child: myTicketList?.isNotEmpty == true
                            ? ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: myTicketList!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(children: [
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
                                                  custom_text(text: myTicketList![index].fields!.ticketId.toString(), textStyles: blackTextSemiBold16, leftValue: 5),
                                                ],
                                              ),
                                              Container(
                                                  decoration: const BoxDecoration(color: colors_name.colorAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                  padding: const EdgeInsets.all(1),
                                                  child: custom_text(text: myTicketList![index].fields!.ticketTitle![0].toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3)),
                                            ],
                                          ),
                                          custom_text(text: myTicketList![index].fields!.notes.toString(), textStyles: blackText16, topValue: 0, bottomValue: 5, leftValue: 5),
                                        ],
                                      ),
                                    ),
                                    Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 0), color: colors_name.lightGreyColor, padding: EdgeInsets.all(0.5)),
                                  ]);
                                })
                            : custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
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
                  Get.to(const HelpDesk());
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                )),
        ));
  }
}
