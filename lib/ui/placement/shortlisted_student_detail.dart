import 'dart:io';

import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../models/base_api_response.dart';
import '../../models/job_module_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../models/request/create_job_opportunity_request.dart';
import '../../utils/tablenames.dart';
import '../../values/text_styles.dart';

class ShortListedStudentDetail extends StatefulWidget {
  const ShortListedStudentDetail({Key? key}) : super(key: key);

  @override
  State<ShortListedStudentDetail> createState() => _ShortListedStudentDetailState();
}

class _ShortListedStudentDetailState extends State<ShortListedStudentDetail> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobOpportunityData = BaseLoginResponse();
  String company_name = "";
  String jobId = "";
  TextEditingController startTimeController = TextEditingController();
  TextEditingController specialInstructionController = TextEditingController();
  TextEditingController postalAddressController = TextEditingController();
  TextEditingController googleMapLinkController = TextEditingController();

  TextEditingController coordinatorNameController = TextEditingController();
  TextEditingController coordinatorNumberController = TextEditingController();

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
      jobOpportunityData = await apiRepository.getJobOppoApi(query);
      for (var i = 0; i < jobOpportunityData.records!.length; i++) {
        if (jobOpportunityData.records![i].fields != null && jobOpportunityData.records![i].fields!.appliedStudents != null) {
          for (var j = 0; j < jobOpportunityData.records![i].fields!.appliedStudents!.length; j++) {
            var jobModuleResponse = JobModuleResponse(
                applied_students_email: jobOpportunityData.records![i].fields!.applied_students_email?[j],
                applied_students_enrollment_number: jobOpportunityData.records![i].fields!.applied_students_enrollment_number![j],
                applied_students_name: jobOpportunityData.records![i].fields!.applied_students_name![j],
                applied_students: jobOpportunityData.records![i].fields!.appliedStudents![j],
                applied_students_number: jobOpportunityData.records![i].fields!.applied_students_number![j],
                applied_students_resume: jobOpportunityData.records![i].fields!.applied_students_resume![j].url,
                applied_students_specialization: jobOpportunityData.records![i].fields!.applied_students_specialization![j],
                applied_students_semester: jobOpportunityData.records![i].fields!.applied_students_semester![j]);
            studentResponse.add(jobModuleResponse);
          }
        }
      }
      if (jobOpportunityData.records!.first.fields!.shortlistedStudents != null) {
        for (var j = 0; j < studentResponse.length; j++) {
          for (var k = 0; k < jobOpportunityData.records!.first.fields!.shortlistedStudents!.length; k++) {
            if (studentResponse[j].applied_students == jobOpportunityData.records!.first.fields!.shortlistedStudents![k]) {
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_sortlist_student),
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                child: custom_text(
                                                  text: "${studentResponse[index].applied_students_name}",
                                                  textStyles: linkTextSemiBold14,
                                                  topValue: 0,
                                                  maxLines: 2,
                                                  bottomValue: 5,
                                                  leftValue: 5,
                                                ),
                                                onTap: () {
                                                  Get.to(const StudentHistory(), arguments: studentResponse[index].applied_students_number);
                                                },
                                              ),
                                              custom_text(text: "${strings_name.str_specializations}: ${studentResponse[index].applied_students_specialization}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 0, leftValue: 5),
                                              custom_text(text: "${strings_name.str_phone}: ${studentResponse[index].applied_students_number}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 0, leftValue: 5),
                                              custom_text(text: "${studentResponse[index].applied_students_email}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                              custom_text(text: "${strings_name.str_enrollment} ${studentResponse[index].applied_students_enrollment_number}", textStyles: blackTextSemiBold12, topValue: 0, maxLines: 2, bottomValue: 5, leftValue: 5),
                                              custom_text(text: "${strings_name.str_semester}: ${studentResponse[index].applied_students_semester}", textStyles: blackTextSemiBold12, topValue: 0, maxLines: 2, bottomValue: 5, leftValue: 5),
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
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ElevatedButton(
                        onPressed: () {
                          CreateJobOpportunityRequest request = CreateJobOpportunityRequest();
                          List<String> selectedStudentsData = [];
                          for (var i = 0; i < studentResponse.length; i++) {
                            if (studentResponse[i].selected) {
                              selectedStudentsData.add(studentResponse[i].applied_students!);
                            }
                          }
                          request.sortlisted = selectedStudentsData;
                          var json = request.toJson();
                          json.removeWhere((key, value) => value == null);
                          if (request.sortlisted!.isNotEmpty) {
                            interviewScheduleDialog();
                          } else {
                            Utils.showSnackBar(context, strings_name.str_please_select_one_student);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors_name.presentColor,
                          padding: const EdgeInsets.all(13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 7.0,
                        ),
                        child: const Text(
                          strings_name.str_schadule_interview,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    CustomButton(
                      fontSize: 15,
                      text: strings_name.str_export_selected_student,
                      click: () async {
                        List<String> selectedStudentsData = [];
                        for (var i = 0; i < studentResponse.length; i++) {
                          if (studentResponse[i].selected) {
                            selectedStudentsData.add(studentResponse[i].applied_students!);
                          }
                        }
                        if (selectedStudentsData.isNotEmpty) {
                          exportStudentData();
                        } else {
                          Utils.showSnackBar(context, strings_name.str_please_select_one_student);
                        }
                      },
                    ),
                  ],
                )
              : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }

  Future<void> exportStudentData() async {
    setState(() {
      isVisible = true;
    });
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    sheet.appendRow(['Name', 'Email', 'Specialization', 'Semester', 'Enrollment Number', 'Mobile Number', 'Resume']);

    List<JobModuleResponse> myData = [];
    for (var i = 0; i < studentResponse.length; i++) {
      if (studentResponse[i].selected) {
        myData.add(studentResponse[i]);
      }
    }

    myData.forEach((row) {
      sheet.appendRow([row.applied_students_name, row.applied_students_email, row.applied_students_specialization, row.applied_students_semester, row.applied_students_enrollment_number, row.applied_students_number, row.applied_students_resume]);
    });

    var appDocumentsDirectory = await getApplicationDocumentsDirectory();
    var file = File("${appDocumentsDirectory.path}/ShortlistedFor${company_name.split(" ").first}.xlsx");
    await file.writeAsBytes(excel.encode()!);
    try {
      await OpenFilex.open(file.path);
      setState(() {
        isVisible = false;
      });
    } catch (e) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBarUsingGet("No Application found to open this file");
    }
  }

  Future<void> shortListFirst() async {
    CreateJobOpportunityRequest request = CreateJobOpportunityRequest();
    List<String> selectedStudentsData = [];
    for (var i = 0; i < studentResponse.length; i++) {
      if (studentResponse[i].selected) {
        selectedStudentsData.add(studentResponse[i].applied_students!);
      }
    }
    request.sortlisted = selectedStudentsData;
    var json = request.toJson();
    json.removeWhere((key, value) => value == null);
    if (request.sortlisted!.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      try {
        var resp = await apiRepository.updateJobSortListedApi(json, jobOpportunityData.records!.first.id!);
        if (resp.id!.isNotEmpty) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_job_sortlisted);
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

  Future<void> interviewScheduleDialog() async {
    Dialog errorDialog = Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            custom_text(text: strings_name.str_schadule_interview, textStyles: boldTitlePrimaryColorStyle),
            custom_text(
              text: 'Company Name : ${jobOpportunityData.records?.first.fields?.companyName?.first.toString()}',
              textStyles: blackTextSemiBold14,
              bottomValue: 0,
              topValue: 0,
            ),
            custom_text(
              text: '${strings_name.str_job_title_} ${jobOpportunityData.records?.first.fields?.jobTitle}',
              textStyles: blackTextSemiBold14,
              bottomValue: 0,
              topValue: 3,
            ),
            SizedBox(height: 5.h),
            InkWell(
              child: IgnorePointer(
                child: custom_edittext(
                  hintText: strings_name.str_job_interview_job_timing,
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
            custom_edittext(
              type: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: specialInstructionController,
              hintText: strings_name.str_special_instruction,
              maxLines: 2,
              minLines: 2,
              maxLength: 50000,
              topValue: 0,
            ),
            SizedBox(height: 5.h),
            custom_edittext(
              type: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              controller: postalAddressController,
              hintText: strings_name.str_interview_address,
              maxLines: 2,
              minLines: 2,
              maxLength: 50000,
              topValue: 0,
            ),
            SizedBox(height: 5.h),
            custom_edittext(
              type: TextInputType.text,
              textInputAction: TextInputAction.newline,
              controller: googleMapLinkController,
              hintText: strings_name.str_google_map_link,
              topValue: 0,
            ),
            SizedBox(height: 5.h),
            custom_edittext(
              type: TextInputType.text,
              textInputAction: TextInputAction.newline,
              controller: coordinatorNameController,
              hintText: strings_name.str_codinator_name,
              topValue: 0,
            ),
            SizedBox(height: 5.h),
            custom_edittext(
              type: TextInputType.number,
              textInputAction: TextInputAction.done,
              controller: coordinatorNumberController,
              hintText: strings_name.str_codinator_number,
              maxLength: 10,
              topValue: 0,
            ),
            CustomButton(
                text: strings_name.str_submit,
                click: () {
/*
                  if (startTimeController.text.trim().isEmpty) {
                    Utils.showSnackBar(context, strings_name.str_empty_job_date_time);
                  }
*/
                  if (postalAddressController.text.trim().isEmpty) {
                    Utils.showSnackBar(context, strings_name.str_empty_postal_Address);
                  } else if (coordinatorNameController.text.trim().isEmpty) {
                    Utils.showSnackBar(context, strings_name.str_empty_coori_name);
                  } else if (coordinatorNumberController.text.trim().isEmpty) {
                    Utils.showSnackBar(context, strings_name.str_empty_coori_number);
                  } else {
                    Get.back(closeOverlays: true);
                    approveNow();
                  }
                })
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  void approveNow() async {
    List<String> selectedStudentsData = [];
    for (var i = 0; i < studentResponse.length; i++) {
      if (studentResponse[i].selected) {
        selectedStudentsData.add(studentResponse[i].applied_students!);
      }
    }

    CreateJobOpportunityRequest request = CreateJobOpportunityRequest();
    request.sortlisted = selectedStudentsData;
    request.status = strings_name.str_job_status_interview_scheduled;
    request.interview_datetime = startTimeController.text.trim().toString();
    request.interview_instruction = specialInstructionController.text.trim().toString();
    request.interview_place_address = postalAddressController.text.trim().toString();
    request.interview_place_url = googleMapLinkController.text.trim().toString();
    request.coordinator_mobile_number = coordinatorNumberController.text.trim().toString();
    request.coordinator_name = coordinatorNameController.text.trim().toString();

    var json = request.toJson();
    json.removeWhere((key, value) => value == null);

    setState(() {
      isVisible = true;
    });
    try {
      var resp = await apiRepository.updateJobOpportunityApi(json, jobOpportunityData.records!.first.id!);
      if (resp.id!.isNotEmpty) {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_interview_time_schedule);
        await Future.delayed(const Duration(milliseconds: 2000));
        Get.back();
        Get.back(closeOverlays: true);
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
