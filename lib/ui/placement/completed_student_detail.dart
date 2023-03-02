import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/models/completion_job_module_response.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_text.dart';
import '../../models/base_api_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../utils/tablenames.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class CompletedStudentDetail extends StatefulWidget {
  const CompletedStudentDetail({Key? key}) : super(key: key);

  @override
  State<CompletedStudentDetail> createState() => _CompletedStudentDetailState();
}

class _CompletedStudentDetailState extends State<CompletedStudentDetail> {
  String jobId = "";
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobpportunityData = BaseLoginResponse();
  String company_name = "";
  List<CompleteModuleResponse> studentResponse = [];

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      jobId = Get.arguments;
    }
    getRecords();
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    var query = "FIND('$jobId', ${TableNames.CLM_JOB_CODE}, 0)";
    try{
      jobpportunityData = await apiRepository.getJoboppoApi(query);
      int completion = 0;
      String completionName = strings_name.str_pending;
      for (var i = 0; i < jobpportunityData.records!.length; i++) {
        if (jobpportunityData.records![i].fields != null && jobpportunityData.records![i].fields!.selectedStudents != null) {
          for (var j = 0; j < jobpportunityData.records![i].fields!.selectedStudents!.length; j++) {
            if (jobpportunityData.records![i].fields!.placedStudents != null && jobpportunityData.records![i].fields!.placedStudents!.contains(jobpportunityData.records![i].fields!.selectedStudents![j])) {
              completion = 1;
              completionName = strings_name.str_placed;
            } else if (jobpportunityData.records![i].fields!.rejected_students != null && jobpportunityData.records![i].fields!.rejected_students!.contains(jobpportunityData.records![i].fields!.selectedStudents![j])) {
              completion = 2;
              completionName = strings_name.str_reject;
            }
            var jobModuleResponse = CompleteModuleResponse(
                applied_students_email: jobpportunityData.records![i].fields!.selected_students_email![j],
                applied_students_enrollment_number: jobpportunityData.records![i].fields!.selected_students_enrollment_number![j],
                applied_students_name: jobpportunityData.records![i].fields!.selected_students_name![j],
                applied_students_number: jobpportunityData.records![i].fields!.selectedStudents![j],
                completionStatus: completion,
                compName: completionName);
            studentResponse.add(jobModuleResponse);
          }
        }
        setState(() {
          isVisible = false;
        });
      }
    }on DioError catch (e) {
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_completed_placement),
      body: Stack(
        children: [
          studentResponse.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: studentResponse.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Card(
                            elevation: 5,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        custom_text(
                                          text: "${studentResponse[index].applied_students_name}",
                                          textStyles: centerTextStyle14,
                                          topValue: 0,
                                          maxLines: 2,
                                          bottomValue: 5,
                                          leftValue: 5,
                                        ),
                                        //custom_text(text: "${strings_name.str_phone}: ${studentResponse[index].applied_students_number}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 0, leftValue: 5),
                                        custom_text(text: "${strings_name.str_email}: ${studentResponse[index].applied_students_email}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                        custom_text(text: "${strings_name.str_enrollment} ${studentResponse[index].applied_students_enrollment_number}", textStyles: blackTextSemiBold12, topValue: 0, maxLines: 2, bottomValue: 5, leftValue: 5),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: studentResponse[index].completionStatus == 1 || studentResponse[index].completionStatus == 0 ? colors_name.presentColor : colors_name.errorColor,
                                        padding: const EdgeInsets.all(10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        elevation: 7.0,
                                      ),
                                      child: Text(
                                        studentResponse[index].compName!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
