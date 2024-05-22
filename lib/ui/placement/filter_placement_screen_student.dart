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

class FilterPlacementScreenStudent extends StatefulWidget {
  const FilterPlacementScreenStudent({Key? key}) : super(key: key);

  @override
  State<FilterPlacementScreenStudent> createState() => _FilterPlacementScreenStudentState();
}

class _FilterPlacementScreenStudentState extends State<FilterPlacementScreenStudent> {
  bool isVisible = false;
  var type = 0;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  List<int> semesterResponseArray = <int>[-1, 1, 2, 3, 4, 5, 6];
  int semesterValue = -1;

  List<String> placedResponseArray = <String>[TableNames.PLACED, TableNames.UNPLACED, TableNames.BANNED];
  String placedValue = TableNames.PLACED;

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
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_select_hub_r,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        bottomValue: 0,
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
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_select_specialization,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
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
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_semester,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
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
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_select_type,
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
                              child: DropdownButtonFormField<String>(
                                elevation: 16,
                                style: blackText16,
                                value: placedValue,
                                focusColor: Colors.white,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    placedValue = newValue!;
                                  });
                                },
                                items: placedResponseArray.map<DropdownMenuItem<String>>((String value) {
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

  Future<void> fetchRecords() async {
    var query = "AND(${TableNames.CLM_HUB_IDS}='$hubValue'";

    if (speValue.isNotEmpty) {
      query += ",${TableNames.CLM_SPE_IDS}='$speValue'";
    }

    if (semesterValue != -1) {
      query += ",${TableNames.CLM_SEMESTER}='${semesterValue.toString()}'";
    } else {
      query += ",${TableNames.CLM_SEMESTER}!='7'";
    }

    if (placedValue == TableNames.PLACED) {
      query += ",${TableNames.CLM_IS_PLACED_NOW}='1'";
    } else if (placedValue == TableNames.UNPLACED) {
      query += ",${TableNames.CLM_IS_PLACED_NOW}='0'";
    } else if (placedValue == TableNames.BANNED) {
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
        if (placedValue == TableNames.BANNED) {
          if (viewStudent?[i].fields?.is_banned == 1) {
            studentList?.add(viewStudent![i].fields!);
          }
        } else if (placedValue == TableNames.PLACED) {
          if (viewStudent?[i].fields?.placedJob != null && viewStudent?[i].fields!.placedJob?.isNotEmpty == true && viewStudent?[i].fields?.is_placed_now == "1") {
            studentList?.add(viewStudent![i].fields!);
          }
        } else if (placedValue == TableNames.UNPLACED) {
          if (viewStudent?[i].fields?.placedJob == null || viewStudent?[i].fields?.is_placed_now == "0") {
            studentList?.add(viewStudent![i].fields!);
          }
        }
      }

      // debugPrint("test=>${studentList?.length} ==>${viewStudent?.length}");
      if (studentList?.isNotEmpty == true) {
        studentList?.sort((a, b) => a.name!.compareTo(b.name!));
        Get.to(const PlacedUnplacedList(), arguments: [
          {"studentList": studentList},
          {"title": placedValue},
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
      for (int j = 0; j < (hubResponse?.fields?.tblStudent?.length ?? 0); j++) {
        if(hubResponse?.fields?.studentSemester![j] != "7") {
          if (speValue.isNotEmpty && speResponse?.fields?.specializationId != hubResponse?.fields?.studentSpecializationIds![j]) {
            totalStudent -= 1;
          } else if (semesterValue != -1 && semesterValue.toString() != hubResponse?.fields?.studentSemester![j]) {
            totalStudent -= 1;
          }
        }else{
          totalStudent -= 1;
        }
      }
      return totalStudent;
    }
    return 0;
  }
}
