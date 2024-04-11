import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_text.dart';
import '../../models/login_fields_response.dart';
import '../../values/text_styles.dart';

class StudentPlacementHistory extends StatefulWidget {
  const StudentPlacementHistory({Key? key}) : super(key: key);

  @override
  State<StudentPlacementHistory> createState() => _StudentPlacementHistoryState();
}

class _StudentPlacementHistoryState extends State<StudentPlacementHistory> {
  bool isVisible = false;
  LoginFieldsResponse? fields;

  @override
  void initState() {
    super.initState();
    fields = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_placement),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 5.h),
                  custom_text(
                      text: fields?.appliedJob != null && fields!.appliedJob!.isNotEmpty ? "Applied jobs : ${fields?.appliedJob!.length}" : "Applied in jobs : 0",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextbold14,
                      bottomValue: 0),
                  fields?.appliedJob != null && fields!.appliedJob!.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.all(10),
                          child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: fields?.appliedJob!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                    elevation: 5,
                                    child: Container(
                                      color: colors_name.colorWhite,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(children: [
                                        custom_text(
                                          text: fields!.company_name_from_applied_job?[index] ?? "",
                                          textStyles: primaryTextSemiBold14,
                                          maxLines: 2,
                                          topValue: 0,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "Job title: ${fields!.job_title_from_applied_job?[index] ?? ""}",
                                          textStyles: primryTextSemiBold13,
                                          maxLines: 2,
                                          topValue: 10,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "Job description: ${fields!.job_description_from_applied_job?[index] ?? ""}",
                                          textStyles: primryTextSemiBold13,
                                          maxLines: 5,
                                          topValue: 5,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "Contact person name: ${fields!.contact_name_from_applied_job?[index].trim() ?? ""}",
                                          textStyles: primryTextSemiBold13,
                                          maxLines: 2,
                                          topValue: 5,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        )
                                      ]),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container(margin: const EdgeInsets.only(top: 5), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
                  custom_text(
                      text: fields?.selectedJob != null && fields!.selectedJob!.isNotEmpty ? "Selected in jobs : ${fields?.selectedJob!.length}" : "Selected in jobs : 0",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextbold14,
                      bottomValue: 0),
                  fields?.selectedJob != null && fields!.selectedJob!.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.all(10),
                          child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: fields?.selectedJob!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                    elevation: 5,
                                    child: Container(
                                      color: colors_name.colorWhite,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(children: [
                                        custom_text(
                                          text: fields!.company_name_from_selected_job?[index] ?? "",
                                          textStyles: primaryTextSemiBold14,
                                          maxLines: 2,
                                          topValue: 0,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "Job title: ${fields!.job_title_selected_job?[index] ?? ""}",
                                          textStyles: primryTextSemiBold13,
                                          maxLines: 2,
                                          topValue: 10,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "Job description: ${fields!.job_description_from_selected_job?[index] ?? ""}",
                                          textStyles: primryTextSemiBold13,
                                          maxLines: 5,
                                          topValue: 5,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "Contact person name: ${fields!.contact_name_from_selected_job?[index].trim() ?? ""}",
                                          textStyles: primryTextSemiBold13,
                                          maxLines: 2,
                                          topValue: 5,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "Job location: ${fields!.city_from_selected_job?[index] ?? ""}",
                                          textStyles: primryTextSemiBold13,
                                          maxLines: 2,
                                          topValue: 5,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                      ]),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container(margin: const EdgeInsets.only(top: 5), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
                  custom_text(
                    text: fields?.placedJob != null && fields!.placedJob!.isNotEmpty ? "Placed in jobs : ${fields?.placedJob!.length}" : "Placed in jobs : 0",
                    alignment: Alignment.topLeft,
                    textStyles: blackTextbold14,
                    bottomValue: 0,
                    topValue: 0,
                  ),
                  fields?.placedJob != null && fields!.placedJob!.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.all(10),
                          child: ListView.builder(
                              primary: false,
                              itemCount: fields?.placedJob!.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                    elevation: 5,
                                    child: Container(
                                      color: colors_name.colorWhite,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(children: [
                                        custom_text(
                                          text: fields!.company_name_from_placed_job?[index] ?? "",
                                          textStyles: primaryTextSemiBold14,
                                          maxLines: 2,
                                          topValue: 0,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "Placed job title: ${fields!.job_title_from_placed_job?[index] ?? ""}",
                                          textStyles: primryTextSemiBold13,
                                          maxLines: 2,
                                          topValue: 10,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "Placed job description: ${fields!.job_description_from_placed_job?[index] ?? ""}",
                                          textStyles: primryTextSemiBold13,
                                          maxLines: 5,
                                          topValue: 5,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                        fields!.is_placed_now == "1" && fields!.company_name_from_placed_job?[index] == fields!.last_company_name?[0]
                                            ? const custom_text(
                                                text: "Currently working Here",
                                                textStyles: primryTextSemiBold14,
                                                maxLines: 2,
                                                topValue: 10,
                                                bottomValue: 0,
                                                leftValue: 5,
                                              )
                                            : Container(),
                                      ]),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container(margin: const EdgeInsets.only(top: 5), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
                  custom_text(
                    text: fields?.rejectedJob != null && fields!.rejectedJob!.isNotEmpty ? "Rejected in jobs : ${fields?.rejectedJob!.length}" : "Rejected in jobs : 0",
                    alignment: Alignment.topLeft,
                    textStyles: blackTextbold14,
                    bottomValue: 0,
                    topValue: 0,
                  ),
                  fields?.rejectedJob != null && fields!.rejectedJob!.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.all(10),
                          child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: fields?.rejectedJob!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Card(
                                    elevation: 5,
                                    child: Container(
                                      color: colors_name.colorWhite,
                                      padding: const EdgeInsets.all(10),
                                      child: Column(children: [
                                        custom_text(
                                          text: fields!.company_name_from_rejected_job?[index] ?? "",
                                          textStyles: primaryTextSemiBold14,
                                          maxLines: 2,
                                          topValue: 0,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "Placed job title: ${fields!.job_title_from_rejected_job?[index] ?? ""}",
                                          textStyles: primryTextSemiBold13,
                                          maxLines: 2,
                                          topValue: 10,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "Placed job description: ${fields!.job_description_from_rejected_job?[index] ?? ""}",
                                          textStyles: primryTextSemiBold13,
                                          maxLines: 5,
                                          topValue: 5,
                                          bottomValue: 0,
                                          leftValue: 5,
                                        ),
                                      ]),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container(margin: const EdgeInsets.only(top: 5), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
                ],
              ),
              Center(
                child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
