import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
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
  HelpdeskResponses? helpDeskTypeResponse;
  bool canUpdateTicketStatus = false, canUpdateTicketCategory = false;
  TextEditingController helpDoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    helpDeskTypeResponse = Get.arguments[0]["fields"];
    canUpdateTicketStatus = Get.arguments[1]["canUpdateTicketStatus"];
    canUpdateTicketCategory = Get.arguments[2]["canUpdateTicketCategory"];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_help_desk_detail),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          custom_text(text: strings_name.str_ticket_id, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5),
                          custom_text(text: helpDeskTypeResponse!.ticketId.toString(), textStyles: blackTextSemiBold16, leftValue: 5),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      custom_text(text: strings_name.str_created_by, textStyles: primaryTextSemiBold16, rightValue: 0, leftValue: 5, topValue: 0),
                      custom_text(text: helpDeskTypeResponse!.employeeName?[0].toString() ?? "", textStyles: blackTextSemiBold16, leftValue: 5, topValue: 0),
                    ],
                  ),
                  custom_text(
                    text: "${strings_name.str_notes} ${helpDeskTypeResponse!.notes}",
                    textStyles: blackText16,
                    topValue: 0,
                    bottomValue: 5,
                    leftValue: 5,
                    maxLines: 4,
                  ),
                  SizedBox(height: 10.h),
                  custom_edittext(
                    type: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: helpDoneController,
                    topValue: 5,
                    maxLines: 5,
                    minLines: 4,
                    hintText: strings_name.str_type_here,
                    maxLength: 5000,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
