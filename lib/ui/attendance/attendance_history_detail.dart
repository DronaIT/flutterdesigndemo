import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/student_attendance_response.dart';
import 'package:flutterdesigndemo/ui/attendance/myattendance.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../customwidget/custom_edittext_search.dart';
import '../../models/student_attendance_response_display.dart';
import '../../utils/utils.dart';

class AttendanceHistoryDetail extends StatefulWidget {
  const AttendanceHistoryDetail({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryDetail> createState() => _AttendanceHistoryDetailState();
}

class _AttendanceHistoryDetailState extends State<AttendanceHistoryDetail> {
  bool isVisible = false;
   BaseApiResponseWithSerializable<StudentAttendanceResponse> dataMain = BaseApiResponseWithSerializable<StudentAttendanceResponse>();
  // BaseApiResponseWithSerializable<StudentAttendanceResponse> dataSearch = BaseApiResponseWithSerializable<StudentAttendanceResponse>();

  List<StudentAttendanceResponseDisplay> data = [];
  List<StudentAttendanceResponseDisplay> dataSearch = [];

  final apiRepository = getIt.get<ApiRepository>();
  var controllerSearch = TextEditingController();
  var present_count = 0, absent_count = 0, total_count = 0;

  void attendanceHistoryDetail() async {
    setState(() {
      isVisible = true;
    });
    try{
      dataMain = await apiRepository.studentAttendanceDetailApi(Get.arguments);

      if (dataMain.fields != null) {
        setState(() {
          isVisible = false;
        });

        if (dataMain.fields?.studentIds != null) {
          total_count = dataMain.fields?.studentIds?.length ?? 0;
          for (var i = 0; i < dataMain.fields!.studentIds!.length; i++) {
            if (dataMain.fields!.presentIds != null && dataMain.fields!.presentIds!.contains(dataMain.fields!.studentIds![i])) {
              present_count++;
            } else {
              absent_count++;
            }
            var studentAttendanceResponseDisplay = StudentAttendanceResponseDisplay();
            studentAttendanceResponseDisplay.studentIds = dataMain.fields!.studentIds![i];
            studentAttendanceResponseDisplay.enrollmentNumberFromStudentIds = dataMain.fields!.enrollmentNumberFromStudentIds![i];
            studentAttendanceResponseDisplay.nameFromStudentIds = dataMain.fields!.nameFromStudentIds![i];
            data.add(studentAttendanceResponseDisplay);
            dataSearch.add(studentAttendanceResponseDisplay);
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
              Row(
                children: [
                  Expanded(
                    child: custom_text(
                      text: 'Present Students : $present_count',
                      textStyles: blackTextGreen14,
                      bottomValue: 0,
                    ),
                  ),
                  Expanded(
                    child: custom_text(
                      text: 'Absent Students : $absent_count',
                      textStyles: blackTextRed14,
                      bottomValue: 0,

                    ),
                  )
                ],
              ),
              SizedBox(height: 5,),
              CustomEditTextSearch(
                type: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: controllerSearch,
                onChanges: (value) {
                  if (value.isEmpty) {
                    data = [];
                    data = dataSearch;
                    setState(() {});
                  } else {
                    data = [];
                    for (var i = 0; i < dataSearch.length; i++) {
                      if (dataSearch[i].nameFromStudentIds!.toLowerCase().contains(value.toLowerCase())) {
                        data.add(dataSearch[i]);
                        //data.add(test[i]);
                      }
                    }
                    setState(() {});
                  }
                },
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: data != null
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: data.length,
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
                                            text: data[index].nameFromStudentIds!,
                                            alignment: Alignment.topLeft,
                                            textStyles: primryTextSemiBold14,
                                            bottomValue: 5,
                                          ),
                                          custom_text(
                                            text: data[index].enrollmentNumberFromStudentIds!,
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
                                          backgroundColor: dataMain.fields!.presentIds != null && dataMain.fields!.presentIds!.contains(data[index].studentIds) ? colors_name.presentColor : colors_name.errorColor,
                                          padding: const EdgeInsets.all(10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          //elevation: 7.0,
                                        ),
                                        child: Text(
                                          dataMain.fields!.presentIds != null && dataMain.fields!.presentIds!.contains(data[index].studentIds) ? strings_name.str_present : strings_name.str_absent,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            onTap: () {
                              Get.to(() => const MyAttendance(), arguments: [
                                {"studentEnrollmentNo": data[index].enrollmentNumberFromStudentIds},
                                {"date": dataMain.fields!.lectureDate},
                                {"name": data[index].nameFromStudentIds}
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
