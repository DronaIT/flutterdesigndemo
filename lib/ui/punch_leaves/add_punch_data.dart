import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/request/add_punch_request.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/ui/punch_leaves/single_employee_selection.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddPunchData extends StatefulWidget {
  const AddPunchData({super.key});

  @override
  State<AddPunchData> createState() => _AddPunchDataState();
}

class _AddPunchDataState extends State<AddPunchData> {
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? employeeData = [];
  var fromUpdate = false;

  String formattedDate = "";
  String formattedTime = "";

  TextEditingController punchInTimeController = TextEditingController();
  TextEditingController punchOutTimeController = TextEditingController();
  TextEditingController reasonForLeaveController = TextEditingController();

  /*
  *   -1 => Present, 0 => Full Day, 1 => First Half, 2 => Second Half
  */
  int leaveType = -1;
  String? punchResponseId;

  @override
  void initState() {
    super.initState();
    checkCurrentData();
  }

  void checkCurrentData() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    debugPrint(formattedDate);

    var timeFormatter = DateFormat('hh:mm aa');
    var dateTime = DateTime.now();
    formattedTime = timeFormatter.format(dateTime);
    debugPrint(formattedTime);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(fromUpdate ? strings_name.str_update_punch_record : strings_name.str_add_punch_record),
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  child: Container(
                    color: colors_name.colorWhite,
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.h),
                    child: employeeData?.isNotEmpty == true
                        ? Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(const SingleEmployeeSelection(), arguments: employeeData)?.then((result) {
                                    if (result != null) {
                                      setState(() {
                                        employeeData = result;
                                      });
                                    }
                                  });
                                },
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(employeeData?.last.fields?.employeeName ?? "", textAlign: TextAlign.center, style: blackTextSemiBold16),
                                  Icon(Icons.edit_outlined, size: 25.h, color: colors_name.colorPrimary),
                                ]),
                              ),
                              custom_text(
                                text: "${strings_name.str_designation}: ${employeeData?.last.fields?.roleTitleFromRoleIds?.last ?? ''}",
                                textStyles: blackText16,
                                topValue: 5,
                                leftValue: 0,
                                maxLines: 2,
                                bottomValue: 0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Utils.launchCaller(employeeData?.last.fields?.mobileNumber ?? "");
                                },
                                child: custom_text(
                                  text: employeeData?.last.fields?.mobileNumber ?? "",
                                  textStyles: linkTextSemiBold16,
                                  topValue: 5,
                                  leftValue: 0,
                                  bottomValue: 0,
                                ),
                              ),
                              custom_text(
                                text: "${strings_name.str_actual_punch_in_time}: ${employeeData?.last.fields?.actual_in_time ?? ''}",
                                textStyles: blackText16,
                                topValue: 5,
                                leftValue: 0,
                                bottomValue: 0,
                              ),
                              custom_text(
                                text: "${strings_name.str_actual_punch_out_time}: ${employeeData?.last.fields?.actual_out_time ?? ''}",
                                textStyles: blackText16,
                                topValue: 5,
                                leftValue: 0,
                                bottomValue: 0,
                              ),
                            ],
                          )
                        : GestureDetector(
                            onTap: () {
                              Get.to(const SingleEmployeeSelection(), arguments: employeeData)?.then((result) {
                                if (result != null) {
                                  setState(() {
                                    employeeData = result;
                                  });
                                }
                              });
                            },
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const Text(strings_name.str_select_employee, textAlign: TextAlign.center, style: blackTextSemiBold16),
                              Icon(Icons.keyboard_arrow_right, size: 25.h, color: colors_name.colorPrimary),
                            ]),
                          ),
                  ),
                ),
                SizedBox(height: 5.h),
                GestureDetector(
                  child: custom_text(text: "${strings_name.str_punch_date} : $formattedDate", textStyles: blackTextSemiBold16),
                  onTap: () {
                    showDatePicker(context: context, initialDate: DateTime.parse(formattedDate), firstDate: DateTime(2005), lastDate: DateTime.now())
                        .then((pickedDate) {
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
                custom_text(
                  topValue: 5,
                  text: strings_name.str_punch_time,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                Row(children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: InkWell(
                      child: IgnorePointer(
                        child: custom_edittext(
                          hintText: strings_name.str_punch_time_in,
                          type: TextInputType.none,
                          textInputAction: TextInputAction.next,
                          controller: punchInTimeController,
                          topValue: 0,
                        ),
                      ),
                      onTap: () {
                        TimeOfDay timeOfDay = TimeOfDay.now();
                        if (punchInTimeController.text.isNotEmpty) {
                          DateTime dateTime = DateFormat("hh:mm aa").parse(punchInTimeController.text);
                          timeOfDay = TimeOfDay.fromDateTime(dateTime);
                        }
                        showTimePicker(
                          context: context,
                          initialTime: timeOfDay,
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                              child: child!,
                            );
                          },
                        ).then((pickedTime) {
                          if (pickedTime == null) {
                            return;
                          }
                          setState(() {
                            var formatter = DateFormat('hh:mm aa');
                            var dateTime = DateTime.now();
                            var time = DateTime(dateTime.year, dateTime.month, dateTime.day, pickedTime.hour, pickedTime.minute);
                            punchInTimeController.text = formatter.format(time);
                            if (leaveType == 0) {
                              leaveType = -1;
                            }
                          });
                        });
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: InkWell(
                      child: IgnorePointer(
                        child: custom_edittext(
                          hintText: strings_name.str_punch_time_out,
                          type: TextInputType.none,
                          textInputAction: TextInputAction.next,
                          controller: punchOutTimeController,
                          topValue: 0,
                        ),
                      ),
                      onTap: () {
                        TimeOfDay timeOfDay = TimeOfDay.now();
                        if (punchOutTimeController.text.isNotEmpty) {
                          DateTime dateTime = DateFormat("hh:mm aa").parse(punchOutTimeController.text);
                          timeOfDay = TimeOfDay.fromDateTime(dateTime);
                        }
                        showTimePicker(
                          context: context,
                          initialTime: timeOfDay,
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                              child: child!,
                            );
                          },
                        ).then((pickedTime) {
                          if (pickedTime == null) {
                            return;
                          }
                          setState(() {
                            var formatter = DateFormat('hh:mm aa');
                            var dateTime = DateTime.now();
                            var time = DateTime(dateTime.year, dateTime.month, dateTime.day, pickedTime.hour, pickedTime.minute);
                            punchOutTimeController.text = formatter.format(time);
                            if (leaveType == 0) {
                              leaveType = -1;
                            }
                          });
                        });
                      },
                    ),
                  ),
                ]),
                custom_text(
                  topValue: 15,
                  bottomValue: 5,
                  text: strings_name.str_on_leave,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: 30.h,
                      child: Checkbox(
                        value: leaveType == 0,
                        onChanged: (bool? value) {
                          if (value != null) {
                            if (value == true) {
                              leaveType = 0;
                              punchInTimeController.text = "";
                              punchOutTimeController.text = "";
                            } else {
                              leaveType = -1;
                            }
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    custom_text(
                        text: strings_name.str_full_day,
                        textStyles: blackTextSemiBold14,
                        topValue: 5,
                        maxLines: 1,
                        bottomValue: 5,
                        leftValue: 0), //Text
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: 30.h,
                      child: Checkbox(
                        value: leaveType == 1,
                        onChanged: (bool? value) {
                          if (value != null) {
                            leaveType = value ? 1 : -1;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    custom_text(
                        text: strings_name.str_first_half,
                        textStyles: blackTextSemiBold14,
                        topValue: 5,
                        maxLines: 1,
                        bottomValue: 5,
                        leftValue: 0), //Text
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      height: 30.h,
                      child: Checkbox(
                        value: leaveType == 2,
                        onChanged: (bool? value) {
                          if (value != null) {
                            leaveType = value ? 2 : -1;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    custom_text(
                        text: strings_name.str_second_half,
                        textStyles: blackTextSemiBold14,
                        topValue: 5,
                        maxLines: 1,
                        bottomValue: 5,
                        leftValue: 0), //Text
                  ],
                ),
                leaveType != -1
                    ? Column(
                        children: [
                          custom_text(
                            text: strings_name.str_reason_for_leave,
                            alignment: Alignment.topLeft,
                            textStyles: blackTextSemiBold16,
                          ),
                          custom_edittext(
                            type: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            controller: reasonForLeaveController,
                            minLines: 3,
                            maxLines: 3,
                            maxLength: 50000,
                            topValue: 0,
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 10.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    if (employeeData?.isNotEmpty != true) {
                      Utils.showSnackBar(context, strings_name.str_empty_select_employee);
                    } else if (formattedDate.isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_punch_date);
                    } else if (leaveType != 0) {
                      if (punchInTimeController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_punch_in_time);
                      } else if (punchOutTimeController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_punch_out_time);
                      } else if (leaveType != -1 && reasonForLeaveController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_reason_for_leave);
                      } else {
                        submitData();
                      }
                    } else if (leaveType == 0 && reasonForLeaveController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_reason_for_leave);
                    } else {
                      submitData();
                    }
                  },
                )
              ],
            ),
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

  submitData() async {
    setState(() {
      isVisible = true;
    });

    try {
      AddPunchRequest request = AddPunchRequest();
      request.employeeId = employeeData?.last.id?.split(",");
      request.punch_date = formattedDate;
      if (leaveType == -1) {
        request.attendance_type = TableNames.ATTENDANCE_TYPE_PRESENT;
      } else if (leaveType == 0) {
        request.attendance_type = TableNames.ATTENDANCE_TYPE_FULL_DAY_LEAVE;
      } else if (leaveType == 1) {
        request.attendance_type = TableNames.ATTENDANCE_TYPE_FIRST_HALF_LEAVE;
      } else if (leaveType == 2) {
        request.attendance_type = TableNames.ATTENDANCE_TYPE_SECOND_HALF_LEAVE;
      }

      if (leaveType != 0) {
        request.punch_in_time = punchInTimeController.text.trim();
        request.punch_out_time = punchOutTimeController.text.trim();
      }

      if (leaveType != -1) {
        request.reason_for_leave = reasonForLeaveController.text.trim();
      }

      var json = request.toJson();
      json.removeWhere((key, value) => value == null);

      if (fromUpdate) {
        var resp = await apiRepository.updatePunchRecord(json, punchResponseId!);
        if (resp.id != null) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_updated_fees_record);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      } else {
        var resp = await apiRepository.addPunchRecordApi(request);
        if (resp.id != null) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_added_fees_record);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      }
    } on Exception catch (e) {
      Utils.showSnackBar(context, strings_name.str_invalid_data);
      setState(() {
        isVisible = false;
      });
    }
  }
}
