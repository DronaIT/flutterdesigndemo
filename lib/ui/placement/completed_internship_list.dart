import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../models/base_api_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';
import 'package:flutter/material.dart';

import 'completed_student_detail.dart';

class CompletedInternList extends StatefulWidget {
  const CompletedInternList({Key? key}) : super(key: key);

  @override
  State<CompletedInternList> createState() => _CompletedInternListState();
}

class _CompletedInternListState extends State<CompletedInternList> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();

  List<BaseApiResponseWithSerializable<JobOpportunityResponse>>? jobOpportunityListMain = [];
  List<BaseApiResponseWithSerializable<JobOpportunityResponse>>? jobOpportunityList = [];
  String offset = "";
  var controllerSearch = TextEditingController();

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

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

    hubResponseArray = PreferenceUtils.getHubList().records;
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      if ((loginData.accessible_hub_ids?.length ?? 0) > 0) {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          var isAccessible = false;
          for (var j = 0; j < loginData.accessible_hub_ids!.length; j++) {
            if (loginData.accessible_hub_ids![j] == hubResponseArray![i].id) {
              isAccessible = true;
              break;
            }
            if (loginData.hubIdFromHubIds?.first == hubResponseArray![i].fields?.hubId) {
              isAccessible = true;
              break;
            }
          }
          if (!isAccessible) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      } else {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          if (loginData.hubIdFromHubIds?.first != hubResponseArray![i].fields?.hubId) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      }
    }
    if (hubResponseArray != null) {
      hubResponse = hubResponseArray?.first;
      hubValue = hubResponseArray!.first.fields!.hubId!.toString();
      setState(() {});
    }

    jobOpportunityListMain?.clear();
    jobOpportunityList?.clear();

    getRecords();
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    var query =
        "AND(${TableNames.CLM_STATUS}='${strings_name.str_job_status_process_complete}',${TableNames.CLM_JOB_TYPE}='$jobValue',${TableNames.CLM_DISPLAY_INTERNSHIP}='2',SEARCH('$hubValue',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0))";
    try {
      var data = await apiRepository.getJobOppoApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          jobOpportunityListMain?.clear();
          jobOpportunityList?.clear();
        }
        jobOpportunityListMain?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<JobOpportunityResponse>>);
        jobOpportunityList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<JobOpportunityResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          for (var i = 0; i < jobOpportunityListMain!.length; i++) {
            int workingNow = 0;
            if (jobOpportunityListMain![i].fields!.placedStudentsWorkingNow?.isNotEmpty == true) {
              for (int j = 0; j < jobOpportunityListMain![i].fields!.placedStudentsWorkingNow!.length; j++) {
                if (jobOpportunityListMain![i].fields!.placedStudentsWorkingNow![j] == "1") {
                  workingNow++;
                }
              }
            }
            jobOpportunityListMain![i].fields?.workingNow = workingNow;
          }

          jobOpportunityList = [];
          jobOpportunityList = jobOpportunityListMain;

          jobOpportunityListMain?.sort((a, b) => a.fields!.companyName!.last.trim().compareTo(b.fields!.companyName!.last.trim()));
          jobOpportunityList?.sort((a, b) => a.fields!.companyName!.last.trim().compareTo(b.fields!.companyName!.last.trim()));

          setState(() {
            isVisible = false;
          });
        }
      } else {
        if (offset.isEmpty) {
          jobOpportunityList = [];
          jobOpportunityListMain = [];
        }
        setState(() {
          isVisible = false;
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
      appBar: AppWidgets.appBarWithoutBack(jobType == 0 ? strings_name.str_view_create_company : strings_name.str_completed_jobs),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              custom_text(
                text: strings_name.str_select_hub,
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
                bottomValue: 0,
              ),
              Container(
                margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
                width: MediaQuery.of(context).size.width,
                child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                  value: hubResponse,
                  isExpanded: true,
                  elevation: 16,
                  style: blackText16,
                  focusColor: Colors.white,
                  onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                    setState(() {
                      hubValue = newValue!.fields!.hubId!.toString();
                      hubResponse = newValue;
                      jobOpportunityListMain?.clear();
                      jobOpportunityList?.clear();

                      getRecords();
                    });
                  },
                  items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
                    return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                      value: value,
                      child: Text(value.fields!.hubName!.toString()),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 4.h),
              Visibility(
                visible: jobOpportunityListMain != null && jobOpportunityListMain!.isNotEmpty,
                child: Column(children: [
                  CustomEditTextSearch(
                    hintText: "Search by company name..",
                    type: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    controller: controllerSearch,
                    onChanges: (value) {
                      if (value.isEmpty) {
                        jobOpportunityList = [];
                        jobOpportunityList = jobOpportunityListMain;
                        setState(() {});
                      } else {
                        jobOpportunityList = [];
                        for (var i = 0; i < jobOpportunityListMain!.length; i++) {
                          if (jobOpportunityListMain![i].fields!.companyName!.first.toLowerCase().contains(value.toLowerCase())) {
                            jobOpportunityList?.add(jobOpportunityListMain![i]);
                          }
                        }
                        setState(() {});
                      }
                    },
                  ),
                  custom_text(
                    text: "Total Jobs: ${jobOpportunityListMain?.length ?? 0}",
                    textStyles: blackTextSemiBold16,
                    leftValue: 15.w,
                    bottomValue: 0,
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                child: jobOpportunityList != null && jobOpportunityList!.isNotEmpty
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: jobOpportunityList?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => const CompletedStudentDetail(), arguments: jobOpportunityList?[index].fields!.jobCode);
                            },
                            child: Card(
                              elevation: 5,
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    custom_text(
                                      text: "${jobOpportunityList?[index].fields!.companyName?.first}",
                                      textStyles: centerTextStyle16,
                                      topValue: 0,
                                      maxLines: 2,
                                      bottomValue: 5,
                                      leftValue: 5,
                                    ),
                                    custom_text(
                                      text: "Job title: ${jobOpportunityList?[index].fields!.jobTitle}",
                                      textStyles: blackTextSemiBold15,
                                      topValue: 0,
                                      maxLines: 2,
                                      bottomValue: 5,
                                      leftValue: 5,
                                    ),
                                    custom_text(
                                      text: "Job created on: ${displayDate(jobOpportunityList?[index].fields!.created)}",
                                      textStyles: blackTextSemiBold12,
                                      topValue: 5,
                                      maxLines: 2,
                                      bottomValue: 5,
                                      leftValue: 5,
                                    ),
                                    custom_text(
                                      text: "${strings_name.str_job_desc}: ${jobOpportunityList![index].fields!.jobDescription}",
                                      textStyles: greyDarkTextStyle,
                                      bottomValue: 5,
                                      topValue: 5,
                                      leftValue: 5,
                                      maxLines: 5000,
                                    ),
                                    custom_text(
                                      text: "Total Students Placed in this job: ${jobOpportunityList![index].fields!.placedStudents?.length ?? 0}",
                                      textStyles: blackTextSemiBold12,
                                      bottomValue: 5,
                                      topValue: 0,
                                      leftValue: 5,
                                      maxLines: 5000,
                                    ),
                                    custom_text(
                                      text: "Total Students Working right now: ${jobOpportunityList![index].fields!.workingNow}",
                                      textStyles: blackTextSemiBold12,
                                      bottomValue: 5,
                                      topValue: 0,
                                      leftValue: 5,
                                      maxLines: 5000,
                                    ),
                                    custom_text(
                                        text: "${strings_name.str_city}: ${jobOpportunityList?[index].fields!.city?.first}",
                                        textStyles: blackTextSemiBold12,
                                        topValue: 0,
                                        maxLines: 2,
                                        bottomValue: 5,
                                        leftValue: 5),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                    : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_no_jobs, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
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

  displayDate(String? date) {
    DateTime? jobCreationDate = DateTime.tryParse(date ?? "");
    String displayDate = DateFormat("dd MMM, yyyy").format(jobCreationDate!);
    return displayDate;
  }
}
