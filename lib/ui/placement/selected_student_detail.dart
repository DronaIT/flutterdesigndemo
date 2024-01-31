import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_edittext.dart';
import '../../models/base_api_response.dart';
import '../../models/job_module_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../models/request/create_job_opportunity_request.dart';
import '../../utils/tablenames.dart';
import '../../values/text_styles.dart';

class SelectedStudentDetail extends StatefulWidget {
  const SelectedStudentDetail({Key? key}) : super(key: key);

  @override
  State<SelectedStudentDetail> createState() => _SelectedStudentDetailState();
}

class _SelectedStudentDetailState extends State<SelectedStudentDetail> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobpportunityData = BaseLoginResponse();
  TextEditingController startTimeController = TextEditingController();

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
    try {
      jobpportunityData = await apiRepository.getJobOppoApi(query);
      for (var i = 0; i < jobpportunityData.records!.length; i++) {
        if (jobpportunityData.records![i].fields != null && jobpportunityData.records![i].fields!.appearedForInterview != null) {
          for (var j = 0; j < jobpportunityData.records![i].fields!.appearedForInterview!.length; j++) {
            var jobModuleResponse = JobModuleResponse(
                applied_students_email: jobpportunityData.records![i].fields!.appeared_for_interview_email![j],
                applied_students_enrollment_number: jobpportunityData.records![i].fields!.appeared_for_interview_enrollment_number![j],
                applied_students_name: jobpportunityData.records![i].fields!.appeared_for_interview_name![j],
                applied_students: jobpportunityData.records![i].fields!.appearedForInterview![j]);
            studentResponse.add(jobModuleResponse);
          }
        }
      }
      for (var j = 0; j < studentResponse.length; j++) {
        if (jobpportunityData.records!.first.fields?.selectedStudents != null) {
          for (var k = 0; k < jobpportunityData.records!.first.fields!.selectedStudents!.length; k++) {
            if (studentResponse[j].applied_students == jobpportunityData.records!.first.fields!.selectedStudents![k]) {
              studentResponse[j].selected = true;
              break;
            }
          }
        }
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_select_student),
      body: Stack(
        children: [
          studentResponse != null && studentResponse.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: studentResponse.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    studentResponse[index].selected = !studentResponse[index].selected;
                                  });
                                },
                                child: Card(
                                  elevation: 5,
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              custom_text(text: "${studentResponse[index].applied_students_name}", textStyles: centerTextStyle14, topValue: 0, maxLines: 2, bottomValue: 5, leftValue: 5),
                                              //custom_text(text: "${strings_name.str_phone}: ${studentResponse[index].applied_students_number}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 0, leftValue: 5),
                                              custom_text(text: "${studentResponse[index].applied_students_email}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                              custom_text(text: "${strings_name.str_enrollment} ${studentResponse[index].applied_students_enrollment_number}", textStyles: blackTextSemiBold12, topValue: 0, maxLines: 2, bottomValue: 5, leftValue: 5),
                                            ],
                                          ),
                                        ),
                                        if (studentResponse[index].selected) const Icon(Icons.check, size: 25, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    CustomButton(
                      text: strings_name.str_submit,
                      click: () async {
                        interviewScheduleDialog();
                      },
                    ),
                  ],
                )
              : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_no_student_appeared_for_interview, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }

  Future<void> interviewScheduleDialog() async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            custom_text(text: strings_name.str_joing_date, textStyles: boldTitlePrimaryColorStyle),
            custom_text(
              text: 'Company Name : ${jobpportunityData.records?.first.fields?.companyName?.first.toString()}',
              textStyles: blackTextSemiBold14,
              bottomValue: 0,
              topValue: 0,
            ),
            custom_text(
              text: '${strings_name.str_job_title_} ${jobpportunityData.records?.first.fields?.jobTitle}',
              textStyles: blackTextSemiBold14,
              bottomValue: 0,
              topValue: 3,
            ),
            SizedBox(height: 10.h),
            InkWell(
              child: IgnorePointer(
                child: custom_edittext(
                  hintText: strings_name.str_joing_date,
                  type: TextInputType.none,
                  textInputAction: TextInputAction.next,
                  controller: startTimeController,
                  topValue: 0,
                ),
              ),
              onTap: () {
                DateTime dateSelected = DateTime.now();
                if (startTimeController.text.isNotEmpty) {
                  dateSelected = DateFormat("yyyy-MM-dd").parse(startTimeController.text);
                }
                showDatePicker(context: context, initialDate: dateSelected, firstDate: DateTime.now(), lastDate: DateTime(2100)).then((pickedDate) {
                  if (pickedDate == null) {
                    return;
                  }
                  setState(() {
                    var dateTime = pickedDate;
                    var formatter = DateFormat('yyyy-MM-dd');
                    var time = DateTime(dateTime.year, dateTime.month, dateTime.day);
                    startTimeController.text = formatter.format(time);
                  });
                });
              },
            ),
            SizedBox(height: 20.h),
            CustomButton(
                text: strings_name.str_submit,
                click: () {
                  if (startTimeController.text.trim().isEmpty) {
                    Utils.showSnackBar(context, strings_name.str_joing_date);
                  } else {
                    Get.back();
                    selectNow();
                  }
                })
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  selectNow() async {
    CreateJobOpportunityRequest request = CreateJobOpportunityRequest();
    List<String> selectedStudentsData = [];
    for (var i = 0; i < studentResponse.length; i++) {
      if (studentResponse[i].selected) {
        selectedStudentsData.add(studentResponse[i].applied_students!);
      }
    }
    request.selected = selectedStudentsData;
    request.joining_date = startTimeController.text.toString();
    var json = request.toJson();
    json.removeWhere((key, value) => value == null);
    if (selectedStudentsData.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      try {
        var resp = await apiRepository.updateJobSortListedApi(json, jobpportunityData.records!.first.id!);
        if (resp.id!.isNotEmpty) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_selected_students);
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
    } else {
      Utils.showSnackBar(context, strings_name.str_please_select_one_student);
    }
  }
}
