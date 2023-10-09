import 'dart:convert';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/request/add_student_attendance_request.dart';
import 'package:flutterdesigndemo/ui/time_table/add_edit_time_table.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/dio_exception.dart';
import '../../models/add_time_table_response.dart';
import '../../models/request/update_time_table_request.dart';

class AttendanceStudentList extends StatefulWidget {
  BaseApiResponseWithSerializable<TimeTableResponseClass>? timeTableData;
  DateTime? date;
  String? time;
  AttendanceStudentList({Key? key,this.timeTableData,this.date,this.time}) : super(key: key);

  @override
  State<AttendanceStudentList> createState() => _AttendanceStudentListState();
}

class _AttendanceStudentListState extends State<AttendanceStudentList> {
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> studentList = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> mainData = [];
  BaseApiResponseWithSerializable<TimeTableResponseClass>? timeTableData;

  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  String status = "";
  String formattedDate = "";
  String formattedTime = "";

  String lectureId = "";
  bool fromEdit = false;

  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkCurrentData();
    if (Get.arguments[0]["studentList"] != null) {
      mainData = Get.arguments[0]["studentList"];
      studentList = Get.arguments[0]["studentList"];
    } else if (Get.arguments[0]["lectureId"] != null) {
      lectureId = Get.arguments[0]["lectureId"];
      fromEdit = true;
      getAttendanceData(lectureId);
    }
    // debugPrint('../ time ${Get.arguments[0]["timeTableData"] == null}');
    // if(Get.arguments[0]["timeTableData"] != null){
    //   debugPrint('../ timeTableData attendance list screen $timeTableData');
    //   timeTableData = Get.arguments[0]["timeTableData"];
    // }
    // debugPrint('../ time table data ${widget.timeTableData == null}');
    if(widget.timeTableData!=null){
      timeTableData = widget.timeTableData;
    }
  }

  void getAttendanceData(String lectureId) async {
    setState(() {
      isVisible = true;
    });
    try {
      var data = await apiRepository.studentAttendanceDetailApi(lectureId);
      if (data.fields != null) {
        setState(() {
          isVisible = false;

          formattedDate = data.fields!.lectureDate!;
          formattedTime = data.fields!.lectureTime!;

          if (data.fields?.studentIds != null) {
            for (var i = 0; i < data.fields!.studentIds!.length; i++) {
              var loginFieldResponse = LoginFieldsResponse();
              loginFieldResponse.name = data.fields!.nameFromStudentIds![i];
              loginFieldResponse.enrollmentNumber = data.fields!.enrollmentNumberFromStudentIds![i];
              if (data.fields!.presentIds != null && data.fields!.presentIds!.contains(data.fields!.studentIds![i])) {
                loginFieldResponse.attendanceStatus = 1;
              } else {
                loginFieldResponse.attendanceStatus = 0;
              }
              var studentData = BaseApiResponseWithSerializable<LoginFieldsResponse>();
              studentData.id = data.fields?.studentIds![i];
              studentData.fields = loginFieldResponse;
              mainData.add(studentData);
            }
            mainData.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));

            studentList = List.from(mainData);
            studentList.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
          }
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

  String convertTo12HourFormat(String timeString) {
    final parsedTime = TimeOfDay.fromDateTime(DateTime.parse("2023-07-22 $timeString"));
    return DateFormat('hh:mm a').format(parsedTime.toDateTime());
  }


  void checkCurrentData() {
    var now = DateTime.now();
    if(widget.date!=null){
      now = widget.date??DateTime.now();
    }
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    print(formattedDate);

    var timeFormatter = DateFormat('hh:mm aa');
    var dateTime = DateTime.now();
    formattedTime = timeFormatter.format(dateTime);


    if(widget.time!=null){
      print('../ time ${widget.time}');
      formattedTime = convertTo12HourFormat(widget.time!);
    }

    print(formattedTime);
  }

  List<GlobalKey<CustomRadioButtonState<String>>> key = [];

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
                    formattedDate = formatter.format(pickedDate);
                  });
                });
              },
            ),
            GestureDetector(
              child: custom_text(text: "${strings_name.str_select_time} : $formattedTime", textStyles: blackTextSemiBold16),
              onTap: () {
                DateTime dateTime = DateFormat("hh:mm aa").parse(formattedTime);
                TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);

                showTimePicker(context: context, initialTime: timeOfDay).then((pickedTime) {
                  if (pickedTime == null) {
                    return;
                  }
                  setState(() {
                    var formatter = DateFormat('hh:mm aa');
                    var dateTime = DateTime.now();
                    var time = DateTime(dateTime.year, dateTime.month, dateTime.day, pickedTime.hour, pickedTime.minute);
                    formattedTime = formatter.format(time);
                  });
                });
              },
            ),
            CustomEditTextSearch(
              type: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: controllerSearch,
              onChanges: (value) {
                filterResult(value);
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
                                    custom_text(topValue: 0, bottomValue: 10, text: "Enrollment No: ${studentList[index].fields?.enrollmentNumber}", textStyles: blackTextSemiBold14),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              studentList[index].fields?.attendanceStatus = 1;
                                              for (int i = 0; i < mainData.length; i++) {
                                                if (studentList[index].fields!.enrollmentNumber == mainData[i].fields!.enrollmentNumber) {
                                                  mainData[i].fields!.attendanceStatus = studentList[index].fields!.attendanceStatus;
                                                }
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(color: studentList[index].fields?.attendanceStatus == 1 ? colors_name.colorPrimary : Theme.of(context).cardColor, border: Border.all(color: colors_name.colorDark)),
                                                child: custom_text(text: strings_name.str_present, textStyles: studentList[index].fields?.attendanceStatus == 1 ? whiteText14 : blackText14, topValue: 5, bottomValue: 5, leftValue: 15, rightValue: 15))),
                                        SizedBox(width: 8.h),
                                        GestureDetector(
                                            onTap: () {
                                              studentList[index].fields?.attendanceStatus = 0;
                                              for (int i = 0; i < mainData.length; i++) {
                                                if (studentList[index].fields!.enrollmentNumber == mainData[i].fields!.enrollmentNumber) {
                                                  mainData[i].fields!.attendanceStatus = studentList[index].fields!.attendanceStatus;
                                                }
                                              }
                                              setState(() {});
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(color: studentList[index].fields?.attendanceStatus == 0 ? colors_name.colorPrimary : Theme.of(context).cardColor, border: Border.all(color: colors_name.colorDark)),
                                                child: custom_text(text: strings_name.str_absent, textStyles: studentList[index].fields?.attendanceStatus == 0 ? whiteText14 : blackText14, topValue: 5, bottomValue: 5, leftValue: 15, rightValue: 15)))
                                      ],
                                    ),
/*                                    CustomRadioButton(
                                      unSelectedColor: Theme.of(context).cardColor,
                                      buttonLables: [strings_name.str_present, strings_name.str_absent],
                                      buttonValues: [strings_name.str_present, strings_name.str_absent],
                                      radioButtonValue: (value) {
                                        if (value == strings_name.str_present) {
                                          studentList[index].fields?.attendanceStatus = 1;
                                        } else if (value == strings_name.str_absent) {
                                          studentList[index].fields?.attendanceStatus = 0;
                                        }
                                        key[index].currentState?.selectButton(value);
                                        for (int i = 0; i < mainData.length; i++) {
                                          if (studentList[index].fields!.mobileNumber == mainData[i].fields!.mobileNumber) {
                                            mainData[i].fields!.attendanceStatus = studentList[index].fields!.attendanceStatus;
                                          }
                                        }
                                        setState(() {});
                                      },
                                      selectedColor: colors_name.colorPrimary,
                                      defaultSelected: studentList[index].fields?.attendanceStatus == 1 ? strings_name.str_present : strings_name.str_absent,
                                    ),*/
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
                } else if (formattedTime.trim().isEmpty) {
                  Utils.showSnackBar(context, strings_name.str_empty_select_time);
                } else {
                  controllerSearch.text = "";
                  filterResult("");

                  var pending = false;
                  for (var i = 0; i < studentList.length; i++) {
                    if (studentList[i].fields?.attendanceStatus == -1) {
                      pending = true;
                      break;
                    }
                  }

                  if (!pending) {
                    confirmationDialog();
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

  Future<void> confirmationDialog() async {
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

    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            custom_text(text: 'Please confirm the attendance', textStyles: boldTitlePrimaryColorStyle),
            SizedBox(height: 5.h),
            custom_text(
              text: 'Total Students : ${studentIds.length}',
              textStyles: blackTextSemiBold14,
            ),
            custom_text(
              text: 'Present Students : ${presentIds.length}',
              textStyles: blackTextSemiBold14,
              bottomValue: 0,
            ),
            custom_text(
              text: 'Absent Students : ${absentIds.length}',
              textStyles: blackTextSemiBold14,
            ),
            Row(
              children: [
                SizedBox(width: 5),
                Expanded(
                    child: CustomButton(
                        text: strings_name.str_submit,
                        click: () {
                          Get.back(closeOverlays: true);
                          submitAttendance();
                        })),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: CustomButton(
                        text: strings_name.str_cancle,
                        click: () {
                          Get.back(closeOverlays: true);
                        })),
                SizedBox(width: 5),
              ],
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
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
    try {
      if (fromEdit) {
        AddStudentAttendanceRequest request = AddStudentAttendanceRequest();
        request.studentIds = studentIds;
        request.presentIds = presentIds;
        request.absentIds = absentIds;
        request.lectureDate = formattedDate;
        request.lectureTime = formattedTime;

        var json = request.toJson();
        json.removeWhere((key, value) => value == null);

        var resp = await apiRepository.updateStudentAttendanceApi(json, lectureId);
        if (resp.id!.isNotEmpty) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_attendance_updated);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(closeOverlays: true, result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      } else {
        AddStudentAttendanceRequest request = Get.arguments[1]["request"];
        request.studentIds = studentIds;
        request.presentIds = presentIds;
        request.absentIds = absentIds;
        request.lectureDate = formattedDate;
        request.lectureTime = formattedTime;

        var resp = await apiRepository.addStudentAttendanceApi(request);
        if (resp.id!.isNotEmpty) {
          if(widget.timeTableData == null){
            setState(() {
              isVisible = false;
            });
            Utils.showSnackBar(context, strings_name.str_attendance_recorded);
            await Future.delayed(const Duration(milliseconds: 2000));
            Get.back(closeOverlays: true, result: true);
          }else{
            updateTimeTableRecord();
          }

        } else {
          setState(() {
            isVisible = false;
          });
        }
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  updateTimeTableRecord() async {
    try {
      UpdateTimeTableRequest? updateTimeTableModel;
      var data = timeTableData?.fields;
        updateTimeTableModel = UpdateTimeTableRequest(
          records: [
            UpdateRecord(
              id: timeTableData?.id??'',
              fields: UpdateFields(
                  date: timeTableData?.fields?.date??'',
                  isHoliday: data?.isHoliday,
                  startTime: data?.startTime,
                  endTime: data?.endTime,
                  holidayTitle: data?.holidayTitle,
                  hubId: data?.hubId??[],
                  specializationId: data?.specializationId,
                  semester: data?.semester,
                  division: data?.division,
                  lectureId: data?.lectureId??[],
                  subjectId: data?.subjectId??[],
                  createdBy: data?.createdBy??[],
                  updatedBy: data?.updatedBy,
                  mode: data?.mode,
                  modeTitle: data?.modeTitle,
                  isAttendanceTaken : true
              ),
            )
          ],
        );

      debugPrint('../ updateTimeTableModel ${jsonEncode(updateTimeTableModel.toJson())}');

      var resp = await apiRepository.updateTimeTableDataApi(updateTimeTableModel.toJson(),timeTableData?.id??'');

      if (resp.records?.isNotEmpty ?? false) {
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
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
    catch(e){
      setState(() {
        isVisible = false;
      });
      final errorMessage = e.toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  void filterResult(String value) {
    if (value.isEmpty) {
      studentList = [];
      studentList = List.from(mainData);
      setState(() {});
    } else {
      studentList = [];
      setState(() {});
      for (var i = 0; i < mainData.length; i++) {
        if (mainData[i].fields!.name!.toLowerCase().contains(value.toLowerCase())) {
          studentList.add(mainData[i]);
        }
      }
      setState(() {});
    }
  }
}
