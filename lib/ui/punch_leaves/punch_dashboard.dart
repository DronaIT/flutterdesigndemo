import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/add_button.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/punch_data_response.dart';
import 'package:flutterdesigndemo/ui/punch_leaves/add_punch_data.dart';
import 'package:flutterdesigndemo/ui/punch_leaves/punch_data_by_hubs.dart';
import 'package:flutterdesigndemo/ui/punch_leaves/punch_data_list.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PunchDashboard extends StatefulWidget {
  const PunchDashboard({super.key});

  @override
  State<PunchDashboard> createState() => _PunchDashboardState();
}

class _PunchDashboardState extends State<PunchDashboard> {
  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  bool isVisible = false;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  List<String> attendanceTypeArray = <String>[
    TableNames.ATTENDANCE_TYPE_PRESENT,
    TableNames.ATTENDANCE_TYPE_FULL_DAY_LEAVE,
    TableNames.ATTENDANCE_TYPE_FIRST_HALF_LEAVE,
    TableNames.ATTENDANCE_TYPE_SECOND_HALF_LEAVE
  ];
  String attendanceValue = "";

  DateTime? startDate = DateTime.now().add(const Duration(days: -1));
  DateTime? endDate = DateTime.now();

  List<BaseApiResponseWithSerializable<PunchDataResponse>> punchData = [];

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
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_punch_leave_records),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              AddButton(
                onTap: () async {
                  Get.to(const AddPunchData())?.then((value) {
                    if (value != null && value) {
                      // getRecords();
                    }
                  });
                },
                title: strings_name.str_add_record,
              ),
              SizedBox(height: 10.h),
              AddButton(
                onTap: () async {
                  Get.to(const PunchDataByHubs());
                },
                title: strings_name.str_browse_hub_wise,
                alignment: Alignment.centerLeft,
                type: 2,
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                    child: Container(
                      height: 1.h,
                      width: 100.w,
                      color: colors_name.darkGrayColor,
                    ),
                  ),
                  custom_text(
                    text: strings_name.str_or,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    bottomValue: 0,
                    topValue: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                    child: Container(
                      height: 1.h,
                      width: 100.w,
                      color: colors_name.darkGrayColor,
                    ),
                  ),
                ],
              ),
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
                  isExpanded: true,
                  elevation: 16,
                  style: blackText16,
                  focusColor: Colors.white,
                  onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                    hubValue = newValue!.fields!.id!.toString();
                    hubResponse = newValue;
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
              SizedBox(height: 5.h),
              custom_text(
                text: strings_name.str_attendance_type,
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
                        focusColor: Colors.white,
                        onChanged: (String? newValue) {
                          setState(() {
                            attendanceValue = newValue!;
                          });
                        },
                        items: attendanceTypeArray.map<DropdownMenuItem<String>>((String value) {
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
              SizedBox(height: 5.h),
              custom_text(
                text: strings_name.str_select_date_range,
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
                topValue: 0,
              ),
              startDate != null && endDate != null
                  ? GestureDetector(
                      child: custom_text(
                        text: "${startDate.toString().split(" ").first} - ${endDate.toString().split(" ").first}",
                        alignment: Alignment.topLeft,
                        textStyles: primaryTextSemiBold16,
                        topValue: 0,
                      ),
                      onTap: () {
                        _show();
                      },
                    )
                  : Container(),
              CustomButton(
                text: strings_name.str_submit,
                click: () {
                  if (hubValue.trim().isEmpty) {
                    Utils.showSnackBar(context, strings_name.str_empty_hub);
                  } else {
                    punchData.clear();
                    fetchData();
                  }
                },
              ),
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
      setState(() {
        startDate = result.start;
        endDate = result.end;
      });
    }
  }

  void fetchData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(";

    query += "SEARCH('${hubResponse?.fields?.hubId}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0),";
    if (attendanceValue.isNotEmpty) {
      query += "SEARCH('$attendanceValue',${TableNames.CLM_ATTENDANCE_TYPE},0),";
    }

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

          isVisible = false;

          Get.to(const PunchDataList(), arguments: [
            {"punchData": punchData},
          ])?.then((result) {
            if (result != null && result) {
              // Get.back(closeOverlays: true);
            }
          });

          setState(() {});
        }
      } else {
        if (punchData.isEmpty) {
          Utils.showSnackBarUsingGet(strings_name.str_no_data_found);
        }
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
}
