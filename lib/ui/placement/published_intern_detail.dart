import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../models/base_api_response.dart';
import '../../models/job_module_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../utils/tablenames.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class PublishedInterDetail extends StatefulWidget {
  const PublishedInterDetail({Key? key}) : super(key: key);

  @override
  State<PublishedInterDetail> createState() => _PublishedInterDetailState();
}

class _PublishedInterDetailState extends State<PublishedInterDetail> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobpportunityData = BaseLoginResponse();
  String company_name = "";
  String jobId = "";
  List<JobModuleResponse> studentResponse = [];

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      company_name = Get.arguments[0]["company_name"];
      jobId = Get.arguments[1]["jobcode"];
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
      for (var i = 0; i < jobpportunityData.records!.length; i++) {
        if (jobpportunityData.records![i].fields != null && jobpportunityData.records![i].fields!.appliedStudents != null) {
          for (var j = 0; j < jobpportunityData.records![i].fields!.appliedStudents!.length; j++) {
            var jobModuleResponse = JobModuleResponse(
                applied_students_email: jobpportunityData.records![i].fields!.applied_students_email![j],
                applied_students_enrollment_number: jobpportunityData.records![i].fields!.applied_students_enrollment_number![j],
                applied_students_name: jobpportunityData.records![i].fields!.applied_students_name![j],
                applied_students_number: jobpportunityData.records![i].fields!.appliedStudents![j]);
            studentResponse.add(jobModuleResponse);
          }
        }
      }
    }on DioError catch (e) {
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
      appBar: AppWidgets.appBarWithoutBack(company_name),
      body: Stack(
        children: [
          studentResponse != null && studentResponse.length > 0
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
