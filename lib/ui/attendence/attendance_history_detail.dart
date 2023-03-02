import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/student_attendance_response.dart';
import 'package:flutterdesigndemo/ui/attendence/myattendance.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../utils/utils.dart';

class AttendanceHistoryDetail extends StatefulWidget {
  const AttendanceHistoryDetail({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryDetail> createState() => _AttendanceHistoryDetailState();
}

class _AttendanceHistoryDetailState extends State<AttendanceHistoryDetail> {
  bool isVisible = false;
  BaseApiResponseWithSerializable<StudentAttendanceResponse> data = BaseApiResponseWithSerializable<StudentAttendanceResponse>();
  final apiRepository = getIt.get<ApiRepository>();

  var present_count = 0, absent_count = 0, total_count = 0;

  void attendanceHistoryDetail() async {
    setState(() {
      isVisible = true;
    });
    try{
      data = await apiRepository.studentAttendanceDetailApi(Get.arguments);
      if (data.fields != null) {
        setState(() {
          isVisible = false;
        });

        if (data.fields?.studentIds != null) {
          total_count = data.fields?.studentIds?.length ?? 0;
          for (var i = 0; i < data.fields!.studentIds!.length; i++) {
            if (data.fields!.presentIds != null && data.fields!.presentIds!.contains(data.fields!.studentIds![i])) {
              present_count++;
            } else {
              absent_count++;
            }
          }
        }
      } else {
        setState(() {
          isVisible = false;
        });
      }
    }on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }

  }

  @override
  void initState() {
    super.initState();
    attendanceHistoryDetail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_students),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              custom_text(
                text: "Total Students : $total_count",
                alignment: Alignment.topLeft,
                textStyles: primaryTextSemiBold16,
                bottomValue: 1,
              ),
              custom_text(
                text: "Present Students : $present_count",
                alignment: Alignment.topLeft,
                textStyles: primryTextSemiBold14,
                bottomValue: 1,
              ),
              custom_text(
                text: "Absent Students : $absent_count",
                alignment: Alignment.topLeft,
                textStyles: primryTextSemiBold14,
                bottomValue: 1,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: data.fields != null
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: data.fields?.nameFromStudentIds?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Card(
                                elevation: 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          custom_text(
                                            text: data.fields!.nameFromStudentIds![index],
                                            alignment: Alignment.topLeft,
                                            textStyles: primryTextSemiBold14,
                                            bottomValue: 5,
                                          ),
                                          custom_text(
                                            text: data.fields!.enrollmentNumberFromStudentIds![index],
                                            alignment: Alignment.topLeft,
                                            textStyles: blackTextSemiBold14,
                                            topValue: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          primary: data.fields!.presentIds != null && data.fields!.presentIds!.contains(data.fields!.studentIds![index]) ? colors_name.presentColor : colors_name.errorColor,
                                          padding: const EdgeInsets.all(10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          elevation: 7.0,
                                        ),
                                        child: Text(
                                          data.fields!.presentIds != null && data.fields!.presentIds!.contains(data.fields!.studentIds![index]) ? strings_name.str_present : strings_name.str_absent,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            onTap: () {
                              Get.to(() => const MyAttendance(), arguments: [
                                {"studentEnrollmentNo": data.fields!.enrollmentNumberFromStudentIds![index]},
                                {"date": data.fields!.lectureDate},
                                {"name": data.fields!.nameFromStudentIds?[index]}
                              ]);
                            },
                          );
                        })
                    : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
              ),
            ]),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
