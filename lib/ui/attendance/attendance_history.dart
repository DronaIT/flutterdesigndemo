import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/login_employee_response.dart';
import 'package:flutterdesigndemo/models/request/add_student_attendance_request.dart';
import 'package:flutterdesigndemo/models/view_lecture_attendance.dart';
import 'package:flutterdesigndemo/ui/attendance/attendance_history_detail.dart';
import 'package:flutterdesigndemo/ui/attendance/attendance_student_list.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../api/dio_exception.dart';
import '../../utils/utils.dart';

class AttendanceHistory extends StatefulWidget {
  const AttendanceHistory({Key? key}) : super(key: key);

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  BaseLoginResponse<LoginEmployeResponse> data = BaseLoginResponse();
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  String phone = "";
  String formattedDate = "";
  List<ViewLectureAttendance>? viewLectureArray = [];
  var formatterShow = DateFormat('dd-MM-yyyy');
  bool canViewAccessibleAttendance = false, canUpdateAccessibleAttendance = false;

  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  String hubRecordId = "";

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() {
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      var loginData = PreferenceUtils.getLoginData();
      phone = loginData.mobileNumber.toString();
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      phone = loginData.mobileNumber.toString();

      hubResponseArray = PreferenceUtils.getHubList().records;
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

    checkCurrentData();
    if (Get.arguments != null) {
      setState(() {
        canViewAccessibleAttendance = Get.arguments[0]["canViewAccessibleAttendance"];
        canUpdateAccessibleAttendance = Get.arguments[1]["canUpdateAccessibleAttendance"];

        viewEmpLectures();
      });
    } else {
      viewEmpLectures();
    }
  }

  void viewEmpLectures() async {
    setState(() {
      isVisible = true;
    });
    var query = "";
    if (canViewAccessibleAttendance) {
      var queryCheck = "SEARCH('$formattedDate', ARRAYJOIN(lecture_date))";
      if (hubValue.isNotEmpty) {
        queryCheck += ",SEARCH('$hubValue', ARRAYJOIN(hub_id_from_lecture))";
      }
      query = "AND($queryCheck)";
    } else {
      query = "(${TableNames.TB_USERS_PHONE}='$phone')";
    }
    print(query);
    try{
      data = await apiRepository.loginEmployeeApi(query);
      if (data.records != null) {
        setState(() {
          isVisible = false;
        });
        viewLectureArray?.clear();
        lectureByDate();
      } else {
        setState(() {
          isVisible = false;
        });
        viewLectureArray?.clear();
      }
    }on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  void checkCurrentData() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
  }

  void lectureByDate() {
    if (data.records != null && (data.records?.length ?? 0) > 0) {
      for (int j = 0; j < data.records!.length; j++) {
        for (int i = 0; i < (data.records![j].fields!.lectureDate?.length ?? 0); i++) {
          var canAdd = false;
          if (formattedDate == data.records![j].fields!.lectureDate![i]) {
            if (hubRecordId.isNotEmpty) {
              canAdd = hubRecordId == data.records![j].fields!.hub_id_from_lecture![i];
            } else {
              canAdd = true;
            }
          }
          if (canAdd) {
            viewLectureArray?.add(ViewLectureAttendance(
                subject_title: data.records![j].fields!.subjectTitle![i],
                lecture_date: data.records![j].fields!.lectureDate![i],
                unit_title: data.records![j].fields!.lectureDate![i],
                semester: data.records![j].fields!.semester![i],
                division: data.records![j].fields!.division![i],
                lecture_id: data.records![j].fields!.lectureIds![i],
                specilization: data.records![j].fields!.specialization_name![i],

                employee_name: data.records![j].fields!.employeeName));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colors_name.colorPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(14),
          ),
        ),
        title: const Text(strings_name.str_viewothers_attendance),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                color: Colors.white,
                iconSize: 30,
                onPressed: () {
                  showDatePicker(context: context, initialDate: DateTime.parse(formattedDate), firstDate: DateTime(2005), lastDate: DateTime.now()).then((pickedDate) {
                    if (pickedDate == null) {
                      return;
                    }
                    setState(() {
                      var formatter = DateFormat('yyyy-MM-dd');
                      formattedDate = formatter.format(pickedDate);

                      viewEmpLectures();
                    });
                  });
                }),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 10.h),
              Visibility(
                visible: canViewAccessibleAttendance,
                child: custom_text(
                  text: strings_name.str_select_hub,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
              ),
              Visibility(
                visible: canViewAccessibleAttendance,
                child: Row(
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

                              viewEmpLectures();
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
              ),
              SizedBox(height: 10.h),
              Container(
                margin: const EdgeInsets.all(10),
                child: viewLectureArray!.isNotEmpty
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: viewLectureArray?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Card(
                                elevation: 5,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        custom_text(
                                          text: viewLectureArray![index].subject_title!,
                                          alignment: Alignment.topLeft,
                                          textStyles: primaryTextSemiBold14,
                                          bottomValue: 5,
                                        ),
                                        custom_text(
                                          text: viewLectureArray![index].specilization!,
                                          alignment: Alignment.topLeft,
                                          textStyles: blackTextSemiBold12,
                                          topValue: 0,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_by_date}: ${formatterShow.format(DateTime.parse(viewLectureArray![index].lecture_date!))}",
                                          alignment: Alignment.topLeft,
                                          textStyles: blackTextSemiBold12,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        Visibility(
                                          visible: canViewAccessibleAttendance,
                                          child: custom_text(
                                            text: "${strings_name.str_taken_by}: ${viewLectureArray![index].employee_name!}",
                                            textStyles: blackTextSemiBold12,
                                            topValue: 5,
                                            bottomValue: 0,
                                          ),
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_semester}: ${viewLectureArray![index].semester!} ${", "} ${strings_name.str_division}: ${viewLectureArray![index].division!}",
                                          alignment: Alignment.topLeft,
                                          textStyles: blackTextSemiBold12,
                                          topValue: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  canUpdateAccessibleAttendance
                                      ? GestureDetector(
                                          onTap: () async {
                                            Get.to(AttendanceStudentList(), arguments: [
                                              {"lectureId": viewLectureArray![index].lecture_id},
                                            ])?.then((result) {
                                              if (result != null && result) {
                                                viewEmpLectures();
                                              }
                                            });
                                          },
                                          child: Container(margin: const EdgeInsets.all(10), child: const Icon(Icons.edit)))
                                      : Container(),
                                ])),
                            onTap: () {
                              Get.to(() => const AttendanceHistoryDetail(), arguments: viewLectureArray?[index].lecture_id);
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
