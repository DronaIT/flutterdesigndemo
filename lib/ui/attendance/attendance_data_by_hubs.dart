import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/student_attendance_response.dart';
import 'package:flutterdesigndemo/ui/attendance/attendance_data_by_specialization.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceDataByHubs extends StatefulWidget {
  const AttendanceDataByHubs({super.key});

  @override
  State<AttendanceDataByHubs> createState() => _AttendanceDataByHubsState();
}

class _AttendanceDataByHubsState extends State<AttendanceDataByHubs> {
  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  bool isVisible = false;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  DateTime? startDate = DateTime.now().add(const Duration(days: -1));
  DateTime? endDate = DateTime.now();

  List<BaseApiResponseWithSerializable<StudentAttendanceResponse>> attendanceData = [];

  @override
  void initState() {
    super.initState();
    hubResponseArray?.addAll(PreferenceUtils.getHubList().records!);
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

      if(hubResponseArray?.isNotEmpty == true){
        hubResponseArray?.sort((a, b) => a.fields!.hubName!.compareTo(b.fields!.hubName!));
      }
    }

    if (Get.arguments != null) {
      if (Get.arguments[0]["attendanceData"] != null) {
        attendanceData = Get.arguments[0]["attendanceData"];
      }
      if (Get.arguments[1]["startDate"] != null) {
        startDate = Get.arguments[1]["startDate"];
      }
      if (Get.arguments[2]["endDate"] != null) {
        endDate = Get.arguments[2]["endDate"];
      }

      combineData();
      setState(() {});
    } else {
      fetchFeesData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_attendance_dashboard),
      body: Stack(children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
          child: Column(
            children: [
              Visibility(
                visible: false,
                child: custom_text(
                  text: strings_name.str_date_range,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  topValue: 0,
                  bottomValue: 5,
                ),
              ),
              startDate != null && endDate != null && false
                  ? GestureDetector(
                      child: custom_text(
                        text:
                            "${startDate.toString().split(" ").first.replaceAll("-", "/")} - ${endDate.toString().split(" ").first.replaceAll("-", "/")}",
                        alignment: Alignment.topLeft,
                        textStyles: primaryTextSemiBold16,
                        topValue: 0,
                      ),
                      onTap: () {
                        _show();
                      },
                    )
                  : Container(),
              hubResponseArray?.isNotEmpty == true
                  ? Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: ListView.builder(
                            itemCount: hubResponseArray?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: colors_name.darkGrayColor, width: 1.r),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                surfaceTintColor: colors_name.colorWhite,
                                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      custom_text(text: "${hubResponseArray![index].fields?.hubName?.trim()}, ${hubResponseArray![index].fields?.city}", maxLines: 2, textStyles: primaryTextSemiBold16),
                                      custom_text(
                                        text: "${strings_name.str_total_lectures_taken}: ${hubResponseArray![index].fields?.totalLecture}",
                                        textStyles: blackTextSemiBold14,
                                        topValue: 5,
                                        bottomValue: 0,
                                      ),
                                      custom_text(
                                        text: "${strings_name.str_average_attendace}: ${hubResponseArray![index].fields?.averageLectureAttendance.toStringAsFixed(2)}%",
                                        textStyles: blackTextSemiBold14,
                                        topValue: 5,
                                        bottomValue: 0,
                                      ),
                                      custom_text(
                                        text: "${strings_name.str_overall_student_attendance}: ${hubResponseArray![index].fields?.overallStudentAttendance.toStringAsFixed(2)}%",
                                        textStyles: blackTextSemiBold14,
                                        topValue: 5,
                                        bottomValue: 0,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(const AttendanceDataBySpecialization(), arguments: [
                                            {"attendanceData": attendanceData},
                                            {"startDate": startDate},
                                            {"endDate": endDate},
                                            {"hubData": hubResponseArray![index]},
                                          ])?.then((result) {
                                            if (result != null && result) {
                                              // Get.back(closeOverlays: true);
                                            }
                                          });
                                        },
                                        child: custom_text(
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
                            }),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: custom_text(text: strings_name.str_no_hub, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
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
      ]),
    ));
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
      startDate = result.start;
      endDate = result.end;

      attendanceData.clear();
      fetchFeesData();
    }
  }

  void fetchFeesData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "OR(SEARCH('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null &&
        PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query +=
          ",SEARCH('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
        }
      }
    }
    query += "),";

    if (startDate.toString().isNotEmpty && endDate.toString().isNotEmpty) {
      var start = startDate?.add(const Duration(days: -1));
      var startFormat = DateFormat("MM/dd/yyyy").format(start!);

      var end = endDate?.add(const Duration(days: 1));
      var endFormat = DateFormat("MM/dd/yyyy").format(end!);
      query += "IS_BEFORE(lecture_date, '$endFormat'), IS_AFTER(lecture_date, '$startFormat')";
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getStudentAttendanceApi(query, offset);
      if (data.records?.isNotEmpty == true) {
        if (offset.isEmpty) {
          attendanceData.clear();
        }
        attendanceData.addAll(data.records as Iterable<BaseApiResponseWithSerializable<StudentAttendanceResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchFeesData();
        } else {
          attendanceData.sort((a, b) => a.fields!.lectureDate!.compareTo(b.fields!.lectureDate!));
          debugPrint(attendanceData.length.toString());

          combineData();

          isVisible = false;
          setState(() {});
        }
      } else {
        isVisible = false;
        setState(() {});
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  combineData() {
    for (int j = 0; j < (hubResponseArray?.length ?? 0); j++) {
      int totalStudent = 0, presentStudent = 0;
      double avgAttendance = 0.0;
      int totalLectures = 0;
      for (int i = 0; i < attendanceData.length; i++) {
        if(attendanceData[i].fields?.hubNameFromHubId?.last == hubResponseArray?[j].fields?.hubName) {
          totalLectures += 1;
          totalStudent += attendanceData[i].fields!.studentIds?.length ?? 0;
          presentStudent += attendanceData[i].fields!.presentIds?.length ?? 0;

          if ((attendanceData[i].fields!.studentIds?.length ?? 0) > 0) {
            var avg = ((attendanceData[i].fields!.presentIds?.length ?? 0) * 100) / attendanceData[i].fields!.studentIds!.length;
            avgAttendance += avg;
          }
        }
      }
      hubResponseArray?[j].fields?.totalLecture = totalLectures;
      hubResponseArray?[j].fields?.overallStudentAttendance = totalStudent > 0 ? ((presentStudent * 100) / totalStudent) : 0;
      hubResponseArray?[j].fields?.averageLectureAttendance = totalLectures > 0 ? (avgAttendance / totalLectures) : 0;
    }
  }
}
