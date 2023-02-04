import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../models/base_api_response.dart';
import '../../models/job_module_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../models/request/create_job_opportunity_request.dart';
import '../../utils/tablenames.dart';
import '../../values/text_styles.dart';

class SortListedStudentDetail extends StatefulWidget {
  const SortListedStudentDetail({Key? key}) : super(key: key);

  @override
  State<SortListedStudentDetail> createState() => _SortListedStudentDetailState();
}

class _SortListedStudentDetailState extends State<SortListedStudentDetail> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobpportunityData = BaseLoginResponse();
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
    jobpportunityData = await apiRepository.getJoboppoApi(query);

    for (var i = 0; i < jobpportunityData.records!.length; i++) {
      if (jobpportunityData.records![i].fields != null && jobpportunityData.records![i].fields!.appliedStudents != null) {
        for (var j = 0; j < jobpportunityData.records![i].fields!.appliedStudents!.length; j++) {
          var jobModuleResponse = JobModuleResponse(
              applied_students_email: jobpportunityData.records![i].fields!.applied_students_email![j],
              applied_students_enrollment_number: jobpportunityData.records![i].fields!.applied_students_enrollment_number![j],
              applied_students_name: jobpportunityData.records![i].fields!.applied_students_name![j],
              applied_students_number: jobpportunityData.records![i].fields!.appliedStudents![j]);
          studentResponse.add(jobModuleResponse);
        }
      }
    }
    for (var j = 0; j < studentResponse.length; j++) {
      for (var k = 0; k < jobpportunityData.records!.first.fields!.shortlistedStudents!.length; k++) {
        if (studentResponse[j].applied_students_number == jobpportunityData.records!.first.fields!.shortlistedStudents![k]) {
          studentResponse[j].selected = true;
          break;
        }
      }
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
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            custom_text(
                                              text: "${studentResponse[index].applied_students_name}",
                                              textStyles: centerTextStyle14,
                                              topValue: 0,
                                              maxLines: 2,
                                              bottomValue: 5,
                                              leftValue: 5,
                                            ),
                                            //custom_text(text: "${strings_name.str_phone}: ${studentResponse[index].applied_students_number}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 0, leftValue: 5),
                                            custom_text(text: "${strings_name.str_email}: ${studentResponse[index].applied_students_email}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                            custom_text(text: "${strings_name.str_enrollment} ${studentResponse[index].applied_students_enrollment_number}", textStyles: blackTextSemiBold12, topValue: 0, maxLines: 2, bottomValue: 5, leftValue: 5),
                                          ],
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
                        onPressed: (){

                        },
                        style: ElevatedButton.styleFrom(
                          primary:colors_name.presentColor,
                          padding: const EdgeInsets.all(13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 7.0,
                        ),
                        child: Text(
                          strings_name.str_schadule_interview,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15, color:Colors.white, fontWeight:FontWeight.w700),
                        ),
                      ),
                    ),
                    CustomButton(
                      text: strings_name.str_submit,
                      click: () async {
                        // BaseLoginResponse<JobOpportunityResponse> jobpportunityData = BaseLoginResponse();

                        CreateJobOpportunityRequest request = CreateJobOpportunityRequest();
                        List<String> selectedStudentsData = [];
                        for (var i = 0; i < studentResponse.length; i++) {
                          if (studentResponse[i].selected) {
                            selectedStudentsData.add(studentResponse[i].applied_students_number!);
                          }
                        }
                        request.sortlisted = selectedStudentsData;

                        var json = request.toJson();
                        json.removeWhere((key, value) => value == null);
                        if (selectedStudentsData.isNotEmpty) {
                          setState(() {
                            isVisible = true;
                          });
                          var resp = await apiRepository.updateJobSortListedApi(json, jobpportunityData.records!.first.id!);
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
}
