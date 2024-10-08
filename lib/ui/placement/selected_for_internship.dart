import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/ui/placement/confirm_internship.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../utils/utils.dart';

class SelectedForInternship extends StatefulWidget {
  const SelectedForInternship({Key? key}) : super(key: key);

  @override
  State<SelectedForInternship> createState() => _SelectedForInternshipState();
}

class _SelectedForInternshipState extends State<SelectedForInternship> {
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
    var query = "AND(${TableNames.CLM_JOB_TYPE}='$jobValue',FIND('${PreferenceUtils.getLoginData().mobileNumber}', ${TableNames.CLM_SELECTED_STUDENTS}, 0))";
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
      appBar: AppWidgets.appBarWithoutBack(jobType == 0 ? strings_name.str_selected_for_jobs : strings_name.str_selected_for_job),
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
                                custom_text(
                                  text: "Location: ${jobOpportunityData.records?[index].fields!.reportingAddress?.first}",
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
                                  text: "Description: ${jobOpportunityData.records![index].fields!.jobDescription!}",
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
                                Row(children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.to(const ConfirmInternShip(), arguments: jobOpportunityData.records![index].fields!.jobCode);
                                        // performAction(true, jobOpportunityData.records![index].id.toString());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colors_name.presentColor,
                                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        elevation: 5.0,
                                      ),
                                      child: const Text(
                                        strings_name.str_accept_offer,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        rejectionDialog(jobOpportunityData.records![index].id.toString());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colors_name.errorColor,
                                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        elevation: 5.0,
                                      ),
                                      child: const Text(
                                        strings_name.str_reject_offer,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  )
                                ])
                              ],
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

  Future<void> rejectionDialog(String? jobId) async {
    Dialog errorDialog = Dialog(
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            custom_text(text: 'Please confirm the offer rejection', textStyles: boldTitlePrimaryColorStyle),
            SizedBox(height: 5.h),
            custom_text(
              text: strings_name.str_reject_offer_disclaimer,
              textStyles: blackTextSemiBold14,
              maxLines: 100,
            ),
            Row(children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: CustomButton(
                    text: strings_name.str_cancle,
                    click: () {
                      Get.back(closeOverlays: true);
                    }),
              ),
              SizedBox(width: 5.h),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: CustomButton(
                    text: strings_name.str_confirm,
                    click: () async {
                      Get.back(closeOverlays: true);
                      performAction(false, jobId!);
                    }),
              ),
            ])
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  Future<void> performAction(bool isAcceptedOffer, String jobId) async {
    setState(() {
      isVisible = true;
    });
    var loginData = PreferenceUtils.getLoginData();
    var query = "FIND('${loginData.mobileNumber.toString()}', ${TableNames.TB_USERS_PHONE}, 0)";
    try {
      var data = await apiRepository.loginApi(query);
      if (data.records!.isNotEmpty) {
        await PreferenceUtils.setLoginData(data.records!.first.fields!);
        await PreferenceUtils.setLoginRecordId(data.records!.first.id!);

        Map<String, dynamic> requestParams = Map();
        if (isAcceptedOffer) {
          var acceptedJobData = data.records!.first.fields?.placedJob ?? [];
          acceptedJobData.add(jobId);

          requestParams[TableNames.CLM_PLACED_JOB] = acceptedJobData;
        } else {
          var rejectedJobData = data.records!.first.fields?.rejectedJob ?? [];
          rejectedJobData.add(jobId);

          requestParams[TableNames.CLM_REJECTED_JOB] = rejectedJobData;
          requestParams[TableNames. CLM_BANNED_FROM_PLACEMENT] = 1;
        }

        var dataUpdate = await apiRepository.updateStudentDataApi(requestParams, data.records!.first.id!);
        if (dataUpdate.fields != null) {
          await PreferenceUtils.setLoginData(dataUpdate.fields!);
          await PreferenceUtils.setLoginRecordId(dataUpdate.id!);

          setState(() {
            isVisible = false;
          });
          Get.back(closeOverlays: true);
          Get.back(closeOverlays: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }
}
