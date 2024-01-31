import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../models/base_api_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../utils/tablenames.dart';
import '../../values/text_styles.dart';

class IssueWarningLetterStudentList extends StatefulWidget {
  const IssueWarningLetterStudentList({Key? key}) : super(key: key);

  @override
  State<IssueWarningLetterStudentList> createState() => _IssueWarningLetterStudentListState();
}

class _IssueWarningLetterStudentListState extends State<IssueWarningLetterStudentList> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobOpportunityData = BaseLoginResponse();

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? viewStudent = [];
  List<BaseApiResponseWithSerializable<JobOpportunityResponse>> jobsData = [];

  var type = 1;
  String title = strings_name.str_issue_warning_letter_1;

  String companyName = "";
  String jobId = "";

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      if (Get.arguments[0]["title"] != null) {
        title = Get.arguments[0]["title"];
      }
      if (Get.arguments[1]["letterType"] != null) {
        type = Get.arguments[1]["letterType"];
      }
      if (Get.arguments[2]["jobList"] != null) {
        jobsData = Get.arguments[2]["jobList"];
      }
      if (Get.arguments[3]["studentList"] != null) {
        viewStudent = Get.arguments[3]["studentList"];
      }
    }
    filterStudentData();
  }

  filterStudentData() {
    if (jobsData.isNotEmpty && viewStudent != null && viewStudent?.isNotEmpty == true) {
      for (int j = 0; j < viewStudent!.length; j++) {
        int isMissedToApply = 0;
        int isMissedToAppearForJobInterview = 0;
        int totalJobsCame = 0;
        for (int i = 0; i < jobsData.length; i++) {
          bool canAddBasedOnHub = true,
              canAddBasedOnSpecialization = true,
              canAddBasedOnSemester = true,
              canAddBasedOnGender = true,
              isAlreadyApplied = false,
              isAppearedForInterview = false;
          if (jobsData[i].fields?.hubIds?.isNotEmpty == true) {
            canAddBasedOnHub = (jobsData[i].fields?.hubIds!.contains(viewStudent![j].fields?.hubIds?.first) == true);
          }
          if (jobsData[i].fields?.specializationIds?.isNotEmpty == true) {
            canAddBasedOnSpecialization = (jobsData[i].fields?.specializationIds!.contains(viewStudent![j].fields?.specializationIds?.first) == true);
          }
          if (jobsData[i].fields?.semester?.isNotEmpty == true) {
            canAddBasedOnSemester = (jobsData[i].fields?.semester!.contains(viewStudent![j].fields?.semester) == true);

            if (!canAddBasedOnSemester) {
              DateTime? jobCreationDate = DateTime.tryParse(jobsData[i].fields?.created ?? "");
              DateTime? batchStartDate = DateTime.tryParse(viewStudent![j].fields?.admission_batch_start?.last ?? "");
              DateTime? batchEndDate = DateTime.tryParse(viewStudent![j].fields?.admission_batch_end?.last ?? "");
              if (batchStartDate?.isAfter(jobCreationDate!) == true || batchEndDate?.isBefore(jobCreationDate!) == true) {
                canAddBasedOnSemester = false;
              } else {
                int sem = 0;
                while (batchStartDate?.isBefore(batchEndDate!) == true) {
                  sem++;
                  DateTime? semStartDate = sem == 1 ? batchStartDate : batchStartDate?.add(Duration(days: sem * 180));
                  DateTime? semEndDate = semStartDate?.add(const Duration(days: 180));
                  if (semStartDate?.isBefore(jobCreationDate!) == true && semEndDate?.isAfter(jobCreationDate!) == true) {
                    if (jobsData[i].fields?.semester!.contains(sem.toString()) == true) {
                      canAddBasedOnSemester = true;
                      break;
                    }
                  }
                  if (sem + 1 > int.parse(viewStudent![j].fields!.semester!)) {
                    break;
                  }
                }
              }
            }
          }
          if (jobsData[i].fields?.gender?.isNotEmpty == true) {
            if (jobsData[i].fields?.gender == strings_name.str_both) {
              canAddBasedOnGender = true;
            } else if (jobsData[i].fields?.gender?.toLowerCase() == viewStudent![j].fields?.gender?.toLowerCase()) {
              canAddBasedOnGender = true;
            } else {
              canAddBasedOnGender = false;
            }
          }
          if (jobsData[i].fields?.appliedStudents?.isNotEmpty == true) {
            isAlreadyApplied = jobsData[i].fields?.appliedStudents!.contains(viewStudent![j].id) == true;
          }
          if (jobsData[i].fields?.appearedForInterview?.isNotEmpty == true) {
            isAppearedForInterview = jobsData[i].fields?.appearedForInterview!.contains(viewStudent![j].id) == true;
          }
          if (canAddBasedOnHub && canAddBasedOnSpecialization && canAddBasedOnSemester && canAddBasedOnGender) {
            if (!isAlreadyApplied) {
              isMissedToApply++;
            } else if (isAlreadyApplied && !isAppearedForInterview) {
              isMissedToAppearForJobInterview++;
            }
            totalJobsCame++;
          }
        }
        if (isMissedToApply == 0 && isMissedToAppearForJobInterview == 0) {
          viewStudent?.removeAt(j);
          j--;
        } else {
          viewStudent![j].fields?.totalJobsCame = totalJobsCame;
          viewStudent![j].fields?.missedToApply = isMissedToApply;
          viewStudent![j].fields?.missedToAppearForInterview = isMissedToAppearForJobInterview;
        }
      }

    } else {
      if (jobsData.isEmpty) {
        Utils.showSnackBar(context, strings_name.str_no_jobs_published);
      } else if (viewStudent == null || viewStudent?.isEmpty == true) {
        Utils.showSnackBar(context, strings_name.str_no_students_found);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(title),
      body: Stack(
        children: [
          viewStudent != null && viewStudent?.isNotEmpty == true
              ? Column(
                  children: [
                    custom_text(
                        text: "Total students : ${viewStudent?.length ?? 0}",
                        textStyles: blackTextSemiBold16,
                        maxLines: 2,
                        bottomValue: 0,
                        leftValue: 15),
                    custom_text(
                        text: "Total jobs came : ${jobsData.length}", textStyles: blackTextSemiBold16, maxLines: 2, bottomValue: 0, leftValue: 15),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: viewStudent?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    viewStudent![index].fields?.selected = !viewStudent![index].fields!.selected;
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
                                              GestureDetector(
                                                onTap: () {
                                                  Get.to(const StudentHistory(), arguments: viewStudent![index].fields?.mobileNumber);
                                                },
                                                child: custom_text(
                                                    text: "${viewStudent![index].fields?.name}",
                                                    textStyles: linkTextSemiBold14,
                                                    topValue: 0,
                                                    maxLines: 2,
                                                    bottomValue: 5,
                                                    leftValue: 5),
                                              ),
                                              custom_text(
                                                  text: "${viewStudent![index].fields?.email}",
                                                  textStyles: blackTextSemiBold12,
                                                  topValue: 5,
                                                  maxLines: 2,
                                                  bottomValue: 5,
                                                  leftValue: 5),
                                              custom_text(
                                                  text: "${strings_name.str_number_of_jobs_came} : ${viewStudent![index].fields?.totalJobsCame}",
                                                  textStyles: blackTextSemiBold12,
                                                  topValue: 5,
                                                  maxLines: 2,
                                                  bottomValue: 5,
                                                  leftValue: 5),
                                              custom_text(
                                                  text:
                                                      "${strings_name.str_number_of_missed_to_apply} : ${viewStudent![index].fields?.missedToApply}",
                                                  textStyles: blackTextSemiBold12,
                                                  topValue: 5,
                                                  maxLines: 2,
                                                  bottomValue: 5,
                                                  leftValue: 5),
                                              custom_text(
                                                  text:
                                                      "${strings_name.str_number_of_missed_to_appear} : ${viewStudent![index].fields?.missedToAppearForInterview}",
                                                  textStyles: blackTextSemiBold12,
                                                  topValue: 5,
                                                  maxLines: 2,
                                                  bottomValue: 5,
                                                  leftValue: 5),
                                            ],
                                          ),
                                        ),
                                        if (viewStudent![index].fields?.selected == true)
                                          const Icon(Icons.check, size: 25, color: colors_name.colorPrimary)
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
                        selectNow();
                      },
                    ),
                  ],
                )
              : Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: custom_text(text: strings_name.str_no_students_found, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
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

  selectNow() async {
    List<String> selectedStudentsData = [];
    List<String> selectedStudentsWarningData = [];
    for (var i = 0; i < (viewStudent?.length ?? 0); i++) {
      if (viewStudent![i].fields?.selected == true) {
        selectedStudentsData.add(viewStudent![i].id!);
        selectedStudentsWarningData.add("Subject: Urgent Action Required Regarding Internship Participation\n\n\n"
            "Dear ${viewStudent![i].fields!.name!.toUpperCase()},\n\n" +
            "This letter serves as a formal warning regarding your non-participation in internship opportunities as mandated by your B.Voc program. It has come to our attention that despite repeated announcements and reminders, you haven't applied to any of the internship opportunities on the Drona Foundations app. This lack of engagement in your career development is concerning and raises questions about your commitment to your Academic Journey and future employability.\n\n" +
            "Failure to secure an internship will have significant academic and professional consequences, including:\n" +
            "•	Loss of Internship Eligibility: You will be ineligible to apply for any internships facilitated by the placement team for the remainder of your academic year.\n" +
            "•	Examination Eligibility: Your eligibility for the Vocational Practice Examination will be reviewed, and can lead to non-eligibility.\n\n" +
            "To avoid these consequences, you are required to take immediate action and schedule a mandatory meeting with the placement team within the next 3 working days. During this meeting, you will need to:\n" +
            "•	Discuss your reasons for not pursuing internships.\n" +
            "•	Develop a concrete action plan outlining steps you will take to secure an internship in next 7 days.\n" +
            "•	Access available resources and support from the placement team, including one-on-one consultations and career workshops.\n" +
            "•	Explore the internship postings on the Drona Foundations app and identify opportunities that align with your interests and skills. Don't hesitate to reach out for assistance if you need help narrowing down your options.\n" +
            "•	Attend upcoming placement workshops and events. These sessions provide valuable insights into the internship landscape and equip you with essential skills for interviews and applications.\n\n" +
            "Remember, internships are an essential part of your B.Voc program and crucial for building practical skills and experience needed for successful employment. Your future success relies on taking this matter seriously and actively engaging in internship opportunities, to avoid facing the outlined consequences do the needful.\n\n\n" +
            "Sincerely,\n" +
            "The Drona Foundation Placement Team\n");
      }
    }
    if (selectedStudentsData.isNotEmpty) {
      debugPrint(selectedStudentsData.length.toString());
      selectTypeDialog(selectedStudentsData, selectedStudentsWarningData);
    } else {
      Utils.showSnackBar(context, strings_name.str_no_students_selected);
    }
  }

  selectTypeDialog(List<String> selectedStudentsData, List<String> selectedStudentsWarningData) {
    Dialog confirmationDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          custom_text(
            text: strings_name.str_warning_letter_type,
            textStyles: primaryTextSemiBold16,
            maxLines: 2,
            leftValue: 15.w,
            bottomValue: 0,
          ),
          custom_text(
              text: "Selected students : ${selectedStudentsData.length}",
              textStyles: blackTextSemiBold16,
              maxLines: 2,
              bottomValue: 5.h,
              leftValue: 15.w),
          GestureDetector(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              elevation: 5,
              child: Container(
                color: colors_name.colorOffWhite,
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(strings_name.str_warning_letter_for_apply, textAlign: TextAlign.center, style: blackTextSemiBold16),
                    Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                  ],
                ),
              ),
            ),
            onTap: () {
              Get.back(closeOverlays: true);
              issueLetter(selectedStudentsData, selectedStudentsWarningData, 1);
            },
          ),
          GestureDetector(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              elevation: 5,
              child: Container(
                color: colors_name.colorOffWhite,
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(strings_name.str_warning_letter_for_appear, textAlign: TextAlign.center, style: blackTextSemiBold16),
                    Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                  ],
                ),
              ),
            ),
            onTap: () {
              Get.back(closeOverlays: true);
              issueLetter(selectedStudentsData, selectedStudentsWarningData, 2);
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => confirmationDialog);
  }

  Future<void> issueLetter(List<String> selectedStudentsData, List<String> selectedStudentsWarningData, int letterType) async {
    for (int i = 0; i < selectedStudentsData.length; i++) {
      if (selectedStudentsData[i].isNotEmpty == true) {
        if (!isVisible) {
          setState(() {
            isVisible = true;
          });
        }
        try {
          String warningMsg = selectedStudentsWarningData[i];
          Map<String, dynamic> requestParams = Map();
          if (type == 1) {
            if (letterType == 1) {
              requestParams[TableNames.CLM_WARNING_LETTER_1_FOR_APPLY] = warningMsg;
            } else if (letterType == 2) {
              requestParams[TableNames.CLM_WARNING_LETTER_1_FOR_APPEAR] = warningMsg;
            }
          } else if (type == 2) {
            if (letterType == 1) {
              requestParams[TableNames.CLM_WARNING_LETTER_2_FOR_APPLY] = warningMsg;
            } else if (letterType == 2) {
              requestParams[TableNames.CLM_WARNING_LETTER_2_FOR_APPEAR] = warningMsg;
            }
          } else if (type == 3) {
            if (letterType == 1) {
              requestParams[TableNames.CLM_WARNING_LETTER_3_FOR_APPLY] = warningMsg;
            } else if (letterType == 2) {
              requestParams[TableNames.CLM_WARNING_LETTER_3_FOR_APPEAR] = warningMsg;
            }
            requestParams[TableNames.CLM_BANNED_FROM_PLACEMENT] = 1;
          }

          var dataUpdate = await apiRepository.updateStudentDataApi(requestParams, selectedStudentsData[i] ?? "");
          if (dataUpdate.fields != null) {
            setState(() {
              if (i + 1 == selectedStudentsData.length) {
                isVisible = false;
              }
            });

            if (i + 1 == selectedStudentsData.length) {
              Utils.showSnackBar(context, strings_name.str_warning_letter_sent);
              await Future.delayed(const Duration(milliseconds: 2000));
              Get.back(result: true);
            }
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
  }
}
