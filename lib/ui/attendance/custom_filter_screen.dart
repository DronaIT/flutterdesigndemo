import 'dart:io';

import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/attendance_data.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/models/units_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../customwidget/custom_edittext.dart';

class CustomFilterScreen extends StatefulWidget {
  const CustomFilterScreen({Key? key}) : super(key: key);

  @override
  State<CustomFilterScreen> createState() => _CustomFilterScreenState();
}

class _CustomFilterScreenState extends State<CustomFilterScreen> {
  bool isVisible = false;
  var type = 0;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  List<int> semesterResponseArray = <int>[1, 2, 3, 4, 5, 6];
  int semesterValue = 1;

  List<String> divisionResponseArray = <String>[TableNames.DIVISION_A, TableNames.DIVISION_B, TableNames.DIVISION_C, TableNames.DIVISION_D];
  String divisionValue = "";

  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectResponseArray = [];
  BaseApiResponseWithSerializable<SubjectResponse>? subjectResponse;
  String subjectValue = "";
  String subjectRecordId = "";

  TextEditingController eligibilityR = TextEditingController();

  List<BaseApiResponseWithSerializable<UnitsResponse>>? unitResponseArray = [];
  BaseApiResponseWithSerializable<UnitsResponse>? unitResponse;
  String unitValue = "";
  String unitRecordId = "";

  List<BaseApiResponseWithSerializable<TopicsResponse>>? topicResponseArray = [];
  BaseApiResponseWithSerializable<TopicsResponse>? topicResponse;
  String topicValue = "";
  String topicRecordId = "";

  DateTime? startDate = DateTime.now().add(const Duration(days: -1));
  DateTime? endDate = DateTime.now();

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? viewStudent = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? studentList = [];

  int continuousCount = 2;
  String title = strings_name.str_filter;
  bool isFromEligible = false;

  var todays = false;

  @override
  void initState() {
    super.initState();
    if (Get.arguments[0]["title"] != null) {
      title = Get.arguments[0]["title"];
    }

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
                          isExpanded: true,
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
                        text: strings_name.str_select_specialization_r,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<BaseApiResponseWithSerializable<SpecializationResponse>>(
                          value: speResponse,
                          isExpanded: true,
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
                        text: strings_name.str_semester_r,
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
                              // getSubjects();
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
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_division_r,
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
                                    // getSubjects();
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
                                          isExpanded: true,
                                          elevation: 16,
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
                                          items: subjectResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SubjectResponse>>>((BaseApiResponseWithSerializable<SubjectResponse> value) {
                                            return DropdownMenuItem<BaseApiResponseWithSerializable<SubjectResponse>>(
                                              value: value,
                                              child: Text(
                                                value.fields!.subjectTitle!.toString(),
                                                overflow: TextOverflow.visible,
                                              ),
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
                      Visibility(
                        visible: isFromEligible && subjectValue.isNotEmpty,
                        child: custom_text(
                          text: strings_name.str_eligibiltyC,
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                        ),
                      ),
                      Visibility(
                          visible: isFromEligible && subjectValue.isNotEmpty,
                          child: custom_edittext(
                            type: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            controller: eligibilityR,
                            maxLength: 2,
                          )),
                      SizedBox(height: 10.h),
                      CustomButton(
                        click: () async {
                          if (hubValue.isEmpty) {
                            Utils.showSnackBar(context, strings_name.str_empty_hub);
                          } else if (startDate == null || endDate == null) {
                            Utils.showSnackBar(context, strings_name.str_empty_date_range);
                          } else if (speValue.isEmpty) {
                            Utils.showSnackBar(context, strings_name.str_empty_specializations);
                          } else if (divisionValue.isEmpty) {
                            Utils.showSnackBar(context, strings_name.str_empty_division);
                          } else if (isFromEligible && subjectValue.isEmpty) {
                            Utils.showSnackBar(context, strings_name.str_empty_subject);
                          } else if (isFromEligible && eligibilityR.text.isEmpty) {
                            Utils.showSnackBar(context, strings_name.str_empty_eligibilty);
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
                Center(
                  child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
                )
              ],
            )));
  }

  Future<void> getSubjects() async {
    if (semesterValue != -1 && divisionValue.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      subjectValue = "";
      unitValue = "";
      topicValue = "";

      var query = "AND(FIND('$semesterValue', ${TableNames.CLM_SEMESTER}, 0),FIND('${Utils.getSpecializationIds(speValue)}',${TableNames.CLM_SPE_IDS}, 0))";
      try {
        var data = await apiRepository.getSubjectsApi(query);
        setState(() {
          subjectResponse = null;
          subjectResponseArray = data.records;

          unitResponse = null;
          topicResponse = null;

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

  Future<void> getUnits() async {
    if (subjectValue.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      var query = "FIND('$subjectValue', ${TableNames.CLM_SUBJECT_IDS}, 0)";
      try {
        var data = await apiRepository.getUnitsApi(query);
        setState(() {
          unitResponse = null;
          unitResponseArray = data.records;

          topicResponse = null;
          isVisible = false;
        });
        if (data.records?.isEmpty == true) {
          Utils.showSnackBar(context, strings_name.str_no_unit_assigned);
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

  Future<void> getTopics() async {
    if (unitValue.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      var query = "FIND('$unitValue', ${TableNames.CLM_UNIT_IDS}, 0)";
      try {
        var data = await apiRepository.getTopicsApi(query);
        setState(() {
          topicResponse = null;
          topicResponseArray = data.records;
          isVisible = false;
        });
        if (data.records?.isEmpty == true) {
          Utils.showSnackBar(context, strings_name.str_no_topic_assigned);
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

  Future<void> fetchRecords() async {
    var query = "AND(${TableNames.CLM_HUB_IDS}='$hubValue'";

    if (speValue.isNotEmpty) {
      query += ",${TableNames.CLM_SPE_IDS}='$speValue'";
    }
    query += ",${TableNames.CLM_SEMESTER}='${semesterValue.toString()}'";
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
          setState(() {
            viewStudent?.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
            isVisible = false;

            filterData();
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            viewStudent = [];
          }
        });
        offset = "";
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

  Future<void> filterData() async {
    debugPrint(viewStudent?.length.toString());
    if (continuousCount == 1) {
      startDate = DateTime.now();
      endDate = DateTime.now();
    }
    if (viewStudent != null && viewStudent?.isNotEmpty == true) {
      if (isFromEligible) {
        studentList?.addAll(viewStudent!);
      } else {
        if (viewStudent?.isNotEmpty == true) {
          setState(() {
            isVisible = true;
          });

          List<AttendanceData> lecturesData = [];
          for (int i = 0; i < viewStudent!.length; i++) {
            if ((viewStudent![i].fields!.lectureIds?.length ?? 0) > 0) {
              for (int j = 0; j < viewStudent![i].fields!.lectureIds!.length; j++) {
                var isAdded = lecturesData.indexWhere((element) => element.lectureId == viewStudent![i].fields!.lectureIds![j]);
                if (isAdded == -1) {
                  AttendanceData lData = AttendanceData();
                  lData.lectureDate = viewStudent![i].fields!.lecture_date![j];
                  lData.lectureId = viewStudent![i].fields!.lectureIds![j];
                  lData.lectureTime = viewStudent![i].fields!.lecture_time![j];
                  lData.employeeName = viewStudent![i].fields!.employee_name![j];
                  lData.subjectTitle = viewStudent![i].fields!.lecture_subject_title![j];
                  lData.specializationId = viewStudent![i].fields!.lecture_specialization_id![j];

                  lecturesData.add(lData);
                }
              }
            }
          }

          lecturesData.sort((a,b) {
            var adate = a.lectureDate;
            var bdate = b.lectureDate;
            return adate!.compareTo(bdate!);
          });

          List<String> titleList = [];
          titleList.add("Enrollment Number");
          titleList.add("Name");
          titleList.add("Mobile Number");
          titleList.add("Total");
          titleList.add("Percentage");

          var totalSub = 0;
          var start = DateFormat("dd MMM yyyy").format(startDate!);
          var end = DateFormat("dd MMM yyyy").format(endDate!);

          var excel = Excel.createExcel();
          var sheet = excel['Sheet1'];
          sheet.appendRow(['Drona Foundation']);
          sheet.appendRow(["${speResponse?.fields?.specializationName?.toString()} - Semester $semesterValue [$start - $end]"]);

          DateTime? strDate;
          var enCheck = DateFormat("yyyy-MM-dd").format(endDate!);
          var strCheck = "";
          do {
            if (strDate == null) {
              strDate = startDate;
            } else {
              strDate = strDate.add(const Duration(days: 1));
            }
            strCheck = DateFormat("yyyy-MM-dd").format(strDate!);
            var isContains = lecturesData.firstWhereOrNull((element) => element.lectureDate == strCheck);
            if (isContains != null) {
              int? pos = 0;
              do {
                pos = lecturesData.indexWhere((element) => element.lectureDate == strCheck, pos!);
                if (pos != -1) {
                  if (lecturesData[pos].specializationId == viewStudent![0].fields!.specializationIds!.first) {
                    var lectureDate = DateFormat("dd MMM yyyy").format(strDate);
                    totalSub++;
                    titleList.add("$lectureDate ${lecturesData[pos].lectureTime} - ${lecturesData[pos].employeeName} - (${lecturesData[pos].subjectTitle})");
                  }
                  pos = pos + 1;
                  if (pos >= lecturesData.length) {
                    break;
                  }
                }
              } while (lecturesData.indexWhere((element) => element.lectureDate == strCheck, pos) != -1);
            }
          } while (strCheck != enCheck);
          sheet.appendRow(titleList);

          for (int i = 0; i < viewStudent!.length; i++) {
            var presentSub = 0;
            List<String> attendanceData = [];
            DateTime? strDate;
            var enCheck = DateFormat("yyyy-MM-dd").format(endDate!);
            var strCheck = "";
            do {
              if (strDate == null) {
                strDate = startDate;
              } else {
                strDate = strDate.add(const Duration(days: 1));
              }
              strCheck = DateFormat("yyyy-MM-dd").format(strDate!);
              var isContains = lecturesData.firstWhereOrNull((element) => element.lectureDate == strCheck);

              if (isContains != null) {
                int? pos = 0;
                do {
                  pos = lecturesData.indexWhere((element) => element.lectureDate == strCheck, pos!);
                  if (pos != -1) {
                    if (lecturesData[pos].specializationId == viewStudent![i].fields!.specializationIds!.first) {
                      if (viewStudent![i].fields!.absentLectureIds?.contains(lecturesData[pos].lectureId) == true) {
                        attendanceData.add("A");
                      } else {
                        presentSub++;
                        attendanceData.add("P");
                      }
                    }
                    pos = pos + 1;
                    if (pos >= lecturesData.length) {
                      break;
                    }
                  }
                } while (lecturesData.indexWhere((element) => element.lectureDate == strCheck, pos) != -1);
              }
            } while (strCheck != enCheck);

            List<String> studentData = [];
            studentData.add(viewStudent![i].fields?.enrollmentNumber ?? " ");
            studentData.add(viewStudent![i].fields?.name ?? " ");
            studentData.add(viewStudent![i].fields?.mobileNumber ?? " ");
            studentData.add("$presentSub/$totalSub");
            studentData.add("${(presentSub * 100 / totalSub).toStringAsFixed(2)}%");
            studentData.addAll(attendanceData);

            sheet.appendRow(studentData);
          }

          var appDocumentsDirectory = await getApplicationDocumentsDirectory();
          var file = File("${appDocumentsDirectory.path}/AttendanceReport.xlsx");
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
        } else {
          Utils.showSnackBarUsingGet(strings_name.str_no_students);
        }
      }
    }
  }
}
