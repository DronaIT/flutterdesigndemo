import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';

import 'package:flutterdesigndemo/values/colors_name.dart';

import '../../customwidget/custom_edittext_search.dart';
import '../../customwidget/custom_text.dart';
import '../../models/base_api_response.dart';
import '../../models/login_fields_response.dart';
import '../../models/view_student_attendance.dart';
import '../../values/text_styles.dart';

class StudentAttendenceHistory extends StatefulWidget {
  const StudentAttendenceHistory({Key? key}) : super(key: key);

  @override
  State<StudentAttendenceHistory> createState() => _StudentAttendenceHistoryState();
}

class _StudentAttendenceHistoryState extends State<StudentAttendenceHistory> {
  var controllerSearch = TextEditingController();
  bool isVisible = false;
  LoginFieldsResponse? fields;

  List<ViewStudentAttendance> studentList = [];
 // List<ViewStudentAttendance> test = [];

  var total_lecture = 0, present_lecture = 0, absent_lecture = 0;
  int totalLectures = 0, totalPresentLectures = 0, totalAbsentLectures = 0;
   var totalPresentPercentage;

  @override
  void initState() {
    super.initState();
    fields = Get.arguments;
    checkPresentAbsentDetailBySubject();
  }

  void checkPresentAbsentDetailBySubject() {
    if (fields != null && fields?.presentSubjectId != null) {
      for (int i = 0; i < fields!.presentSubjectId!.length; i++) {
        var isAdded = false;
        for (int j = 0; j < studentList.length; j++) {
          if (studentList[j].subject_id == fields!.presentSubjectId![i]) {
            isAdded = true;
            studentList[j].total_lectures += 1;
            studentList[j].present_lectures += 1;
            break;
          }
        }
        if (!isAdded) {
          var attendanceData = ViewStudentAttendance(subject_id: fields!.presentSubjectId![i], subject_title: fields!.presentSubjectTitle![i], lecture_date: fields!.presentLectureDate![i], status: 1);
          attendanceData.total_lectures += 1;
          attendanceData.present_lectures += 1;
          studentList.add(attendanceData);
        }
      }
    }
    if (fields != null && fields?.absentSubjectId != null) {
      for (int i = 0; i < fields!.absentSubjectId!.length; i++) {
        var isAdded = false;
        for (int j = 0; j < studentList.length; j++) {
          if (studentList[j].subject_id == fields!.absentSubjectId![i]) {
            isAdded = true;
            studentList[j].total_lectures += 1;
            studentList[j].absent_lectures += 1;
            break;
          }
        }
        if (!isAdded) {
          var attendanceData = ViewStudentAttendance(subject_id: fields!.absentSubjectId![i], subject_title: fields!.absentSubjectTitle![i], lecture_date: fields!.absentLectureDate![i], status: 0);
          attendanceData.total_lectures += 1;
          attendanceData.absent_lectures += 1;
          studentList.add(attendanceData);
        }
      }
    }
    for (int i = 0; i < studentList.length; i++) {
      total_lecture += studentList[i].total_lectures;
      present_lecture += studentList[i].present_lectures;
      absent_lecture += studentList[i].absent_lectures;
    }
    //test.addAll(studentList!);
    //test = List.from(studentList);
    setState(() {
      totalLectures = total_lecture;
      totalPresentLectures = present_lecture;
      totalAbsentLectures = absent_lecture;
      totalPresentPercentage = ((present_lecture * 100) / total_lecture);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_attendence),
      body: Stack(children: [
        Column(
          children: [
            SizedBox(height: 5.h),
            custom_text(text: "Total Lectures : $totalLectures", alignment: Alignment.topLeft, textStyles: blackTextbold14, bottomValue: 0),
            custom_text(text: "Total Present Lectures : $totalPresentLectures", alignment: Alignment.topLeft, textStyles: blackTextbold14, bottomValue: 0),
            custom_text(text: "Total Present : ${totalPresentPercentage.toStringAsFixed(2)} %", alignment: Alignment.topLeft, textStyles: blackTextbold14, bottomValue: 0),

            // CustomEditTextSearch(
            //   type: TextInputType.text,
            //   textInputAction: TextInputAction.done,
            //   controller: controllerSearch,
            //   onChanges: (value) {
            //     if (value.isEmpty) {
            //       studentList = [];
            //       studentList = List.from(test);
            //       setState(() {});
            //     } else {
            //       studentList = [];
            //       for (var i = 0; i < test.length; i++) {
            //         if (test[i].subject_title!.toLowerCase().contains(value.toLowerCase())) {
            //           studentList.add(test[i]);
            //         }
            //       }
            //       setState(() {});
            //     }
            //   },
            // ),
            studentList.isNotEmpty
                ? Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ListView.builder(
                          itemCount: studentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {},
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  color: colors_name.colorWhite,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      custom_text(text: "${studentList[index].subject_title}", textStyles: primaryTextSemiBold16,maxLines: 3,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                custom_text(topValue: 0, bottomValue: 5, text: "Total lecture: ${studentList[index].total_lectures}", textStyles: blackTextSemiBold14),
                                                custom_text(topValue: 0, bottomValue: 5, text: "Present lecture: ${studentList[index].present_lectures}", textStyles: blackTextSemiBold14),
                                                custom_text(topValue: 0, bottomValue: 5, text: "Absent lecture: ${studentList[index].absent_lectures}", textStyles: blackTextSemiBold14),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: 100,
                                              margin: EdgeInsets.all(5),
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  primary: ((studentList[index].present_lectures * 100) / studentList[index].total_lectures) >= 75 ? colors_name.presentColor : colors_name.errorColor,
                                                  padding: const EdgeInsets.all(6),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                child: Text(
                                                  ((studentList[index].present_lectures * 100) / studentList[index].total_lectures) >= 75 ? "Eligible for exam" : "Not eligible for exam",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          ],
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
