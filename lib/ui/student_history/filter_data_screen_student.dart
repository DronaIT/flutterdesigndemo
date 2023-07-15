import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

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
  var subjectName ;
  var subjectId ;
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
                              onTap: (){
                                Get.to(StudentHistory(),arguments: studentList[index].fields?.mobileNumber);
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
                                      custom_text(topValue: 0, bottomValue: 5,maxLines: 2,
                                          text: "Specialization: ${Utils.getSpecializationName(studentList[index].fields?.specializationIds![0])}", textStyles: blackTextSemiBold14),
                                      custom_text(topValue: 0, bottomValue: 5, text: "Mobile No: ${studentList[index].fields?.mobileNumber}", textStyles: blackTextSemiBold14),
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
