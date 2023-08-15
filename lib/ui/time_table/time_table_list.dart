import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/add_button.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_text.dart';
import '../../models/add_time_table_response.dart';
import '../../models/base_api_response.dart';
import '../../models/hub_response.dart';
import '../../models/login_fields_response.dart';
import '../../models/request/add_student_attendance_request.dart';
import '../../models/specialization_response.dart';
import '../../models/subject_response.dart';
import '../../models/topics_response.dart';
import '../../models/units_response.dart';
import '../../utils/preference.dart';
import '../../utils/tablenames.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';
import '../attendence/attendance_student_list.dart';
import 'add_edit_time_table.dart';

class TimeTableList extends StatefulWidget {
  const TimeTableList({super.key});

  @override
  State<TimeTableList> createState() => _TimeTableListState();
}

class _TimeTableListState extends State<TimeTableList> {
  bool canAddTimeTable = false;
  bool canUpdateTimeTable = false;
  bool canShowTimeTable = false;
  bool canShowAllTimeTable = false;

  bool isLoading = false;
  var loginId = "";
  var loginData;
  String loginType = "";

  var employeeId;
  var roleId = "";

  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  String hubRecordId = "";

  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationResponseArray = [];
  BaseApiResponseWithSerializable<SpecializationResponse>? specializationResponse;
  String specializationValue = "";
  String specializationRecordId = "";

  List<int> semesterResponseArray = <int>[1, 2, 3, 4, 5, 6];
  int semesterValue = -1;

  List<String> divisionResponseArray = <String>[TableNames.DIVISION_A, TableNames.DIVISION_B, TableNames.DIVISION_C, TableNames.DIVISION_D];
  String divisionValue = "";

  List<String> lectureHourResponseArray = <String>[TableNames.ONE_HOUR, TableNames.TWO_HOUR];
  String lectureValue = "";

  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectResponseArray = [];
  BaseApiResponseWithSerializable<SubjectResponse>? subjectResponse;
  String subjectValue = "";
  String subjectRecordId = "";

  List<BaseApiResponseWithSerializable<UnitsResponse>>? unitResponseArray = [];
  BaseApiResponseWithSerializable<UnitsResponse>? unitResponse;
  String unitValue = "";
  String unitRecordId = "";

  List<BaseApiResponseWithSerializable<TopicsResponse>>? topicResponseArray = [];
  BaseApiResponseWithSerializable<TopicsResponse>? topicResponse;
  String topicValue = "";
  String topicRecordId = "";

  bool isSpeLoading = false;
  bool isSubLoading = false;

  final apiRepository = getIt.get<ApiRepository>();

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  String offset = "";

  String createdBy = "";

  TextEditingController _tcDateRange = TextEditingController();

  List<BaseApiResponseWithSerializable<TimeTableResponseClass>> timeTables = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
    init();
  }

  init() {
    hubResponseArray = PreferenceUtils.getHubList().records;
    createdBy = PreferenceUtils.getLoginRecordId();
    fetchLoginCred();
  }

  fetchLoginCred() async {
    setState(() {
      isLoading = true;
    });
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 2) {
      loginData = PreferenceUtils.getLoginDataEmployee();
      roleId = loginData.roleIdFromRoleIds!.join(',');
      loginId = loginData.employeeId.toString();
      employeeId = loginData.employeeId;
      loginType = TableNames.ANNOUNCEMENT_ROLE_EMPLOYEE;
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
    } else if (isLogin == 1) {
      roleId = TableNames.STUDENT_ROLE_ID;
      loginId = PreferenceUtils.getLoginData().studentId.toString();
      loginData = PreferenceUtils.getLoginData();
      loginType = TableNames.ANNOUNCEMENT_ROLE_STUDENT;
    } else if (isLogin == 3) {
      loginData = PreferenceUtils.getLoginDataOrganization();
      roleId = TableNames.ORGANIZATION_ROLE_ID;
      loginId = PreferenceUtils.getLoginDataOrganization().id.toString();
      loginType = TableNames.ANNOUNCEMENT_ROLE_ORGANIZATION;
    }
    await checkPermission();
    fetchTimeTableList();
  }

  checkPermission() async {
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
            debugPrint('../ canShowAllTimeTable $canShowAllTimeTable');
          }
        }
      }
    } on DioError catch (e) {
      debugPrint('../ permission error $e');
    }
  }

  bool isFilterTimeTable = false;

  filterTimeTable() {
    if (hubValue.trim().isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_campus);
      return;
    }
    // else if (specializationValue.trim().isEmpty) {
    //   Utils.showSnackBar(context, strings_name.str_empty_spe);
    //   return;
    // } else if (semesterValue == -1) {
    //   Utils.showSnackBar(context, strings_name.str_empty_semester);
    // } else if (divisionValue.trim().isEmpty) {
    //   Utils.showSnackBar(context, strings_name.str_empty_division);
    //   return;
    // } else if (_tcDateRange.text.isEmpty) {
    //   Utils.showSnackBar(context, strings_name.str_empty_date_range);
    //   return;
    // }
    isFilterTimeTable = true;
    clearAndFetchTimeTable();
  }

  String formatDate(String inputDate) {
    // Convert the input date string to DateTime format
    DateTime dateTime = DateFormat('dd/MM/yyyy').parse(inputDate);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  List<String> splitAndReFormatDate(String value) {
    List<String> dates = value.replaceAll(' ', '').split('-');
    String startDateFormatted = formatDate(dates[0]);
    String endDateFormatted = formatDate(dates[1]);
    return [startDateFormatted, endDateFormatted];
  }

  // fetchTimeTableList() async {
  //   try {
  //     var query = "";
  //     var isLogin = PreferenceUtils.getIsLogin();
  //
  //     if (isLogin == 1) {
  //       query = "OR(AND( FIND(\"${loginData.hubIdFromHubIds[0]}\", ARRAYJOIN({hub_id (from hub_id)})), {specialization_id (from specialization_id)} = '${loginData.specialization_name[0]}', {semester} = '${loginData.semester}', {division} = '${loginData.division}', {date} = TODAY()), AND(FIND(\"${loginData.hubIdFromHubIds[0]}\", ARRAYJOIN({hub_id (from hub_id)})), {is_holiday} = 1, {date} = TODAY()))";
  //     }else if(isLogin == 2){
  //       if (isFilterTimeTable) {
  //         List<String> dates = splitAndReFormatDate(_range);
  //         query = "AND( FIND(\"$hubValue\", ARRAYJOIN({hub_id})), {specialization_id} = '$specializationValue', {semester} = '$semesterValue', {division} = '$divisionValue', {date} >= '${dates[0]}', {date} <= '${dates[1]}')";
  //       } else {
  //         loginData = PreferenceUtils.getLoginDataEmployee();
  //         loginId = loginData.employeeId.toString();
  //         query = "AND({created_by} = $loginId,{date} = TODAY())";
  //         debugPrint('query $query');
  //       }
  //     }else {
  //       return;
  //     }
  //
  //     debugPrint('../ query is $query');
  //
  //     var data = await apiRepository.fetchTimeTablesListApi(query, offset);
  //     if (data.records!.isNotEmpty) {
  //       if (offset.isEmpty) {
  //         timeTables.clear();
  //       }
  //       timeTables.addAll(data.records as Iterable<BaseApiResponseWithSerializable<TimeTableResponseClass>>);
  //       offset = data.offset;
  //       if (offset.isNotEmpty) {
  //         fetchTimeTableList();
  //       }
  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } on DioError catch (e) {
  //     final errorMessage = DioExceptions.fromDioError(e).toString();
  //     Utils.showSnackBarUsingGet(errorMessage);
  //     setState(() {
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     Utils.showSnackBar(context, e.toString());
  //     debugPrint('error is $e');
  //   }
  // }

  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
      debugPrint('../load more call');
      if (offset.isNotEmpty) {
        fetchTimeTableList();
      }
    }
  }

  @override
  dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  fetchTimeTableList() async {
    try {
      var query = "";
      var isLogin = PreferenceUtils.getIsLogin();
      if (isLogin == 1) {
        query =
            "OR(AND( FIND(\"${loginData.hubIdFromHubIds[0]}\", ARRAYJOIN({hub_id (from hub_id)})), {specialization_id (from specialization_id)} = '${loginData.specializationIdFromSpecializationIds[0]}', {semester} = '${loginData.semester}', {division} = '${loginData.division}', {date} = TODAY()), AND(FIND(\"${loginData.hubIdFromHubIds[0]}\", ARRAYJOIN({hub_id (from hub_id)})), {is_holiday} = 1, {date} = TODAY()))";
      } else if (isLogin == 2) {
        if (isFilterTimeTable) {
          // query = "AND( OR({created_by} = $loginId,{lecture_id} = $loginId),FIND(\"$hubValue\", ARRAYJOIN({hub_id}))";
          // if(specializationValue.trim().isNotEmpty){
          //   query += ", {specialization_id} = '$specializationValue'";
          // }
          // if(semesterValue != -1){
          //   query += ", {semester} = '$semesterValue'";
          // }
          // if(divisionValue.trim().isNotEmpty){
          //   query += ", {division} = '$divisionValue'";
          // }
          // if (_tcDateRange.text.isNotEmpty) {
          //   List<String> dates = splitAndReFormatDate(_range);
          //   query += ", {date} >= '${dates[0]}', {date} <= '${dates[1]}'";
          // }
          // query += ")";

          query = "OR( AND(FIND(\"$hubValue\", ARRAYJOIN({hub_id})),{is_holiday} = 1),AND( ${canShowAllTimeTable ? '' : 'OR({created_by} = $loginId,{lecture_id} = $loginId),'}FIND(\"$hubValue\", ARRAYJOIN({hub_id}))";
          if (specializationValue.trim().isNotEmpty) {
            query += ", {specialization_id} = '$specializationValue'";
          }
          if (semesterValue != -1) {
            query += ", {semester} = '$semesterValue'";
          }
          if (divisionValue.trim().isNotEmpty) {
            query += ", {division} = '$divisionValue'";
          }
          if (_tcDateRange.text.isNotEmpty) {
            List<String> dates = splitAndReFormatDate(_range);
            query += ", {date} >= '${dates[0]}', {date} <= '${dates[1]}'";
          }
          query += "))";

          debugPrint('../ query is $query');
        } else {
          loginData = PreferenceUtils.getLoginDataEmployee();
          loginId = loginData.employeeId.toString();
          // query = "AND(OR({created_by} = $loginId,{lecture_id} = $loginId),{date} = TODAY())";

          if (canShowAllTimeTable) {
            query = "AND({date} = TODAY())";
          } else {
            String hubValue = loginData.hubIdFromHubIds![0];
            query = "AND(OR({created_by} = $loginId,{lecture_id} = $loginId,AND(FIND(\"$hubValue\", ARRAYJOIN({hub_id (from hub_id)})),{is_holiday} = 1)),{date} = TODAY())";
          }
        }
      } else {
        return;
      }

      debugPrint('../ query is $query');

      var data = await apiRepository.fetchTimeTablesListApi(query, offset, 25);
      if (data.records!.isNotEmpty) {
        // if (offset.isEmpty) {
        //   timeTables.clear();
        // }
        timeTables.addAll(data.records as Iterable<BaseApiResponseWithSerializable<TimeTableResponseClass>>);
        offset = data.offset;
        // if (offset.isNotEmpty) {
        //   fetchTimeTableList();
        // }
        // debugPrint('../ offset $offset');
        // debugPrint('../ offset runtimeType ${offset.runtimeType}');
        // debugPrint('../ offset runtimeType ${offset.isEmpty}');
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Utils.showSnackBar(context, e.toString());
      debugPrint('error is $e');
    }
  }

  Future<void> getSpecializations() async {
    if (hubValue.isNotEmpty) {
      setState(() {
        isSpeLoading = true;
      });
      specializationValue = "";

      var query = "FIND('${Utils.getHubIds(hubValue)}',${TableNames.CLM_HUB_IDS}, 0)";
      try {
        var speData = await apiRepository.getSpecializationDetailApi(query);
        setState(() {
          specializationResponse = null;
          specializationResponseArray = speData.records;
          isSpeLoading = false;
        });
        if (speData.records?.isEmpty == true) {
          Utils.showSnackBar(context, strings_name.str_no_specialization_assigned);
        }
      } on DioError catch (e) {
        setState(() {
          isSpeLoading = false;
        });
        final errorMessage = DioExceptions.fromDioError(e).toString();
        Utils.showSnackBarUsingGet(errorMessage);
      }
    }
  }

  Future<void> getSubjects() async {
    if (semesterValue != -1 && divisionValue.isNotEmpty) {
      setState(() {
        isSubLoading = true;
      });
      subjectValue = "";
      unitValue = "";
      topicValue = "";

      var query = "AND(FIND('$semesterValue', ${TableNames.CLM_SEMESTER}, 0),FIND('${Utils.getSpecializationIds(specializationValue)}',${TableNames.CLM_SPE_IDS}, 0))";
      try {
        var data = await apiRepository.getSubjectsApi(query);
        setState(() {
          subjectResponse = null;
          subjectResponseArray = data.records;

          unitResponse = null;
          topicResponse = null;

          isSubLoading = false;
        });
        if (data.records?.isEmpty == true) {
          Utils.showSnackBar(context, strings_name.str_no_subject_assigned);
        }
      } on DioError catch (e) {
        setState(() {
          isSubLoading = false;
        });
        final errorMessage = DioExceptions.fromDioError(e).toString();
        Utils.showSnackBarUsingGet(errorMessage);
      }
    }
  }

  clearAndFetchTimeTable() {
    setState(() {
      isLoading = true;
    });
    offset = "";
    timeTables.clear();
    fetchTimeTableList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_time_table),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: colors_name.colorPrimary,
              ),
            )
          : ListView(
              controller: _scrollController,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Visibility(
                    visible: canAddTimeTable,
                    child: AddButton(
                      title: strings_name.str_new_time_table_icon,
                      onTap: () async {
                        var data = await Get.to(const AddEditTimeTable());
                        if (data == TableNames.LUK_ADD_TIME_TABLE) {
                          clearAndFetchTimeTable();
                        }
                      },
                    )),
                Visibility(
                  visible: canAddTimeTable,
                  child: SizedBox(
                    height: 20.h,
                  ),
                ),
                Visibility(
                  visible: canAddTimeTable,
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: colors_name.textColorGreyLight,
                        indent: 90.w,
                      )),
                      SizedBox(
                        width: 16.w,
                      ),
                      const Text(
                        strings_name.str_or,
                        style: greyDarkTextStyle12WH,
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Expanded(child: Divider(color: colors_name.textColorGreyLight, endIndent: 90.w))
                    ],
                  ),
                ),
                Visibility(
                  visible: canAddTimeTable,
                  child: SizedBox(
                    height: 10.h,
                  ),
                ),
                Visibility(visible: canAddTimeTable, child: renderDropDown()),
                Visibility(
                    visible: canAddTimeTable,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: CustomButton(
                        text: strings_name.str_submit,
                        click: () {
                          filterTimeTable();
                        },
                      ),
                    )),
                Visibility(
                  visible: canAddTimeTable,
                  child: SizedBox(
                    height: 10.h,
                  ),
                ),
                Visibility(
                    visible: canAddTimeTable,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                      child: const Text(strings_name.str_timetable),
                    )),
                Visibility(
                  visible: canAddTimeTable,
                  child: SizedBox(
                    height: 5.h,
                  ),
                ),

                // timeTables
                !canShowTimeTable
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
                            itemCount: timeTables.length + 1,
                            itemBuilder: (context, index) {
                              return index == timeTables.length
                                  ? offset.isNotEmpty
                                      ? const Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8.0),
                                            child: CircularProgressIndicator(
                                              color: colors_name.colorPrimary,
                                            ),
                                          ),
                                        )
                                      : const SizedBox()
                                  : TimeTableCard(
                                      data: timeTables[index],
                                      canUpdateTimeTable: canUpdateTimeTable,
                                      onEdit: () async {
                                        var data = await Get.to(
                                          AddEditTimeTable(
                                            timeTableData: timeTables[index],
                                          ),
                                        );
                                        debugPrint('../ result $data');
                                        if (data == TableNames.LUK_UPDATE_TIME_TABLE) {
                                          clearAndFetchTimeTable();
                                        }
                                      },
                                      onTap: () {
                                        if ((timeTables[index].fields?.createdBy?.contains(createdBy) ?? false) || (timeTables[index].fields?.lectureId?.contains(createdBy) ?? false)) {
                                          if (timeTables[index].fields?.isAttendanceTaken ?? false) {
                                            Utils.showSnackBarUsingGet(strings_name.str_attendance_already_taken);
                                          } else {
                                            debugPrint('../ timeTables ${timeTables[index].fields?.toJson()}');
                                            subjectValue = timeTables[index].fields?.subjectIdFromSubjectId?[0].toString() ?? '';
                                            selectUnitAndTopicDropDown(timeTables[index]);
                                          }
                                        } else {
                                          Utils.showSnackBarUsingGet(strings_name.str_not_per_atek_attedndance);
                                        }
                                      },
                                    );
                            }),
                SizedBox(
                  height: 30.h,
                ),
              ],
            ),
    );
  }

  bool isDialogDropDownLoading = false;

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
            query += "FIND('${timeTableData.fields?.hubIdFromHubId![0]}',{${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}, 0)";
            query += ",FIND('${timeTableData.fields?.specializationIdFromSpecializationId![0]}',{${TableNames.CLM_SPE_IDS_FROM_SPE_ID}}, 0)";
            query += ",FIND('${timeTableData.fields?.semester}', {${TableNames.CLM_SEMESTER}}, 0)";
            query += ",FIND('${timeTableData.fields?.division}', {${TableNames.CLM_DIVISION}}, 0)";
            query += ")";
            print(query);
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
                  request.employeeId = timeTableData.fields!.lectureId;
                  request.hubId = timeTableData.fields!.hubId!;
                  request.specializationId = timeTableData.fields!.specializationId!;
                  request.division = '${timeTableData.fields?.division}';
                  request.subjectId = timeTableData.fields!.subjectId;
                  request.unitId = unitRecordId.split(",");
                  request.topicId = topicRecordId.split(",");
                  request.lecture_duration = '$differenceInHours Hour';
                  request.semesterByStudent = '${timeTableData.fields?.semester}';
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
                                custom_text(
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
                        custom_text(
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

  Widget renderDropDown() {
    var viewWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        custom_text(
          text: strings_name.str_campus_r,
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
                width: viewWidth,
                child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                  value: hubResponse,
                  elevation: 16,
                  style: blackText16,
                  focusColor: Colors.white,
                  onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                    setState(() {
                      hubValue = newValue!.fields!.id!.toString();
                      hubResponse = newValue;
                      hubRecordId = newValue.id!;
                      getSpecializations();
                    });
                  },
                  items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
                    return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                      value: value,
                      child: Text(value.fields!.hubName!.toString()),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        custom_text(
          text: strings_name.str_specialization_r,
          alignment: Alignment.topLeft,
          textStyles: blackTextSemiBold16,
        ),
        isSpeLoading
            ? progressIndicator()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      width: viewWidth,
                      child: DropdownButtonFormField<BaseApiResponseWithSerializable<SpecializationResponse>>(
                        value: specializationResponse,
                        elevation: 16,
                        style: blackText16,
                        focusColor: Colors.white,
                        onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                          setState(() {
                            specializationValue = newValue!.fields!.id!.toString();
                            specializationResponse = newValue;
                            specializationRecordId = newValue.id!;
                            // getSubjects();
                          });
                        },
                        items: specializationResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>((BaseApiResponseWithSerializable<SpecializationResponse> value) {
                          return DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>(
                            value: value,
                            child: Text(value.fields!.specializationName!.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
        SizedBox(height: 10.h),
        custom_text(
          text: strings_name.str_semester_r,
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
                width: viewWidth,
                child: DropdownButtonFormField<int>(
                  elevation: 16,
                  style: blackText16,
                  focusColor: Colors.white,
                  onChanged: (int? newValue) {
                    setState(() {
                      semesterValue = newValue!;
                      getSubjects();
                    });
                  },
                  value: semesterValue == -1 ? null : semesterValue,
                  items: semesterResponseArray.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text("Semester $value"),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Visibility(
          child: custom_text(
            text: strings_name.str_division_r,
            alignment: Alignment.topLeft,
            textStyles: blackTextSemiBold16,
          ),
        ),
        Visibility(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  width: viewWidth,
                  child: DropdownButtonFormField<String>(
                    elevation: 16,
                    style: blackText16,
                    focusColor: Colors.white,
                    value: divisionValue == '' ? null : divisionValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        divisionValue = newValue!;
                      });
                    },
                    items: divisionResponseArray.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        custom_text(
          text: strings_name.str_range_r,
          alignment: Alignment.topLeft,
          textStyles: blackTextSemiBold16,
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
          width: viewWidth,
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
        SizedBox(height: 10.h),
      ],
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        startDate = args.value.startDate;
        endDate = args.value.endDate;
        // debugPrint('../ start date type ${args.value.startDate.runtimeType}');
        // debugPrint('../ end date type ${args.value.endDate.runtimeType}');
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  setDateRange() {
    _tcDateRange.text = _range;
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
              // initialSelectedRange: PickerDateRange(DateTime.now().subtract(const Duration(days: 4)), DateTime.now().add(const Duration(days: 3))),
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

  Widget progressIndicator() => const Center(
        child: CircularProgressIndicator(
          color: colors_name.colorPrimary,
        ),
      );
}

class TimeTableCard extends StatelessWidget {
  final BaseApiResponseWithSerializable<TimeTableResponseClass> data;
  final bool canUpdateTimeTable;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;

  const TimeTableCard({
    super.key,
    required this.data,
    this.canUpdateTimeTable = false,
    this.onEdit,
    this.onTap,
  });

  String formatDateString(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final day = DateFormat('dd').format(date);
    final month = DateFormat('MMM').format(date);
    final year = DateFormat('y').format(date);

    String suffix = _getDaySuffix(int.parse(day));

    return '$day$suffix $month $year';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String getDayName(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String dayName = DateFormat('EEEE').format(date);
    return dayName;
  }

  @override
  Widget build(BuildContext context) {
    String createdBy = PreferenceUtils.getLoginRecordId();
    var timeTable = data.fields;
    return timeTable?.isHoliday ?? false
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            decoration: BoxDecoration(color: colors_name.lightCoffee, border: Border.all(color: colors_name.coffee), borderRadius: BorderRadius.circular(6.w)),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 25.w,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          timeTable?.holidayTitle ?? '',
                          style: coffeeTextSemiBold16,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    (timeTable?.createdBy?.contains(createdBy) ?? false) && canUpdateTimeTable
                        ? GestureDetector(
                            onTap: canUpdateTimeTable ? onEdit : null,
                            child: Container(
                              height: 25.w,
                              width: 25.w,
                              decoration: BoxDecoration(
                                color: colors_name.lightGreyColor.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                color: colors_name.colorBlack,
                                size: 15.w,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 25.w,
                          ),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDateString(timeTable?.date ?? ''),
                      style: blackTextBold14,
                    ),
                    Text(
                      getDayName(timeTable?.date ?? ''),
                      style: blackTextBold14,
                    ),
                  ],
                ),
              ],
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(border: Border.all(color: colors_name.textColorGreyLight), borderRadius: BorderRadius.circular(6.w)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: (timeTable?.mode ?? '') == TableNames.TIMETABLE_MODE_STATUS_ONLINE,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(color: colors_name.colorLightGreen3, borderRadius: BorderRadius.only(topLeft: Radius.circular(6.w), topRight: Radius.circular(6.w))),
                      child: const Text(
                        strings_name.str_online,
                        style: blackTextSemiBold16,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 25.w,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  timeTable?.subjectTitleFromSubjectId?.isEmpty ?? true ? '' : timeTable?.subjectTitleFromSubjectId?.first ?? '',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: blackTextSemiBold16,
                                ),
                              ),
                            ),
                            (timeTable?.createdBy?.contains(createdBy) ?? false) && canUpdateTimeTable
                                ? GestureDetector(
                                    onTap: canUpdateTimeTable ? onEdit : null,
                                    child: Container(
                                      height: 25.w,
                                      width: 25.w,
                                      decoration: BoxDecoration(
                                        color: colors_name.lightGreyColor.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        color: colors_name.colorBlack,
                                        size: 15.w,
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width: 25.w,
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDateString(timeTable?.date ?? ''),
                              style: blackTextBold14,
                            ),
                            Text(
                              getDayName(timeTable?.date ?? ''),
                              style: blackTextBold14,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          '${strings_name.str_faculty}: ${timeTable?.employeeNameFromLectureId?.isEmpty ?? true ? '' : timeTable?.employeeNameFromLectureId?.first ?? ''}',
                          style: lightGrey14,
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Row(
                          children: [
                            Text(
                              '${strings_name.str_timings}:',
                              style: lightGrey14,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            TextWithBackground(
                              title: timeTable?.startTime ?? '',
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              strings_name.str_to,
                              style: lightGrey14,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            TextWithBackground(
                              title: timeTable?.endTime ?? '',
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Visibility(
                          visible: timeTable?.mode == TableNames.TIMETABLE_MODE_STATUS_ONLINE,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${strings_name.str_link}:',
                                style: lightGrey14,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    await launchUrl(Uri.parse(timeTable?.modeTitle ?? ''), mode: LaunchMode.externalApplication);
                                  },
                                  child: Text(
                                    timeTable?.modeTitle ?? '',
                                    style: blueSemiBold14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: timeTable?.mode != TableNames.TIMETABLE_MODE_STATUS_ONLINE,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${strings_name.str_class_room}:',
                                style: lightGrey14,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 2.h),
                                  decoration: BoxDecoration(border: Border.all(color: colors_name.colorBlack), borderRadius: BorderRadius.circular(20.w)),
                                  child: Text(timeTable?.modeTitle ?? ''),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class TextWithBackground extends StatelessWidget {
  final String title;
  final Color? bgColor;

  const TextWithBackground({
    super.key,
    required this.title,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.h),
      decoration: BoxDecoration(color: colors_name.colorLightGreen2, borderRadius: BorderRadius.circular(20.w)),
      child: Text(
        title,
        style: dartGreen14.copyWith(color: bgColor),
      ),
    );
  }
}
