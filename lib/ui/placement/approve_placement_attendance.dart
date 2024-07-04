import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/ui/placement/approve_placement_attendance_detail.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class ApprovePlacementAttendance extends StatefulWidget {
  const ApprovePlacementAttendance({super.key});

  @override
  State<ApprovePlacementAttendance> createState() => _ApprovePlacementAttendanceState();
}

class _ApprovePlacementAttendanceState extends State<ApprovePlacementAttendance> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? studentData = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? mainStudentData = [];

  TextEditingController rejectionReasonController = TextEditingController();

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  var controllerSearch = TextEditingController();

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? mentorMainArray = [];
  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? mentorArray = [];
  BaseApiResponseWithSerializable<ViewEmployeeResponse>? mentorResponse;
  String mentorValue = "";

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

      fetchFaculty();
    }

    if (PreferenceUtils.getIsLogin() == 2) {
      getRecords();
    }
  }

  getRecords() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }

    var query = "AND(";
    query += "OR(FIND('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",FIND('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
        }
      }
    }
    query +=
        "),OR(FIND('${strings_name.str_pending}',ARRAYJOIN({${TableNames.CLM_PLACEMENT_ATTENDANCE_STATUS}})), FIND('${strings_name.str_pending}',ARRAYJOIN({${TableNames.CLM_PLACEMENT_COMPANY_LOC_STATUS}})), FIND('${strings_name.str_pending}',ARRAYJOIN({${TableNames.CLM_PLACEMENT_WORKBOOK_STATUS}}))))";
    debugPrint(query);

    try {
      var data = await apiRepository.loginApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mainStudentData?.clear();
        }
        mainStudentData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          mainStudentData?.sort((a, b) {
            var adate = a.fields!.name;
            var bdate = b.fields!.name;
            return adate!.compareTo(bdate!);
          });

          studentData = [];
          studentData = List.from(mainStudentData!);

          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            studentData = [];
            mainStudentData = [];
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
  }

  fetchFaculty() async {
    var query = "AND({is_working} = 1, {assigned_students}!='')";
    setState(() {
      isVisible = true;
    });
    try {
      var data = await apiRepository.getEmployeeListApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mentorArray?.clear();
          mentorMainArray?.clear();
        }
        mentorMainArray?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<ViewEmployeeResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchFaculty();
        } else {
          mentorMainArray?.sort((a, b) => a.fields!.employeeName!.toLowerCase().compareTo(b.fields!.employeeName!.toLowerCase()));
          updateMentor();
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    } catch (e) {
      final errorMessage = e.toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  updateMentor() {
    mentorValue = "";
    mentorResponse = null;
    mentorArray?.clear();

    for (int i = 0; i < (mentorMainArray?.length ?? 0); i++) {
      bool contains = false;
      if (hubValue.isEmpty) {
        for (int j = 0; j < (hubResponseArray?.length ?? 0); j++) {
          if (mentorMainArray![i].fields!.hubIdFromHubIds?.contains(hubResponseArray![j].fields?.hubId) == true) {
            contains = true;
            break;
          } else if (mentorMainArray![i].fields!.accessible_hub_codes?.contains(hubResponseArray![j].fields?.hubId) == true) {
            contains = true;
            break;
          }
        }
      } else {
        if (mentorMainArray![i].fields!.hubIdFromHubIds?.contains(hubResponse?.fields?.hubId) == true) {
          contains = true;
        } else if (mentorMainArray![i].fields!.accessible_hub_codes?.contains(hubResponse?.fields?.hubId) == true) {
          contains = true;
        }
      }
      if (contains) {
        mentorArray?.add(mentorMainArray![i]);
      }
    }

    mentorArray?.sort((a, b) => a.fields!.employeeName!.toLowerCase().compareTo(b.fields!.employeeName!.toLowerCase()));
  }

  filterStudents() {
    studentData = [];

    for (var i = 0; i < mainStudentData!.length; i++) {
      bool canAddBasedOnHub = true, canAddBasedOnMentor = true, canAddBasedOnSearch = true;
      if (hubValue.isNotEmpty) {
        if (mainStudentData![i].fields!.hubIdFromHubIds!.last != hubResponse?.fields?.hubId) {
          canAddBasedOnHub = false;
        }
      }
      if (mentorValue.isNotEmpty) {
        if (mainStudentData![i].fields!.assigned_to!.last != mentorResponse?.id || mainStudentData![i].fields!.assigned_to_employee_name!.last != mentorResponse?.fields?.employeeName) {
          canAddBasedOnMentor = false;
        }
      }
      if (controllerSearch.text.trim().isNotEmpty) {
        if (!mainStudentData![i].fields!.name!.toLowerCase().contains(controllerSearch.text.trim().toLowerCase())) {
          canAddBasedOnSearch = false;
        }
      }

      if (canAddBasedOnHub && canAddBasedOnMentor && canAddBasedOnSearch) {
        studentData?.add(mainStudentData![i]);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_approve_placement_attendance),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),
              Visibility(
                visible: mainStudentData != null && mainStudentData!.isNotEmpty,
                child: Column(children: [
                  const custom_text(
                    text: strings_name.str_select_hub,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    bottomValue: 0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    width: viewWidth,
                    child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                      value: hubResponse,
                      isExpanded: true,
                      elevation: 16,
                      style: blackText16,
                      focusColor: Colors.white,
                      onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                        setState(() {
                          hubValue = newValue!.fields!.id!.toString();
                          hubResponse = newValue;

                          updateMentor();
                          filterStudents();
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
                  SizedBox(height: 5.h),
                  const custom_text(
                    text: strings_name.str_select_mentor,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    bottomValue: 0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    width: viewWidth,
                    child: DropdownButtonFormField<BaseApiResponseWithSerializable<ViewEmployeeResponse>>(
                      value: mentorResponse,
                      isExpanded: true,
                      elevation: 16,
                      style: blackText16,
                      focusColor: Colors.white,
                      onChanged: (BaseApiResponseWithSerializable<ViewEmployeeResponse>? newValue) {
                        setState(() {
                          mentorValue = newValue!.id!.toString();
                          mentorResponse = newValue;

                          filterStudents();
                        });
                      },
                      items: mentorArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<ViewEmployeeResponse>>>((BaseApiResponseWithSerializable<ViewEmployeeResponse> value) {
                        return DropdownMenuItem<BaseApiResponseWithSerializable<ViewEmployeeResponse>>(
                          value: value,
                          child: Text(value.fields!.employeeName!.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                  CustomEditTextSearch(
                    type: TextInputType.text,
                    hintText: "Search by student name...",
                    textInputAction: TextInputAction.done,
                    controller: controllerSearch,
                    onChanges: (value) {
                      filterStudents();
/*
                      if (value.isEmpty) {
                        studentData = [];
                        studentData = mainStudentData;
                        setState(() {});
                      } else {
                        studentData = [];
                        for (var i = 0; i < mainStudentData!.length; i++) {
                          if (mainStudentData![i].fields!.name!.toLowerCase().contains(value.toLowerCase())) {
                            studentData?.add(mainStudentData![i]);
                          }
                        }
                        setState(() {});
                      }
*/
                    },
                  ),
                  custom_text(
                    text: "Total students: ${studentData?.length ?? 0}",
                    textStyles: blackTextSemiBold16,
                    leftValue: 12.w,
                    bottomValue: 0,
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: studentData != null && studentData!.isNotEmpty
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: studentData?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: custom_text(
                                      text: "${studentData?[index].fields!.name}",
                                      textStyles: linkTextSemiBold14,
                                      topValue: 0,
                                      maxLines: 2,
                                      bottomValue: 5,
                                      leftValue: 5,
                                    ),
                                    onTap: () {
                                      Get.to(const StudentHistory(), arguments: studentData?[index].fields?.mobileNumber);
                                    },
                                  ),
                                  custom_text(
                                      topValue: 0,
                                      bottomValue: 5,
                                      maxLines: 2,
                                      leftValue: 5,
                                      text: "Specialization: ${Utils.getSpecializationName(studentData?[index].fields?.specializationIds![0])}",
                                      textStyles: blackTextSemiBold14),
                                  custom_text(topValue: 0, bottomValue: 5, leftValue: 5, text: "Semester: ${studentData?[index].fields?.semester}", textStyles: blackTextSemiBold14),
                                  custom_text(
                                      topValue: 0,
                                      text: "Company name: ${studentData?[index].fields!.company_name_from_placed_job?.last}",
                                      textStyles: blackTextSemiBold14,
                                      maxLines: 2,
                                      bottomValue: 5,
                                      leftValue: 5),
                                  custom_text(
                                    text: "Job title: ${studentData?[index].fields!.job_title_from_placed_job?.last}",
                                    textStyles: blackTextSemiBold14,
                                    topValue: 0,
                                    maxLines: 2,
                                    bottomValue: 5,
                                    leftValue: 5,
                                  ),
                                  custom_text(
                                    text: "Total Documents Uploaded: ${studentData?[index].fields!.placement_attendance_form?.length ?? 0}",
                                    textStyles: blackTextSemiBold14,
                                    topValue: 0,
                                    maxLines: 2,
                                    bottomValue: 5,
                                    leftValue: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => const ApprovePlacementAttendanceDetail(), arguments: studentData![index]);
                                    },
                                    child: const custom_text(
                                      text: strings_name.str_view_details,
                                      textStyles: primaryTextSemiBold14,
                                      alignment: Alignment.centerRight,
                                      topValue: 10,
                                      bottomValue: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                    : Container(
                        margin: const EdgeInsets.only(top: 10), child: const custom_text(text: strings_name.str_no_doc_approval_pending, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
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
}
