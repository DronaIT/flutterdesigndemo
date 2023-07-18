import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_edittext.dart';
import '../../customwidget/custom_text.dart';
import '../../models/help_desk_type_response.dart';
import '../../models/helpdesk_responses.dart';
import '../../values/text_styles.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';

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
  bool canUpdateTicketStatus = false, canUpdateTicketCategory = false;

  TextEditingController helpDoneController = TextEditingController();

  List<String> ticketStatusArray = <String>[TableNames.TICKET_STATUS_OPEN, TableNames.TICKET_STATUS_INPROGRESS, TableNames.TICKET_STATUS_HOLD, TableNames.TICKET_STATUS_RESOLVED, TableNames.TICKET_STATUS_SUGGESTION];
  String ticketValue = "";

  @override
  void initState() {
    super.initState();
    helpDeskTypeResponse = Get.arguments[0]["fields"];
    canUpdateTicketStatus = Get.arguments[1]["canUpdateTicketStatus"];
    canUpdateTicketCategory = Get.arguments[2]["canUpdateTicketCategory"];
    helpDeskTypeResponseId = Get.arguments[3]["recordId"];
    title = Get.arguments[4]["title"];
    ticketValue = helpDeskTypeResponse?.status ?? TableNames.TICKET_STATUS_OPEN;
    if (canUpdateTicketCategory) {
      helpDeskType();
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
                          child: custom_text(text: helpDeskTypeResponse!.ticketTitle![0].toString(), textStyles: whiteTextSemiBold16, alignment: Alignment.centerRight, topValue: 1, bottomValue: 1, leftValue: 3, rightValue: 3)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      custom_text(text: strings_name.str_created_by, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
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
                  helpDeskTypeResponse!.studentHubName?.isNotEmpty == true ? Row(
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
                  ) : Container(),
                  helpDeskTypeResponse!.studentSpecializationName?.isNotEmpty == true ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      custom_text(text: strings_name.str_specialization, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                      Expanded(
                        child: custom_text(
                            text: helpDeskTypeResponse!.studentSpecializationName![0].toString(),
                            textStyles: blackText16,
                            leftValue: 5,
                            maxLines: 2,
                            topValue: 0),
                      ),
                    ],
                  ) : Container(),
                  custom_text(
                    text: "${helpDeskTypeResponse!.notes}",
                    textStyles: blackText16,
                    topValue: 5,
                    bottomValue: 5,
                    leftValue: 5,
                    maxLines: 5000,
                  ),
                  SizedBox(height: 10.h),
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
                  SizedBox(height: 5.h),
                  Visibility(
                    visible: helpDeskTypeResponse!.resolutionRemark?.trim().isNotEmpty == true,
                    child: Column(children: [
                      SizedBox(height: 3.h),
                      custom_text(text: "${strings_name.str_remarks}: ", textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0, bottomValue: 5),
                      custom_text(text: "${helpDeskTypeResponse!.resolutionRemark}", textStyles: blackTextSemiBold16, maxLines: 5000, leftValue: 5, rightValue: 0, topValue: 0),
                    ]),
                  ),
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

  Future<void> updateTicket(Map<String, dynamic> ticketFormula) async {
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
                              items: helpDeskTypeArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>>((BaseApiResponseWithSerializable<HelpDeskTypeResponse> value) {
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

                          if (helpDeskTypeSelected!.fields!.centerAutority != null) {
                            for (int j = 0; j < helpDeskTypeSelected!.fields!.centerAutority!.length; j++) {
                              if (helpDeskTypeSelected!.fields!.centerAuthorityHubId![j] == hubName) {
                                if (authority_of.isEmpty || !authority_of.contains(helpDeskTypeSelected!.fields!.centerAutority![j])) {
                                  authority_of.add(helpDeskTypeSelected!.fields!.centerAutority![j]);
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

                          updateTicket(ticketFormula);
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
                          updateTicket(ticketFormula);
                        })
                  ],
                ));
          });
        });
  }
}
