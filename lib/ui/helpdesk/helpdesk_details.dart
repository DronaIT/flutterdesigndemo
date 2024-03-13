import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/ui/task/employee_selection.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/push_notification_service.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_edittext.dart';
import '../../customwidget/custom_text.dart';
import '../../models/help_desk_type_response.dart';
import '../../models/helpdesk_responses.dart';
import '../../values/text_styles.dart';

class HelpdeskDetail extends StatefulWidget {
  const HelpdeskDetail({Key? key}) : super(key: key);

  @override
  State<HelpdeskDetail> createState() => _HelpdeskDetailState();
}

class _HelpdeskDetailState extends State<HelpdeskDetail> {
  final helpRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  List<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>? helpDeskTypeArray = [];
  BaseApiResponseWithSerializable<HelpDeskTypeResponse>? helpDeskTypeSelected;
  int helpDeskTypeSelectedId = 0;

  HelpdeskResponses? helpDeskTypeResponse;
  String? helpDeskTypeResponseId, title;
  bool canUpdateTicketStatus = false, canUpdateTicketCategory = false, canUpdateTicketAssignee = false;

  TextEditingController helpDoneController = TextEditingController();

  List<String> ticketStatusArray = <String>[
    TableNames.TICKET_STATUS_OPEN,
    TableNames.TICKET_STATUS_INPROGRESS,
    TableNames.TICKET_STATUS_HOLD,
    TableNames.TICKET_STATUS_RESOLVED,
    TableNames.TICKET_STATUS_SUGGESTION
  ];
  String ticketValue = "", createdOn = "";

  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? employeeData = [];
  String offset = "";

  @override
  void initState() {
    super.initState();
    helpDeskTypeResponse = Get.arguments[0]["fields"];
    canUpdateTicketStatus = Get.arguments[1]["canUpdateTicketStatus"];
    canUpdateTicketCategory = Get.arguments[2]["canUpdateTicketCategory"];
    helpDeskTypeResponseId = Get.arguments[3]["recordId"];
    title = Get.arguments[4]["title"];
    canUpdateTicketAssignee = Get.arguments[5]["canUpdateTicketAssignee"];
    ticketValue = helpDeskTypeResponse?.status ?? TableNames.TICKET_STATUS_OPEN;
    if (canUpdateTicketCategory) {
      helpDeskType();
    }

    var createdDateTime = DateTime.parse(helpDeskTypeResponse!.createdOn!.trim()).toLocal();
    createdOn = DateFormat("yyyy-MM-dd hh:mm aa").format(createdDateTime);

    if (helpDeskTypeResponse?.assignedTo?.isNotEmpty == true) {
      getEmployeeData();
    }
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
          helpDeskTypeArray = resp.records;
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

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(title ?? strings_name.str_help_desk_detail),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          custom_text(text: strings_name.str_ticket_id, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5),
                          custom_text(text: helpDeskTypeResponse!.ticketId.toString(), textStyles: blackTextSemiBold16, rightValue: 0, leftValue: 5),
                        ],
                      ),
                      Container(
                          decoration: const BoxDecoration(color: colors_name.colorAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.all(1),
                          margin: const EdgeInsets.only(right: 5),
                          child: custom_text(
                              text: helpDeskTypeResponse!.ticketTitle![0].toString(),
                              textStyles: whiteTextSemiBold16,
                              alignment: Alignment.centerRight,
                              topValue: 1,
                              bottomValue: 1,
                              leftValue: 3,
                              rightValue: 3)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      custom_text(text: strings_name.str_created_by, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (helpDeskTypeResponse!.studentName?.isNotEmpty == true) {
                              Get.to(const StudentHistory(), arguments: helpDeskTypeResponse!.studentMobileNumber![0]);
                            }
                          },
                          child: custom_text(
                              text: helpDeskTypeResponse!.studentName?.isNotEmpty == true
                                  ? helpDeskTypeResponse!.studentName![0].toString()
                                  : (helpDeskTypeResponse!.employeeName?.isNotEmpty == true
                                      ? helpDeskTypeResponse!.employeeName![0].toString()
                                      : (helpDeskTypeResponse!.companyName?.isNotEmpty == true
                                          ? helpDeskTypeResponse!.companyName![0].toString()
                                          : "")),
                              textStyles: helpDeskTypeResponse!.studentName?.isNotEmpty == true ? linkTextSemiBold16 : blackTextSemiBold16,
                              leftValue: 5,
                              maxLines: 2,
                              topValue: 0),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      custom_text(text: strings_name.str_created_on, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                      Expanded(
                        child: custom_text(text: createdOn, textStyles: blackTextSemiBold16, leftValue: 5, maxLines: 2, topValue: 0),
                      ),
                    ],
                  ),
                  helpDeskTypeResponse!.studentHubName?.isNotEmpty == true
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            custom_text(text: strings_name.str_hubname, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                            Expanded(
                              child: custom_text(
                                  text: helpDeskTypeResponse!.studentHubName![0].toString(),
                                  textStyles: blackText16,
                                  leftValue: 5,
                                  maxLines: 2,
                                  topValue: 0),
                            ),
                          ],
                        )
                      : Container(),
                  helpDeskTypeResponse!.studentSpecializationName?.isNotEmpty == true
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            custom_text(
                                text: strings_name.str_specialization, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                            Expanded(
                              child: custom_text(
                                  text: helpDeskTypeResponse!.studentSpecializationName![0].toString(),
                                  textStyles: blackText16,
                                  leftValue: 5,
                                  maxLines: 2,
                                  topValue: 0),
                            ),
                          ],
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 8),
                          child: SelectableLinkify(
                            text: "${helpDeskTypeResponse!.notes?.trim()}",
                            style: blackText16,
                            onOpen: (link) async {
                              await launchUrl(Uri.parse(link.url), mode: LaunchMode.externalApplication);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  helpDeskTypeResponse!.attachments != null
                      ? Row(children: [
                          custom_text(
                              text: "${strings_name.str_attachments} : ",
                              textStyles: primaryTextSemiBold16,
                              topValue: 5,
                              maxLines: 2,
                              bottomValue: 10,
                              leftValue: 5),
                          GestureDetector(
                              onTap: () async {
                                await launchUrl(Uri.parse(helpDeskTypeResponse!.attachments?.first.url ?? ""), mode: LaunchMode.externalApplication);
                              },
                              child: custom_text(
                                  text: "Show", textStyles: primaryTextSemiBold16, topValue: 5, maxLines: 2, bottomValue: 10, leftValue: 0)),
                        ])
                      : Container(),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      custom_text(
                        text: strings_name.str_status,
                        textStyles: primaryTextSemiBold16,
                        topValue: 5,
                        bottomValue: 5,
                        leftValue: 5,
                      ),
                      Container(
                          decoration: const BoxDecoration(color: colors_name.presentColor, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: const EdgeInsets.all(1),
                          margin: const EdgeInsets.only(right: 5),
                          child: custom_text(
                              text: helpDeskTypeResponse!.status.toString(),
                              textStyles: whiteTextSemiBold16,
                              alignment: Alignment.centerRight,
                              topValue: 1,
                              bottomValue: 1,
                              leftValue: 3,
                              rightValue: 3)),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  PreferenceUtils.getIsLogin() == 2 &&
                          helpDeskTypeResponse!.assignedEmployeeName != null &&
                          helpDeskTypeResponse!.assignedEmployeeName!.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            custom_text(
                                text: strings_name.str_assigned_to, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                            Expanded(
                              child: custom_text(
                                  text: helpDeskTypeResponse!.assignedEmployeeName?.join(",").replaceAll(" ,", ", ") ?? "",
                                  textStyles: blackTextSemiBold16,
                                  leftValue: 5,
                                  maxLines: 5000,
                                  topValue: 0),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(height: 5.h),
                  Visibility(
                    visible: helpDeskTypeResponse!.resolutionRemark?.trim().isNotEmpty == true,
                    child: Column(children: [
                      SizedBox(height: 3.h),
                      custom_text(
                          text: "${strings_name.str_remarks}: ",
                          textStyles: primaryTextSemiBold16,
                          rightValue: 0,
                          leftValue: 5,
                          topValue: 0,
                          bottomValue: 5),
                      custom_text(
                          text: "${helpDeskTypeResponse!.resolutionRemark}",
                          textStyles: blackTextSemiBold16,
                          maxLines: 5000,
                          leftValue: 5,
                          rightValue: 0,
                          topValue: 0),
                    ]),
                  ),
                  SizedBox(height: 5.h),
                  helpDeskTypeResponse?.status_updated_by_employee_name?.isNotEmpty != null
                      ? Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          custom_text(
                              text: "${strings_name.str_updated_by}: ",
                              textStyles: primaryTextSemiBold16,
                              rightValue: 0,
                              leftValue: 5,
                              topValue: 0,
                              bottomValue: 5),
                          custom_text(
                              text: helpDeskTypeResponse!.status_updated_by_employee_name![0],
                              textStyles: blackTextSemiBold16,
                              maxLines: 2,
                              leftValue: 5,
                              rightValue: 0,
                              topValue: 0),
                        ])
                      : Container(),
                  Visibility(
                      visible: helpDeskTypeResponse!.status != TableNames.TICKET_STATUS_RESOLVED && canUpdateTicketStatus,
                      child: CustomButton(
                          text: strings_name.str_update_ticket_status,
                          click: () {
                            showStatusUpdateDialog(viewWidth);
                          })),
                  Visibility(
                      visible: helpDeskTypeResponse!.status != TableNames.TICKET_STATUS_RESOLVED && canUpdateTicketCategory,
                      child: CustomButton(
                          text: strings_name.str_update_ticket_type,
                          click: () {
                            showCategoryUpdateDialog(viewWidth);
                          })),
                  Visibility(
                      visible: helpDeskTypeResponse!.status != TableNames.TICKET_STATUS_RESOLVED && canUpdateTicketAssignee,
                      child: CustomButton(
                          text: strings_name.str_update_ticket_assignee,
                          click: () {
                            showUpdateAssigneeDialog();
                          })),
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

  /*
  *   Type values
  *   1 => Updated category
  *   2 => Status updated
  *   3 => Assignee updated
  */
  Future<void> updateTicket(Map<String, dynamic> ticketFormula, int type) async {
    setState(() {
      isVisible = true;
    });
    try {
      var resp = await helpRepository.updateTicket(ticketFormula, helpDeskTypeResponseId!);
      if (resp.fields != null) {
        Utils.showSnackBarUsingGet(strings_name.str_update_ticket_message);
        setState(() {
          helpDeskTypeResponse = resp.fields;
          isVisible = false;
        });
        sendPushNotification(type);
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

  sendPushNotification(int type) {
    String message = "", selfMessage = "";
    if (type == 1) {
      message = strings_name.str_push_desc_assigned_ticket_category_updated;
      selfMessage = strings_name.str_push_desc_ticket_category_updated;
    } else if (type == 2) {
      if (helpDeskTypeResponse?.status == TableNames.TICKET_STATUS_COMPLETED || helpDeskTypeResponse?.status == TableNames.TICKET_STATUS_RESOLVED) {
        selfMessage = strings_name.str_push_desc_ticket_resolved;
      } else {
        selfMessage = strings_name.str_push_desc_ticket_status_updated;
      }
    } else if (type == 3) {
      message = strings_name.str_push_desc_ticket_assignee_updated;
    }

    if (helpDeskTypeResponse?.assignedToToken?.isNotEmpty == true && message.isNotEmpty) {
      List<String> tokens = helpDeskTypeResponse!.assignedToToken!;
      if (PreferenceUtils.getIsLogin() == 2 && tokens.contains(PreferenceUtils.getLoginDataEmployee().token!)) {
        tokens.remove(PreferenceUtils.getLoginDataEmployee().token!);
      }
      if (tokens.isNotEmpty) {
        PushNotificationService.sendNotificationToMultipleDevices(tokens, "", message);
      }
    }
    if (helpDeskTypeResponse?.createdByOrganizationToken?.isNotEmpty == true && selfMessage.isNotEmpty) {
      PushNotificationService.sendNotificationToMultipleDevices(helpDeskTypeResponse!.createdByOrganizationToken!, "", selfMessage);
    }
    if (helpDeskTypeResponse?.createdByStudentToken?.isNotEmpty == true && selfMessage.isNotEmpty) {
      PushNotificationService.sendNotificationToMultipleDevices(helpDeskTypeResponse!.createdByStudentToken!, "", selfMessage);
    }
    if (helpDeskTypeResponse?.createdByEmployeeToken?.isNotEmpty == true && selfMessage.isNotEmpty) {
      PushNotificationService.sendNotificationToMultipleDevices(helpDeskTypeResponse!.createdByEmployeeToken!, "", selfMessage);
    }
  }

  Future<void> showCategoryUpdateDialog(double viewWidth) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                              value: helpDeskTypeSelected,
                              elevation: 16,
                              style: blackText16,
                              focusColor: Colors.white,
                              onChanged: (BaseApiResponseWithSerializable<HelpDeskTypeResponse>? newValue) {
                                setState(() {
                                  helpDeskTypeSelectedId = newValue!.fields!.id!;
                                  helpDeskTypeSelected = newValue;
                                });
                              },
                              items: helpDeskTypeArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>>(
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
                    SizedBox(height: 10.h),
                    CustomButton(
                        text: strings_name.str_update,
                        click: () {
                          Get.back();

                          List<String> assigned_to = [];
                          List<String> authority_of = [];
                          var hubName = PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0];

                          if (helpDeskTypeSelected!.fields!.centerAuthority != null) {
                            for (int j = 0; j < helpDeskTypeSelected!.fields!.centerAuthority!.length; j++) {
                              if (helpDeskTypeSelected!.fields!.centerAuthorityHubId![j] == hubName) {
                                if (authority_of.isEmpty || !authority_of.contains(helpDeskTypeSelected!.fields!.centerAuthority![j])) {
                                  authority_of.add(helpDeskTypeSelected!.fields!.centerAuthority![j]);
                                }
                              }
                            }
                          }

                          if (helpDeskTypeSelected!.fields!.concernPerson != null) {
                            for (int j = 0; j < helpDeskTypeSelected!.fields!.concernPerson!.length; j++) {
                              if (helpDeskTypeSelected!.fields!.concernPersonHubId![j] == hubName) {
                                if (assigned_to.isEmpty || !assigned_to.contains(helpDeskTypeSelected!.fields!.concernPerson![j])) {
                                  assigned_to.add(helpDeskTypeSelected!.fields!.concernPerson![j]);
                                }
                              }
                            }
                          }

                          Map<String, dynamic> ticketFormula = {};
                          ticketFormula["ticket_type_id"] = [helpDeskTypeSelected?.id] ?? [];
                          ticketFormula["assigned_to"] = assigned_to;
                          ticketFormula["authority_of"] = authority_of;

                          updateTicket(ticketFormula, 1);
                        }),
                  ],
                ));
          });
        });
  }

  Future<void> showStatusUpdateDialog(double viewWidth) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    custom_text(
                      text: strings_name.str_status,
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
                              value: ticketValue,
                              style: blackText16,
                              focusColor: Colors.white,
                              onChanged: (String? newValue) {
                                setState(() {
                                  ticketValue = newValue!;
                                });
                              },
                              items: ticketStatusArray.map<DropdownMenuItem<String>>((String value) {
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
                    Visibility(
                      visible: ticketValue != TableNames.TICKET_STATUS_OPEN && ticketValue != TableNames.TICKET_STATUS_INPROGRESS,
                      child: custom_edittext(
                        type: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        controller: helpDoneController,
                        topValue: 5,
                        maxLines: 5,
                        minLines: 4,
                        hintText: strings_name.str_type_here,
                        maxLength: 5000,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    CustomButton(
                        text: strings_name.str_update,
                        click: () {
                          Get.back();

                          Map<String, dynamic> ticketFormula = {};
                          ticketFormula["Status"] = ticketValue;
                          if (ticketValue != TableNames.TICKET_STATUS_OPEN && ticketValue != TableNames.TICKET_STATUS_INPROGRESS) {
                            if (helpDoneController.text.trim().isNotEmpty) {
                              ticketFormula["resolution_remark"] = helpDoneController.text.trim();
                            }
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
                          ticketFormula["status_updated_by"] = updatedBy.split(",");
                          updateTicket(ticketFormula, 2);
                        })
                  ],
                ));
          });
        });
  }

  showUpdateAssigneeDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    custom_text(
                      text: strings_name.str_update_ticket_assignee,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    Row(
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
                                        Expanded(
                                            child:
                                                Text("${employeeData![index].fields!.employeeName}", textAlign: TextAlign.start, style: blackText16)),
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
                    CustomButton(
                        text: strings_name.str_update,
                        click: () {
                          if (employeeData?.isNotEmpty == true) {
                            Get.back();

                            List<String> assigned_to = [];
                            for (int j = 0; j < employeeData!.length; j++) {
                              assigned_to.add(employeeData![j].id!);
                            }

                            Map<String, dynamic> ticketFormula = {};
                            ticketFormula["assigned_to"] = assigned_to;

                            updateTicket(ticketFormula, 3);
                          } else {
                            Utils.showSnackBarUsingGet(strings_name.str_empty_ticket_assignee);
                          }
                        }),
                  ],
                ));
          });
        });
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
      var data = await helpRepository.getEmployeeListApi(query, offset);
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
}
