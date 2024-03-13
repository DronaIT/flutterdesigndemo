import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/placement/placed_unplaced_list.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class PlacementAttendanceDataReport extends StatefulWidget {
  const PlacementAttendanceDataReport({Key? key}) : super(key: key);

  @override
  State<PlacementAttendanceDataReport> createState() => _PlacementAttendanceDataReportState();
}

class _PlacementAttendanceDataReportState extends State<PlacementAttendanceDataReport> {
  bool isVisible = false;
  var type = 0;

  DateTime? startDate = DateTime.now().add(const Duration(days: -1));
  DateTime? endDate = DateTime.now();

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  List<int> semesterResponseArray = <int>[-1, 1, 2, 3, 4, 5, 6];
  int semesterValue = -1;

  List<String> optionsArray = <String>[TableNames.ATTENDANCE_SHEET_RECEIVED, TableNames.ATTENDANCE_SHEET_PENDING, TableNames.LOC_RECEIVED, TableNames.LOC_PENDING];
  String selectedValue = TableNames.ATTENDANCE_SHEET_RECEIVED;

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? viewStudent = [];
  List<LoginFieldsResponse>? studentList = [];
  String title = strings_name.str_filter;

  @override
  void initState() {
    super.initState();
    getHubs();
  }

  Future<void> getHubs() async {
    try {
      setState(() {
        isVisible = true;
      });
      var hubResponse = await apiRepository.getHubApi();
      if (hubResponse.records!.isNotEmpty) {
        PreferenceUtils.setHubList(hubResponse);
        debugPrint("Hubs ${PreferenceUtils.getHubList().records!.length}");
      }
      setHubData();
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
      setHubData();
    }
  }

  setHubData() {
    hubResponseArray = PreferenceUtils.getHubList().records;
    if (hubResponseArray!.isNotEmpty) {
      for (int i = 0; i < hubResponseArray!.length; i++) {
        if (hubResponseArray![i].fields?.hubId == TableNames.CANCELLED_HUB_ID) {
          hubResponseArray?.removeAt(i);
          i--;
        } else if (hubResponseArray![i].fields?.hubId == TableNames.SUSPENDED_HUB_ID) {
          hubResponseArray?.removeAt(i);
          i--;
        }
      }
    }

    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
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
    // getSpecializations();
    setState(() {
      isVisible = false;
    });
  }

  getSpecializations() {
    speResponseArray = [];
    speResponseArray?.addAll(PreferenceUtils.getSpecializationList().records!);

    for (int i = 0; i < (speResponseArray?.length ?? 0); i++) {
      bool contains = false;
      for (int j = 0; j < (hubResponseArray?.length ?? 0); j++) {
        if (speResponseArray![i].fields!.hubIdFromHubIds?.contains(hubResponseArray![j].fields?.hubId) == true) {
          contains = true;
          break;
        }
      }
      if (!contains) {
        speResponseArray?.removeAt(i);
        i--;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: AppWidgets.appBarWithoutBack(title),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      custom_text(
                        text: strings_name.str_select_hub_r,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        bottomValue: 0,
                        topValue: 5.h,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                          value: hubResponse,
                          elevation: 16,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                            hubValue = newValue!.fields!.id!.toString();
                            hubResponse = newValue;

                            getSpecializations();
                            if (hubValue.trim().isNotEmpty) {
                              for (int i = 0; i < speResponseArray!.length; i++) {
                                if (speResponseArray![i].fields?.hubIdFromHubIds?.contains(hubResponse?.fields?.hubId) != true) {
                                  speResponseArray!.removeAt(i);
                                  i--;
                                }
                              }
                            }
                            speValue = "";
                            speResponse = null;
                            if (speResponseArray?.isEmpty == true) {
                              Utils.showSnackBar(context, strings_name.str_no_specialization_linked);
                            }
                            setState(() {});
                          },
                          items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
                            return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                              value: value,
                              child: Text(value.fields!.hubName!.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      custom_text(
                        text: strings_name.str_select_specialization,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
                        bottomValue: 5.h,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<BaseApiResponseWithSerializable<SpecializationResponse>>(
                          value: speResponse,
                          elevation: 16,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                            setState(() {
                              speValue = newValue!.fields!.id.toString();
                              speResponse = newValue;
                            });
                          },
                          items: speResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>((BaseApiResponseWithSerializable<SpecializationResponse> value) {
                            return DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>(
                              value: value,
                              child: Text(value.fields!.specializationName.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      custom_text(
                        text: strings_name.str_semester,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
                        bottomValue: 5.h,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<int>(
                          value: semesterValue,
                          elevation: 16,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (int? newValue) {
                            setState(() {
                              semesterValue = newValue!;
                            });
                          },
                          items: semesterResponseArray.map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value == -1 ? "Select semester" : "Semester $value"),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      custom_text(
                        text: strings_name.str_select_type,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
                        bottomValue: 5.h,
                      ),
                      Row(
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
                                value: selectedValue,
                                focusColor: Colors.white,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValue = newValue!;
                                  });
                                },
                                items: optionsArray.map<DropdownMenuItem<String>>((String value) {
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
                      SizedBox(height: 10.h),
                      custom_text(
                        text: strings_name.str_select_date_range,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
                        bottomValue: 8.h,
                      ),
                      startDate != null && endDate != null
                          ? GestureDetector(
                              child: custom_text(
                                text: "${startDate.toString().split(" ").first.replaceAll("-", "/")} - ${endDate.toString().split(" ").first.replaceAll("-", "/")}",
                                alignment: Alignment.topLeft,
                                textStyles: primaryTextSemiBold16,
                                topValue: 0,
                              ),
                              onTap: () {
                                _show();
                              },
                            )
                          : Container(),
                      SizedBox(height: 10.h),
                      CustomButton(
                        click: () async {
                          if (hubValue.isEmpty) {
                            Utils.showSnackBar(context, strings_name.str_empty_hub);
                          } else {
                            fetchRecords();
                          }
                        },
                        text: strings_name.str_submit,
                      ),
                      SizedBox(height: 5.h),
                    ],
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
                ),
              ],
            )));
  }

  void _show() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015, 1, 1),
      lastDate: DateTime(2050, 12, 31),
      currentDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: startDate!, end: endDate!),
      saveText: 'Done',
    );

    if (result != null) {
      debugPrint(result.start.toString());
      startDate = result.start;
      endDate = result.end;

      setState(() {});
    }
  }

  Future<void> fetchRecords() async {
    var query = "AND(${TableNames.CLM_HUB_IDS}='$hubValue'";

    if (speValue.isNotEmpty) {
      query += ",${TableNames.CLM_SPE_IDS}='$speValue'";
    }

    if (semesterValue != -1) {
      query += ",${TableNames.CLM_SEMESTER}='${semesterValue.toString()}'";
    }

    if (selectedValue == TableNames.PLACED) {
      query += ",${TableNames.CLM_IS_PLACED_NOW}='1'";
    } else if (selectedValue == TableNames.UNPLACED) {
      query += ",${TableNames.CLM_IS_PLACED_NOW}='0'";
    } else if (selectedValue == TableNames.BANNED) {
      query += ",OR(${TableNames.CLM_BANNED_FROM_PLACEMENT}=1,${TableNames.CLM_BANNED_FROM_PLACEMENT}=2)";
    }

    query += ")";
    debugPrint(query);

    setState(() {
      isVisible = true;
    });
    try {
      var data = await apiRepository.loginApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          viewStudent?.clear();
        }
        viewStudent?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchRecords();
        } else {
          setState(() {
            viewStudent?.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
            isVisible = false;

            filterData();
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            viewStudent = [];
          }
        });
        offset = "";
        Utils.showSnackBarUsingGet(strings_name.str_no_students);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  void filterData() {
    studentList?.clear();
    if (viewStudent != null && viewStudent?.isNotEmpty == true) {
      for (int i = 0; i < viewStudent!.length; i++) {
        if (selectedValue == TableNames.BANNED) {
          if (viewStudent?[i].fields?.is_banned == 1) {
            studentList?.add(viewStudent![i].fields!);
          }
        } else if (selectedValue == TableNames.PLACED) {
          if (viewStudent?[i].fields?.placedJob != null && viewStudent?[i].fields!.placedJob?.isNotEmpty == true && viewStudent?[i].fields?.is_placed_now == "1") {
            studentList?.add(viewStudent![i].fields!);
          }
        } else if (selectedValue == TableNames.UNPLACED) {
          if (viewStudent?[i].fields?.placedJob == null || viewStudent?[i].fields?.is_placed_now == "0") {
            studentList?.add(viewStudent![i].fields!);
          }
        }
      }

      countTotalStudents();

      // debugPrint("test=>${studentList?.length} ==>${viewStudent?.length}");
      if (studentList?.isNotEmpty == true) {
        studentList?.sort((a, b) => a.name!.compareTo(b.name!));
        Get.to(const PlacedUnplacedList(), arguments: [
          {"studentList": studentList},
          {"title": selectedValue},
          {"total students": countTotalStudents()},
        ])?.then((result) {
          if (result != null && result) {
            // Get.back(closeOverlays: true);
          }
        });
      } else {
        Utils.showSnackBarUsingGet(strings_name.str_no_students);
      }
    }
  }

  int countTotalStudents() {
    if (hubResponse != null && hubResponse?.fields != null) {
      int totalStudent = hubResponse?.fields?.tblStudent?.length ?? 0;
      if (speValue.isNotEmpty) {
        for (int j = 0; j < (hubResponse?.fields?.tblStudent?.length ?? 0); j++) {
          if (speResponse?.fields?.specializationId != hubResponse?.fields?.studentSpecializationIds![j]) {
            totalStudent -= 1;
          }
        }
      }
      if (semesterValue != -1) {
        for (int j = 0; j < (hubResponse?.fields?.tblStudent?.length ?? 0); j++) {
          if (semesterValue.toString() != hubResponse?.fields?.studentSemester![j]) {
            totalStudent -= 1;
          }
        }
      }
      return totalStudent;
    }
    return 0;
  }
}
