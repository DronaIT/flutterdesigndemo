import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/punch_data_response.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../values/text_styles.dart';

class PunchDataList extends StatefulWidget {
  const PunchDataList({Key? key}) : super(key: key);

  @override
  State<PunchDataList> createState() => _PunchDataListState();
}

class _PunchDataListState extends State<PunchDataList> {
  List<BaseApiResponseWithSerializable<PunchDataResponse>> studentList = [];
  List<BaseApiResponseWithSerializable<PunchDataResponse>> test = [];

  bool isVisible = false;
  var controllerSearch = TextEditingController();

  int totalAbsent = 0;

  @override
  void initState() {
    super.initState();
    if (Get.arguments[0]["punchData"] != null) {
      test = Get.arguments[0]["punchData"];
      studentList = Get.arguments[0]["punchData"];
    }

    for (int i = 0; i < test.length; i++) {
      if (test[i].fields?.attendanceType == TableNames.ATTENDANCE_TYPE_FULL_DAY_LEAVE) {
        totalAbsent += 1;
      }
      if (test[i].fields?.attendanceType != TableNames.ATTENDANCE_TYPE_FULL_DAY_LEAVE) {
        if (test[i].fields?.actualInTime?.isNotEmpty == true) {
          DateTime actualTime = DateFormat("hh:mm aa").parse(test[i].fields?.actualInTime?.last ?? "");
          DateTime punchTime = DateFormat("hh:mm aa").parse(test[i].fields?.punchInTime ?? "");
          test[i].fields?.runningLate = punchTime.isAfter(actualTime);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_punch_leave_records),
      body: Stack(children: [
        Column(
          children: [
            SizedBox(height: 5.h),
            Row(children: [
              custom_text(
                text: "${strings_name.str_total_on_leave}: ",
                textStyles: blackTextSemiBold16,
                topValue: 5,
                bottomValue: 5,
                maxLines: 2,
                rightValue: 0,
              ),
              custom_text(
                text: totalAbsent.toString(),
                textStyles: primaryTextSemiBold16,
                topValue: 5,
                bottomValue: 5,
                maxLines: 2,
                leftValue: 5,
              ),
            ]),
            SizedBox(height: 10.h),
            CustomEditTextSearch(
              type: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: controllerSearch,
              onChanges: (value) {
                if (value.isEmpty) {
                  studentList = [];
                  studentList = List.from(test);
                  setState(() {});
                } else {
                  studentList = [];
                  for (var i = 0; i < test.length; i++) {
                    if (test[i].fields!.employeeName!.last.toLowerCase().contains(value.toLowerCase())) {
                      studentList.add(test[i]);
                    }
                  }
                  setState(() {});
                }
              },
            ),
            studentList.isNotEmpty
                ? Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ListView.builder(
                          itemCount: studentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 5,
                              child: Container(
                                color: colors_name.colorWhite,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    custom_text(text: "${studentList[index].fields?.employeeName?.last}", textStyles: primaryTextSemiBold16),
                                    Row(
                                      children: [
                                        custom_text(
                                          text: "${strings_name.str_mobile}:",
                                          alignment: Alignment.topLeft,
                                          textStyles: blackTextSemiBold14,
                                          topValue: 0,
                                          bottomValue: 5,
                                          rightValue: 5,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _launchCaller(studentList[index].fields!.employeeMobileNumber?.last ?? "");
                                          },
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            margin: const EdgeInsets.only(top: 0, bottom: 5),
                                            child: Text(
                                              "${studentList[index].fields!.employeeMobileNumber?.last}",
                                              style: const TextStyle(
                                                decoration: TextDecoration.underline,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(
                                            topValue: 0,
                                            bottomValue: 5,
                                            text: "${strings_name.str_punch_date} : ${studentList[index].fields?.punchDate}",
                                            textStyles: blackTextSemiBold14),
                                        studentList[index].fields?.runningLate == true
                                            ? Container(
                                                decoration: const BoxDecoration(
                                                    color: colors_name.colorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                padding: const EdgeInsets.all(1),
                                                child: custom_text(
                                                  topValue: 3,
                                                  bottomValue: 3,
                                                  leftValue: 5,
                                                  rightValue: 5,
                                                  text: strings_name.str_running_late,
                                                  textStyles: whiteText12,
                                                ))
                                            : Container(),
                                      ],
                                    ),
                                    studentList[index].fields?.attendanceType != TableNames.ATTENDANCE_TYPE_PRESENT
                                        ? custom_text(
                                            topValue: 0,
                                            bottomValue: 5,
                                            text: "On Leave : ${studentList[index].fields?.attendanceType}",
                                            textStyles: primaryTextSemiBold14)
                                        : Container(),
                                    studentList[index].fields?.attendanceType != TableNames.ATTENDANCE_TYPE_FULL_DAY_LEAVE
                                        ? custom_text(
                                            topValue: 0,
                                            bottomValue: 5,
                                            text:
                                                "${strings_name.str_punch_time} : ${studentList[index].fields?.punchInTime} - ${studentList[index].fields?.punchOutTime}",
                                            textStyles: blackTextSemiBold14)
                                        : Container(),
                                    studentList[index].fields?.reasonForLeave?.isNotEmpty == true
                                        ? custom_text(
                                            topValue: 0,
                                            bottomValue: 5,
                                            text: "${strings_name.str_reason_for_leave} : ${studentList[index].fields?.reasonForLeave}",
                                            textStyles: blackTextSemiBold14)
                                        : Container(),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          ],
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }

  _launchCaller(String mobile) async {
    try {
      await launchUrl(Uri.parse("tel:$mobile"), mode: LaunchMode.externalApplication);
    } catch (e) {
      Utils.showSnackBarUsingGet(strings_name.str_invalid_mobile);
    }
  }
}
