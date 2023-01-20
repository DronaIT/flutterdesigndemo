import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/request/add_student_attendance_request.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/models/units_response.dart';
import 'package:flutterdesigndemo/ui/attendance_student_list.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class TakeAttendance extends StatefulWidget {
  const TakeAttendance({Key? key}) : super(key: key);

  @override
  State<TakeAttendance> createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  bool isVisible = false;

  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  String hubRecordId = "";

  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationResponseArray = [];
  BaseApiResponseWithSerializable<SpecializationResponse>? specializationResponse;
  String specializationValue = "";
  String specializationRecordId = "";

  List<int> semesterResponseArray = <int>[1, 2, 3, 4, 5, 6];
  int semesterValue = -1;

  List<String> divisionResponseArray = <String>[TableNames.DIVISION_A, TableNames.DIVISION_B, TableNames.DIVISION_C, TableNames.DIVISION_D];
  String divisionValue = "";

  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectResponseArray = [];
  BaseApiResponseWithSerializable<SubjectResponse>? subjectResponse;
  String subjectValue = "";
  String subjectRecordId = "";

  List<BaseApiResponseWithSerializable<UnitsResponse>>? unitResponseArray = [];
  BaseApiResponseWithSerializable<UnitsResponse>? unitResponse;
  String unitValue = "";
  String unitRecordId = "";

  List<BaseApiResponseWithSerializable<TopicsResponse>>? topicResponseArray = [];
  BaseApiResponseWithSerializable<TopicsResponse>? topicResponse;
  String topicValue = "";
  String topicRecordId = "";

  final apiRepository = getIt.get<ApiRepository>();

  @override
  void initState() {
    super.initState();
    hubResponseArray = PreferenceUtils.getHubList().records;
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_take_attendence),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: 10.h),
                    custom_text(
                      text: strings_name.str_select_hub,
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
                            child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                              value: hubResponse,
                              elevation: 16,
                              style: blackText16,
                              focusColor: Colors.white,
                              onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                                setState(() {
                                  hubValue = newValue!.fields!.id!.toString();
                                  hubResponse = newValue;
                                  hubRecordId = newValue.id!;
                                  getSpecializations();
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
                        ),
                      ],
                    ),
                    specializationResponseArray!.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(height: 10.h),
                              custom_text(
                                text: strings_name.str_select_spelization,
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
                                      child: DropdownButtonFormField<BaseApiResponseWithSerializable<SpecializationResponse>>(
                                        value: specializationResponse,
                                        elevation: 16,
                                        style: blackText16,
                                        focusColor: Colors.white,
                                        onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                                          setState(() {
                                            specializationValue = newValue!.fields!.id!.toString();
                                            specializationResponse = newValue;
                                            specializationRecordId = newValue.id!;
                                            getSubjects();
                                          });
                                        },
                                        items: specializationResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>((BaseApiResponseWithSerializable<SpecializationResponse> value) {
                                          return DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>(
                                            value: value,
                                            child: Text(value.fields!.specializationName!.toString()),
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
                    specializationValue.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(height: 10.h),
                              custom_text(
                                text: strings_name.str_semester,
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
                                      child: DropdownButtonFormField<int>(
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
                                            child: Text("Semester $value"),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
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
                            ],
                          )
                        : Container(),
                    subjectResponseArray!.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(height: 10.h),
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
                                            getUnits();
                                          });
                                        },
                                        items: subjectResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SubjectResponse>>>((BaseApiResponseWithSerializable<SubjectResponse> value) {
                                          return DropdownMenuItem<BaseApiResponseWithSerializable<SubjectResponse>>(
                                            value: value,
                                            child: Text(value.fields!.subjectTitle!.toString()),
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
                    unitResponseArray!.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(height: 10.h),
                              custom_text(
                                text: strings_name.str_view_unit,
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
                                      child: DropdownButtonFormField<BaseApiResponseWithSerializable<UnitsResponse>>(
                                        value: unitResponse,
                                        elevation: 16,
                                        isExpanded: true,
                                        style: blackText16,
                                        focusColor: Colors.white,
                                        onChanged: (BaseApiResponseWithSerializable<UnitsResponse>? newValue) {
                                          setState(() {
                                            unitValue = newValue!.fields!.ids!.toString();
                                            unitResponse = newValue;
                                            unitRecordId = newValue.id!;
                                            getTopics();
                                          });
                                        },
                                        items: unitResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<UnitsResponse>>>((BaseApiResponseWithSerializable<UnitsResponse> value) {
                                          return DropdownMenuItem<BaseApiResponseWithSerializable<UnitsResponse>>(
                                            value: value,
                                            child: Text(value.fields!.unitTitle!.toString()),
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
                    topicResponseArray!.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(height: 10.h),
                              custom_text(
                                text: strings_name.str_view_topic,
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
                                      child: DropdownButtonFormField<BaseApiResponseWithSerializable<TopicsResponse>>(
                                        value: topicResponse,
                                        elevation: 16,
                                        isExpanded: true,
                                        style: blackText16,
                                        focusColor: Colors.white,
                                        onChanged: (BaseApiResponseWithSerializable<TopicsResponse>? newValue) {
                                          setState(() {
                                            topicValue = newValue!.fields!.ids!.toString();
                                            topicResponse = newValue;
                                            topicRecordId = newValue.id!;
                                          });
                                        },
                                        items: topicResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<TopicsResponse>>>((BaseApiResponseWithSerializable<TopicsResponse> value) {
                                          return DropdownMenuItem<BaseApiResponseWithSerializable<TopicsResponse>>(
                                            value: value,
                                            child: Text(value.fields!.topicTitle!.toString()),
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
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: strings_name.str_get_students,
                      click: () {
                        if (hubValue.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_hub);
                        } else if (specializationValue.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_spe);
                        } else if (semesterValue == -1) {
                          Utils.showSnackBar(context, strings_name.str_empty_semester);
                        } else if (divisionValue.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_division);
                        } else if (subjectValue.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_subject);
                        } else if (unitValue.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_unit);
                        } else if (topicValue.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_topic);
                        } else {
                          getStudents();
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }

  Future<void> getSpecializations() async {
    if (hubValue.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      var query = "FIND('${Utils.getHubIds(hubValue)}',${TableNames.CLM_HUB_IDS}, 0)";
      var speData = await apiRepository.getSpecializationDetailApi(query);
      setState(() {
        specializationResponse = null;
        specializationResponseArray = speData.records;
        isVisible = false;
      });
      if (speData.records?.isEmpty == true) {
        Utils.showSnackBar(context, strings_name.str_no_specialization_assigned);
      }
    }
  }

  Future<void> getSubjects() async {
    if (semesterValue != -1 && divisionValue.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      var query = "FIND('${semesterValue}', ${TableNames.CLM_SEMESTER}, 0)";
      var data = await apiRepository.getSubjectsApi(query);
      setState(() {
        subjectResponse = null;
        subjectResponseArray = data.records;
        isVisible = false;
      });
      if (data.records?.isEmpty == true) {
        Utils.showSnackBar(context, strings_name.str_no_subject_assigned);
      }
    }
  }

  Future<void> getUnits() async {
    if (subjectValue.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      var query = "FIND('${subjectValue}', ${TableNames.CLM_SUBJECT_IDS}, 0)";
      var data = await apiRepository.getUnitsApi(query);
      setState(() {
        unitResponse = null;
        unitResponseArray = data.records;
        isVisible = false;
      });
      if (data.records?.isEmpty == true) {
        Utils.showSnackBar(context, strings_name.str_no_unit_assigned);
      }
    }
  }

  Future<void> getTopics() async {
    if (unitValue.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      var query = "FIND('${unitValue}', ${TableNames.CLM_UNIT_IDS}, 0)";
      var data = await apiRepository.getTopicsApi(query);
      setState(() {
        topicResponse = null;
        topicResponseArray = data.records;
        isVisible = false;
      });
      if (data.records?.isEmpty == true) {
        Utils.showSnackBar(context, strings_name.str_no_topic_assigned);
      }
    }
  }

  Future<void> getStudents() async {
    setState(() {
      isVisible = true;
    });
    var query = "AND(";
    query += "FIND('${Utils.getHubIds(hubValue)}',${TableNames.CLM_HUB_IDS}, 0)";
    query += ",FIND('${Utils.getSpecializationIds(specializationValue)}',${TableNames.CLM_SPE_IDS}, 0)";
    query += ",FIND('${semesterValue}', ${TableNames.CLM_SEMESTER}, 0)";
    query += ",FIND('${divisionValue}', ${TableNames.CLM_DIVISION}, 0)";
    query += ")";
    print(query);
    var data = await apiRepository.loginApi(query);
    if (data.records!.isNotEmpty) {
      setState(() {
        isVisible = false;
      });

      AddStudentAttendanceRequest request = AddStudentAttendanceRequest();
      request.employeeId = PreferenceUtils.getLoginRecordId().split(",");
      request.hubId = hubRecordId.split(",");
      request.specializationId = specializationRecordId.split(",");
      request.division = divisionValue;
      request.subjectId = subjectRecordId.split(",");
      request.unitId = unitRecordId.split(",");
      request.topicId = topicRecordId.split(",");
      Get.to(const AttendanceStudentList(), arguments: [
        {"studentList": data.records},
        {"request": request},
      ])?.then((result) {
        if (result != null && result) {
          Get.back(closeOverlays: true);
        }
      });
    } else {
      Utils.showSnackBar(context, strings_name.str_no_students);
    }
    setState(() {
      isVisible = false;
    });
  }
}
