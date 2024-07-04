import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/request/create_job_opportunity_request.dart';
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
import 'selected_student_detail.dart';

class SelectedStudentList extends StatefulWidget {
  const SelectedStudentList({Key? key}) : super(key: key);

  @override
  State<SelectedStudentList> createState() => _SelectedStudentListState();
}

class _SelectedStudentListState extends State<SelectedStudentList> {
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

  TextEditingController reasonController = TextEditingController();

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

    getRecords();
  }

  getRecords() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query =
        "AND(${TableNames.CLM_STATUS}='${strings_name.str_job_status_interview_scheduled}',${TableNames.CLM_JOB_TYPE}='$jobValue',SEARCH('$hubValue',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0))";
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
          jobOpportunityListMain?.sort((a, b) => a.fields!.companyName!.first.trim().compareTo(b.fields!.companyName!.first.trim()));
          jobOpportunityList?.sort((a, b) => a.fields!.companyName!.first.trim().compareTo(b.fields!.companyName!.first.trim()));
          setState(() {
            isVisible = false;
          });
        }
      } else {
        if (offset.isEmpty) {
          jobOpportunityListMain = [];
          jobOpportunityList = [];
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_select_student),
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
                SizedBox(height: 8.h),
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
                jobOpportunityList != null && jobOpportunityList?.isNotEmpty == true
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                        child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: jobOpportunityList?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => const SelectedStudentDetail(), arguments: [
                                    {"company_name": jobOpportunityList?[index].fields!.companyName?.first},
                                    {"jobcode": jobOpportunityList?[index].fields!.jobCode}
                                  ]);
                                },
                                child: Card(
                                  elevation: 5,
                                  child: Container(
                                    margin: EdgeInsets.all(10.h),
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
                                            text: "${strings_name.str_job_title_} ${jobOpportunityList?[index].fields!.jobTitle}",
                                            textStyles: blackTextSemiBold144,
                                            topValue: 0,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                          text: "Job created on: ${displayDate(jobOpportunityList?[index].fields!.created)}",
                                          textStyles: blackTextSemiBold12,
                                          topValue: 0,
                                          maxLines: 2,
                                          bottomValue: 5,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                            text: "${strings_name.str_job_desc}: ${jobOpportunityList?[index].fields!.jobDescription}",
                                            textStyles: greyDarkTextStyle,
                                            topValue: 0,
                                            maxLines: 5000,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            text: "${strings_name.str_city}: ${jobOpportunityList?[index].fields!.city?.first}",
                                            textStyles: blackTextSemiBold12,
                                            topValue: 0,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            text: "${strings_name.str_total_students_appeared}: ${jobOpportunityList?[index].fields!.appearedForInterview?.length ?? 0}",
                                            textStyles: blackTextSemiBold12,
                                            topValue: 0,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        GestureDetector(
                                          onTap: () {
                                            reasonController.text = "";
                                            closeConfirmationDialog(jobOpportunityList![index]);
                                          },
                                          child: const custom_text(
                                            text: strings_name.str_complete_jobs,
                                            textStyles: primaryTextSemiBold14,
                                            alignment: Alignment.centerRight,
                                            topValue: 10,
                                            bottomValue: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_no_jobs, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
              ],
            ),
          ),
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

  Future<void> closeConfirmationDialog(BaseApiResponseWithSerializable<JobOpportunityResponse> jobData) async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          custom_text(text: 'Please Confirm Job Detail', textStyles: boldTitlePrimaryColorStyle),
          SizedBox(height: 5.h),
          custom_text(
            text: 'Company Name : ${jobData.fields?.companyName?.first.toString()}',
            textStyles: blackTextSemiBold14,
            maxLines: 2,
            bottomValue: 0,
          ),
          custom_text(
            text: 'Position : ${jobData.fields?.jobTitle}',
            textStyles: blackTextSemiBold14,
            maxLines: 2,
            bottomValue: 0,
          ),
          SizedBox(height: 5.h),
          const custom_text(
            text: strings_name.str_provide_completion_reason,
            alignment: Alignment.topLeft,
            maxLines: 2,
            textStyles: blackTextSemiBold16,
            bottomValue: 5,
          ),
          custom_edittext(
            type: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: reasonController,
            minLines: 3,
            maxLines: 3,
            maxLength: 50000,
            topValue: 0,
          ),
          CustomButton(
              text: strings_name.str_submit,
              click: () {
                if (reasonController.text.trim().isEmpty) {
                  Utils.showSnackBar(context, strings_name.str_rejection_reason);
                } else {
                  Get.back(closeOverlays: true);
                  updateJobStatus(jobData);
                }
              })
        ],
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  void updateJobStatus(BaseApiResponseWithSerializable<JobOpportunityResponse> jobData) async {
    setState(() {
      isVisible = true;
    });

    CreateJobOpportunityRequest request = CreateJobOpportunityRequest();
    request.status = strings_name.str_job_status_process_complete;
    request.jobRejectionReason = reasonController.text.trim().toString();

    var json = request.toJson();
    json.removeWhere((key, value) => value == null);
    try {
      var resp = await apiRepository.updateJobOpportunityApi(json, jobData.id.toString());
      if (resp.id!.isNotEmpty) {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_job_approved);
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
  }
}
