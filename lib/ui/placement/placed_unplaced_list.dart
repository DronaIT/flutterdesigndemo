import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../values/text_styles.dart';

class Placed_unplaced_SList extends StatefulWidget {
  const Placed_unplaced_SList({super.key});

  @override
  State<Placed_unplaced_SList> createState() => _Placed_unplaced_SListState();
}

class _Placed_unplaced_SListState extends State<Placed_unplaced_SList> {
  List<LoginFieldsResponse> studentList = [];
  bool isVisible = false;
  String title = "";
  String totalStudents = "";
  List<LoginFieldsResponse> test = [];

  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (Get.arguments[0]["studentList"] != null) {
      test = Get.arguments[0]["studentList"];
      studentList = Get.arguments[0]["studentList"];
      title = Get.arguments[1]["title"];
      totalStudents = Get.arguments[2]["total students"];
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
            custom_text(text: "Total Students: $totalStudents", textStyles: primaryTextSemiBold16, bottomValue: 5),
            custom_text(text: "Total $title Students: ${test.length}", textStyles: primaryTextSemiBold16),
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
                    if (test[i].name!.toLowerCase().contains(value.toLowerCase())) {
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
                                 Get.to(const StudentHistory(), arguments: studentList[index].mobileNumber);
                              },
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  color: colors_name.colorWhite,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      custom_text(
                                        text: "${studentList[index].name}",
                                        textStyles: primaryTextSemiBold16,
                                        bottomValue: 5,
                                      ),
                                      Visibility(
                                        visible: studentList[index].company_name_from_placed_job != null,
                                        child: custom_text(topValue: 0, bottomValue: 5, maxLines: 2, text: "Company name: ${studentList[index].company_name_from_placed_job?.last}", textStyles: blackTextSemiBold15),
                                      ),
                                      custom_text(topValue: 0, bottomValue: 5, text: "Enrollment No: ${studentList[index].enrollmentNumber}", textStyles: blackTextSemiBold14),
                                      custom_text(topValue: 0, bottomValue: 5, maxLines: 2, text: "Specialization: ${Utils.getSpecializationName(studentList[index].specializationIds![0])}", textStyles: blackTextSemiBold14),
                                      custom_text(topValue: 0, bottomValue: 5, text: "Semester: ${studentList[index].semester}", textStyles: blackTextSemiBold14),
                                      custom_text(topValue: 0, bottomValue: 5, text: "Mobile No: ${studentList[index].mobileNumber}", textStyles: blackTextSemiBold14),
                                      custom_text(topValue: 0, bottomValue: 5, text: "Email: ${studentList[index].email}", textStyles: blackTextSemiBold14),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
            Visibility(
              visible: studentList.isNotEmpty,
              child: CustomButton(
                fontSize: 15,
                text: strings_name.str_export_student_data,
                click: () async {
                  if (studentList.isNotEmpty) {
                    exportStudentData();
                  }
                },
              ),
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
    sheet.appendRow(['Name', 'Email', 'Specialization', 'Semester', 'EnrollmentNumber', 'MobileNumber', 'Company Name']);

    studentList.forEach((row) {
      sheet.appendRow([row.name, row.email, Utils.getSpecializationName(row.specializationIds![0]), row.semester, row.enrollmentNumber, row.mobileNumber, row.company_name_from_placed_job?.last ?? ""]);
    });

    var appDocumentsDirectory = await getApplicationDocumentsDirectory();
    var file = File("${appDocumentsDirectory.path}/PlacedUnPlacedData.xlsx");
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
