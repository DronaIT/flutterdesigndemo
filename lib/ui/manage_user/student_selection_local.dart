import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/student_response.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../customwidget/custom_edittext_search.dart';

class StudentSelectionLocal extends StatefulWidget {
  const StudentSelectionLocal({Key? key}) : super(key: key);

  @override
  State<StudentSelectionLocal> createState() => _StudentSelectionLocalState();
}

class _StudentSelectionLocalState extends State<StudentSelectionLocal> {
  bool isVisible = false;
  List<StudentResponse>? studentData = [];
  List<StudentResponse>? mainStudentData = [];
  List<StudentResponse>? selectedData = [];

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  List<int> semesterResponseArray = <int>[-1, 1, 2, 3, 4, 5, 6];
  int semesterValue = -1;

  final apiRepository = getIt.get<ApiRepository>();
  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    getHubs();
  }

  getSpecializations() {
    speResponseArray = [];
    speResponseArray?.addAll(PreferenceUtils.getSpecializationList().records!);
  }

  Future<void> getHubs() async {
    try {
      setState(() {
        isVisible = true;
      });
      var hubResponse = await apiRepository.getHubApi();
      if (hubResponse.records!.isNotEmpty) {
        PreferenceUtils.setHubList(hubResponse);
        debugPrint("Hubs ${PreferenceUtils.getHubList().records!.length}");

        for (int i = 0; i < hubResponse.records!.length; i++) {
          if (hubResponse.records![i].fields?.hubId == TableNames.CANCELLED_HUB_ID) {
            hubResponse.records?.removeAt(i);
            i--;
          } else if (hubResponse.records![i].fields?.hubId == TableNames.SUSPENDED_HUB_ID) {
            hubResponse.records?.removeAt(i);
            i--;
          }
        }

        hubResponseArray = hubResponse.records;
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

        this.hubResponse = hubResponseArray![0];
        hubValue = hubResponseArray![0].id!;

        getSpecializations();
        if (hubValue.trim().isNotEmpty) {
          for (int i = 0; i < speResponseArray!.length; i++) {
            if (speResponseArray![i].fields?.hubIdFromHubIds?.contains(this.hubResponse?.fields?.hubId) != true) {
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

        getStudentRecords();
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = true;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  getStudentRecords() {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    mainStudentData = [];
    studentData = [];
    for (int i = 0; i < (hubResponse?.fields?.tblStudent?.length ?? 0); i++) {
      if (hubResponse?.fields!.studentSemester![i] != "7") {
        StudentResponse data = StudentResponse();
        data.studentId = hubResponse!.fields!.tblStudent![i];
        data.studentName = hubResponse!.fields!.studentName![i];
        data.studentMobileNumber = hubResponse!.fields!.studentMobileNumber![i];
        data.studentSemester = hubResponse!.fields!.studentSemester![i];
        data.studentSpecializationIds = hubResponse!.fields!.studentSpecializationIds![i];

        mainStudentData?.add(data);
      }
    }

    if (speValue.isNotEmpty && speResponse?.fields!.specializationId?.isNotEmpty == true) {
      for (int i = 0; i < (mainStudentData?.length ?? 0); i++) {
        if (speResponse?.fields!.specializationId != mainStudentData![i].studentSpecializationIds) {
          mainStudentData?.removeAt(i);
          i--;
        }
      }
    }

    if (semesterValue != -1) {
      for (int i = 0; i < (mainStudentData?.length ?? 0); i++) {
        if (semesterValue.toString() != mainStudentData![i].studentSemester) {
          mainStudentData?.removeAt(i);
          i--;
        }
      }
    }

    if (mainStudentData?.isNotEmpty == true) {
      mainStudentData?.sort((a, b) {
        var adate = a.studentName?.trim();
        var bdate = b.studentName?.trim();
        return adate!.compareTo(bdate!);
      });
    }

    studentData = List.from(mainStudentData!);
    isVisible = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_select_company),
      body: Stack(children: [
        SingleChildScrollView(
            child: Column(children: [
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
                hubValue = newValue!.id!.toString();
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

                getStudentRecords();
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
                });

                getStudentRecords();
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
                });
                getStudentRecords();
              },
              items: semesterResponseArray.map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value == -1 ? "Select semester" : "Semester $value"),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10.h),
          Visibility(
            visible: mainStudentData?.isNotEmpty == true,
            child: Column(children: [
              CustomEditTextSearch(
                type: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: controllerSearch,
                onChanges: (value) {
                  if (value.isEmpty) {
                    studentData = [];
                    studentData = List.from(mainStudentData as Iterable);
                    setState(() {});
                  } else {
                    studentData = [];
                    if (mainStudentData != null && mainStudentData?.isNotEmpty == true) {
                      for (var i = 0; i < mainStudentData!.length; i++) {
                        if (mainStudentData![i].studentName!.toLowerCase().contains(value.toLowerCase())) {
                          studentData?.add(mainStudentData![i]);
                        }
                      }
                    }
                    setState(() {});
                  }
                },
              ),
              custom_text(
                text: "Total Students: ${mainStudentData?.length}",
                textAlign: TextAlign.start,
                textStyles: primaryTextSemiBold14,
                bottomValue: 0,
              ),
              SizedBox(height: 5.h),
              Visibility(
                  visible: studentData?.isNotEmpty == true,
                  child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: studentData?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.h),
                          child: GestureDetector(
                            child: Container(
                              color: colors_name.colorWhite,
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          child: custom_text(
                                            text: "${studentData![index].studentName}",
                                            textAlign: TextAlign.start,
                                            textStyles: linkTextSemiBold14,
                                            topValue: 5,
                                            bottomValue: 5,
                                          ),
                                          onTap: () {
                                            Get.to(const StudentHistory(), arguments: studentData![index].studentMobileNumber);
                                          },
                                        ),
                                        custom_text(
                                          text: "${Utils.getSpecializationNameFromId(studentData![index].studentSpecializationIds)}",
                                          textAlign: TextAlign.start,
                                          textStyles: blackText14,
                                          topValue: 0,
                                          bottomValue: 5,
                                        ),
                                        custom_text(
                                          text: "Semester: ${studentData![index].studentSemester}",
                                          textAlign: TextAlign.start,
                                          textStyles: blackText14,
                                          topValue: 0,
                                          bottomValue: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (studentData![index].selected) const Icon(Icons.check, size: 20, color: colors_name.colorPrimary),
                                ],
                              ),
                            ),
                            onTap: () {
                              studentData![index].selected = !studentData![index].selected;
                              for (int i = 0; i < mainStudentData!.length; i++) {
                                if (studentData![index].studentId == mainStudentData![i].studentId) {
                                  mainStudentData![i].selected = studentData![index].selected;
                                  break;
                                }
                              }
                              setState(() {});
                            },
                          ),
                        );
                      })),
              SizedBox(height: 20.h),
              CustomButton(
                text: strings_name.str_submit,
                click: () {
                  List<StudentResponse>? selectedData = [];
                  for (var i = 0; i < mainStudentData!.length; i++) {
                    if (mainStudentData![i].selected) {
                      selectedData.add(mainStudentData![i]);
                    }
                  }

                  if (selectedData.isNotEmpty == true) {
                    Get.back(result: selectedData);
                  } else {
                    Utils.showSnackBar(context, strings_name.str_empty_select_student);
                  }
                },
              )
            ]),
          ),
        ])),
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
      ]),
    ));
  }
}
