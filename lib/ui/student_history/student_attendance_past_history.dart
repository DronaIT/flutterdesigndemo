import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_text.dart';
import '../../models/login_fields_response.dart';
import '../../models/view_student_attendance.dart';
import '../../values/text_styles.dart';

class StudentAttendancePastHistory extends StatefulWidget {
  const StudentAttendancePastHistory({Key? key}) : super(key: key);

  @override
  State<StudentAttendancePastHistory> createState() => _StudentAttendancePastHistoryState();
}

class _StudentAttendancePastHistoryState extends State<StudentAttendancePastHistory> {
  var controllerSearch = TextEditingController();
  bool isVisible = false;
  LoginFieldsResponse? fields;

  List<ViewStudentAttendance> studentList = [];

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
    if (fields != null && fields?.lectureIds != null) {
      for (int i = 0; i < fields!.lectureIds!.length; i++) {
        if(fields!.semesterByStudent![i] != fields?.semester) {
          if (fields!.presentLectureIds?.contains(fields!.lectureIds?[i]) == true) {
            var viewAttendance = ViewStudentAttendance(subject_id: fields!.lectureSubjectId![i],
                subject_title: fields!.lecture_subject_title![i], lecture_date: fields!.lecture_date![i], status: 1);
            viewAttendance.present_lectures = 1;
            viewAttendance.total_lectures += 1;
            studentList.add(viewAttendance);
          } else if (fields!.absentLectureIds?.contains(fields!.lectureIds?[i]) == true) {
            var viewAttendance = ViewStudentAttendance(subject_id: fields!.lectureSubjectId![i],
                subject_title: fields!.lecture_subject_title![i], lecture_date: fields!.lecture_date![i], status: 1);
            viewAttendance.absent_lectures = 1;
            viewAttendance.total_lectures += 1;
            studentList.add(viewAttendance);
          }
        }
      }
    }

    for (int i = 0; i < studentList.length; i++) {
      total_lecture += studentList[i].total_lectures;
      present_lecture += studentList[i].present_lectures;
      absent_lecture += studentList[i].absent_lectures;
    }
    setState(() {
      totalLectures = total_lecture;
      totalPresentLectures = present_lecture;
      totalAbsentLectures = absent_lecture;
      //  totalPresentPercentage = ((present_lecture * 100) / total_lecture);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppWidgets.appBarWithoutBack(strings_name.str_viewothers_attendance),
          body: Stack(children: [
            Column(
              children: [
                SizedBox(height: 5.h),
                custom_text(text: "Total Lectures : $totalLectures", alignment: Alignment.topLeft, textStyles: blackTextbold14, bottomValue: 0),
                custom_text(text: "Total Present lectures : $totalPresentLectures", alignment: Alignment.topLeft, textStyles: blackTextbold14, bottomValue: 0),
                custom_text(text: "Total Absent lectures : $totalAbsentLectures", alignment: Alignment.topLeft, textStyles: blackTextbold14, bottomValue: 0),
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
                                    custom_text(text: "${studentList[index].subject_title}", textStyles: primaryTextSemiBold16,maxLines: 3,topValue: 0,bottomValue: 0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(topValue: 0, bottomValue: 0, text: "Lecture date: ${studentList[index].lecture_date}", textStyles: blackTextSemiBold14),
                                        Container(
                                          width: 100,
                                          margin: EdgeInsets.all(5),
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: studentList[index].present_lectures == 1 ? colors_name.presentColor : colors_name.errorColor,
                                              padding: const EdgeInsets.all(6),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              studentList[index].present_lectures == 1 ? "Present" : "Absent",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
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
