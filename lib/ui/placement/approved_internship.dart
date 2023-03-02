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
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/models/request/create_job_opportunity_request.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/dio_exception.dart';

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
    var query = "AND(${TableNames.CLM_STATUS}='${strings_name.str_job_status_pending}')";
    try{
      jobOpportunityData = await apiRepository.getJoboppoApi(query);
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_list_pending_job_opp),
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
                                  text: "Location: ${jobOpportunityData.records?[index].fields!.reportingAddress?.first} ${jobOpportunityData.records?[index].fields!.city?.first}",
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
                                Container(
                                  alignment: Alignment.centerRight,
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Visibility(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        confirmationDialog(jobOpportunityData.records![index]);
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
                      }),
                )
              : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_no_jobs_approval_pending, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
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
          ),
          custom_text(
            text: 'Position : ${jobData.fields?.jobTitle}',
            textStyles: blackTextSemiBold14,
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
    try{
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
    }on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }


  }
}
