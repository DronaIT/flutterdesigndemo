import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/ui/task/add_task.dart';
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
import '../../customwidget/custom_text.dart';
import '../../models/help_desk_type_response.dart';
import '../../models/helpdesk_responses.dart';
import '../../values/text_styles.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({Key? key}) : super(key: key);

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  final helpRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  List<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>? helpDeskTypeArray = [];
  BaseApiResponseWithSerializable<HelpDeskTypeResponse>? helpDeskTypeSelected;
  int helpDeskTypeSelectedId = 0;

  HelpdeskResponses? helpDeskTypeResponse;
  String? helpDeskTypeResponseId;
  bool canUpdateTask = false, updateStatusNow = false, updateCategoryNow = false, isUpdated = false;
  TextEditingController helpDoneController = TextEditingController();

  String dateTimeDeadline = "";

  @override
  void initState() {
    super.initState();
    helpDeskTypeResponse = Get.arguments[0]["fields"];
    canUpdateTask = Get.arguments[1]["canUpdateTask"];
    helpDeskTypeResponseId = Get.arguments[2]["recordId"];

    if (helpDeskTypeResponse?.deadline != null && helpDeskTypeResponse?.deadline?.isNotEmpty == true) {
      dateTimeDeadline = DateFormat("yyyy-MM-dd hh:mm aa").format(DateTime.parse(helpDeskTypeResponse!.deadline!).toLocal());
    }

    if (helpDeskTypeResponse?.status == TableNames.TICKET_STATUS_COMPLETED) {
      canUpdateTask = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_task_detail),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                            custom_text(text: helpDeskTypeResponse!.ticketId.toString(), textStyles: blackTextSemiBold16, rightValue: 0, leftValue: 5),
                          ],
                        ),
                      ),
                      helpDeskTypeResponse!.ticketTitle != null && helpDeskTypeResponse!.ticketTitle!.isNotEmpty
                          ? Container(
                              decoration: const BoxDecoration(color: colors_name.colorAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                              padding: const EdgeInsets.all(1),
                              child: custom_text(
                                text: helpDeskTypeResponse!.ticketTitle![0].toString(),
                                textStyles: whiteTextSemiBold16,
                                alignment: Alignment.centerRight,
                                topValue: 1,
                                bottomValue: 1,
                                leftValue: 3,
                                rightValue: 3,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      custom_text(text: strings_name.str_assigned_by, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
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
                                  : (helpDeskTypeResponse!.employeeName?.isNotEmpty == true ? helpDeskTypeResponse!.employeeName![0].toString() : (helpDeskTypeResponse!.companyName?.isNotEmpty == true ? helpDeskTypeResponse!.companyName![0].toString() : "")),
                              textStyles: helpDeskTypeResponse!.studentName?.isNotEmpty == true ? linkTextSemiBold16 : blackTextSemiBold16,
                              leftValue: 5,
                              maxLines: 2,
                              topValue: 0),
                        ),
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
                              child: custom_text(text: helpDeskTypeResponse!.studentHubName![0].toString(), textStyles: blackText16, leftValue: 5, maxLines: 2, topValue: 0),
                            ),
                          ],
                        )
                      : Container(),
                  helpDeskTypeResponse!.studentSpecializationName?.isNotEmpty == true
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            custom_text(text: strings_name.str_specialization, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                            Expanded(
                              child: custom_text(text: helpDeskTypeResponse!.studentSpecializationName![0].toString(), textStyles: blackText16, leftValue: 5, maxLines: 2, topValue: 0),
                            ),
                          ],
                        )
                      : Container(),
                  custom_text(text: "${strings_name.str_task}: ", textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0, bottomValue: 5),
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
                          custom_text(text: "${strings_name.str_attachments} : ", textStyles: primaryTextSemiBold16, topValue: 5, maxLines: 2, bottomValue: 10, leftValue: 5),
                          GestureDetector(
                              onTap: () async {
                                await launchUrl(Uri.parse(helpDeskTypeResponse!.attachments?.first.url ?? ""), mode: LaunchMode.externalApplication);
                              },
                              child: custom_text(text: "Show", textStyles: primaryTextSemiBold16, topValue: 5, maxLines: 2, bottomValue: 10, leftValue: 0)),
                        ])
                      : Container(),
                  helpDeskTypeResponse!.required_time != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            custom_text(text: strings_name.str_provided_duration, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                            custom_text(text: helpDeskTypeResponse!.required_time != null ? "${helpDeskTypeResponse?.required_time} Hours" : "", textStyles: blackTextSemiBold16, leftValue: 5, topValue: 0),
                          ],
                        )
                      : Container(),
                  dateTimeDeadline.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            custom_text(text: strings_name.str_deadline, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                            custom_text(text: dateTimeDeadline, textStyles: blackTextSemiBold16, leftValue: 5, topValue: 0),
                          ],
                        )
                      : Container(),
                  helpDeskTypeResponse?.task_importance?.isNotEmpty == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            custom_text(text: strings_name.str_task_importance, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                            custom_text(text: helpDeskTypeResponse!.task_importance.toString(), textStyles: blackTextSemiBold16, leftValue: 5, topValue: 0),
                          ],
                        )
                      : Container(),
                  helpDeskTypeResponse!.assignedEmployeeName != null && helpDeskTypeResponse!.assignedEmployeeName!.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            custom_text(text: strings_name.str_assigned_to, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                            Expanded(
                              child: custom_text(text: helpDeskTypeResponse!.assignedEmployeeName?.join(",").replaceAll(" ,", ", ") ?? "", textStyles: blackTextSemiBold16, leftValue: 5, maxLines: 5000, topValue: 0),
                            ),
                          ],
                        )
                      : Container(),
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
                          child: custom_text(text: helpDeskTypeResponse!.status.toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3)),
                    ],
                  ),
                  Visibility(
                    visible: helpDeskTypeResponse!.resolutionRemark?.trim().isNotEmpty == true,
                    child: Column(children: [
                      SizedBox(height: 3.h),
                      custom_text(text: "${strings_name.str_remarks}: ", textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0, bottomValue: 5),
                      custom_text(text: "${helpDeskTypeResponse!.resolutionRemark}", textStyles: blackTextSemiBold16, maxLines: 5000, leftValue: 5, rightValue: 0, topValue: 0),
                    ]),
                  ),
                  helpDeskTypeResponse?.status_updated_by_employee_name?.isNotEmpty != null
                      ? Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          custom_text(text: "${strings_name.str_updated_by}: ", textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 5, bottomValue: 5),
                          custom_text(text: helpDeskTypeResponse!.status_updated_by_employee_name![0], textStyles: blackTextSemiBold16, maxLines: 2, leftValue: 5, rightValue: 0, topValue: 5),
                        ])
                      : Container(),
                  Visibility(
                      visible: (helpDeskTypeResponse!.status != TableNames.TICKET_STATUS_RESOLVED || helpDeskTypeResponse!.status != TableNames.TICKET_STATUS_COMPLETED) && canUpdateTask,
                      child: CustomButton(
                          text: strings_name.str_update_task,
                          click: () {
                            Get.to(const AddTask(), arguments: [
                              {"fields": helpDeskTypeResponse},
                              {"fromUpdate": true},
                              {"recordId": helpDeskTypeResponseId}
                            ])?.then((value) {
                              if (value != null && value) {
                                Get.back(result: true);
                              }
                            });
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
  Future<void> updateTicket(Map<String, String> ticketFormula, int type) async {
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
}
