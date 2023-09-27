import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../values/text_styles.dart';

class FilterDataStudent extends StatefulWidget {
  const FilterDataStudent({Key? key}) : super(key: key);

  @override
  State<FilterDataStudent> createState() => _FilterDataStudentState();
}

class _FilterDataStudentState extends State<FilterDataStudent> {
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> studentList = [];

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> test = [];

  bool isVisible = false;
  var subjectName;

  var subjectId;

  var isFromEligible;
  var speName;
  var hubName;
  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (Get.arguments[0]["studentList"] != null) {
      test = Get.arguments[0]["studentList"];
      studentList = Get.arguments[0]["studentList"];
      subjectName = Get.arguments[1]["subject"];
      subjectId = Get.arguments[4]["subjectid"];
      speName = Get.arguments[2]["specialization"];
      hubName = Get.arguments[3]["hub"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_students),
      body: Stack(children: [
        Column(
          children: [
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                custom_text(text: "Total Students: ${test.length}", textStyles: primaryTextSemiBold16),
              ],
            ),
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
                    if (test[i].fields!.name!.toLowerCase().contains(value.toLowerCase())) {
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
                            return GestureDetector(
                              onTap: () {
                                Get.to(const StudentHistory(), arguments: studentList[index].fields?.mobileNumber);
                              },
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  color: colors_name.colorWhite,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      custom_text(text: "${studentList[index].fields?.name}", textStyles: primaryTextSemiBold16),
                                      custom_text(topValue: 0, bottomValue: 5, text: "Enrollment No: ${studentList[index].fields?.enrollmentNumber}", textStyles: blackTextSemiBold14),
                                      custom_text(topValue: 0, bottomValue: 5, maxLines: 2, text: "Specialization: ${Utils.getSpecializationName(studentList[index].fields?.specializationIds![0])}", textStyles: blackTextSemiBold14),
                                      custom_text(topValue: 0, bottomValue: 5, text: "Mobile No: ${studentList[index].fields?.mobileNumber}", textStyles: blackTextSemiBold14),
                                      custom_text(topValue: 0, bottomValue: 5, text: "Semester: ${studentList[index].fields?.semester}", textStyles: blackTextSemiBold14),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
            CustomButton(
              fontSize: 15,
              text: strings_name.str_export_student_data,
              click: () async {
                if (studentList.isNotEmpty) {
                  exportStudentData();
                } else {
                  Utils.showSnackBar(context, strings_name.str_please_select_one_student);
                }
              },
            ),
          ],
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }

  Future<void> exportStudentData() async {
    setState(() {
      isVisible = true;
    });
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow([Utils.getHubName(studentList[0].fields?.hubIdFromHubIds?.first)]);
    sheet.appendRow(['Name', 'Enrollment Number', 'Mobile Number', 'Email', 'Specialization', 'Semester', 'Division', 'Placement Status', 'Company Name', 'Job Title', 'Total Attendance', 'Attendance Percentage']);

    studentList.forEach((row) {
      String placementStatus = "Not Placed", companyName = "", jobTitle = "";
      if ((row.fields?.placedJob?.length ?? 0) > 0) {
        placementStatus = "Placed";
        companyName = row.fields?.company_name_from_placed_job?.last ?? "";
        jobTitle = row.fields?.job_title_from_placed_job?.last ?? "";
      }
      var total_lecture = 0, total_present = 0, totalPresentPercentage, total_absent = 0;
      if (row.fields?.lectureSubjectId?.isNotEmpty == true) {
        if (row.fields?.presentLectureIds != null && row.fields?.presentLectureIds?.isNotEmpty == true) {
          for (var i = 0; i < row.fields!.presentLectureIds!.length; i++) {
            if (row.fields?.presentSemesterByStudent![i] == row.fields?.semester) {
              total_present += 1;
              total_lecture += 1;
            }
          }
        }
        if (row.fields?.absentLectureIds != null && row.fields?.absentLectureIds?.isNotEmpty == true) {
          for (var i = 0; i < row.fields!.absentLectureIds!.length; i++) {
            if (row.fields?.absentSemesterByStudent![i] == row.fields?.semester) {
              total_absent += 1;
              total_lecture += 1;
            }
          }
        }
      }
      totalPresentPercentage = ((total_present * 100) / total_lecture).toStringAsFixed(2);
      sheet.appendRow([row.fields?.name, row.fields?.enrollmentNumber, row.fields?.mobileNumber, row.fields?.email, Utils.getSpecializationName(row.fields?.specializationIds?.first), row.fields?.semester, row.fields?.division, placementStatus, companyName, jobTitle, "$total_present/$total_lecture", "$totalPresentPercentage%"]);
    });

    var appDocumentsDirectory = await getApplicationDocumentsDirectory();
    var file = File("${appDocumentsDirectory.path}/${Utils.getHubName(studentList[0].fields?.hubIdFromHubIds?.first)?.replaceAll(" ", "").replaceAll("/", "")}_StudentsData.xlsx");
    await file.writeAsBytes(excel.encode()!);
    try {
      await OpenFilex.open(file.path);
      setState(() {
        isVisible = false;
      });
    } catch (e) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBarUsingGet("No Application found to open this file");
    }
  }
}
