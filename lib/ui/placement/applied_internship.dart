import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../utils/utils.dart';

class AppliedInternship extends StatefulWidget {
  const AppliedInternship({Key? key}) : super(key: key);

  @override
  State<AppliedInternship> createState() => _AppliedInternshipState();
}

class _AppliedInternshipState extends State<AppliedInternship> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();

  BaseLoginResponse<JobOpportunityResponse> jobOpportunityData = BaseLoginResponse();

  /*
  *   argument value = 0 > Regular Internship
  *   argument value = 1 > Final Placement
  */
  int jobType = 0;
  String jobValue = strings_name.str_job_type_regular_internship;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      if (Get.arguments[0]["placementType"] != null) {
        jobType = Get.arguments[0]["placementType"];
      }
    }
    jobValue = jobType == 0 ? strings_name.str_job_type_regular_internship : strings_name.str_job_type_final_placement;

    getRecords();
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    var query = "AND(${TableNames.CLM_JOB_TYPE}='$jobValue',FIND('${PreferenceUtils.getLoginData().mobileNumber}', ${TableNames.CLM_APPLIED_STUDENTS}, 0))";
    try {
      jobOpportunityData = await apiRepository.getJobOpportunityApi(query);
      setState(() {
        isVisible = false;
      });
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
      appBar: AppWidgets.appBarWithoutBack(jobType == 0 ? strings_name.str_applied_jobs : strings_name.str_applied_job),
      body: Stack(
        children: [
          jobOpportunityData.records != null && jobOpportunityData.records!.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: jobOpportunityData.records?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                custom_text(
                                  text: "${jobOpportunityData.records?[index].fields!.jobTitle}",
                                  textStyles: centerTextStyle20,
                                  topValue: 0,
                                  maxLines: 2,
                                  bottomValue: 5,
                                  leftValue: 5,
                                ),
                                custom_text(text: "Company Name: ${jobOpportunityData.records?[index].fields!.companyName?.first}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                jobOpportunityData.records?[index].fields!.stipendRangeMin != null && jobOpportunityData.records?[index].fields!.stipendRangeMax != null
                                    ? custom_text(
                                        text: "Stipend: ${jobOpportunityData.records?[index].fields!.stipendRangeMin} - ${jobOpportunityData.records?[index].fields!.stipendRangeMax}",
                                        textStyles: blackTextSemiBold12,
                                        topValue: 5,
                                        maxLines: 2,
                                        bottomValue: 5,
                                        leftValue: 5,
                                      )
                                    : Container(),
                                custom_text(text: "Timings: ${jobOpportunityData.records?[index].fields!.timingStart} - ${jobOpportunityData.records?[index].fields!.timingEnd}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                custom_text(text: "Vacancies: ${jobOpportunityData.records?[index].fields!.vacancies}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                custom_text(
                                  text: "Location: ${jobOpportunityData.records?[index].fields!.reportingAddress?.first.toString().trim()}",
                                  textStyles: blackTextSemiBold12,
                                  topValue: 5,
                                  maxLines: 5,
                                  bottomValue: 5,
                                  leftValue: 5,
                                ),
                                custom_text(
                                  text: "City: ${jobOpportunityData.records?[index].fields!.city?.first.toString().trim()}",
                                  textStyles: blackTextSemiBold12,
                                  topValue: 5,
                                  maxLines: 5,
                                  bottomValue: 5,
                                  leftValue: 5,
                                ),
                                custom_text(
                                  text: "Internship : ${jobOpportunityData.records?[index].fields!.internshipModes} - ${jobOpportunityData.records?[index].fields!.internshipDuration}",
                                  textStyles: blackTextSemiBold12,
                                  topValue: 5,
                                  maxLines: 2,
                                  bottomValue: 5,
                                  leftValue: 5,
                                ),
                                custom_text(
                                  text: "Description: ${jobOpportunityData.records![index].fields!.jobDescription!.trim()}",
                                  textStyles: blackTextSemiBold12,
                                  bottomValue: 5,
                                  topValue: 5,
                                  leftValue: 5,
                                  maxLines: 1000,
                                ),
                                jobOpportunityData.records?[index].fields!.specificRequirements != null
                                    ? custom_text(
                                        text: "Specific Requirement: ${jobOpportunityData.records?[index].fields!.specificRequirements?.trim()}",
                                        textStyles: primryTextSemiBold14,
                                        topValue: 5,
                                        maxLines: 1000,
                                        bottomValue: 5,
                                        leftValue: 5,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: jobType == 0 ? strings_name.str_no_jobs_applied : strings_name.str_no_job_applied, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
