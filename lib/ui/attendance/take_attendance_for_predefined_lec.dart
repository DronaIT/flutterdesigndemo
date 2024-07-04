import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_text.dart';
import '../../models/add_time_table_response.dart';
import '../../models/base_api_response.dart';
import '../../models/login_fields_response.dart';
import '../../models/request/add_student_attendance_request.dart';
import '../../models/topics_response.dart';
import '../../models/units_response.dart';
import '../../utils/preference.dart';
import '../../utils/tablenames.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';
import '../time_table/time_table_list.dart';
import 'attendance_student_list.dart';

class TakeAttendanceForPredefinedLec extends StatefulWidget {
  const TakeAttendanceForPredefinedLec({super.key});

  @override
  State<TakeAttendanceForPredefinedLec> createState() => _TakeAttendanceForPredefinedLecState();
}

class _TakeAttendanceForPredefinedLecState extends State<TakeAttendanceForPredefinedLec> {
  bool isLoading = false;

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";

  List<BaseApiResponseWithSerializable<TimeTableResponseClass>> timeTables = [];

  List<BaseApiResponseWithSerializable<UnitsResponse>>? unitResponseArray = [];
  BaseApiResponseWithSerializable<UnitsResponse>? unitResponse;
  String unitValue = "";
  String unitRecordId = "";

  List<BaseApiResponseWithSerializable<TopicsResponse>>? topicResponseArray = [];
  BaseApiResponseWithSerializable<TopicsResponse>? topicResponse;
  String topicValue = "";
  String topicRecordId = "";

  bool canAddTimeTable = false;
  bool canUpdateTimeTable = false;
  bool canShowTimeTable = false;
  bool canShowAllTimeTable = false;

  String createdBy = "";

  loading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  var roleId = "";

  @override
  void initState() {
    // TODO: implement initState
    createdBy = PreferenceUtils.getLoginRecordId();
    super.initState();
    init();
  }

  init() async {
    await checkPermission();
    fetchTimeTable();
  }

  var loginData;
  String loginType = "";
  var employeeId;
  var loginId = "";

  checkPermission() async {
    loading(true);
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 2) {
      loginData = PreferenceUtils.getLoginDataEmployee();
      roleId = loginData.roleIdFromRoleIds!.join(',');
      loginId = loginData.employeeId.toString();
      employeeId = loginData.employeeId;
      loginType = TableNames.ANNOUNCEMENT_ROLE_EMPLOYEE;

      var query = "AND(FIND('$roleId',role_ids)>0,module_ids='${TableNames.MODULE_TIME_TABLE}')";
      try {
        var data = await apiRepository.getPermissionsApi(query);
        if (data.records!.isNotEmpty) {
          for (var i = 0; i < data.records!.length; i++) {
            if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_TIME_TABLE) {
              canAddTimeTable = true;
            } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_TIME_TABLE) {
              canUpdateTimeTable = true;
            } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_TIME_TABLE) {
              canShowTimeTable = true;
            } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_ALL_TIME_TABLE) {
              canShowAllTimeTable = true;
              // debugPrint('../ canShowAllTimeTable $canShowAllTimeTable');
            }
          }
        }
        debugPrint('../ canShowTimeTable $canShowAllTimeTable');
        debugPrint('../ canShowAllTimeTable $canShowAllTimeTable');
      } on DioError catch (e) {
        debugPrint('../ permission error $e');
      }
    }
  }

  TextEditingController _tcDateRange = TextEditingController();

  String formatDate(String inputDate) {
    // Convert the input date string to DateTime format
    DateTime dateTime = DateFormat('dd/MM/yyyy').parse(inputDate);
    debugPrint('../ date Time $dateTime');
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  List<String> splitAndReFormatDate(String value) {
    List<String> dates = value.replaceAll(' ', '').split('-');
    String startDateFormatted = formatDate(dates[0]);
    String endDateFormatted = formatDate(dates[1]);
    return [startDateFormatted, endDateFormatted];
  }

  fetchTimeTable() async {
    loading(true);
    try {
      var isLogin = PreferenceUtils.getIsLogin();
      if (isLogin != 2) {
        return;
      } else {
        var loginData = PreferenceUtils.getLoginDataEmployee();
        String hubValue = loginData.hubIdFromHubIds![0];
        var loginId = loginData.employeeId.toString();
        var query = "";
        debugPrint('../ hub id is $hubValue');
        if (_tcDateRange.text.isEmpty) {
          // query = "AND({lecture_id} = $loginId,{date} = TODAY())";
          // query = "AND(OR({created_by} = $loginId,{lecture_id} = $loginId),{date} = TODAY())";
          if (canShowAllTimeTable) {
            query = "AND({date} = TODAY())";
          } else {
            query = "AND(OR({created_by} = $loginId,{lecture_id} = $loginId,{proxy_taker}=$loginId,AND(FIND(\"$hubValue\", ARRAYJOIN({hub_id (from hub_id)})),{is_holiday} = 1)),{date} = TODAY())";
          }
        } else {
          List<String> dates = splitAndReFormatDate(_rangeToSend);
          if (canShowAllTimeTable) {
            query = "AND({date} >= '${dates[0]}', {date} <= '${dates[1]}')";
          } else {
            query = "AND(OR({created_by} = $loginId,{lecture_id} = $loginId,{proxy_taker}=$loginId),{date} >= '${dates[0]}', {date} <= '${dates[1]}')";
          }
        }
        debugPrint('../ query $query');
        var data = await apiRepository.fetchTimeTablesListApi(query, offset);
        if (data.records!.isNotEmpty) {
          timeTables.addAll(data.records as Iterable<BaseApiResponseWithSerializable<TimeTableResponseClass>>);
          for (int i = 0; i < timeTables.length; i++) {
            if (timeTables[i].fields?.status == strings_name.str_status_lecture_cancelled) {
              timeTables.removeAt(i);
              i--;
            }
          }
          offset = data.offset;
          if (offset.isNotEmpty) {
            fetchTimeTable();
          }
          loading(false);
        } else {
          loading(false);
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
      loading(false);
    } catch (e) {
      loading(false);
      Utils.showSnackBar(context, e.toString());
    }
  }

  selectUnitAndTopicDropDown(BaseApiResponseWithSerializable<TimeTableResponseClass> timeTableData) {
    topicResponseArray?.clear();
    var fetchUnit = getUnits();
    String offset = "";
    bool isVisible = false;
    unitValue = "";
    topicValue = "";
    List<BaseApiResponseWithSerializable<LoginFieldsResponse>> studentList = [];
    return Get.defaultDialog(
      titlePadding: EdgeInsets.only(top: 12.h, bottom: 10.h),
      contentPadding: EdgeInsets.symmetric(horizontal: 30.w),
      title: strings_name.str_select_unit_and_topic,
      content: StatefulBuilder(
        builder: (context, setState) {
          Future<void> getTopics() async {
            if (unitValue.isNotEmpty) {
              setState(() {
                topicResponseArray?.clear();
                isDialogDropDownLoading = true;
              });
              debugPrint('../ unitValue $unitValue');
              var query = "FIND('$unitValue', ${TableNames.CLM_UNIT_IDS}, 0)";
              try {
                var data = await apiRepository.getTopicsApi(query);
                setState(() {
                  topicResponse = null;
                  topicResponseArray = data.records;
                  isDialogDropDownLoading = false;
                });
                if (data.records?.isEmpty == true) {
                  Utils.showSnackBar(context, strings_name.str_no_topic_assigned);
                }
              } on DioError catch (e) {
                setState(() {
                  isDialogDropDownLoading = false;
                });
                final errorMessage = DioExceptions.fromDioError(e).toString();
                Utils.showSnackBarUsingGet(errorMessage);
              }
            }
          }

          Future<void> getStudents() async {
            setState(() {
              isVisible = true;
            });
            var query = "AND(";
            query += "SEARCH('${timeTableData.fields?.hubIdFromHubId![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}), 0)";
            query += ",SEARCH('${timeTableData.fields?.specializationIdFromSpecializationId![0]}',ARRAYJOIN({${TableNames.CLM_SPE_ID_FROM_SPE_IDS}}), 0)";
            query += ",FIND('${timeTableData.fields?.semester}', {${TableNames.CLM_SEMESTER}}, 0)";
            query += ",FIND('${timeTableData.fields?.division}', {${TableNames.CLM_DIVISION}}, 0)";
            query += ")";
            debugPrint(query);
            try {
              var data = await apiRepository.loginApi(query, offset);
              if (data.records!.isNotEmpty) {
                if (offset.isEmpty) {
                  studentList.clear();
                }
                studentList.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
                offset = data.offset;
                if (offset.isNotEmpty) {
                  getStudents();
                } else {
                  setState(() {
                    isVisible = false;
                  });
                  studentList.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));

                  // debugPrint('../ start time ${ timeTableData.fields!.startTime}');
                  // debugPrint('../ endTime time ${ timeTableData.fields!.endTime}');

                  Duration difference = getHourDifference(timeTableData.fields!.startTime ?? '', timeTableData.fields!.endTime ?? '');
                  int differenceInHours = difference.inHours;

                  if (differenceInHours <= 1) {
                    differenceInHours = 1;
                  } else {
                    differenceInHours = 2;
                  }

                  // debugPrint('../ duration in hour $differenceInHours');

                  AddStudentAttendanceRequest request = AddStudentAttendanceRequest();
                  // request.employeeId = PreferenceUtils.getLoginRecordId().split(",");
                  request.employeeId = timeTableData.fields!.proxy_taker?.isNotEmpty == true ? timeTableData.fields?.proxy_taker : timeTableData.fields!.lectureId;
                  request.hubId = timeTableData.fields!.hubId!;
                  request.specializationId = timeTableData.fields!.specializationId!;
                  request.division = '${timeTableData.fields?.division}';
                  request.subjectId = timeTableData.fields!.subjectId;
                  request.unitId = unitRecordId.split(",");
                  request.topicId = topicRecordId.split(",");
                  request.lecture_duration = '$differenceInHours Hour';
                  request.semesterByStudent = '${timeTableData.fields?.semester}';
                  debugPrint('../ timeTableData pre define lec $timeTableData');
                  Get.off(
                      AttendanceStudentList(
                        timeTableData: timeTableData,
                        date: DateTime.parse(timeTableData.fields?.date ?? ''),
                        time: timeTableData.fields?.startTime ?? '',
                      ),
                      arguments: [
                        {"studentList": studentList},
                        {"request": request},
                      ])?.then((result) {
                    if (result != null && result) {
                      Get.back(closeOverlays: true);
                    }
                  });
                }
              } else {
                setState(() {
                  isVisible = false;
                  if (offset.isEmpty) {
                    studentList = [];
                    Utils.showSnackBar(context, strings_name.str_no_students);
                  }
                });
                offset = "";
              }
            } on DioError catch (e) {
              setState(() {
                isVisible = false;
              });
              final errorMessage = DioExceptions.fromDioError(e).toString();
              Utils.showSnackBarUsingGet(errorMessage);
            }
          }

          return Column(
            children: [
              FutureBuilder(
                  future: fetchUnit,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: colors_name.colorPrimary,
                      ));
                    } else {
                      return unitResponseArray!.isNotEmpty
                          ? Column(
                              children: [
                                const custom_text(
                                  text: strings_name.str_view_unit,
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
                                        width: 1.sw,
                                        child: DropdownButtonFormField<BaseApiResponseWithSerializable<UnitsResponse>>(
                                          value: unitResponse,
                                          elevation: 16,
                                          isExpanded: true,
                                          style: blackText16,
                                          focusColor: Colors.white,
                                          onChanged: (BaseApiResponseWithSerializable<UnitsResponse>? newValue) {
                                            setState(() {
                                              unitValue = newValue!.fields!.ids!.toString();
                                              unitResponse = newValue;
                                              unitRecordId = newValue.id!;
                                              topicValue = '';
                                              getTopics();
                                            });
                                          },
                                          items: unitResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<UnitsResponse>>>((BaseApiResponseWithSerializable<UnitsResponse> value) {
                                            return DropdownMenuItem<BaseApiResponseWithSerializable<UnitsResponse>>(
                                              value: value,
                                              child: Text(value.fields!.unitTitle!.toString()),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox();
                    }
                  }),
              topicResponseArray!.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(height: 10.h),
                        const custom_text(
                          text: strings_name.str_view_topic,
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
                                width: 1.sw,
                                child: DropdownButtonFormField<BaseApiResponseWithSerializable<TopicsResponse>>(
                                  value: topicResponse,
                                  elevation: 16,
                                  isExpanded: true,
                                  style: blackText16,
                                  focusColor: Colors.white,
                                  onChanged: (BaseApiResponseWithSerializable<TopicsResponse>? newValue) {
                                    topicValue = newValue!.fields!.ids!.toString();
                                    topicResponse = newValue;
                                    topicRecordId = newValue.id!;
                                  },
                                  items: topicResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<TopicsResponse>>>((BaseApiResponseWithSerializable<TopicsResponse> value) {
                                    return DropdownMenuItem<BaseApiResponseWithSerializable<TopicsResponse>>(
                                      value: value,
                                      child: Text(value.fields!.topicTitle!.toString()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : isDialogDropDownLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: colors_name.colorPrimary,
                          ),
                        )
                      : Container(),
              SizedBox(
                height: 10.h,
              ),
              isVisible
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: colors_name.colorPrimary,
                      ),
                    )
                  : CustomButton(
                      text: strings_name.str_submit,
                      click: () async {
                        if (unitValue.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_unit);
                        } else if (topicValue.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_topic);
                        } else {
                          getStudents();
                        }
                      },
                    )
            ],
          );
        },
      ),
    );
  }

  Duration getHourDifference(String startTimeStr, String endTimeStr) {
    List<String> startTimeParts = startTimeStr.split(':');
    List<String> endTimeParts = endTimeStr.split(':');

    int startHour = int.parse(startTimeParts[0]);
    int startMinute = int.parse(startTimeParts[1]);

    int endHour = int.parse(endTimeParts[0]);
    int endMinute = int.parse(endTimeParts[1]);

    int totalStartMinutes = startHour * 60 + startMinute;
    int totalEndMinutes = endHour * 60 + endMinute;

    int differenceInMinutes = totalEndMinutes - totalStartMinutes;

    return Duration(minutes: differenceInMinutes);
  }

  bool isDialogDropDownLoading = false;

  String subjectValue = "";

  Future<void> getUnits() async {
    debugPrint('../ subjectValue value $subjectValue');
    if (subjectValue.isNotEmpty) {
      var query = "FIND('$subjectValue', ${TableNames.CLM_SUBJECT_IDS}, 0)";
      try {
        var data = await apiRepository.getUnitsApi(query);
        setState(() {
          unitResponse = null;
          unitResponseArray = data.records;

          topicResponse = null;
        });
        if (data.records?.isEmpty == true) {
          Utils.showSnackBar(context, strings_name.str_no_unit_assigned);
        }
      } on DioError catch (e) {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        Utils.showSnackBarUsingGet(errorMessage);
      }
    }
  }

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '', _rangeToSend = '';
  String _rangeCount = '';

  setDateRange() {
    _tcDateRange.text = _range;
    if (_tcDateRange.text.isNotEmpty) {
      timeTables.clear();
      fetchTimeTable();
    }
  }

  DateTime? startDate, endDate;

  Future<void> _showDatePicker() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(strings_name.str_data_range),
          content: SizedBox(
            height: 350,
            width: 095.w,
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              // initialSelectedRange: PickerDateRange(DateTime.now().subtract(const Duration(days: 4)), DateTime.now().add(const Duration(days: 3),),
              // initialSelectedRange: PickerDateRange(DateTime.now().subtract(const Duration(days: 4)), DateTime.now().add(const Duration(days: 3),),),
              initialSelectedRange: startDate == null && endDate == null ? null : PickerDateRange(startDate, endDate),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(strings_name.str_done),
              onPressed: () {
                setDateRange();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        DateTime endD = args.value.endDate ?? args.value.startDate;
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} - ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        _rangeToSend = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} - ${DateFormat('dd/MM/yyyy').format(endD.add(const Duration(days: 1)))}';
        startDate = args.value.startDate;
        endDate = args.value.endDate ?? args.value.startDate;
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppWidgets.appBarWithoutBack(strings_name.str_take_attendance),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: colors_name.colorPrimary,
                  ),
                )
              : ListView(
                  children: [
                    SizedBox(height: 10.h),
                    const custom_text(
                      text: strings_name.str_range_r,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      width: 1.sw,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _tcDateRange,
                              onTap: () {
                                _showDatePicker();
                              },
                              readOnly: true,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: colors_name.colorBlack,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _tcDateRange.text.isNotEmpty,
                            child: IconButton(
                                onPressed: () {
                                  timeTables.clear();
                                  _tcDateRange.clear();
                                  startDate = null;
                                  endDate = null;
                                  _range = '';
                                  fetchTimeTable();
                                },
                                icon: const Icon(Icons.clear)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    !canShowTimeTable && !canShowAllTimeTable
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.0.h),
                            child: const Center(
                              child: Text(strings_name.str_you_do_not_have_permission_time_table),
                            ),
                          )
                        : timeTables.isEmpty
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.0.h),
                                child: const Center(
                                  child: Text(strings_name.str_no_time_table_found),
                                ),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: timeTables.length,
                                itemBuilder: (context, index) {
                                  return TimeTableCard(
                                    data: timeTables[index],
                                    onTap: () {
                                      debugPrint('../ timeTables ${timeTables[index].fields?.toJson()}');
                                      if ((timeTables[index].fields?.createdBy?.contains(createdBy) ?? false) ||
                                          (timeTables[index].fields?.proxy_taker?.isNotEmpty == true
                                              ? (timeTables[index].fields?.proxy_taker?.contains(createdBy) ?? false)
                                              : (timeTables[index].fields?.lectureId?.contains(createdBy) ?? false))) {
                                        if (timeTables[index].fields?.isAttendanceTaken ?? false) {
                                          Utils.showSnackBarUsingGet(strings_name.str_attendance_already_taken);
                                        } else {
                                          subjectValue = timeTables[index].fields?.subjectIdFromSubjectId?[0].toString() ?? '';
                                          selectUnitAndTopicDropDown(timeTables[index]);
                                        }
                                      } else {
                                        Utils.showSnackBarUsingGet(strings_name.str_not_per_atek_attedndance);
                                      }
                                    },
                                  );
                                },
                              ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                )),
    );
  }
}
