import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/models/add_timetable_model.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:get/get.dart';
import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_edittext.dart';
import '../../customwidget/custom_text.dart';
import '../../models/add_time_table_response.dart';
import '../../models/base_api_response.dart';
import '../../models/hub_response.dart';
import '../../models/request/update_time_table_request.dart';
import '../../models/specialization_response.dart';
import '../../models/subject_response.dart';
import '../../models/topics_response.dart';
import '../../models/units_response.dart';
import '../../models/viewemployeeresponse.dart';
import '../../utils/preference.dart';
import '../../utils/tablenames.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';
import '../announcements/add_announcement.dart';

enum MODE { online, offline }

class AddEditTimeTable extends StatefulWidget {
  final BaseApiResponseWithSerializable<TimeTableResponseClass>? timeTableData;

  const AddEditTimeTable({super.key, this.timeTableData});

  @override
  State<AddEditTimeTable> createState() => _AddEditTimeTableState();
}

class _AddEditTimeTableState extends State<AddEditTimeTable> {
  final TextEditingController _tcDate = TextEditingController();
  final TextEditingController _tcStartTime = TextEditingController();
  final TextEditingController _tcEndTime = TextEditingController();
  final TextEditingController _tcHoliday = TextEditingController();
  final TextEditingController _tcOnlineClassLink = TextEditingController();
  final TextEditingController _tcClassRoomNumber = TextEditingController();

  bool isLoading = false;

  DateTime selectedDate = DateTime.now();

  bool isHoliday = false;

  MODE selectedMode = MODE.online;

  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  String hubRecordId = "";
  List<String> selectedHubIds = [];

  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? facultyResponseArray = [];
  BaseApiResponseWithSerializable<ViewEmployeeResponse>? facultyResponse;
  String facultyValue = "";
  String facultyRecordId = "";

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

  String offset = "";

  final apiRepository = getIt.get<ApiRepository>();

  bool isDataLoading = false;

  bool isFacultyLogin = false;

  Future<void> _selectDate() async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _tcDate.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() {
    if (widget.timeTableData != null) {
      setState(() {
        isDataLoading = true;
      });
    }
    hubResponseArray = PreferenceUtils.getHubList().records;
    fetchLoginCred();
  }

  String employeeId = '';

  fetchLoginCred() async {
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      debugPrint('../ id ${loginData.roleIdFromRoleIds?[0]}');
      debugPrint('../ id ${loginData.employeeId}');
      employeeId = loginData.employeeId.toString();
      if (TableNames.FACULTY_ROLE_ID == loginData.roleIdFromRoleIds?[0]) {
        isFacultyLogin = true;
      }
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
    }
    await fetchFaculty();
    if (widget.timeTableData != null) {
      setInitDataForUpdate();
    }
  }

  setInitDataForUpdate() async {
    var timeTableData = widget.timeTableData?.fields;
    _tcDate.text = timeTableData?.date ?? '';
    selectedDate = DateTime.parse(timeTableData?.date ?? '');
    isHoliday = timeTableData?.isHoliday ?? false;
    if (isHoliday) {
      _tcHoliday.text = timeTableData?.holidayTitle ?? '';
      for (var hub in hubResponseArray ?? []) {
        for (var data in timeTableData?.hubId ?? []) {
          if (hub.id == data) {
            hub.fields?.selected = true;
          }
        }
      }
    } else {
      for (var hub in hubResponseArray ?? []) {
        for (var data in timeTableData?.hubId ?? []) {
          if (hub.id == data) {
            hubValue = hub!.fields!.id!.toString();
            hubResponse = hub;
            hubRecordId = hub.id!;
          }
        }
      }
      await getSpecializations();
      for (var spe in specializationResponseArray ?? []) {
        for (var data in timeTableData?.specializationId ?? []) {
          if (spe.id == data) {
            specializationValue = spe!.fields!.id!.toString();
            specializationResponse = spe;
            specializationRecordId = spe.id!;
          }
        }
      }
      for (var sem in semesterResponseArray) {
        if (sem.toString() == timeTableData?.semester.toString()) {
          semesterValue = sem;
        }
      }
      for (var div in divisionResponseArray) {
        if (div.toString() == timeTableData?.division.toString()) {
          divisionValue = div;
        }
      }
      await getSubjects();
      for (var sub in subjectResponseArray ?? []) {
        for (var data in timeTableData!.subjectId ?? []) {
          if (sub.id.toString() == data.toString()) {
            subjectValue = sub!.fields!.ids!.toString();
            subjectResponse = sub;
            subjectRecordId = sub.id!;
          }
        }
      }
      for (var fac in facultyResponseArray ?? []) {
        for (var data in timeTableData!.lectureId ?? []) {
          if (fac.id.toString() == data.toString()) {
            facultyValue = fac!.fields!.employeeId!.toString();
            facultyResponse = fac;
            facultyRecordId = fac.id!;
            if (!isFacultyLogin) {
              _tcFacultyName.text = facultyResponse?.fields?.employeeName ?? '';
            }
          }
        }
      }
      _tcStartTime.text = timeTableData?.startTime ?? '';
      _tcEndTime.text = timeTableData?.endTime ?? '';
      if (timeTableData?.mode.toString() == TableNames.TIMETABLE_MODE_STATUS_ONLINE) {
        selectedMode = MODE.online;
        _tcOnlineClassLink.text = timeTableData?.modeTitle ?? '';
      } else {
        selectedMode = MODE.offline;
        _tcClassRoomNumber.text = timeTableData?.modeTitle ?? '';
      }
    }
    setState(() {
      isDataLoading = false;
    });
  }

  Future<void> getSpecializations() async {
    if (hubValue.isNotEmpty) {
      setState(() {
        isSpeLoading = true;
      });
      specializationValue = "";

      var query = "SEARCH('${hubResponse?.fields?.hubId}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}), 0)";
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

      var query =
          "AND(FIND('$semesterValue', ${TableNames.CLM_SEMESTER}, 0),FIND('${Utils.getSpecializationIds(specializationValue)}',${TableNames.CLM_SPE_IDS}, 0))";

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

  fetchFaculty() async {
    // var query = "AND({is_working} = 1,{role_ids} = 'DR05')";
    var query = "AND({is_working} = 1)";
    try {
      var data = await apiRepository.getEmployeeListApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          facultyResponseArray?.clear();
        }
        if (isFacultyLogin) {
          for (var faculty in data.records as Iterable<BaseApiResponseWithSerializable<ViewEmployeeResponse>>) {
            if (faculty.fields?.employeeId.toString() == employeeId.toString()) {
              setState(() {
                facultyResponseArray?.add(faculty);
              });
            }
          }
        } else {
          setState(() {
            facultyResponseArray?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<ViewEmployeeResponse>>);
          });
        }
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchFaculty();
        }
        facultyResponseArray?.sort((a, b) => a.fields!.employeeName!.toLowerCase().compareTo(b.fields!.employeeName!.toLowerCase()));
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    } catch (e) {
      final errorMessage = e.toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  checkValidation({bool isForAdd = true}) {
    selectedHubIds.clear();
    if (_tcDate.text.isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_date);
    } else if (isHoliday) {
      if (_tcHoliday.text.isEmpty) {
        Utils.showSnackBar(context, strings_name.str_empty_holiday_title);
      } else {
        for (var data in hubResponseArray!) {
          if (data.fields!.selected) {
            selectedHubIds.add(data.id.toString());
          }
        }
        if (selectedHubIds.isEmpty) {
          Utils.showSnackBar(context, strings_name.str_empty_campus);
        } else {
          if (isForAdd) {
            addData();
          } else {
            updateData();
          }
        }
      }
    } else if (hubValue.trim().isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_campus);
    } else if (specializationValue.trim().isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_spe);
    } else if (semesterValue == -1) {
      Utils.showSnackBar(context, strings_name.str_empty_semester);
    } else if (divisionValue.trim().isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_division);
    } else if (subjectValue.trim().isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_subject);
    } else if (facultyValue.trim().isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_faculty);
    } else if (_tcStartTime.text.isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_start_time_tt);
    } else if (_tcEndTime.text.isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_end_time_tt);
    } else if (MODE.online == selectedMode && _tcOnlineClassLink.text.isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_meeting_link);
    } else if (MODE.offline == selectedMode && _tcClassRoomNumber.text.isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_class_number);
    } else {
      if (isForAdd) {
        addData();
      } else {
        updateData();
      }
    }
  }

  void _convertLink() {
    String link = _tcOnlineClassLink.text.trim();
    if (link.isNotEmpty) {
      if (!link.startsWith('http://') && !link.startsWith('https://')) {
        link = 'https://$link';
      }
    }
    _tcOnlineClassLink.text = link;
  }

  addData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String createdBy = PreferenceUtils.getLoginRecordId();

      AddTimeTableModel? addTimeTableModel;

      if (_tcOnlineClassLink.text.isNotEmpty) {
        _convertLink();
      }

      if (!isHoliday) {
        addTimeTableModel = AddTimeTableModel(
          records: [
            Record(
              fields: AddTimeTable(
                  date: '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                  isHoliday: isHoliday,
                  startTime: _tcStartTime.text,
                  endTime: _tcEndTime.text,
                  holidayTitle: _tcHoliday.text,
                  hubId: [hubRecordId],
                  specializationId: [
                    specializationRecordId,
                  ],
                  semester: semesterValue.toString(),
                  division: divisionValue.toString(),
                  lectureId: [facultyRecordId],
                  subjectId: [
                    subjectRecordId,
                  ],
                  createdBy: [createdBy],
                  updatedBy: [createdBy],
                  mode: selectedMode.name,
                  modeTitle: selectedMode == MODE.online ? _tcOnlineClassLink.text : _tcClassRoomNumber.text),
            )
          ],
        );
      } else {
        addTimeTableModel = AddTimeTableModel(
          records: [
            Record(
              fields: AddTimeTable(
                date: '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                isHoliday: isHoliday,
                holidayTitle: _tcHoliday.text,
                startTime: _tcStartTime.text,
                endTime: _tcEndTime.text,
                hubId: selectedHubIds,
                specializationId: [],
                lectureId: [],
                subjectId: [],
                createdBy: [createdBy],
                updatedBy: [createdBy],
                mode: "holiday",
                modeTitle: "",
              ),
            )
          ],
        );
      }

      var json = addTimeTableModel.toJson();
      json.removeWhere((key, value) => value == null);
      debugPrint('../ addTimeTableModel ${json.toString()}');

      var resp = await apiRepository.addTimeTableDataApi(json);

      if (resp.records?.isNotEmpty ?? false) {
        setState(() {
          isLoading = false;
        });
        Get.back(result: TableNames.LUK_ADD_TIME_TABLE);
        Utils.showSnackBar(context, strings_name.str_time_table_added);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  updateData() async {
    setState(() {
      isLoading = true;
    });

    try {
      String currentUserId = PreferenceUtils.getLoginRecordId();

      if (_tcOnlineClassLink.text.isNotEmpty) {
        _convertLink();
      }

      UpdateTimeTableRequest? updateTimeTableModel;

      List<String>? updatedBy = [];
      updatedBy.addAll(widget.timeTableData?.fields?.updatedBy ?? []);
      if (!updatedBy.contains(currentUserId)) {
        updatedBy.add(currentUserId);
      }

      if (!isHoliday) {
        _tcHoliday.clear();
        updateTimeTableModel = UpdateTimeTableRequest(
          records: [
            UpdateRecord(
              id: widget.timeTableData?.id ?? '',
              fields: UpdateFields(
                  date: '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                  isHoliday: isHoliday,
                  startTime: _tcStartTime.text,
                  endTime: _tcEndTime.text,
                  holidayTitle: _tcHoliday.text,
                  hubId: [hubRecordId],
                  specializationId: [
                    specializationRecordId,
                  ],
                  semester: semesterValue.toString(),
                  division: divisionValue.toString(),
                  lectureId: [facultyRecordId],
                  subjectId: [
                    subjectRecordId,
                  ],
                  createdBy: widget.timeTableData?.fields?.createdBy ?? [],
                  updatedBy: updatedBy,
                  mode: selectedMode.name,
                  modeTitle: selectedMode == MODE.online ? _tcOnlineClassLink.text : _tcClassRoomNumber.text,
                  isAttendanceTaken: widget.timeTableData?.fields?.isAttendanceTaken ?? false),
            )
          ],
        );
      } else {
        _tcStartTime.clear();
        _tcEndTime.clear();
        updateTimeTableModel = UpdateTimeTableRequest(
          records: [
            UpdateRecord(
              id: widget.timeTableData?.id ?? '',
              fields: UpdateFields(
                date: '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                isHoliday: isHoliday,
                holidayTitle: _tcHoliday.text,
                startTime: _tcStartTime.text,
                endTime: _tcEndTime.text,
                hubId: selectedHubIds,
                specializationId: [],
                lectureId: [],
                subjectId: [],
                createdBy: widget.timeTableData?.fields?.createdBy ?? [],
                updatedBy: updatedBy,
                mode: "holiday",
                modeTitle: "",
              ),
            )
          ],
        );
      }

      var json = updateTimeTableModel.toJson();
      json.removeWhere((key, value) => value == null);
      debugPrint('../ updateTimeTableModel ${jsonEncode(json)}');

      var resp = await apiRepository.updateTimeTableDataApi(json, widget.timeTableData?.id ?? '');

      if (resp.records?.isNotEmpty ?? false) {
        setState(() {
          isLoading = false;
        });
        Get.back(result: TableNames.LUK_UPDATE_TIME_TABLE);
        Utils.showSnackBar(context, strings_name.str_time_table_updated);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppWidgets.appBarWithoutBack(widget.timeTableData == null ? strings_name.str_add_new_time_table : strings_name.str_edit_timetable),
      body: isDataLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: colors_name.colorPrimary,
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
              children: [
                SizedBox(
                  height: 10.h,
                ),
                custom_text(
                  text: strings_name.str_date_r,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  leftValue: 0,
                ),
                Container(
                  width: viewWidth,
                  child: TextFormField(
                    controller: _tcDate,
                    onTap: () {
                      _selectDate();
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
                SizedBox(
                  height: 6.h,
                ),
                Row(
                  children: [
                    Checkbox(
                      visualDensity: VisualDensity.compact,
                      value: isHoliday,
                      onChanged: (value) {
                        setState(() {
                          isHoliday = value ?? false;
                        });
                      },
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            isHoliday = !isHoliday;
                          });
                        },
                        child: const Text(strings_name.str_holiday))
                  ],
                ),
                Visibility(
                  visible: isHoliday,
                  child: custom_text(
                    text: strings_name.str_holiday_title,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    leftValue: 0,
                  ),
                ),
                Visibility(
                  visible: isHoliday,
                  child: custom_edittext(
                    margin: EdgeInsets.zero,
                    type: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _tcHoliday,
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Visibility(
                  visible: isHoliday,
                  child: customExpansionTileItem(
                    title: strings_name.campus,
                    widget: ListView.builder(
                        shrinkWrap: true,
                        itemCount: hubResponseArray?.length ?? 0,
                        itemBuilder: (context, index) {
                          var data = hubResponseArray![index];
                          return CustomCheckListTile(
                            title: data.fields?.hubName ?? "",
                            onChanged: (bool? value) {
                              setState(() {
                                data.fields?.selected = value!;
                              });
                            },
                            isSelected: data.fields!.selected,
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Visibility(
                  visible: !isHoliday,
                  child: Column(
                    children: [
                      renderDropDown(),
                      custom_text(
                        text: '${strings_name.str_timings}:',
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        leftValue: 0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _tcStartTime,
                              onTap: () {
                                _selectStartTime();
                              },
                              readOnly: true,
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          const Text(strings_name.str_to),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _tcEndTime,
                              onTap: () {
                                _selectEndTime();
                              },
                              readOnly: true,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        children: [
                          custom_text(
                            text: strings_name.str_mode,
                            alignment: Alignment.topLeft,
                            textStyles: blackTextSemiBold16,
                            leftValue: 0,
                          ),
                          ModeSelectedCard(
                            title: strings_name.str_online,
                            isSelected: MODE.online == selectedMode,
                            onTap: () {
                              onChangeMode(MODE.online);
                            },
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          ModeSelectedCard(
                            title: strings_name.str_offline,
                            isSelected: MODE.offline == selectedMode,
                            onTap: () {
                              onChangeMode(MODE.offline);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Visibility(
                        visible: selectedMode == MODE.online,
                        child: custom_text(
                          text: strings_name.str_meeting_link_r,
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                          leftValue: 0,
                        ),
                      ),
                      Visibility(
                        visible: selectedMode == MODE.online,
                        child: custom_edittext(
                          margin: EdgeInsets.zero,
                          type: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          controller: _tcOnlineClassLink,
                          // hintText: strings_name.announcement_title_asterisk,
                        ),
                      ),
                      Visibility(
                        visible: selectedMode == MODE.offline,
                        child: custom_text(
                          text: strings_name.str_class_room_number,
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                          leftValue: 0,
                        ),
                      ),
                      Visibility(
                        visible: selectedMode == MODE.offline,
                        child: custom_edittext(
                          margin: EdgeInsets.zero,
                          type: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          controller: _tcClassRoomNumber,
                          // hintText: strings_name.announcement_title_asterisk,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 14.h,
                ),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: colors_name.colorPrimary,
                        ),
                      )
                    : CustomButton(
                        click: () async {
                          checkValidation(isForAdd: widget.timeTableData == null);
                        },
                        text: widget.timeTableData == null ? strings_name.str_add_timetable : strings_name.str_edit_timetable,
                      ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
    );
  }

  ExpansionTileItem customExpansionTileItem({required String title, required Widget widget, double? listHeight}) {
    return ExpansionTileItem(
      childrenPadding: EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border.all(
          color: colors_name.darkGrayColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(title),
      children: [
        SizedBox(
          height: listHeight ?? 200.h,
          child: widget,
        )
      ],
    );
  }

  onChangeMode(MODE value) {
    setState(() {
      selectedMode = value;
    });
  }

  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  Future<void> _selectStartTime() async {
    final TimeOfDay? pickedS = await showTimePicker(
        context: context,
        initialTime: selectedStartTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (pickedS != null && pickedS != selectedStartTime) {
      selectedStartTime = pickedS;
      if (selectedEndTime.toDateTime().isBefore(selectedStartTime.toDateTime()) && _tcEndTime.text.isNotEmpty) {
        Utils.showSnackBarUsingGet('Start time cannot be after end time.');
        selectedStartTime = TimeOfDay.now();
      } else {
        setState(() {
          _tcStartTime.text = '${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}';
          if (_tcStartTime.text == '00:00') {
            _tcStartTime.text = '12:00';
          }
        });
      }
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? pickedS = await showTimePicker(
        context: context,
        initialTime: selectedEndTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (pickedS != null && pickedS != selectedEndTime) {
      selectedEndTime = pickedS;
      if (selectedEndTime.toDateTime().isBefore(selectedStartTime.toDateTime()) && _tcStartTime.text.isNotEmpty) {
        Utils.showSnackBarUsingGet('End time cannot be before start time.');
        selectedEndTime = TimeOfDay.now();
      } else {
        setState(() {
          // selectedEndTime = pickedS;
          debugPrint('selectedEndTime $selectedEndTime');
          _tcEndTime.text = '${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}';
          if (_tcEndTime.text == '00:00') {
            _tcEndTime.text = '12:00';
          }
        });
      }
    }
  }

  TextEditingController _tcFacultyName = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? filterFacultyResponseArray = [];

  updateAndBack() {
    Navigator.pop(context);
    _tcFacultyName.text = facultyResponse?.fields?.employeeName ?? '';
    setState(() {});
  }

  facultyDropDown() {
    searchController.clear();
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Faculty',
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear),
                        ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    List<BaseApiResponseWithSerializable<ViewEmployeeResponse>> tempList = [];
                    facultyResponseArray?.forEach((item) {
                      if (item.fields!.employeeName!.toLowerCase().contains(value.toLowerCase())) {
                        tempList.add(item);
                      }
                    });
                    setState(() {
                      filterFacultyResponseArray?.clear();
                      filterFacultyResponseArray?.addAll(tempList);
                    });
                  } else {
                    setState(() {
                      filterFacultyResponseArray?.clear();
                      filterFacultyResponseArray?.addAll(facultyResponseArray!);
                    });
                  }
                },
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: searchController.text.isEmpty
                    ? ListView.builder(
                        itemCount: facultyResponseArray?.length ?? 0,
                        itemBuilder: (context, index) {
                          var data = facultyResponseArray?[index];
                          return GestureDetector(
                            onTap: () {
                              facultyValue = data!.fields!.employeeId!.toString();
                              facultyResponse = data;
                              facultyRecordId = data.id!;
                              updateAndBack();
                            },
                            child: Container(padding: const EdgeInsets.symmetric(vertical: 6), child: Text(data?.fields?.employeeName ?? '')),
                          );
                        })
                    : ListView.builder(
                        itemCount: filterFacultyResponseArray?.length ?? 0,
                        itemBuilder: (context, index) {
                          var data = filterFacultyResponseArray?[index];
                          return GestureDetector(
                            onTap: () {
                              facultyValue = data!.fields!.employeeId!.toString();
                              facultyResponse = data;
                              facultyRecordId = data.id!;
                              updateAndBack();
                            },
                            child: Container(padding: const EdgeInsets.symmetric(vertical: 6), child: Text(data?.fields?.employeeName ?? '')),
                          );
                        }),
              ),
            );
          });
        });
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
          leftValue: 0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
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
                  items: hubResponseArray
                      ?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
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
          leftValue: 0,
        ),
        isSpeLoading
            ? progressIndicator()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: SizedBox(
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
                            getSubjects();
                          });
                        },
                        items: specializationResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>(
                            (BaseApiResponseWithSerializable<SpecializationResponse> value) {
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
          leftValue: 0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
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
            leftValue: 0,
          ),
        ),
        Visibility(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: SizedBox(
                  width: viewWidth,
                  child: DropdownButtonFormField<String>(
                    elevation: 16,
                    style: blackText16,
                    focusColor: Colors.white,
                    onChanged: (String? newValue) {
                      setState(() {
                        divisionValue = newValue!;
                        getSubjects();
                      });
                    },
                    value: divisionValue == "" ? null : divisionValue,
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
        isSubLoading
            ? progressIndicator()
            : custom_text(
                text: strings_name.str_subject_r,
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
                leftValue: 0,
              ),
        Visibility(
          visible: !isSubLoading,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: SizedBox(
                  width: viewWidth,
                  child: DropdownButtonFormField<BaseApiResponseWithSerializable<SubjectResponse>>(
                    value: subjectResponse,
                    elevation: 16,
                    isExpanded: true,
                    style: blackText16,
                    focusColor: Colors.white,
                    onChanged: (BaseApiResponseWithSerializable<SubjectResponse>? newValue) {
                      setState(() {
                        subjectValue = newValue!.fields!.ids!.toString();
                        subjectResponse = newValue;
                        subjectRecordId = newValue.id!;
                      });
                    },
                    items: subjectResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SubjectResponse>>>(
                        (BaseApiResponseWithSerializable<SubjectResponse> value) {
                      return DropdownMenuItem<BaseApiResponseWithSerializable<SubjectResponse>>(
                        value: value,
                        child: Text(value.fields!.subjectTitle!.toString()),
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
          text: strings_name.str_faculty_name,
          alignment: Alignment.topLeft,
          textStyles: blackTextSemiBold16,
          leftValue: 0,
        ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Flexible(
        //       fit: FlexFit.loose,
        //       child: SizedBox(
        //         width: viewWidth,
        //         child: DropdownButtonFormField<
        //             BaseApiResponseWithSerializable<ViewEmployeeResponse>>(
        //           value: facultyResponse,
        //           elevation: 16,
        //           style: blackText16,
        //           focusColor: Colors.white,
        //           onChanged:
        //               (BaseApiResponseWithSerializable<ViewEmployeeResponse>?
        //                   newValue) {
        //             setState(() {
        //               facultyValue = newValue!.fields!.employeeId!.toString();
        //               facultyResponse = newValue;
        //               facultyRecordId = newValue.id!;
        //             });
        //           },
        //           items: facultyResponseArray?.map<
        //                   DropdownMenuItem<
        //                       BaseApiResponseWithSerializable<
        //                           ViewEmployeeResponse>>>(
        //               (BaseApiResponseWithSerializable<ViewEmployeeResponse>
        //                   value) {
        //             return DropdownMenuItem<BaseApiResponseWithSerializable<ViewEmployeeResponse>>(
        //               value: value,
        //               child: Text(value.fields!.employeeName!.toString()),
        //             );
        //           }).toList(),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                width: viewWidth,
                child: !isFacultyLogin
                    ? TextFormField(
                        controller: _tcFacultyName,
                        readOnly: true,
                        onTap: () {
                          if (facultyResponseArray?.isNotEmpty ?? false) {
                            facultyDropDown();
                          }
                        },
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                        ),
                      )
                    : DropdownButtonFormField<BaseApiResponseWithSerializable<ViewEmployeeResponse>>(
                        value: facultyResponse,
                        elevation: 16,
                        style: blackText16,
                        focusColor: Colors.white,
                        onChanged: (BaseApiResponseWithSerializable<ViewEmployeeResponse>? newValue) {
                          setState(() {
                            facultyValue = newValue!.fields!.employeeId!.toString();
                            facultyResponse = newValue;
                            facultyRecordId = newValue.id!;
                          });
                        },
                        items: facultyResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<ViewEmployeeResponse>>>(
                            (BaseApiResponseWithSerializable<ViewEmployeeResponse> value) {
                          return DropdownMenuItem<BaseApiResponseWithSerializable<ViewEmployeeResponse>>(
                            value: value,
                            child: Text(value.fields!.employeeName!.toString()),
                          );
                        }).toList(),
                      ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget progressIndicator() => const Center(
        child: CircularProgressIndicator(
          color: colors_name.colorPrimary,
        ),
      );
}

class ModeSelectedCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const ModeSelectedCard({super.key, required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.h),
        decoration: BoxDecoration(
            color: isSelected ? colors_name.colorLightGreen2 : null,
            border: Border.all(color: isSelected ? colors_name.presentColor : colors_name.colorBlack),
            borderRadius: BorderRadius.circular(20.w)),
        child: Text(
          title,
          style: dartGreen14.copyWith(color: isSelected ? colors_name.presentColor : colors_name.colorBlack),
        ),
      ),
    );
  }
}

extension TimeOfDayExtension on TimeOfDay {
  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}
