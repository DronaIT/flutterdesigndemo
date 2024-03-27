import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/company_approch_response.dart';
import 'package:flutterdesigndemo/models/company_detail_response.dart';
import 'package:flutterdesigndemo/models/fees_response.dart';
import 'package:flutterdesigndemo/models/home_module_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/marketing_response.dart';
import 'package:flutterdesigndemo/models/punch_data_response.dart';
import 'package:flutterdesigndemo/models/student_attendance_response.dart';
import 'package:flutterdesigndemo/ui/attendance/attendance_data_by_hubs.dart';
import 'package:flutterdesigndemo/ui/fees/fees_data_by_hubs.dart';
import 'package:flutterdesigndemo/ui/marketing/marketing_dashboard.dart';
import 'package:flutterdesigndemo/ui/placement/company_approach_data_by_hubs.dart';
import 'package:flutterdesigndemo/ui/placement/placement_data_by_hubs.dart';
import 'package:flutterdesigndemo/ui/punch_leaves/punch_data_by_hubs.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MISDashboard extends StatefulWidget {
  const MISDashboard({super.key});

  @override
  State<MISDashboard> createState() => _MISDashboardState();
}

class _MISDashboardState extends State<MISDashboard> {
  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  bool isVisible = false;

  DateTime? startDate = DateTime.now().add(const Duration(days: -1));
  DateTime? endDate = DateTime.now();

  BaseLoginResponse<HubResponse> hubResponse = BaseLoginResponse();
  int totalStudents = 0, totalCompany = 0, totalPlacement = 0;
  double overallPlacement = 0;
  int newlyPlaced = 0, newlySelfPlaced = 0;

  BaseLoginResponse<homeModuleResponse> homeModule = BaseLoginResponse();
  int canShowFees = -1, canShowAttendance = -1, canShowMarketing = -1, canShowPlacement = -1, canShowPunchLeave = -1;
  var roleId = "";

  List<BaseApiResponseWithSerializable<StudentAttendanceResponse>> attendanceData = [];
  double averageLectureAttendance = 0, overallStudentAttendance = 0;

  List<BaseApiResponseWithSerializable<PunchDataResponse>> punchData = [];
  int totalOnLeave = 0, totalRunningLate = 0;

  List<BaseApiResponseWithSerializable<MarketingResponse>> marketingData = [];
  int numberOfApproaches = 0, numberOfMeetings = 0, numberOfSeminarArranged = 0, numberOfSeminarsCompleted = 0;

  List<BaseApiResponseWithSerializable<CompanyApproachResponse>> companyApproachData = [];
  List<BaseApiResponseWithSerializable<CompanyDetailResponse>> companyData = [];
  List<BaseApiResponseWithSerializable<CompanyDetailResponse>> totalCompanyData = [];
  List<BaseApiResponseWithSerializable<JobOpportunityResponse>> jobsData = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> placedStudentData = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> totalPlacedStudentData = [];
  int vacancies = 0;

  List<BaseApiResponseWithSerializable<FeesResponse>> feesData = [];
  double totalFeesReceived = 0;
  int totalStudentsWhoPaid = 0;
  NumberFormat format = NumberFormat.currency(locale: 'HI', symbol: "₹");

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
      hubResponse = await apiRepository.getHubApi();
      if (hubResponse.records!.isNotEmpty) {
        PreferenceUtils.setHubList(hubResponse);
        debugPrint("Hubs ${PreferenceUtils.getHubList().records!.length}");

        for (int i = 0; i < hubResponse.records!.length; i++) {
          if (hubResponse.records![i].fields?.hubId == TableNames.CANCELLED_HUB_ID) {
            hubResponse.records?.removeAt(i);
            i--;
          } else if (hubResponse.records![i].fields?.hubId == TableNames.SUSPENDED_HUB_ID) {
            hubResponse.records?.removeAt(i);
            i--;
          }
        }
      }
      var isLogin = PreferenceUtils.getIsLogin();
      if (isLogin == 2) {
        roleId = PreferenceUtils.getLoginDataEmployee().roleIdFromRoleIds![0];
        getModulePermission(roleId);
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  Future<void> getModulePermission(String roleId) async {
    var query = "AND(SEARCH('$roleId',${TableNames.CLM_ROLE_ID},0),is_active=1)";
    setState(() {
      isVisible = true;
    });
    try {
      homeModule = await apiRepository.getHomeModulesApi(query);
      if (homeModule.records!.isNotEmpty) {
        for (int i = 0; i < (homeModule.records?.length ?? 0); i++) {
          if (homeModule.records![i].fields?.moduleId == TableNames.MODULE_ATTENDANCE) {
            canShowAttendance = i;
          }
          if (homeModule.records![i].fields?.moduleId == TableNames.MODULE_MARKETING) {
            canShowMarketing = i;
          }
          if (homeModule.records![i].fields?.moduleId == TableNames.MODULE_PLACEMENT) {
            canShowPlacement = i;
          }
          if (homeModule.records![i].fields?.moduleId == TableNames.MODULE_FEES) {
            canShowFees = i;
          }
          if (homeModule.records![i].fields?.moduleId == TableNames.MODULE_PUNCH_LEAVES) {
            canShowPunchLeave = i;
          }
        }
        fetchData();
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
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_mis_dashboard),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
              child: homeModule.records?.isNotEmpty != null
                  ? Column(
                      children: [
                        custom_text(
                          text: strings_name.str_select_date_range,
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                          topValue: 0,
                          bottomValue: 5,
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
                        canShowFees != -1
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: colors_name.darkGrayColor, width: 1.r),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                surfaceTintColor: colors_name.colorWhite,
                                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                elevation: 4,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                                              child: Image.network(homeModule.records![canShowFees].fields!.moduleImage.toString(), fit: BoxFit.fill, width: 20.w),
                                            ),
                                            custom_text(
                                              topValue: 0,
                                              bottomValue: 0,
                                              text: strings_name.str_fees,
                                              textStyles: primaryTextSemiBold16,
                                            ),
                                          ],
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_total_students_who_paid}: $totalStudentsWhoPaid",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 8,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_total_fees_received}: ${format.format(totalFeesReceived)}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(const FeesDataByHubs(), arguments: [
                                              {"feesData": feesData},
                                              {"startDate": startDate},
                                              {"endDate": endDate},
                                            ])?.then((result) {
                                              if (result != null && result) {
                                                // Get.back(closeOverlays: true);
                                              }
                                            });
                                          },
                                          child: custom_text(
                                            text: strings_name.str_view_details,
                                            textStyles: primaryTextSemiBold14,
                                            alignment: Alignment.centerRight,
                                            topValue: 10,
                                            bottomValue: 0,
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                            : Container(),
                        canShowPunchLeave != -1
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: colors_name.darkGrayColor, width: 1.r),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                surfaceTintColor: colors_name.colorWhite,
                                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                elevation: 4,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                                              child: Image.network(homeModule.records![canShowPunchLeave].fields!.moduleImage.toString(), fit: BoxFit.fill, width: 20.w),
                                            ),
                                            custom_text(
                                              topValue: 0,
                                              bottomValue: 0,
                                              text: strings_name.str_punch_leave_records,
                                              textStyles: primaryTextSemiBold16,
                                            ),
                                          ],
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_total_on_leave}: $totalOnLeave",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_running_late}: $totalRunningLate",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(const PunchDataByHubs(), arguments: [
                                              {"punchData": punchData},
                                              {"startDate": startDate},
                                              {"endDate": endDate},
                                            ])?.then((result) {
                                              if (result != null && result) {
                                                // Get.back(closeOverlays: true);
                                              }
                                            });
                                          },
                                          child: custom_text(
                                            text: strings_name.str_view_details,
                                            textStyles: primaryTextSemiBold14,
                                            alignment: Alignment.centerRight,
                                            topValue: 10,
                                            bottomValue: 0,
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                            : Container(),
                        canShowAttendance != -1
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: colors_name.darkGrayColor, width: 1.r),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                surfaceTintColor: colors_name.colorWhite,
                                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                elevation: 4,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                                              child: Image.network(homeModule.records![canShowAttendance].fields!.moduleImage.toString(), fit: BoxFit.fill, width: 20.w),
                                            ),
                                            custom_text(
                                              topValue: 0,
                                              bottomValue: 0,
                                              text: strings_name.str_attendance,
                                              textStyles: primaryTextSemiBold16,
                                            ),
                                          ],
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_total_lectures_taken}: ${attendanceData.length}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 8,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_average_attendace}: ${averageLectureAttendance.toStringAsFixed(2)}%",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_overall_student_attendance}: ${overallStudentAttendance.toStringAsFixed(2)}%",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(const AttendanceDataByHubs(), arguments: [
                                              {"attendanceData": attendanceData},
                                              {"startDate": startDate},
                                              {"endDate": endDate},
                                            ])?.then((result) {
                                              if (result != null && result) {
                                                // Get.back(closeOverlays: true);
                                              }
                                            });
                                          },
                                          child: custom_text(
                                            text: strings_name.str_view_details,
                                            textStyles: primaryTextSemiBold14,
                                            alignment: Alignment.centerRight,
                                            topValue: 10,
                                            bottomValue: 0,
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                            : Container(),
                        canShowMarketing != -1
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: colors_name.darkGrayColor, width: 1.r),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                surfaceTintColor: colors_name.colorWhite,
                                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                elevation: 4,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                                              child: Image.network(homeModule.records![canShowMarketing].fields!.moduleImage.toString(), fit: BoxFit.fill, width: 20.w),
                                            ),
                                            custom_text(
                                              topValue: 0,
                                              bottomValue: 0,
                                              text: strings_name.str_marketing,
                                              textStyles: primaryTextSemiBold16,
                                            ),
                                          ],
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_approach}: $numberOfApproaches",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 8,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_meeting}: $numberOfMeetings",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_seminars_arranged}: $numberOfSeminarArranged",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_seminars_completed}: $numberOfSeminarsCompleted",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(const MarketingDashboard());
                                          },
                                          child: custom_text(
                                            text: strings_name.str_view_details,
                                            textStyles: primaryTextSemiBold14,
                                            alignment: Alignment.centerRight,
                                            topValue: 10,
                                            bottomValue: 0,
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                            : Container(),
                        canShowPlacement != -1 && false
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: colors_name.darkGrayColor, width: 1.r),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                surfaceTintColor: colors_name.colorWhite,
                                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                elevation: 4,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                                              child: Image.network(homeModule.records![canShowPlacement].fields!.moduleImage.toString(), fit: BoxFit.fill, width: 20.w),
                                            ),
                                            custom_text(
                                              topValue: 0,
                                              bottomValue: 0,
                                              text: strings_name.str_company_approach,
                                              textStyles: primaryTextSemiBold16,
                                            ),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(const CompanyApproachDataByHubs(), arguments: [
                                              {"companyApproachData": companyApproachData},
                                              {"startDate": startDate},
                                              {"endDate": endDate},
                                              {"companyData": companyData},
                                              {"jobsData": jobsData},
                                            ])?.then((result) {
                                              if (result != null && result) {
                                                // Get.back(closeOverlays: true);
                                              }
                                            });
                                          },
                                          child: custom_text(
                                            text: strings_name.str_view_details,
                                            textStyles: primaryTextSemiBold14,
                                            alignment: Alignment.centerRight,
                                            topValue: 10,
                                            bottomValue: 0,
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                            : Container(),
                        canShowPlacement != -1
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: colors_name.darkGrayColor, width: 1.r),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                surfaceTintColor: colors_name.colorWhite,
                                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                elevation: 4,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(10.w, 0, 0, 0),
                                              child: Image.network(homeModule.records![canShowPlacement].fields!.moduleImage.toString(), fit: BoxFit.fill, width: 20.w),
                                            ),
                                            custom_text(
                                              topValue: 0,
                                              bottomValue: 0,
                                              text: strings_name.str_placement,
                                              textStyles: primaryTextSemiBold16,
                                            ),
                                          ],
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_approach}: ${companyApproachData.length}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 8,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_company_registered}: ${companyData.length}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_jobs_created}: ${jobsData.length}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_vacancies_confirmed}: $vacancies",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_new_students_placed}: $newlyPlaced",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_new_self_placed_students}: $newlySelfPlaced",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_total_companies}: $totalCompany",
                                          maxLines: 2,
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_total_students}: $totalStudents",
                                          maxLines: 2,
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_total_students_placed}: $totalPlacement",
                                          maxLines: 2,
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_overall_student_placement}: ${overallPlacement.toStringAsFixed(2)}%",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(const PlacementDataByHubs(), arguments: [
                                              {"placedStudentData": placedStudentData},
                                              {"startDate": startDate},
                                              {"endDate": endDate},
                                              {"companyApproachData": companyApproachData},
                                              {"companyData": companyData},
                                              {"jobsData": jobsData},
                                            ])?.then((result) {
                                              if (result != null && result) {
                                                // Get.back(closeOverlays: true);
                                              }
                                            });
                                          },
                                          child: custom_text(
                                            text: strings_name.str_view_details,
                                            textStyles: primaryTextSemiBold14,
                                            alignment: Alignment.centerRight,
                                            topValue: 10,
                                            bottomValue: 0,
                                          ),
                                        ),
                                      ],
                                    )),
                              )
                            : Container(),
                      ],
                    )
                  : Container()),
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

      fetchData();
    }
  }

  fetchData() {
    if (canShowAttendance != -1) {
      attendanceData.clear();
      overallStudentAttendance = 0;
      averageLectureAttendance = 0;

      fetchAttendanceData();
    } else if (canShowMarketing != -1) {
      marketingData.clear();

      numberOfApproaches = 0;
      numberOfMeetings = 0;
      numberOfSeminarArranged = 0;
      numberOfSeminarsCompleted = 0;

      fetchMarketingData();
    } else if (canShowPunchLeave != -1) {
      punchData.clear();
      totalRunningLate = 0;
      totalOnLeave = 0;

      fetchPunchLeaveData();
    } else if (canShowFees != -1) {
      feesData.clear();
      totalFeesReceived = 0;
      totalStudentsWhoPaid = 0;
      fetchFeesData();
    } else if (canShowPlacement != -1) {
      companyApproachData.clear();
      fetchCompanyApproachData();
    } else {
      isVisible = false;
      setState(() {});
    }
  }

  void fetchPunchLeaveData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "OR(SEARCH('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",SEARCH('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
        }
      }
    }
    query += "),";

    if (startDate.toString().isNotEmpty && endDate.toString().isNotEmpty) {
      var start = startDate?.add(const Duration(days: -1));
      var startFormat = DateFormat("MM/dd/yyyy").format(start!);

      var end = endDate?.add(const Duration(days: 1));
      var endFormat = DateFormat("MM/dd/yyyy").format(end!);
      query += "IS_BEFORE(punch_date, '$endFormat'),IS_AFTER(punch_date, '$startFormat')";
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getPunchRecordsApi(query, offset);
      if (data.records?.isNotEmpty == true) {
        if (offset.isEmpty) {
          punchData.clear();
        }
        punchData.addAll(data.records as Iterable<BaseApiResponseWithSerializable<PunchDataResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchPunchLeaveData();
        } else {
          punchData.sort((a, b) => b.fields!.punchDate!.compareTo(a.fields!.punchDate!));
          debugPrint(punchData.length.toString());

          if (punchData.isNotEmpty) {
            for (int j = 0; j < punchData.length; j++) {
              if (punchData[j].fields?.attendanceType != TableNames.ATTENDANCE_TYPE_PRESENT) {
                totalOnLeave += 1;
              }
              if (punchData[j].fields?.attendanceType != TableNames.ATTENDANCE_TYPE_FULL_DAY_LEAVE) {
                if (punchData[j].fields?.actualInTime?.isNotEmpty == true) {
                  DateTime actualTime = DateFormat("hh:mm aa").parse(punchData[j].fields?.actualInTime?.last ?? "");
                  DateTime punchTime = DateFormat("hh:mm aa").parse(punchData[j].fields?.punchInTime ?? "");
                  if (punchTime.isAfter(actualTime)) {
                    totalRunningLate += 1;
                  }
                }
              }
            }
          }

          if (canShowFees != -1) {
            feesData.clear();
            totalFeesReceived = 0;
            totalStudentsWhoPaid = 0;
            fetchFeesData();
          } else {
            isVisible = false;
            setState(() {});
          }
        }
      } else {
        if (canShowFees != -1) {
          feesData.clear();
          totalFeesReceived = 0;
          totalStudentsWhoPaid = 0;
          fetchFeesData();
        } else {
          isVisible = false;
          setState(() {});
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

  void fetchAttendanceData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "OR(SEARCH('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",SEARCH('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
        }
      }
    }
    query += "),";

    if (startDate.toString().isNotEmpty && endDate.toString().isNotEmpty) {
      var start = startDate?.add(const Duration(days: -1));
      var startFormat = DateFormat("MM/dd/yyyy").format(start!);

      var end = endDate?.add(const Duration(days: 1));
      var endFormat = DateFormat("MM/dd/yyyy").format(end!);
      query += "IS_BEFORE(lecture_date, '$endFormat'), IS_AFTER(lecture_date, '$startFormat')";
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getStudentAttendanceApi(query, offset);
      if (data.records?.isNotEmpty == true) {
        if (offset.isEmpty) {
          attendanceData.clear();
        }
        attendanceData.addAll(data.records as Iterable<BaseApiResponseWithSerializable<StudentAttendanceResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchAttendanceData();
        } else {
          attendanceData.sort((a, b) => a.fields!.lectureDate!.compareTo(b.fields!.lectureDate!));
          debugPrint(attendanceData.length.toString());

          int totalStudent = 0, presentStudent = 0;
          double avgAttendance = 0.0;
          for (int i = 0; i < attendanceData.length; i++) {
            totalStudent += attendanceData[i].fields!.studentIds?.length ?? 0;
            presentStudent += attendanceData[i].fields!.presentIds?.length ?? 0;

            if ((attendanceData[i].fields!.studentIds?.length ?? 0) > 0) {
              var avg = ((attendanceData[i].fields!.presentIds?.length ?? 0) * 100) / attendanceData[i].fields!.studentIds!.length;
              avgAttendance += avg;
            }
          }

          overallStudentAttendance = (presentStudent * 100) / totalStudent;
          averageLectureAttendance = avgAttendance / attendanceData.length;

          if (canShowMarketing != -1) {
            marketingData.clear();

            numberOfApproaches = 0;
            numberOfMeetings = 0;
            numberOfSeminarArranged = 0;
            numberOfSeminarsCompleted = 0;

            fetchMarketingData();
          } else {
            isVisible = false;
            setState(() {});
          }
        }
      } else {
        if (canShowMarketing != -1) {
          marketingData.clear();

          numberOfApproaches = 0;
          numberOfMeetings = 0;
          numberOfSeminarArranged = 0;
          numberOfSeminarsCompleted = 0;

          fetchMarketingData();
        } else {
          isVisible = false;
          setState(() {});
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

  void fetchMarketingData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "OR(SEARCH('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_EMPLOYEE_HUB_ID}}),0)";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",SEARCH('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_EMPLOYEE_HUB_ID}}),0)";
        }
      }
    }
    query += "),";

    if (startDate.toString().isNotEmpty && endDate.toString().isNotEmpty) {
      var start = startDate?.add(const Duration(days: -1));
      var startFormat = DateFormat("MM/dd/yyyy").format(start!);

      var end = endDate?.add(const Duration(days: 1));
      var endFormat = DateFormat("MM/dd/yyyy").format(end!);
      query += "IS_BEFORE(entry_date, '$endFormat'), IS_AFTER(entry_date, '$startFormat')";
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getMarketingRecordsApi(query, offset);
      if (data.records?.isNotEmpty == true) {
        if (offset.isEmpty) {
          marketingData.clear();
        }
        marketingData.addAll(data.records as Iterable<BaseApiResponseWithSerializable<MarketingResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchMarketingData();
        } else {
          marketingData.sort((a, b) => a.fields!.entryDate!.compareTo(b.fields!.entryDate!));
          debugPrint(marketingData.length.toString());

          for (int i = 0; i < marketingData.length; i++) {
            numberOfApproaches += marketingData[i].fields!.numberOfApproach ?? 0;
            numberOfMeetings += marketingData[i].fields!.numberOfMeetings ?? 0;
            numberOfSeminarArranged += marketingData[i].fields!.numberOfSeminarArranged ?? 0;
            numberOfSeminarsCompleted += marketingData[i].fields!.numberOfSeminarsCompleted ?? 0;
          }

          if (canShowPunchLeave != -1) {
            punchData.clear();
            totalRunningLate = 0;
            totalOnLeave = 0;

            fetchPunchLeaveData();
          } else {
            isVisible = false;
            setState(() {});
          }
        }
      } else {
        if (canShowPunchLeave != -1) {
          punchData.clear();
          totalRunningLate = 0;
          totalOnLeave = 0;

          fetchPunchLeaveData();
        } else {
          isVisible = false;
          setState(() {});
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

  void fetchCompanyApproachData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    if (startDate.toString().isNotEmpty && endDate.toString().isNotEmpty) {
      var start = startDate?.add(const Duration(days: -1));
      var startFormat = DateFormat("MM/dd/yyyy").format(start!);

      var end = endDate?.add(const Duration(days: 1));
      var endFormat = DateFormat("MM/dd/yyyy").format(end!);
      query += "IS_BEFORE(CREATED, '$endFormat'), IS_AFTER(CREATED, '$startFormat')";
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getCompanyApproachApi(query, offset);
      if (data.records?.isNotEmpty == true) {
        if (offset.isEmpty) {
          companyApproachData.clear();
        }
        companyApproachData.addAll(data.records as Iterable<BaseApiResponseWithSerializable<CompanyApproachResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchCompanyApproachData();
        } else {
          companyApproachData.sort((a, b) => a.fields!.companyName!.compareTo(b.fields!.companyName!));
          debugPrint(companyApproachData.length.toString());

          companyData.clear();
          fetchCompanyData();
        }
      } else {
        companyData.clear();
        fetchCompanyData();
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  void fetchCompanyData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "OR(SEARCH('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",SEARCH('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
        }
      }
    }
    query += "),";

    if (startDate.toString().isNotEmpty && endDate.toString().isNotEmpty) {
      var start = startDate?.add(const Duration(days: -1));
      var startFormat = DateFormat("MM/dd/yyyy").format(start!);

      var end = endDate?.add(const Duration(days: 1));
      var endFormat = DateFormat("MM/dd/yyyy").format(end!);
      query += "IS_BEFORE(CREATED, '$endFormat'), IS_AFTER(CREATED, '$startFormat')";
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getCompanyDetailApi(query, offset);
      if (data.records?.isNotEmpty == true) {
        if (offset.isEmpty) {
          companyData.clear();
        }
        companyData.addAll(data.records as Iterable<BaseApiResponseWithSerializable<CompanyDetailResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchCompanyData();
        } else {
          companyData.sort((a, b) => a.fields!.companyName!.compareTo(b.fields!.companyName!));
          debugPrint(companyData.length.toString());

          jobsData.clear();
          vacancies = 0;
          fetchJobsData();
        }
      } else {
        jobsData.clear();
        vacancies = 0;
        fetchJobsData();
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  void fetchJobsData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "OR(SEARCH('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",SEARCH('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
        }
      }
    }
    query += "),";

    if (startDate.toString().isNotEmpty && endDate.toString().isNotEmpty) {
      var start = startDate?.add(const Duration(days: -1));
      var startFormat = DateFormat("MM/dd/yyyy").format(start!);

      var end = endDate?.add(const Duration(days: 1));
      var endFormat = DateFormat("MM/dd/yyyy").format(end!);
      query += "IS_BEFORE(Created, '$endFormat'), IS_AFTER(Created, '$startFormat')";
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getJobOppoApi(query, offset);
      if (data.records?.isNotEmpty == true) {
        if (offset.isEmpty) {
          jobsData.clear();
        }
        jobsData.addAll(data.records as Iterable<BaseApiResponseWithSerializable<JobOpportunityResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchJobsData();
        } else {
          jobsData.sort((a, b) => a.fields!.jobTitle!.compareTo(b.fields!.jobTitle!));
          debugPrint(jobsData.length.toString());
          for (int i = 0; i < jobsData.length; i++) {
            vacancies += jobsData[i].fields?.vacancies ?? 0;
          }

          placedStudentData.clear();
          fetchPlacedStudentData();
        }
      } else {
        placedStudentData.clear();
        fetchPlacedStudentData();
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  void fetchPlacedStudentData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "OR(SEARCH('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",SEARCH('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
        }
      }
    }
    query += "),${TableNames.CLM_IS_PLACED_NOW}='1',";

    if (startDate.toString().isNotEmpty && endDate.toString().isNotEmpty) {
      var start = startDate?.add(const Duration(days: -1));
      var startFormat = DateFormat("MM/dd/yyyy").format(start!);

      var end = endDate?.add(const Duration(days: 1));
      var endFormat = DateFormat("MM/dd/yyyy").format(end!);
      query += "IS_BEFORE(placed_now_changed_on, '$endFormat'), IS_AFTER(placed_now_changed_on, '$startFormat')";
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.loginApi(query, offset);
      if (data.records?.isNotEmpty == true) {
        if (offset.isEmpty) {
          placedStudentData.clear();
        }
        placedStudentData.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchPlacedStudentData();
        } else {
          placedStudentData.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
          debugPrint(placedStudentData.length.toString());

          newlyPlaced = 0;
          newlySelfPlaced = 0;
          for (int i = 0; i < placedStudentData.length; i++) {
            if (placedStudentData[i].fields?.isSelfPlacedCurrently?.last == 1) {
              newlySelfPlaced += 1;
            } else {
              newlyPlaced += 1;
            }
          }

          fetchDataLocally();
          isVisible = false;
          setState(() {});
          // totalPlacedStudentData.clear();
          // fetchTotalPlacedStudentData();
        }
      } else {
        fetchDataLocally();
        isVisible = false;
        setState(() {});
        // totalPlacedStudentData.clear();
        // fetchTotalPlacedStudentData();
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  fetchDataLocally() {
    totalStudents = 0;
    totalCompany = 0;
    totalPlacement = 0;
    overallPlacement = 0;
    HashSet<String> companySet = HashSet<String>();

    for (int i = 0; i < (hubResponse.records?.length ?? 0); i++) {
      if (hubResponse.records![i].fields?.hubId == PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds?.last) {
        totalCompany += hubResponse.records![i].fields?.tblCompany?.length ?? 0;
        companySet.addAll(hubResponse.records![i].fields?.tblCompany?.toSet() ?? []);
        for (int j = 0; j < (hubResponse.records![i].fields?.isPlacedNow?.length ?? 0); j++) {
          if (hubResponse.records![i].fields?.studentSemester![j] != "7") {
            totalStudents += 1;
            if (hubResponse.records![i].fields?.isPlacedNow![j] == "1") {
              totalPlacement += 1;
            }
          }
        }
      } else if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true &&
          PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.contains(hubResponse.records![i].fields?.hubId) == true) {
        totalCompany += hubResponse.records![i].fields?.tblCompany?.length ?? 0;
        companySet.addAll(hubResponse.records![i].fields?.tblCompany?.toSet() ?? []);
        for (int j = 0; j < (hubResponse.records![i].fields?.isPlacedNow?.length ?? 0); j++) {
          if (hubResponse.records![i].fields?.studentSemester![j] != "7") {
            totalStudents += 1;
            if (hubResponse.records![i].fields?.isPlacedNow![j] == "1") {
              totalPlacement += 1;
            }
          }
        }
      }
    }

    if (totalStudents > 0) {
      overallPlacement = (totalPlacement * 100) / totalStudents;
    }

    if (companySet.isNotEmpty) {
      totalCompany = companySet.length;
    }
  }

  void fetchTotalPlacedStudentData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "OR(SEARCH('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",SEARCH('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
        }
      }
    }
    query += "),${TableNames.CLM_IS_PLACED_NOW}='1'";

    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.loginApi(query, offset);
      if (data.records?.isNotEmpty == true) {
        if (offset.isEmpty) {
          totalPlacedStudentData.clear();
        }
        totalPlacedStudentData.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchTotalPlacedStudentData();
        } else {
          totalPlacedStudentData.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
          debugPrint(totalPlacedStudentData.length.toString());

          totalCompanyData.clear();
          fetchTotalCompanyData();
        }
      } else {
        totalCompanyData.clear();
        fetchTotalCompanyData();
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  void fetchTotalCompanyData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "OR(SEARCH('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",SEARCH('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
        }
      }
    }
    query += "),NOT(BLANK(TBL_JOBS))";

    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getCompanyDetailApi(query, offset);
      if (data.records?.isNotEmpty == true) {
        if (offset.isEmpty) {
          totalCompanyData.clear();
        }
        totalCompanyData.addAll(data.records as Iterable<BaseApiResponseWithSerializable<CompanyDetailResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchTotalCompanyData();
        } else {
          totalCompanyData.sort((a, b) => a.fields!.companyName!.compareTo(b.fields!.companyName!));
          debugPrint(totalCompanyData.length.toString());

          isVisible = false;
          setState(() {});
        }
      } else {
        isVisible = false;
        setState(() {});
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  void fetchFeesData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "OR(SEARCH('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",SEARCH('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
        }
      }
    }
    query += "),";

    if (startDate.toString().isNotEmpty && endDate.toString().isNotEmpty) {
      var start = startDate?.add(const Duration(days: -1));
      var startFormat = DateFormat("MM/dd/yyyy").format(start!);

      var end = endDate?.add(const Duration(days: 1));
      var endFormat = DateFormat("MM/dd/yyyy").format(end!);
      query += "IS_BEFORE(paid_on, '$endFormat'),IS_AFTER(paid_on, '$startFormat')";
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getFeesRecordsApi(query, offset);
      if (data.records?.isNotEmpty == true) {
        if (offset.isEmpty) {
          feesData.clear();
        }
        feesData.addAll(data.records as Iterable<BaseApiResponseWithSerializable<FeesResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchFeesData();
        } else {
          feesData.sort((a, b) => a.fields!.studentName!.first.compareTo(b.fields!.studentName!.first));
          debugPrint(feesData.length.toString());

          for (int i = 0; i < feesData.length; i++) {
            totalFeesReceived += feesData[i].fields!.feesPaid ?? 0;
            totalStudentsWhoPaid += 1;
          }

          if (canShowPlacement != -1) {
            companyApproachData.clear();
            fetchCompanyApproachData();
          } else {
            isVisible = false;
            setState(() {});
          }
        }
      } else {
        if (canShowPlacement != -1) {
          companyApproachData.clear();
          fetchCompanyApproachData();
        } else {
          isVisible = false;
          setState(() {});
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
}
