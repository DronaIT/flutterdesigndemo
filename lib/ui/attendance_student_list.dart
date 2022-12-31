import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/request/add_student_attendance_request.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceStudentList extends StatefulWidget {
  const AttendanceStudentList({Key? key}) : super(key: key);

  @override
  State<AttendanceStudentList> createState() => _AttendanceStudentListState();
}

class _AttendanceStudentListState extends State<AttendanceStudentList> {
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> studentList = [];

  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  String status = "";
  String formattedDate = "";

  @override
  void initState() {
    super.initState();
    studentList = Get.arguments[0]["studentList"];
    checkCurrentData();
  }

  void checkCurrentData() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    print(formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_students),
      body: Stack(children: [
        Column(
          children: [
            GestureDetector(
              child: custom_text(text: "${strings_name.str_select_date} : $formattedDate", textStyles: blackTextSemiBold16),
              onTap: () {
                showDatePicker(context: context, initialDate: DateTime.parse(formattedDate), firstDate: DateTime(2005), lastDate: DateTime.now()).then((pickedDate) {
                  if (pickedDate == null) {
                    return;
                  }
                  setState(() {
                    var formatter = DateFormat('yyyy-MM-dd');
                    setState(() {
                      formattedDate = formatter.format(pickedDate);
                    });
                  });
                });
              },
            ),
            studentList.isNotEmpty
                ? Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ListView.builder(
                          itemCount: studentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 5,
                              child: Container(
                                color: colors_name.colorWhite,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    custom_text(text: "${studentList[index].fields?.name}", textStyles: blackTextSemiBold16),
                                    CustomRadioButton(
                                      unSelectedColor: Theme.of(context).cardColor,
                                      buttonLables: [strings_name.str_present, strings_name.str_absent],
                                      buttonValues: [strings_name.str_present, strings_name.str_absent],
                                      radioButtonValue: (value) {
                                        if (value == strings_name.str_present) {
                                          studentList[index].fields?.attendanceStatus = 1;
                                        } else if (value == strings_name.str_absent) {
                                          studentList[index].fields?.attendanceStatus = 0;
                                        }
                                      },
                                      selectedColor: colors_name.colorPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
            CustomButton(
              text: strings_name.str_submit_attendance,
              click: () {
                if (formattedDate.trim().isEmpty) {
                  Utils.showSnackBar(context, strings_name.str_empty_select_date);
                } else {
                  var pending = false;
                  for (var i = 0; i < studentList.length; i++) {
                    if (studentList[i].fields?.attendanceStatus == -1) {
                      pending = true;
                      break;
                    }
                  }

                  if (!pending) {
                    submitAttendance();
                  } else {
                    Utils.showSnackBar(context, strings_name.str_err_submit_attendance);
                  }
                }
              },
            )
          ],
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }

  Future<void> submitAttendance() async {
    setState(() {
      isVisible = true;
    });

    List<String> studentIds = [];
    List<String> presentIds = [];
    List<String> absentIds = [];

    for (var i = 0; i < studentList.length; i++) {
      studentIds.add(studentList[i].id!);
      if (studentList[i].fields!.attendanceStatus == 1) {
        presentIds.add(studentList[i].id!);
      } else if (studentList[i].fields!.attendanceStatus == 0) {
        absentIds.add(studentList[i].id!);
      }
    }

    AddStudentAttendanceRequest request = Get.arguments[1]["request"];
    request.studentIds = studentIds;
    request.presentIds = presentIds;
    request.absentIds = absentIds;
    request.lectureDate = formattedDate;

    var resp = await apiRepository.addStudentAttendanceApi(request);
    if (resp.id!.isNotEmpty) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBar(context, strings_name.str_attendance_recorded);
      await Future.delayed(const Duration(milliseconds: 2000));
      Get.back(closeOverlays: true, result: true);
    } else {
      setState(() {
        isVisible = false;
      });
    }
  }
}
