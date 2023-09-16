import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../models/base_api_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class ApplyForInternship extends StatefulWidget {
  const ApplyForInternship({Key? key}) : super(key: key);

  @override
  State<ApplyForInternship> createState() => _ApplyForInternshipState();
}

class _ApplyForInternshipState extends State<ApplyForInternship> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();

  // BaseLoginResponse<JobOpportunityResponse> jobOpportunityData = BaseLoginResponse();
  List<BaseApiResponseWithSerializable<JobOpportunityResponse>>? jobOpportunityList = [];
  String offset = "";

  @override
  void initState() {
    super.initState();
    getRecords();
  }

  getRecords() async {
    if (PreferenceUtils.getIsLogin() == 1) {
      if (!isVisible) {
        setState(() {
          isVisible = true;
        });
      }
      var loginData = PreferenceUtils.getLoginData();
      var query = "AND(";
      query += "FIND('${strings_name.str_job_status_published}',${TableNames.CLM_STATUS}, 0)";
      query += ",FIND('1',${TableNames.CLM_DISPLAY_INTERNSHIP})";
      query += ")";
      try {
        var data = await apiRepository.getJoboppoApi(query, offset);

        if (data.records!.isNotEmpty) {
          if (offset.isEmpty) {
            jobOpportunityList?.clear();
          }
          for (int i = 0; i < data.records!.length; i++) {
            bool canAddBasedOnHub = true, canAddBasedOnSpecialization = true, canAddBasedOnSemester = true, canAddBasedOnGender = true, isAlreadyApplied = false;
            if (data.records![i].fields?.hubIds?.isNotEmpty == true) {
              canAddBasedOnHub = (data.records![i].fields?.hubIds!.contains(loginData.hubIds?.first) == true);
            }
            if (data.records![i].fields?.specializationIds?.isNotEmpty == true) {
              canAddBasedOnSpecialization = (data.records![i].fields?.specializationIds!.contains(loginData.specializationIds?.first) == true);
            }
            if (data.records![i].fields?.semester?.isNotEmpty == true) {
              canAddBasedOnSemester = (data.records![i].fields?.semester!.contains(loginData.semester) == true);
            }
            if (data.records![i].fields?.gender?.isNotEmpty == true) {
              if (data.records![i].fields?.gender == strings_name.str_both) {
                canAddBasedOnGender = true;
              } else if (data.records![i].fields?.gender?.toLowerCase() == loginData.gender?.toLowerCase()) {
                canAddBasedOnGender = true;
              } else {
                canAddBasedOnGender = false;
              }
            }
            if (data.records![i].fields?.appliedStudents?.isNotEmpty == true) {
              isAlreadyApplied = data.records![i].fields?.appliedStudents!.contains(PreferenceUtils.getLoginRecordId()) == true;
            }
            if (!canAddBasedOnHub || !canAddBasedOnSpecialization || !canAddBasedOnSemester || !canAddBasedOnGender || isAlreadyApplied) {
              data.records?.removeAt(i);
              i--;
            }
          }
          jobOpportunityList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<JobOpportunityResponse>>);
          offset = data.offset;
          if (offset.isNotEmpty) {
            getRecords();
          } else {
            jobOpportunityList?.sort((a, b) => a.fields!.jobTitle!.trim().compareTo(b.fields!.jobTitle!.trim()));
            setState(() {
              isVisible = false;
            });
          }
        } else {
          setState(() {
            isVisible = false;
            if (offset.isEmpty) {
              jobOpportunityList = [];
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

      setState(() {
        isVisible = false;
      });
    }
  }

  applyForInternship(String? jobId) async {
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

        var appliedJobData = data.records!.first.fields?.appliedJob ?? [];
        appliedJobData.add(jobId!);

        Map<String, dynamic> appliedJobs = {
          TableNames.CLM_APPLIED_JOB: appliedJobData,
        };

        var dataUpdate = await apiRepository.updateStudentDataApi(appliedJobs, data.records!.first.id!);
        if (dataUpdate.fields != null) {
          await PreferenceUtils.setLoginData(data.records!.first.fields!);
          await PreferenceUtils.setLoginRecordId(data.records!.first.id!);

          setState(() {
            isVisible = false;
          });
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_list_job_opp_detail),
      body: Stack(
        children: [
          jobOpportunityList != null && jobOpportunityList!.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: jobOpportunityList?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                custom_text(
                                  text: "${jobOpportunityList?[index].fields!.jobTitle}",
                                  textStyles: centerTextStyle20,
                                  topValue: 0,
                                  maxLines: 2,
                                  bottomValue: 5,
                                  leftValue: 5,
                                ),
                                custom_text(text: "Company Name: ${jobOpportunityList?[index].fields!.companyName?.first}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                jobOpportunityList?[index].fields!.stipendRangeMin != null && jobOpportunityList?[index].fields!.stipendRangeMax != null
                                    ? custom_text(
                                        text: "Stipend: ${jobOpportunityList?[index].fields!.stipendRangeMin} - ${jobOpportunityList?[index].fields!.stipendRangeMax}",
                                        textStyles: blackTextSemiBold12,
                                        topValue: 5,
                                        maxLines: 2,
                                        bottomValue: 5,
                                        leftValue: 5,
                                      )
                                    : Container(),
                                custom_text(text: "Timings: ${jobOpportunityList?[index].fields!.timingStart} - ${jobOpportunityList?[index].fields!.timingEnd}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                custom_text(text: "Vacancies: ${jobOpportunityList?[index].fields!.vacancies}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                custom_text(
                                  text: "Location: ${jobOpportunityList?[index].fields!.reportingAddress?.first}",
                                  textStyles: blackTextSemiBold12,
                                  topValue: 5,
                                  maxLines: 5,
                                  bottomValue: 5,
                                  leftValue: 5,
                                ),
                                custom_text(
                                  text: "City: ${jobOpportunityList?[index].fields!.city?.first.toString().trim()}",
                                  textStyles: blackTextSemiBold12,
                                  topValue: 5,
                                  maxLines: 5,
                                  bottomValue: 5,
                                  leftValue: 5,
                                ),
                                custom_text(
                                  text: "Internship : ${jobOpportunityList?[index].fields!.internshipModes} - ${jobOpportunityList?[index].fields!.internshipDuration}",
                                  textStyles: blackTextSemiBold12,
                                  topValue: 5,
                                  maxLines: 2,
                                  bottomValue: 5,
                                  leftValue: 5,
                                ),
                                custom_text(
                                  text: "Description: ${jobOpportunityList![index].fields!.jobDescription!}",
                                  textStyles: blackTextSemiBold12,
                                  bottomValue: 5,
                                  topValue: 5,
                                  leftValue: 5,
                                  maxLines: 1000,
                                ),
                                jobOpportunityList![index].fields!.specificRequirements != null
                                    ? custom_text(
                                        text: "Specific Requirement: ${jobOpportunityList![index].fields!.specificRequirements?.trim()}",
                                        textStyles: blackTextSemiBold12,
                                        topValue: 5,
                                        maxLines: 1000,
                                        bottomValue: 5,
                                        leftValue: 5,
                                      )
                                    : Container(),
                                Container(
                                  alignment: Alignment.centerRight,
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Visibility(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        applyForInternship(jobOpportunityList![index].id);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: colors_name.presentColor,
                                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        elevation: 5.0,
                                      ),
                                      child: const Text(
                                        strings_name.str_apply,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                )
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
}
