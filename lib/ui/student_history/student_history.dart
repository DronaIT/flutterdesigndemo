import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/ui/student_history/student_attendance_past_history.dart';
import 'package:flutterdesigndemo/ui/student_history/student_attendance_history.dart';
import 'package:flutterdesigndemo/ui/student_history/student_attendance_history_moredetail.dart';
import 'package:flutterdesigndemo/ui/student_history/student_placement_history.dart';
import 'package:flutterdesigndemo/ui/student_history/view_resume_placement.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_text.dart';
import '../../models/base_api_response.dart';
import '../../utils/tablenames.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class StudentHistory extends StatefulWidget {
  const StudentHistory({Key? key}) : super(key: key);

  @override
  State<StudentHistory> createState() => _StudentHistoryState();
}

class _StudentHistoryState extends State<StudentHistory> {
  var mobileNumber;
  BaseLoginResponse<LoginFieldsResponse> data = BaseLoginResponse();
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  var total_lecture = 0, total_present = 0, totalPresentPercentage, total_absent = 0;

  getStudentHistory() async {
    setState(() {
      isVisible = true;
    });
    var query = "(${TableNames.TB_USERS_PHONE}='$mobileNumber')";
    try {
      data = await apiRepository.loginApi(query);
      checkPresentAbsentDetailBySubject();
      if (data.records != null) {
        setState(() {
          isVisible = false;
        });
      } else {
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

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      mobileNumber = Get.arguments;
    }
    getStudentHistory();
  }

  void checkPresentAbsentDetailBySubject() {
    if (data.records != null) {
      if (data.records!.first.fields!.lectureSubjectId?.isNotEmpty == true) {
        if (data.records!.first.fields!.presentLectureIds != null) {
          for (var i = 0; i < data.records!.first.fields!.presentLectureIds!.length; i++) {
            if (data.records!.first.fields!.presentSemesterByStudent![i] == data.records!.first.fields?.semester) {
              total_present += 1;
              total_lecture += 1;
            }
          }
        }
        if (data.records!.first.fields!.absentLectureIds != null) {
          for (var i = 0; i < data.records!.first.fields!.absentLectureIds!.length; i++) {
            if (data.records!.first.fields!.absentSemesterByStudent![i] == data.records!.first.fields?.semester) {
              total_absent += 1;
              total_lecture += 1;
            }
          }
        }
      }
      totalPresentPercentage = ((total_present * 100) / total_lecture).toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_student_history),
      body: data.records != null
          ? Container(
              margin: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    custom_text(
                      text: data.records!.first.fields!.name!,
                      alignment: Alignment.topLeft,
                      textStyles: primaryTextSemiBold16,
                      bottomValue: 0,
                      topValue: 0,
                      leftValue: 10,
                      maxLines: 2,
                    ),
                    Row(
                      children: [
                        const custom_text(
                          text: "${strings_name.str_phone}:",
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                          topValue: 10,
                          bottomValue: 0,
                          leftValue: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchCaller(data.records!.first.fields!.mobileNumber ?? "");
                          },
                          child: Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 10, bottom: 0),
                            child: Text(
                              data.records!.first.fields!.mobileNumber!,
                              style: linkTextSemiBold16,
                            ),
                          ),
                        )
                      ],
                    ),
                    custom_text(
                      text: "${strings_name.str_email}: ${data.records!.first.fields!.email!}",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      maxLines: 3,
                      topValue: 10,
                      bottomValue: 0,
                      leftValue: 10,
                    ),
                    custom_text(
                      text: "${strings_name.str_hub_name}: ${Utils.getHubName(data.records!.first.fields!.hubIdFromHubIds![0])!}",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      topValue: 10,
                      maxLines: 2,
                      bottomValue: 0,
                      leftValue: 10,
                    ),
                    custom_text(
                      text: "${strings_name.str_code}: ${data.records!.first.fields!.enrollmentNumber!}",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      topValue: 10,
                      bottomValue: 0,
                      leftValue: 10,
                    ),
                    custom_text(
                      text: "${strings_name.str_university_number}: ${data.records!.first.fields!.sr_number!}",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      topValue: 10,
                      bottomValue: 0,
                      leftValue: 10,
                    ),
                    custom_text(
                      text: "${strings_name.str_specilization}: ${Utils.getSpecializationName(data.records!.first.fields!.specializationIds![0])!}",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      maxLines: 2,
                      topValue: 10,
                      bottomValue: 0,
                      leftValue: 10,
                    ),
                    custom_text(
                      text: "${strings_name.str_semester}: ${data.records!.first.fields!.semester!}",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      topValue: 10,
                      bottomValue: 0,
                      leftValue: 10,
                    ),
                    custom_text(
                      text: "${strings_name.str_total_lectures}: $total_lecture",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      topValue: 10,
                      bottomValue: 0,
                      leftValue: 10,
                    ),
                    custom_text(
                      text: "${strings_name.str_total_p_lectures}: $total_present",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      topValue: 10,
                      bottomValue: 0,
                      leftValue: 10,
                    ),
                    custom_text(
                      text: "${strings_name.str_total_a_lectures}: $total_absent",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      topValue: 10,
                      bottomValue: 0,
                      leftValue: 10,
                    ),
                    custom_text(
                      text: "${strings_name.str_total_attendance}: $totalPresentPercentage%",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      topValue: 10,
                      bottomValue: 0,
                      leftValue: 10,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Get.to(const StudentAttendanceHistory(), arguments: data.records?.first.fields);
                      },
                      child: Card(
                        elevation: 5,
                        color: colors_name.colorPrimary,
                        child: Container(
                          color: colors_name.colorPrimary,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(5),
                          child: const custom_text(
                            text: strings_name.str_attendance,
                            alignment: Alignment.centerLeft,
                            textStyles: whiteTextSemiBold16,
                            topValue: 0,
                            bottomValue: 0,
                            leftValue: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        Get.to(const StudentAttendanceHistoryMoreDetail(), arguments: data.records?.first.fields);
                      },
                      child: Card(
                        elevation: 5,
                        color: colors_name.colorPrimary,
                        child: Container(
                          color: colors_name.colorPrimary,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(5),
                          child: const custom_text(
                            text: strings_name.str_viewothers_attendance,
                            alignment: Alignment.centerLeft,
                            textStyles: whiteTextSemiBold16,
                            topValue: 0,
                            bottomValue: 0,
                            leftValue: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        Get.to(const StudentPlacementHistory(), arguments: data.records?.first.fields);
                      },
                      child: Card(
                        elevation: 5,
                        color: colors_name.colorPrimary,
                        child: Container(
                          color: colors_name.colorPrimary,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(5),
                          child: const custom_text(
                            text: strings_name.str_placement,
                            alignment: Alignment.centerLeft,
                            textStyles: whiteTextSemiBold16,
                            topValue: 0,
                            bottomValue: 0,
                            leftValue: 0,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const StudentAttendancePastHistory(), arguments: data.records?.first.fields);
                      },
                      child: Card(
                        elevation: 5,
                        color: colors_name.colorPrimary,
                        child: Container(
                          color: colors_name.colorPrimary,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(5),
                          child: const custom_text(
                            text: strings_name.str_past_history,
                            alignment: Alignment.centerLeft,
                            textStyles: whiteTextSemiBold16,
                            topValue: 0,
                            bottomValue: 0,
                            leftValue: 0,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const ViewResumePlacement(), arguments: data.records?.first.fields);
                      },
                      child: Card(
                        elevation: 5,
                        color: colors_name.colorPrimary,
                        child: Container(
                          color: colors_name.colorPrimary,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(5),
                          child: const custom_text(
                            text: strings_name.str_view_resume,
                            alignment: Alignment.centerLeft,
                            textStyles: whiteTextSemiBold16,
                            topValue: 0,
                            bottomValue: 0,
                            leftValue: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
            ),
    ));
  }

  _launchCaller(String mobile) async {
    try {
      await launchUrl(Uri.parse("tel:$mobile"), mode: LaunchMode.externalApplication);
    } catch (e) {
      Utils.showSnackBarUsingGet(strings_name.str_invalid_mobile);
    }
  }
}
