import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../models/base_api_response.dart';
import '../../models/job_module_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../models/request/create_job_opportunity_request.dart';
import '../../utils/tablenames.dart';
import '../../values/text_styles.dart';

class AppearedForInterviewStudentDetail extends StatefulWidget {
  const AppearedForInterviewStudentDetail({Key? key}) : super(key: key);

  @override
  State<AppearedForInterviewStudentDetail> createState() => _AppearedForInterviewStudentDetailState();
}

class _AppearedForInterviewStudentDetailState extends State<AppearedForInterviewStudentDetail> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobOpportunityData = BaseLoginResponse();

  String companyName = "";
  String jobId = "";
  List<JobModuleResponse> studentResponse = [];

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      companyName = Get.arguments[0]["company_name"];
      jobId = Get.arguments[1]["jobcode"];
    }
    getRecords();
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    var query = "FIND('$jobId', ${TableNames.CLM_JOB_CODE}, 0)";
    try {
      jobOpportunityData = await apiRepository.getJobOppoApi(query);
      for (var i = 0; i < jobOpportunityData.records!.length; i++) {
        if (jobOpportunityData.records![i].fields != null && jobOpportunityData.records![i].fields!.shortlistedStudents != null) {
          for (var j = 0; j < jobOpportunityData.records![i].fields!.shortlistedStudents!.length; j++) {
            var jobModuleResponse = JobModuleResponse(
                applied_students_email: jobOpportunityData.records![i].fields!.shortlisted_students_email![j],
                applied_students_enrollment_number: jobOpportunityData.records![i].fields!.shortlisted_students_enrollment_number![j],
                applied_students_name: jobOpportunityData.records![i].fields!.shortlisted_students_name![j],
                applied_students: jobOpportunityData.records![i].fields!.shortlistedStudents![j]);
            studentResponse.add(jobModuleResponse);
          }
        }
      }
      for (var j = 0; j < studentResponse.length; j++) {
        if (jobOpportunityData.records!.first.fields?.appearedForInterview != null) {
          for (var k = 0; k < jobOpportunityData.records!.first.fields!.appearedForInterview!.length; k++) {
            if (studentResponse[j].applied_students == jobOpportunityData.records!.first.fields!.appearedForInterview![k]) {
              studentResponse[j].selected = true;
              break;
            }
          }
        }
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }

    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_appear_for_interview_student),
      body: Stack(
        children: [
          studentResponse != null && studentResponse.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: studentResponse.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    studentResponse[index].selected = !studentResponse[index].selected;
                                  });
                                },
                                child: Card(
                                  elevation: 5,
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              custom_text(
                                                  text: "${studentResponse[index].applied_students_name}",
                                                  textStyles: centerTextStyle14,
                                                  topValue: 0,
                                                  maxLines: 2,
                                                  bottomValue: 5,
                                                  leftValue: 5),
                                              custom_text(
                                                  text: "${studentResponse[index].applied_students_email}",
                                                  textStyles: blackTextSemiBold12,
                                                  topValue: 5,
                                                  maxLines: 2,
                                                  bottomValue: 5,
                                                  leftValue: 5),
                                              custom_text(
                                                  text: "${strings_name.str_enrollment} ${studentResponse[index].applied_students_enrollment_number}",
                                                  textStyles: blackTextSemiBold12,
                                                  topValue: 0,
                                                  maxLines: 2,
                                                  bottomValue: 5,
                                                  leftValue: 5),
                                            ],
                                          ),
                                        ),
                                        if (studentResponse[index].selected) const Icon(Icons.check, size: 25, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    CustomButton(
                      text: strings_name.str_submit,
                      click: () async {
                        selectNow();
                      },
                    ),
                  ],
                )
              : Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: custom_text(text: strings_name.str_no_student_shortlisted_for_interview, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }

  selectNow() async {
    CreateJobOpportunityRequest request = CreateJobOpportunityRequest();
    List<String> selectedStudentsData = [];
    for (var i = 0; i < studentResponse.length; i++) {
      if (studentResponse[i].selected) {
        selectedStudentsData.add(studentResponse[i].applied_students!);
      }
    }
    request.appearedForInterview = selectedStudentsData;
    var json = request.toJson();
    json.removeWhere((key, value) => value == null);
    if (selectedStudentsData.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      try {
        var resp = await apiRepository.updateJobSortListedApi(json, jobOpportunityData.records!.first.id!);
        if (resp.id!.isNotEmpty) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_selected_students);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(closeOverlays: true, result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      } on DioError catch (e) {
        setState(() {
          isVisible = false;
        });
        final errorMessage = DioExceptions.fromDioError(e).toString();
        Utils.showSnackBarUsingGet(errorMessage);
      }
    } else {
      Utils.showSnackBar(context, strings_name.str_please_select_one_student);
    }
  }
}
