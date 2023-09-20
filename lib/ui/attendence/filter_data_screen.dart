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
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/login_fields_report_response.dart';
import '../../values/text_styles.dart';

class FilterData extends StatefulWidget {
  const FilterData({Key? key}) : super(key: key);

  @override
  State<FilterData> createState() => _FilterDataState();
}

class _FilterDataState extends State<FilterData> {
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> studentList = [];

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> studentEligibiltyList = [];


  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> test = [];

  bool isVisible = false;
  var subjectName ;
  var subjectId ;
  var isFromEligible;
  var eligiblePersentage;
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
      isFromEligible = Get.arguments[5]["eligible"];
      eligiblePersentage = Get.arguments[6]["eligible_percentage"];
      if(isFromEligible){
        checkPresentAbsentDetailBySubject();
      }
    }
  }

  void checkPresentAbsentDetailBySubject() {
    for(int i = 0 ; i<studentList.length ; i++){
      if(studentList[i].fields!.lectureSubjectId!.contains(subjectId)){
        studentEligibiltyList.add(studentList[i]);
      }
    }
    test.clear();
    studentList.clear();
    for (int j = 0; j < studentEligibiltyList.length; j++) {
      var total_lecture = 0,  total_present = 0;
      for( int k=0; k < studentEligibiltyList[j].fields!.lectureSubjectId!.length ; k++){
        if(studentEligibiltyList[j].fields!.lectureSubjectId![k] == subjectId){
          total_lecture += 1;
        }
      }
      if(studentEligibiltyList[j].fields!.presentSubjectId != null){
        for( int M=0; M < studentEligibiltyList[j].fields!.presentSubjectId!.length ; M++){
          if(studentEligibiltyList[j].fields!.presentSubjectId![M] == subjectId){
            total_present += 1;
          }
        }
      }
      var totalPresentPercentage = ((total_present * 100) / total_lecture);
      if(totalPresentPercentage < (int.tryParse(eligiblePersentage) ?? 75)){
        test.add(studentEligibiltyList[j]);
      }
      studentEligibiltyList[j].fields!.percentage = totalPresentPercentage.toStringAsFixed(2);
    }
    studentList = List.from(test);
  }


  Future<void> saveExcelFile(List<BaseApiResponseWithSerializable<LoginFieldsResponse>> data) async {

    setState(() {
      isVisible = true;
    });
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow(['Name', 'Email', 'EnrollmentNumber', 'Mobile Number', 'Address', 'City', 'Division', 'Gender', 'joining year', 'Semester',
        'Hub Name', 'Specialization', 'Subject',
    ]);
    List<LoginFieldsReportResponse> myData = [];
    for (var i = 0; i < data.length; i++) {
      var responseValue = LoginFieldsReportResponse(
        name: data[i].fields!.name!,
        email: data[i].fields!.email ?? "",
        enrollmentNumber: data[i].fields!.enrollmentNumber ?? "",
        mobileNumber: data[i].fields!.mobileNumber ?? "",
        address: data[i].fields!.address ?? "",
        city: data[i].fields!.city ?? "",
        division: data[i].fields!.division ?? "",
        gender: data[i].fields!.gender ?? "",
        joiningYear: data[i].fields!.joiningYear ?? "",
        semester: data[i].fields!.semester ?? "",
        hub: hubName ?? "",
        specialization:  speName ?? "",
        subject: subjectName ?? "",
      );
      myData.add(responseValue);
    }
    myData.forEach((row) {
      sheet.appendRow([
        row.name,
        row.email,
        row.enrollmentNumber,
        row.mobileNumber,
        row.address,
        row.city,
        row.division,
        row.gender,
        row.joiningYear,
        row.semester,
        row.hub,
        row.specialization,
        row.subject
      ]);
    });

    var appDocumentsDirectory = await getApplicationDocumentsDirectory();
    var file = File("${appDocumentsDirectory.path}/Student_Report.xlsx");
    await file.writeAsBytes(excel.encode()!);
    try{
      await OpenFilex.open(file.path);
      setState(() {
        isVisible = false;
      });

    }catch(e){
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBarUsingGet("No Application found to open this file");
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
                Container(
                  margin: EdgeInsets.all(5),
                  child: CustomButton(
                    bWidth: MediaQuery.of(context).size.width * 0.40,
                    text: strings_name.str_export_data,
                    click: () {
                      saveExcelFile(studentList);
                    },
                  ),
                ),
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
                            return Card(
                              elevation: 5,
                              child: Container(
                                color: colors_name.colorWhite,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    custom_text(text: "${studentList[index].fields?.name}", textStyles: primaryTextSemiBold16),
                                    custom_text(topValue: 0, bottomValue: 5, text: "Enrollment No: ${studentList[index].fields?.enrollmentNumber}", textStyles: blackTextSemiBold14),
                                    custom_text(topValue: 0, bottomValue: 5, text: "Specialization: ${Utils.getSpecializationName(studentList[index].fields?.specializationIds![0])}", textStyles: blackTextSemiBold14),
                                    custom_text(topValue: 0, bottomValue: 5, text: "Mobile No: ${studentList[index].fields?.mobileNumber}", textStyles: blackTextSemiBold14),
                                    Visibility(
                                        visible: isFromEligible,
                                        child: custom_text(topValue: 0, bottomValue: 5, text: "Attendance Percentage: ${studentList[index].fields?.percentage}%", textStyles: blackTextSemiBold14)),

                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: CustomButton(
                                          text: strings_name.str_call,
                                          bWidth: MediaQuery.of(context).size.width * 0.25,
                                          click: () async {
                                            _launchCaller(studentList[index].fields?.mobileNumber ?? "");
                                          }),
                                    )
                                  ],
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

  _launchCaller(String mobile) async {
    try {
      await launchUrl(Uri.parse("tel:$mobile"), mode: LaunchMode.externalApplication);
    } catch (e) {
      Utils.showSnackBarUsingGet(strings_name.str_invalid_mobile);
    }
  }
}
