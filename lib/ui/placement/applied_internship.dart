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

  @override
  void initState() {
    super.initState();
    getRecords();
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    var query = "FIND('${PreferenceUtils.getLoginData().mobileNumber}', ${TableNames.CLM_APPLIED_STUDENTS}, 0)";
    try{
      jobOpportunityData = await apiRepository.getJobOpportunityApi(query);
      setState(() {
        isVisible = false;
      });
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_applied_jobs),
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
                                  text: "Location: ${jobOpportunityData.records?[index].fields!.city?.first}",
                                  textStyles: blackTextSemiBold12,
                                  topValue: 5,
                                  maxLines: 2,
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
                                  text: "Description: ${jobOpportunityData.records![index].fields!.jobDescription!}",
                                  textStyles: blackTextSemiBold12,
                                  bottomValue: 5,
                                  topValue: 5,
                                  leftValue: 5,
                                  maxLines: 1000,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_no_jobs_applied, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
