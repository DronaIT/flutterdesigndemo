import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/student_attendance_response.dart';
import 'package:flutterdesigndemo/ui/myattendance.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class AttendanceHistoryDetail extends StatefulWidget {
  const AttendanceHistoryDetail({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryDetail> createState() => _AttendanceHistoryDetailState();
}

class _AttendanceHistoryDetailState extends State<AttendanceHistoryDetail> {
  bool isVisible = false;
  BaseApiResponseWithSerializable<StudentAttendanceResponse> data = BaseApiResponseWithSerializable<StudentAttendanceResponse>();
  final apiRepository = getIt.get<ApiRepository>();

  void attendanceHistoryDetail() async {
    setState(() {
      isVisible = true;
    });
    data = await apiRepository.studentAttendanceDetailApi(Get.arguments);
    if (data != null) {
      setState(() {
        isVisible = false;
      });
    } else {
      setState(() {
        isVisible = false;
      });
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
          Container(
            margin: const EdgeInsets.all(10),
            child: data.fields != null
                ? ListView.builder(
                    itemCount: data.fields?.nameFromStudentIds?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Card(
                            elevation: 5,
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
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
