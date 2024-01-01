import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/punch_data_response.dart';
import 'package:flutterdesigndemo/ui/punch_leaves/punch_data_list.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PunchDataByHubs extends StatefulWidget {
  const PunchDataByHubs({super.key});

  @override
  State<PunchDataByHubs> createState() => _PunchDataByHubsState();
}

class _PunchDataByHubsState extends State<PunchDataByHubs> {
  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  bool isVisible = false;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  DateTime? startDate = DateTime.now().add(const Duration(days: -1));
  DateTime? endDate = DateTime.now();

  List<BaseApiResponseWithSerializable<PunchDataResponse>> punchData = [];
  NumberFormat format = NumberFormat.currency(locale: 'HI', symbol: "₹");

  @override
  void initState() {
    super.initState();
    hubResponseArray?.addAll(PreferenceUtils.getHubList().records!);
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

      if (hubResponseArray?.isNotEmpty == true) {
        hubResponseArray?.sort((a, b) => a.fields!.hubName!.compareTo(b.fields!.hubName!));
      }
    }

    if (Get.arguments != null) {
      if (Get.arguments[0]["punchData"] != null) {
        punchData = Get.arguments[0]["punchData"];
      }
      if (Get.arguments[1]["startDate"] != null) {
        startDate = Get.arguments[1]["startDate"];
      }
      if (Get.arguments[2]["endDate"] != null) {
        endDate = Get.arguments[2]["endDate"];
      }

      combineData();
      setState(() {});
    } else {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_punch_leave_records),
      body: Stack(children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
          child: Column(
            children: [
              Visibility(
                visible: false,
                child: custom_text(
                  text: strings_name.str_date_range,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  topValue: 0,
                  bottomValue: 5,
                ),
              ),
              startDate != null && endDate != null && false
                  ? GestureDetector(
                      child: custom_text(
                        text:
                            "${startDate.toString().split(" ").first.replaceAll("-", "/")} - ${endDate.toString().split(" ").first.replaceAll("-", "/")}",
                        alignment: Alignment.topLeft,
                        textStyles: primaryTextSemiBold16,
                        topValue: 0,
                      ),
                      onTap: () {
                        _show();
                      },
                    )
                  : Container(),
              hubResponseArray?.isNotEmpty == true
                  ? Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: ListView.builder(
                            itemCount: hubResponseArray?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: colors_name.darkGrayColor, width: 1.r),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                surfaceTintColor: colors_name.colorWhite,
                                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      custom_text(
                                          text: "${hubResponseArray![index].fields?.hubName?.trim()}, ${hubResponseArray![index].fields?.city}",
                                          maxLines: 2,
                                          textStyles: primaryTextSemiBold16),
                                      Visibility(
                                        visible: false,
                                        child: custom_text(
                                            topValue: 0,
                                            bottomValue: 5,
                                            maxLines: 2,
                                            text: "${strings_name.str_total_employees}: ${hubResponseArray![index].fields?.totalEmployee}",
                                            textStyles: blackTextSemiBold14),
                                      ),
                                      custom_text(
                                          topValue: 0,
                                          bottomValue: 5,
                                          maxLines: 2,
                                          text: "${strings_name.str_total_on_leave}: ${hubResponseArray![index].fields?.onLeaveToday}",
                                          textStyles: blackTextSemiBold14),
                                      custom_text(
                                          topValue: 0,
                                          bottomValue: 8,
                                          maxLines: 2,
                                          text: "${strings_name.str_running_late}: ${hubResponseArray![index].fields?.runningLate}",
                                          textStyles: blackTextSemiBold14),
                                      GestureDetector(
                                        onTap: () {
                                          List<BaseApiResponseWithSerializable<PunchDataResponse>> selectedPunchData = [];
                                          for (int j = 0; j < punchData.length; j++) {
                                            if (punchData[j].fields?.hubIdFromHubIds?.last == hubResponseArray![index].fields?.hubId) {
                                              selectedPunchData.add(punchData[j]);
                                            }
                                          }

                                          Get.to(const PunchDataList(), arguments: [
                                            {"punchData": selectedPunchData},
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
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: custom_text(text: strings_name.str_no_hub, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
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

      punchData.clear();
      fetchData();
    }
  }

  void fetchData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "OR(SEARCH('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null &&
        PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query +=
              ",SEARCH('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
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
          fetchData();
        } else {
          punchData.sort((a, b) => b.fields!.punchDate!.compareTo(a.fields!.punchDate!));
          debugPrint(punchData.length.toString());

          combineData();

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

  combineData() {
    for (int i = 0; i < (hubResponseArray?.length ?? 0); i++) {
      int totalOnLeave = 0, totalEmployee = 0, runningLate = 0;
      for (int j = 0; j < (hubResponseArray![i].fields?.workingEmployees?.length ?? 0); j++) {
        if (hubResponseArray![i].fields?.workingEmployees![j] == "1") {
          totalEmployee += 1;
        }
      }
      for (int j = 0; j < punchData.length; j++) {
        if (punchData[j].fields?.hubIdFromHubIds?.last == hubResponseArray![i].fields?.hubId) {
          if (punchData[j].fields?.attendanceType != TableNames.ATTENDANCE_TYPE_PRESENT) {
            totalOnLeave += 1;
          }
          if (punchData[j].fields?.attendanceType != TableNames.ATTENDANCE_TYPE_FULL_DAY_LEAVE) {
            if (punchData[j].fields?.actualInTime?.isNotEmpty == true) {
              DateTime actualTime = DateFormat("hh:mm aa").parse(punchData[j].fields?.actualInTime?.last ?? "");
              DateTime punchTime = DateFormat("hh:mm aa").parse(punchData[j].fields?.punchInTime ?? "");
              if (punchTime.isAfter(actualTime)) {
                runningLate += 1;
              }
            }
          }
        }
      }
      hubResponseArray![i].fields?.totalEmployee = totalEmployee;
      hubResponseArray![i].fields?.onLeaveToday = totalOnLeave;
      hubResponseArray![i].fields?.runningLate = runningLate;
    }
  }
}
