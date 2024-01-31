import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/placement/issue_warning_letter_student_list.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class IssueWarningLetter extends StatefulWidget {
  const IssueWarningLetter({Key? key}) : super(key: key);

  @override
  State<IssueWarningLetter> createState() => _IssueWarningLetterState();
}

class _IssueWarningLetterState extends State<IssueWarningLetter> {
  bool isVisible = false;
  var type = 1;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  List<int> semesterResponseArray = <int>[-1, 1, 2, 3, 4, 5, 6];
  int semesterValue = -1;

  List<String> divisionResponseArray = <String>[TableNames.DIVISION_A, TableNames.DIVISION_B, TableNames.DIVISION_C, TableNames.DIVISION_D];
  String divisionValue = "";

  DateTime? startDate = DateTime.now().add(const Duration(days: -1));
  DateTime? endDate = DateTime.now();

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? viewStudent = [];
  List<BaseApiResponseWithSerializable<JobOpportunityResponse>> jobsData = [];

  int continuousCount = 2;
  String title = strings_name.str_issue_warning_letter_1;
  bool isFromEligible = false;

  var todays = false;

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
    }

    if (mounted) {
      getHubs();

      if (continuousCount > 0) {
        int day = continuousCount - 1;
        startDate = DateTime.now().add(Duration(days: -day));
      }

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
    }
  }

  getSpecializations() {
    speResponseArray = [];
    speResponseArray?.addAll(PreferenceUtils.getSpecializationList().records!);
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: AppWidgets.appBarWithoutBack(title),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Visibility(
                        visible: !todays,
                        child: custom_text(
                          text: strings_name.str_select_date_range,
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                          topValue: 0,
                        ),
                      ),
                      Visibility(
                          visible: !todays,
                          child: startDate != null && endDate != null
                              ? GestureDetector(
                                  child: custom_text(
                                    text: "${startDate.toString().split(" ").first} - ${endDate.toString().split(" ").first}",
                                    alignment: Alignment.topLeft,
                                    textStyles: primaryTextSemiBold16,
                                    topValue: 0,
                                  ),
                                  onTap: () {
                                    _show();
                                  },
                                )
                              : Container()),
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_select_hub_r,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        bottomValue: 0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                          value: hubResponse,
                          elevation: 16,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                            hubValue = newValue!.fields!.id!.toString();
                            hubResponse = newValue;

                            getSpecializations();
                            if (hubValue.trim().isNotEmpty) {
                              for (int i = 0; i < speResponseArray!.length; i++) {
                                if (speResponseArray![i].fields?.hubIdFromHubIds?.contains(hubResponse?.fields?.hubId) != true) {
                                  speResponseArray!.removeAt(i);
                                  i--;
                                }
                              }
                            }
                            speValue = "";
                            speResponse = null;
                            if (speResponseArray?.isEmpty == true) {
                              Utils.showSnackBar(context, strings_name.str_no_specialization_linked);
                            }
                            setState(() {});
                          },
                          items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>(
                              (BaseApiResponseWithSerializable<HubResponse> value) {
                            return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                              value: value,
                              child: Text(value.fields!.hubName!.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_select_specialization,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<BaseApiResponseWithSerializable<SpecializationResponse>>(
                          value: speResponse,
                          elevation: 16,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                            setState(() {
                              speValue = newValue!.fields!.id.toString();
                              speResponse = newValue;
                              // getSubjects();
                            });
                          },
                          items: speResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>(
                              (BaseApiResponseWithSerializable<SpecializationResponse> value) {
                            return DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>(
                              value: value,
                              child: Text(value.fields!.specializationName.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_semester,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<int>(
                          value: semesterValue,
                          elevation: 16,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (int? newValue) {
                            setState(() {
                              semesterValue = newValue!;
                            });
                          },
                          items: semesterResponseArray.map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value == -1 ? "Select semester" : "Semester $value"),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_division,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                              width: viewWidth,
                              child: DropdownButtonFormField<String>(
                                elevation: 16,
                                style: blackText16,
                                focusColor: Colors.white,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    divisionValue = newValue!;
                                  });
                                },
                                items: divisionResponseArray.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CustomButton(
                        click: () async {
                          if (hubValue.isEmpty) {
                            Utils.showSnackBar(context, strings_name.str_empty_hub);
                          } else if (startDate == null || endDate == null) {
                            Utils.showSnackBar(context, strings_name.str_empty_date_range);
                          } else {
                            viewStudent = [];
                            fetchStudents();
                            // fetchRecords();
                          }
                        },
                        text: strings_name.str_submit,
                      ),
                      SizedBox(height: 5.h),
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
            )));
  }

  void _show() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime(2050, 12, 31),
      currentDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: startDate!, end: endDate!),
      saveText: 'Done',
    );

    if (result != null) {
      debugPrint(result.start.toString());
      setState(() {
        startDate = result.start;
        endDate = result.end;
      });
    }
  }

  Future<void> getHubs() async {
    try {
      if (mounted) {
        isVisible = true;
        setState(() {});
      }
      BaseLoginResponse<HubResponse> hubResponse = await apiRepository.getHubApi();
      if (hubResponse.records!.isNotEmpty) {
        PreferenceUtils.setHubList(hubResponse);
        debugPrint("Hubs ${PreferenceUtils.getHubList().records!.length}");
      }
      if (mounted) {
        isVisible = false;
        setState(() {});
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  fetchStudents() {
    viewStudent?.clear();
    if (hubResponse != null) {
      if (hubResponse!.fields?.studentMobileNumber?.isNotEmpty == true) {
        for (int i = 0; i < hubResponse!.fields!.studentMobileNumber!.length; i++) {
          if (hubResponse!.fields?.isPlacedNow![i] != "1") {
            bool canAddBasedOnSpecialization = true, canAddBasedOnSemester = true, canAddBasedOnDivision = true, canAddBasedOnType = true;
            if (speValue.isNotEmpty) {
              canAddBasedOnSpecialization = hubResponse?.fields?.studentSpecializationIds?[i] == speResponse?.fields?.specializationId;
            }
            if (semesterValue != -1) {
              canAddBasedOnSemester = hubResponse?.fields?.studentSemester?[i] == semesterValue.toString();
            }
            if (divisionValue.isNotEmpty) {
              canAddBasedOnDivision = hubResponse?.fields?.studentDivision?[i] == divisionValue;
            }

            if (type == 1) {
              canAddBasedOnType = hubResponse?.fields?.warningLetter1Issued?[i] == "No";
            } else if (type == 2) {
              canAddBasedOnType = hubResponse?.fields?.warningLetter1Issued?[i] == "Yes" && hubResponse?.fields?.warningLetter2Issued?[i] == "No";
            } else if (type == 3) {
              canAddBasedOnType = hubResponse?.fields?.warningLetter1Issued?[i] == "Yes" &&
                  hubResponse?.fields?.warningLetter2Issued?[i] == "Yes" &&
                  hubResponse?.fields?.warningLetter3Issued?[i] == "No";
            }

            if (canAddBasedOnSpecialization && canAddBasedOnSemester && canAddBasedOnDivision && canAddBasedOnType) {
              BaseApiResponseWithSerializable<LoginFieldsResponse> studentData = BaseApiResponseWithSerializable();
              studentData.fields = LoginFieldsResponse();
              studentData.fields?.name = hubResponse?.fields?.studentName?[i].trim() ?? "";
              studentData.fields?.email = hubResponse?.fields?.studentEmail?[i].trim() ?? "";
              studentData.fields?.mobileNumber = hubResponse?.fields?.studentMobileNumber?[i].trim() ?? "";
              studentData.fields?.hubIds = hubResponse?.id?.split(",");
              studentData.fields?.specializationIds = Utils.getSpecializationId(hubResponse?.fields?.studentSpecializationIds?[i])?.split(",");
              studentData.fields?.semester = hubResponse?.fields?.studentSemester?[i];
              studentData.fields?.division = hubResponse?.fields?.studentDivision?[i];
              studentData.fields?.gender = hubResponse?.fields?.studentGender?[i];
              studentData.fields?.admission_batch_start = hubResponse?.fields?.admissionBatchStart?[i].split(",");
              studentData.fields?.admission_batch_end = hubResponse?.fields?.admissionBatchEnd?[i].split(",");

              studentData.id = hubResponse?.fields?.tblStudent?[i];
              viewStudent?.add(studentData);
            }
          }
        }
      }
    }

    if (viewStudent?.isEmpty == true) {
      Utils.showSnackBarUsingGet(strings_name.str_no_students);
    } else {
      debugPrint(viewStudent?.length.toString());
      viewStudent?.sort((a, b) => a.fields!.name!.trim().compareTo(b.fields!.name!.trim()));
      fetchJobsData();
    }
  }

  void fetchJobsData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "SEARCH('${hubResponse?.fields?.hubId}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0),";
    query += "FIND('${strings_name.str_job_status_process_complete}',${TableNames.CLM_STATUS}, 0),";

    if (startDate.toString().isNotEmpty && endDate.toString().isNotEmpty) {
      var start = startDate?.add(const Duration(days: -1));
      var startFormat = DateFormat("MM/dd/yyyy").format(start!);

      var end = endDate?.add(const Duration(days: 1));
      var endFormat = DateFormat("MM/dd/yyyy").format(end!);
      query += "IS_BEFORE(Created, '$endFormat'), IS_AFTER(Created, '$startFormat')";
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getJobOppoApi(query, offset);
      if (data.records?.isNotEmpty == true) {
        if (offset.isEmpty) {
          jobsData.clear();
        }
        jobsData.addAll(data.records as Iterable<BaseApiResponseWithSerializable<JobOpportunityResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchJobsData();
        } else {
          jobsData.sort((a, b) => a.fields!.jobTitle!.compareTo(b.fields!.jobTitle!));
          debugPrint("Total jobs : ${jobsData.length.toString()}");

          filterStudentData();
        }
      } else {
        setState(() {
          isVisible = false;
        });

        filterStudentData();
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  filterStudentData() {
    if (jobsData.isNotEmpty && viewStudent != null && viewStudent?.isNotEmpty == true) {
      for (int i = 0; i < jobsData.length; i++) {
        bool isEmptyShortListStudents = true;
        if (jobsData[i].fields?.shortlistedStudents != null && jobsData[i].fields?.shortlistedStudents?.isNotEmpty == true) {
          isEmptyShortListStudents = false;
        }
        if (jobsData[i].fields?.appliedStudents?.isNotEmpty == true &&
            isEmptyShortListStudents &&
            jobsData[i].fields?.placedStudents?.isNotEmpty == true) {
          jobsData.removeAt(i);
          i--;
        }
      }
      debugPrint("After removing self place jobs : ${jobsData.length.toString()}");

      if (jobsData.isEmpty) {
        Utils.showSnackBar(context, strings_name.str_no_jobs_published);
      } else {
        for (int j = 0; j < viewStudent!.length; j++) {
          int isMissedToApply = 0;
          int isMissedToAppearForJobInterview = 0;
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
              canAddBasedOnSpecialization =
                  (jobsData[i].fields?.specializationIds!.contains(viewStudent![j].fields?.specializationIds?.first) == true);
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
            }
          }
          if (isMissedToApply == 0 && isMissedToAppearForJobInterview == 0) {
            viewStudent?.removeAt(j);
            j--;
          }
        }

        if (viewStudent?.isEmpty == true) {
          Utils.showSnackBar(context, strings_name.str_no_students_found);
        } else {
          Get.to(() => const IssueWarningLetterStudentList(), arguments: [
            {"title": title},
            {"letterType": type},
            {"jobList": jobsData},
            {"studentList": viewStudent},
          ])?.then((result) {
            if (result != null && result) {
              Get.back(closeOverlays: true);
            }
          });
        }
      }
    } else {
      if (jobsData.isEmpty) {
        Utils.showSnackBar(context, strings_name.str_no_jobs_published);
      } else if (viewStudent == null || viewStudent?.isEmpty == true) {
        Utils.showSnackBar(context, strings_name.str_no_students_found);
      }
    }
    setState(() {
      isVisible = false;
    });
  }
}
