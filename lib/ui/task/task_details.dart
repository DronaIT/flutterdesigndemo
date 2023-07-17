import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/ui/task/add_task.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_edittext.dart';
import '../../customwidget/custom_text.dart';
import '../../models/help_desk_type_response.dart';
import '../../models/helpdesk_responses.dart';
import '../../values/text_styles.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';

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

  List<String> ticketStatusArray = <String>[TableNames.TICKET_STATUS_OPEN, TableNames.TICKET_STATUS_INPROGRESS, TableNames.TICKET_STATUS_HOLD, TableNames.TICKET_STATUS_RESOLVED, TableNames.TICKET_STATUS_SUGGESTION];
  String ticketValue = "", dateTimeDeadline = "";

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
                      helpDeskTypeResponse!.ticketTitle != null && helpDeskTypeResponse!.ticketTitle!.isNotEmpty
                          ? Container(
                              decoration: const BoxDecoration(color: colors_name.colorAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                              padding: const EdgeInsets.all(1),
                              margin: const EdgeInsets.only(right: 5),
                              child: custom_text(text: helpDeskTypeResponse!.ticketTitle![0].toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3),
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
                        child: custom_text(
                            text: helpDeskTypeResponse!.studentName?.isNotEmpty == true
                                ? helpDeskTypeResponse!.studentName![0].toString()
                                : (helpDeskTypeResponse!.employeeName?.isNotEmpty == true ? helpDeskTypeResponse!.employeeName![0].toString() : (helpDeskTypeResponse!.companyName?.isNotEmpty == true ? helpDeskTypeResponse!.companyName![0].toString() : "")),
                            textStyles: blackTextSemiBold16,
                            leftValue: 5,
                            maxLines: 2,
                            topValue: 0),
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
                  custom_text(text: "${helpDeskTypeResponse!.notes}", textStyles: blackTextSemiBold16, maxLines: 5000, leftValue: 5, rightValue: 0, topValue: 0),
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
                    child: custom_text(
                      text: "Remarks: ${helpDeskTypeResponse!.resolutionRemark}",
                      textStyles: blackText16,
                      topValue: 5,
                      bottomValue: 5,
                      leftValue: 5,
                      maxLines: 5000,
                    ),
                  ),
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
                              Get.back(result: true);
                            });
                            ;
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

  Future<void> updateTicket(Map<String, String> ticketFormula) async {
    setState(() {
      isVisible = true;
    });
    try {
      var resp = await helpRepository.updateTicket(ticketFormula, helpDeskTypeResponseId!);
      if (resp != null) {
        Utils.showSnackBarUsingGet(strings_name.str_update_ticket_message);
        setState(() {
          helpDeskTypeResponse = resp.fields;
          isVisible = false;
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
}
