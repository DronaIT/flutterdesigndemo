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
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/student_attendance_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceDataBySpecialization extends StatefulWidget {
  const AttendanceDataBySpecialization({super.key});

  @override
  State<AttendanceDataBySpecialization> createState() => _AttendanceDataBySpecializationState();
}

class _AttendanceDataBySpecializationState extends State<AttendanceDataBySpecialization> {
  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  bool isVisible = false;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  DateTime? startDate = DateTime.now().add(const Duration(days: -1));
  DateTime? endDate = DateTime.now();

  List<BaseApiResponseWithSerializable<StudentAttendanceResponse>> attendanceData = [];

  @override
  void initState() {
    super.initState();
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
      if (Get.arguments[3]["hubData"] != null) {
        hubResponse = Get.arguments[3]["hubData"];
      }

      speResponseArray?.addAll(PreferenceUtils.getSpecializationList().records!);
      if (hubResponse != null) {
        for (int i = 0; i < speResponseArray!.length; i++) {
          if (speResponseArray![i].fields?.hubIdFromHubIds?.contains(hubResponse?.fields?.hubId) != true) {
            speResponseArray!.removeAt(i);
            i--;
          }
        }
      }
      if(speResponseArray?.isNotEmpty == true){
        speResponseArray?.sort((a, b) => a.fields!.specializationName!.compareTo(b.fields!.specializationName!));
      }

      combineData();
      setState(() {});
    } else {
      fetchAttendanceData();
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
              custom_text(
                text: "${hubResponse?.fields?.hubName?.trim()}, ${hubResponse?.fields?.city}",
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
                topValue: 0,
                bottomValue: 5,
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
              speResponseArray?.isNotEmpty == true
                  ? Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: ListView.builder(
                            itemCount: speResponseArray?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Card(
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
                                        custom_text(text: "${speResponseArray![index].fields?.specializationName}", textStyles: primaryTextSemiBold16),
                                        custom_text(
                                          text: "${strings_name.str_total_lectures_taken}: ${speResponseArray![index].fields?.totalLecture}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_average_attendace}: ${speResponseArray![index].fields?.averageLectureAttendance.toStringAsFixed(2)}%",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_overall_student_attendance}: ${speResponseArray![index].fields?.overallStudentAttendance.toStringAsFixed(2)}%",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: custom_text(text: strings_name.str_no_specialization, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
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
      fetchAttendanceData();
    }
  }

  void fetchAttendanceData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "OR(SEARCH('${hubResponse?.fields?.hubId}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
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
          fetchAttendanceData();
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
    for (int j = 0; j < (speResponseArray?.length ?? 0); j++) {
      int totalStudent = 0, presentStudent = 0;
      double avgAttendance = 0.0;
      int totalLectures = 0;
      for (int i = 0; i < attendanceData.length; i++) {
        if(attendanceData[i].fields?.hubNameFromHubId?.last == hubResponse?.fields?.hubName) {
          if (attendanceData[i].fields?.specializationNameFromSpecializationId?.last == speResponseArray?[j].fields?.specializationName) {
            totalLectures += 1;
            totalStudent += attendanceData[i].fields!.studentIds?.length ?? 0;
            presentStudent += attendanceData[i].fields!.presentIds?.length ?? 0;

            if ((attendanceData[i].fields!.studentIds?.length ?? 0) > 0) {
              var avg = ((attendanceData[i].fields!.presentIds?.length ?? 0) * 100) / attendanceData[i].fields!.studentIds!.length;
              avgAttendance += avg;
            }
          }
        }
      }
      speResponseArray?[j].fields?.totalLecture = totalLectures;
      speResponseArray?[j].fields?.overallStudentAttendance = totalStudent > 0 ? ((presentStudent * 100) / totalStudent) : 0;
      speResponseArray?[j].fields?.averageLectureAttendance = totalLectures > 0 ? (avgAttendance / totalLectures) : 0;
    }
  }
}
