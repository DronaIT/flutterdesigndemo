import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/ui/placement/approve_placement_attendance_detail.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class ApprovePlacementAttendance extends StatefulWidget {
  const ApprovePlacementAttendance({super.key});

  @override
  State<ApprovePlacementAttendance> createState() => _ApprovePlacementAttendanceState();
}

class _ApprovePlacementAttendanceState extends State<ApprovePlacementAttendance> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? studentData = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? mainStudentData = [];

  TextEditingController rejectionReasonController = TextEditingController();

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (PreferenceUtils.getIsLogin() == 2) {
      getRecords();
    }
  }

  getRecords() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }

    var query = "AND(";
    query += "OR(FIND('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",FIND('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
        }
      }
    }
    query +=
        "),OR(FIND('${strings_name.str_pending}',ARRAYJOIN({${TableNames.CLM_PLACEMENT_ATTENDANCE_STATUS}})), FIND('${strings_name.str_pending}',ARRAYJOIN({${TableNames.CLM_PLACEMENT_COMPANY_LOC_STATUS}})), FIND('${strings_name.str_pending}',ARRAYJOIN({${TableNames.CLM_PLACEMENT_WORKBOOK_STATUS}}))))";
    debugPrint(query);

    try {
      var data = await apiRepository.loginApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mainStudentData?.clear();
        }
        mainStudentData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          mainStudentData?.sort((a, b) {
            var adate = a.fields!.name;
            var bdate = b.fields!.name;
            return adate!.compareTo(bdate!);
          });

          studentData = [];
          studentData = List.from(mainStudentData!);

          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            studentData = [];
            mainStudentData = [];
          }
        });
        offset = "";
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
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_approve_placement_attendance),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),
              Visibility(
                visible: mainStudentData != null && mainStudentData!.isNotEmpty,
                child: Column(children: [
                  CustomEditTextSearch(
                    type: TextInputType.text,
                    hintText: "Search by student name...",
                    textInputAction: TextInputAction.done,
                    controller: controllerSearch,
                    onChanges: (value) {
                      if (value.isEmpty) {
                        studentData = [];
                        studentData = mainStudentData;
                        setState(() {});
                      } else {
                        studentData = [];
                        for (var i = 0; i < mainStudentData!.length; i++) {
                          if (mainStudentData![i].fields!.name!.toLowerCase().contains(value.toLowerCase())) {
                            studentData?.add(mainStudentData![i]);
                          }
                        }
                        setState(() {});
                      }
                    },
                  ),
                  custom_text(
                    text: "Total students: ${mainStudentData?.length ?? 0}",
                    textStyles: blackTextSemiBold16,
                    leftValue: 12.w,
                    bottomValue: 0,
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: studentData != null && studentData!.isNotEmpty
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: studentData?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: custom_text(
                                      text: "${studentData?[index].fields!.name}",
                                      textStyles: linkTextSemiBold14,
                                      topValue: 0,
                                      maxLines: 2,
                                      bottomValue: 5,
                                      leftValue: 5,
                                    ),
                                    onTap: () {
                                      Get.to(const StudentHistory(), arguments: studentData?[index].fields?.mobileNumber);
                                    },
                                  ),
                                  custom_text(
                                      topValue: 0,
                                      bottomValue: 5,
                                      maxLines: 2,
                                      leftValue: 5,
                                      text: "Specialization: ${Utils.getSpecializationName(studentData?[index].fields?.specializationIds![0])}",
                                      textStyles: blackTextSemiBold14),
                                  custom_text(topValue: 0, bottomValue: 5, leftValue: 5, text: "Semester: ${studentData?[index].fields?.semester}", textStyles: blackTextSemiBold14),
                                  custom_text(
                                      topValue: 0,
                                      text: "Company name: ${studentData?[index].fields!.company_name_from_placed_job?.last}",
                                      textStyles: blackTextSemiBold14,
                                      maxLines: 2,
                                      bottomValue: 5,
                                      leftValue: 5),
                                  custom_text(
                                    text: "Job title: ${studentData?[index].fields!.job_title_from_placed_job?.last}",
                                    textStyles: blackTextSemiBold14,
                                    topValue: 0,
                                    maxLines: 2,
                                    bottomValue: 5,
                                    leftValue: 5,
                                  ),
                                  custom_text(
                                    text: "Total Documents Uploaded: ${studentData?[index].fields!.placement_attendance_form?.length ?? 0}",
                                    textStyles: blackTextSemiBold14,
                                    topValue: 0,
                                    maxLines: 2,
                                    bottomValue: 5,
                                    leftValue: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const ApprovePlacementAttendanceDetail(), arguments: studentData![index]);
                                    },
                                    child: const custom_text(
                                      text: strings_name.str_view_details,
                                      textStyles: primaryTextSemiBold14,
                                      alignment: Alignment.centerRight,
                                      topValue: 10,
                                      bottomValue: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                    : Container(
                        margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_no_doc_approval_pending, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
              )
            ],
          )),
          Visibility(
            visible: isVisible,
            child: Container(
              color: colors_name.colorWhite,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
