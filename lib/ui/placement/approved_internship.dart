import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/models/request/create_job_opportunity_request.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/dio_exception.dart';
import '../../customwidget/custom_edittext_search.dart';

class ApprovedInternship extends StatefulWidget {
  const ApprovedInternship({Key? key}) : super(key: key);

  @override
  State<ApprovedInternship> createState() => _ApprovedInternshipState();
}

class _ApprovedInternshipState extends State<ApprovedInternship> {
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  String startDateVal = "", endDateVal = "";

  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();

  List<BaseApiResponseWithSerializable<JobOpportunityResponse>>? jobOpportunityListMain = [];
  List<BaseApiResponseWithSerializable<JobOpportunityResponse>>? jobOpportunityList = [];
  String offset = "";
  var controllerSearch = TextEditingController();

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  @override
  void initState() {
    super.initState();
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
        "AND(${TableNames.CLM_STATUS}='${strings_name.str_job_status_pending}', SEARCH('$hubValue',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0))";
    debugPrint(query);
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_list_pending_job_opp),
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
                  items: hubResponseArray
                      ?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
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
                          return Card(
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
                                  jobOpportunityList?[index].fields!.stipendRangeMin != null &&
                                          jobOpportunityList?[index].fields!.stipendRangeMax != null
                                      ? custom_text(
                                          text:
                                              "Stipend: ${jobOpportunityList?[index].fields!.stipendRangeMin} - ${jobOpportunityList?[index].fields!.stipendRangeMax}",
                                          textStyles: blackTextSemiBold12,
                                          topValue: 5,
                                          maxLines: 2,
                                          bottomValue: 5,
                                          leftValue: 5,
                                        )
                                      : Container(),
                                  custom_text(
                                      text:
                                          "Timings: ${jobOpportunityList?[index].fields!.timingStart} - ${jobOpportunityList?[index].fields!.timingEnd}",
                                      textStyles: blackTextSemiBold12,
                                      topValue: 5,
                                      maxLines: 2,
                                      bottomValue: 5,
                                      leftValue: 5),
                                  custom_text(
                                      text: "Vacancies: ${jobOpportunityList?[index].fields!.vacancies}",
                                      textStyles: blackTextSemiBold12,
                                      topValue: 5,
                                      maxLines: 2,
                                      bottomValue: 5,
                                      leftValue: 5),
                                  custom_text(
                                    text: jobOpportunityList?[index].fields?.reportingAddress?.first != null
                                        ? "Location: ${jobOpportunityList?[index].fields?.reportingAddress?.first.toString().trim()} ${jobOpportunityList?[index].fields!.city?.first}"
                                        : "Location:N/A",
                                    textStyles: blackTextSemiBold12,
                                    topValue: 5,
                                    maxLines: 5,
                                    bottomValue: 5,
                                    leftValue: 5,
                                  ),
                                  custom_text(
                                    text:
                                        "Internship : ${jobOpportunityList?[index].fields!.internshipModes} - ${jobOpportunityList?[index].fields!.internshipDuration}",
                                    textStyles: blackTextSemiBold12,
                                    topValue: 5,
                                    maxLines: 2,
                                    bottomValue: 5,
                                    leftValue: 5,
                                  ),
                                  custom_text(
                                    text: "Description: ${jobOpportunityList![index].fields!.jobDescription}",
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
                                          confirmationDialog(jobOpportunityList![index]);
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
                                          strings_name.str_approve,
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
                        })
                    : Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: custom_text(
                            text: strings_name.str_no_jobs_approval_pending, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
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

  Future<void> confirmationDialog(BaseApiResponseWithSerializable<JobOpportunityResponse> jobData) async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          custom_text(text: 'Please confirm the approval', textStyles: boldTitlePrimaryColorStyle),
          SizedBox(height: 5.h),
          custom_text(
            text: 'Company Name : ${jobData.fields?.companyName?.first.toString()}',
            textStyles: blackTextSemiBold14,
            maxLines: 2,
          ),
          custom_text(
            text: 'Position : ${jobData.fields?.jobTitle}',
            textStyles: blackTextSemiBold14,
            maxLines: 2,
          ),
          SizedBox(height: 5.h),
          custom_text(
            text: strings_name.str_job_apply_timing,
            alignment: Alignment.topLeft,
            textStyles: blackTextSemiBold16,
          ),
          InkWell(
            child: IgnorePointer(
              child: custom_edittext(
                hintText: strings_name.str_start_time,
                type: TextInputType.none,
                textInputAction: TextInputAction.next,
                controller: startTimeController,
                topValue: 0,
              ),
            ),
            onTap: () {
              DateTime dateSelected = DateTime.now();
              TimeOfDay timeSelected = TimeOfDay.now();

              if (startTimeController.text.isNotEmpty) {
                dateSelected = DateFormat("yyyy-MM-dd").parse(startTimeController.text);

                DateTime time = DateFormat("hh:mm aa").parse(startTimeController.text);
                timeSelected = TimeOfDay.fromDateTime(time);
              }

              showDatePicker(context: context, initialDate: dateSelected, firstDate: DateTime.now(), lastDate: DateTime(2100)).then((pickedDate) {
                if (pickedDate == null) {
                  return;
                }
                setState(() {
                  showTimePicker(context: context, initialTime: timeSelected).then((pickedTime) {
                    if (pickedTime == null) {
                      return;
                    }
                    setState(() {
                      var dateTime = pickedDate;
                      var formatter = DateFormat('yyyy-MM-dd hh:mm aa');

                      var time = DateTime(dateTime.year, dateTime.month, dateTime.day, pickedTime.hour, pickedTime.minute);
                      startTimeController.text = formatter.format(time);
                    });
                  });
                });
              });
            },
          ),
          SizedBox(height: 5.h),
          InkWell(
            child: IgnorePointer(
              child: custom_edittext(
                hintText: strings_name.str_end_time,
                type: TextInputType.none,
                textInputAction: TextInputAction.next,
                controller: endTimeController,
                topValue: 0,
              ),
            ),
            onTap: () {
              DateTime dateSelected = DateTime.now();
              TimeOfDay timeSelected = TimeOfDay.now();

              if (endTimeController.text.isNotEmpty) {
                dateSelected = DateFormat("yyyy-MM-dd").parse(endTimeController.text);

                DateTime time = DateFormat("hh:mm aa").parse(endTimeController.text);
                timeSelected = TimeOfDay.fromDateTime(time);
              }

              showDatePicker(context: context, initialDate: dateSelected, firstDate: DateTime.now(), lastDate: DateTime(2100)).then((pickedDate) {
                if (pickedDate == null) {
                  return;
                }
                setState(() {
                  showTimePicker(context: context, initialTime: timeSelected).then((pickedTime) {
                    if (pickedTime == null) {
                      return;
                    }
                    setState(() {
                      var dateTime = pickedDate;
                      var formatter = DateFormat('yyyy-MM-dd hh:mm aa');

                      var time = DateTime(dateTime.year, dateTime.month, dateTime.day, pickedTime.hour, pickedTime.minute);
                      endTimeController.text = formatter.format(time);
                    });
                  });
                });
              });
            },
          ),
          CustomButton(
              text: strings_name.str_submit,
              click: () {
                if (startTimeController.text.trim().isEmpty) {
                  Utils.showSnackBar(context, strings_name.str_empty_job_apply_start_time);
                } else if (endTimeController.text.trim().isEmpty) {
                  Utils.showSnackBar(context, strings_name.str_empty_job_apply_end_time);
                } else {
                  Get.back(closeOverlays: true);
                  approveNow(jobData);
                }
              })
        ],
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  void approveNow(BaseApiResponseWithSerializable<JobOpportunityResponse> jobData) async {
    setState(() {
      isVisible = true;
    });

    CreateJobOpportunityRequest request = CreateJobOpportunityRequest();
    request.status = strings_name.str_job_status_published;
    request.jobApplyStartTime = startTimeController.text.trim().toString();
    request.jobApplyEndTime = endTimeController.text.trim().toString();

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

  displayDate(String? date) {
    DateTime? jobCreationDate = DateTime.tryParse(date ?? "");
    String displayDate = DateFormat("dd MMM, yyyy").format(jobCreationDate!);
    return displayDate;
  }
}
