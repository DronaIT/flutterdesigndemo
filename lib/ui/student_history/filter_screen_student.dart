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
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import 'filter_data_screen_student.dart';

class FilterScreenStudent extends StatefulWidget {
  const FilterScreenStudent({Key? key}) : super(key: key);

  @override
  State<FilterScreenStudent> createState() => _FilterScreenStudentState();
}

class _FilterScreenStudentState extends State<FilterScreenStudent> {
  bool isVisible = false;
  var type = 0;

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

  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectResponseArray = [];
  BaseApiResponseWithSerializable<SubjectResponse>? subjectResponse;
  String subjectValue = "";
  String subjectRecordId = "";

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? viewStudent = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? studentList = [];
  String title = strings_name.str_filter;

  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? mentorMainArray = [];
  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? mentorArray = [];
  BaseApiResponseWithSerializable<ViewEmployeeResponse>? mentorResponse;
  String mentorValue = "";

  bool canViewMentors = false;

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

    getPermission();
  }

  Future<void> getPermission() async {
    setState(() {
      isVisible = true;
    });
    var loginData = PreferenceUtils.getLoginDataEmployee();
    var query = "AND(FIND('${loginData.roleIdFromRoleIds!.join(',')}',role_ids)>0,module_ids='${TableNames.MODULE_STUDENT_DIRECTORY}')";
    debugPrint(query);
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_MENTORS) {
            canViewMentors = true;
          }
        }
        if (canViewMentors) {
          fetchFaculty();
        } else {
          setState(() {
            isVisible = false;
          });
        }
      } else {
        Utils.showSnackBar(context, strings_name.str_something_wrong);
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

  getSpecializations() {
    speResponseArray = [];
    speResponseArray?.addAll(PreferenceUtils.getSpecializationList().records!);

    for (int i = 0; i < (speResponseArray?.length ?? 0); i++) {
      bool contains = false;
      for (int j = 0; j < (hubResponseArray?.length ?? 0); j++) {
        if (speResponseArray![i].fields!.hubIdFromHubIds?.contains(hubResponseArray![j].fields?.hubId) == true) {
          contains = true;
          break;
        }
      }
      if (!contains) {
        speResponseArray?.removeAt(i);
        i--;
      }
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

          setState(() {
            isVisible = false;
          });
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
    setState(() {
      isVisible = false;
    });
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
                      custom_text(
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

                              if (canViewMentors) {
                                updateMentor();
                              }
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
                                Utils.showSnackBar(context, strings_name.str_no_specialization_assigned);
                              }

                              subjectValue = "";
                              subjectResponse = null;
                              subjectResponseArray = [];

                              setState(() {});
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
                      canViewMentors
                          ? Column(
                              children: [
                                SizedBox(height: 5.h),
                                custom_text(
                                  text: strings_name.str_select_mentor,
                                  alignment: Alignment.topLeft,
                                  textStyles: blackTextSemiBold16,
                                  bottomValue: 0,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
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

                                        setState(() {});
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
                              ],
                            )
                          : Container(),
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
                          isExpanded: true,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                            setState(() {
                              speValue = newValue!.fields!.id.toString();
                              speResponse = newValue;
                              getSubjects();
                            });
                          },
                          items: speResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>((BaseApiResponseWithSerializable<SpecializationResponse> value) {
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
                              getSubjects();
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
                                    getSubjects();
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
                      subjectResponseArray!.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(height: 5.h),
                                custom_text(
                                  text: strings_name.str_view_subject,
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
                                        child: DropdownButtonFormField<BaseApiResponseWithSerializable<SubjectResponse>>(
                                          value: subjectResponse,
                                          elevation: 16,
                                          isExpanded: true,
                                          style: blackText16,
                                          focusColor: Colors.white,
                                          onChanged: (BaseApiResponseWithSerializable<SubjectResponse>? newValue) {
                                            setState(() {
                                              subjectValue = newValue!.fields!.ids!.toString();
                                              subjectResponse = newValue;
                                              subjectRecordId = newValue.id!;
                                              // getUnits();
                                            });
                                          },
                                          items:
                                              subjectResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SubjectResponse>>>((BaseApiResponseWithSerializable<SubjectResponse> value) {
                                            return DropdownMenuItem<BaseApiResponseWithSerializable<SubjectResponse>>(
                                              value: value,
                                              child: Text(value.fields!.subjectTitle!.toString(), overflow: TextOverflow.visible),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(height: 10.h),
                      CustomButton(
                        click: () async {
                          if (hubValue.isEmpty && mentorValue.isEmpty) {
                            if (canViewMentors) {
                              Utils.showSnackBar(context, strings_name.str_empty_mentor_hub);
                            } else {
                              Utils.showSnackBar(context, strings_name.str_empty_hub);
                            }
                          } else {
                            viewStudent = [];
                            studentList = [];

                            fetchRecords();
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

  Future<void> getSubjects() async {
    if (semesterValue != -1 && divisionValue.isNotEmpty && speValue.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      subjectValue = "";

      var query = "AND(FIND('$semesterValue', ${TableNames.CLM_SEMESTER}, 0),FIND('${Utils.getSpecializationIds(speValue)}',${TableNames.CLM_SPE_IDS}, 0))";
      try {
        var data = await apiRepository.getSubjectsApi(query);
        setState(() {
          subjectResponse = null;
          subjectResponseArray = data.records;

          isVisible = false;
        });
        if (data.records?.isEmpty == true) {
          Utils.showSnackBar(context, strings_name.str_no_subject_assigned);
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

  Future<void> fetchRecords() async {
    var query = "AND(";
    if (mentorValue.isNotEmpty) {
      query += "last_mentor='${mentorResponse?.fields?.mobileNumber}'";
    }

    if (hubValue.isNotEmpty) {
      if (mentorValue.isNotEmpty) {
        query += ",";
      }
      query += "SEARCH('${hubResponse?.fields?.hubId}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
    }

    if (speValue.isNotEmpty) {
      query += ",${TableNames.CLM_SPE_IDS}='$speValue'";
    }
    if (semesterValue != -1) {
      query += ",${TableNames.CLM_SEMESTER}='${semesterValue.toString()}'";
    } else {
      query += ",${TableNames.CLM_SEMESTER}!='7'";
    }
    if (divisionValue.isNotEmpty) {
      query += ",${TableNames.CLM_DIVISION}='${divisionValue.toString()}'";
    }

    query += ")";
    debugPrint(query);

    setState(() {
      isVisible = true;
    });
    try {
      var data = await apiRepository.loginApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          viewStudent?.clear();
        }
        viewStudent?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchRecords();
        } else {
          viewStudent?.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
          filterData();

          setState(() {
            isVisible = false;
          });
        }
      } else {
        if (offset.isEmpty) {
          viewStudent = [];
        }
        offset = "";
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBarUsingGet(strings_name.str_no_students);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  void filterData() {
    if (viewStudent != null && viewStudent?.isNotEmpty == true) {
      studentList?.addAll(viewStudent!);

      if (studentList?.isNotEmpty == true) {
        studentList?.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
        Get.to(const FilterDataStudent(), arguments: [
          {"studentList": studentList},
          {"subject": subjectResponse?.fields?.subjectTitle},
          {"specialization": speResponse?.fields?.specializationName},
          {"hub": hubResponse?.fields?.hubName},
          {"subjectid": subjectResponse?.id},
          {"mentor": canViewMentors ? mentorResponse?.fields?.employeeName : " "},
        ])?.then((result) {
          if (result != null && result) {
            // Get.back(closeOverlays: true);
          }
        });
      } else {
        Utils.showSnackBarUsingGet(strings_name.str_no_students);
      }
    }
  }
}
