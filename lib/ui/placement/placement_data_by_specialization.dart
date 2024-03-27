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
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PlacementDataBySpecialization extends StatefulWidget {
  const PlacementDataBySpecialization({super.key});

  @override
  State<PlacementDataBySpecialization> createState() => _PlacementDataBySpecializationState();
}

class _PlacementDataBySpecializationState extends State<PlacementDataBySpecialization> {
  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  bool isVisible = false;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  DateTime? startDate = DateTime.now().add(const Duration(days: -1));
  DateTime? endDate = DateTime.now();

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> placedStudentData = [];
  NumberFormat format = NumberFormat.currency(locale: 'HI', symbol: "₹");

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      if (Get.arguments[0]["placedStudentData"] != null) {
        placedStudentData = Get.arguments[0]["placedStudentData"];
      }
      if (Get.arguments[1]["startDate"] != null) {
        startDate = Get.arguments[1]["startDate"];
      }
      if (Get.arguments[2]["endDate"] != null) {
        endDate = Get.arguments[2]["endDate"];
      }
      if (Get.arguments[3]["hubData"] != null) {
        hubResponse = Get.arguments[3]["hubData"];
      }

      speResponseArray?.addAll(PreferenceUtils.getSpecializationList().records!);
      if (hubResponse != null) {
        for (int i = 0; i < speResponseArray!.length; i++) {
          if (speResponseArray![i].fields?.hubIdFromHubIds?.contains(hubResponse?.fields?.hubId) != true) {
            speResponseArray!.removeAt(i);
            i--;
          }
        }
      }
      if (speResponseArray?.isNotEmpty == true) {
        speResponseArray?.sort((a, b) => a.fields!.specializationName!.compareTo(b.fields!.specializationName!));
      }

      combineData();
      setState(() {});
    } else {
      fetchPlacedStudentData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_placement_dashboard),
      body: Stack(children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
          child: Column(
            children: [
              custom_text(
                text: "${hubResponse?.fields?.hubName?.trim()}, ${hubResponse?.fields?.city}",
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
                topValue: 0,
                bottomValue: 5,
              ),
              custom_text(
                text: "${strings_name.str_total_companies}: ${hubResponse?.fields?.tblCompany?.length ?? 0}",
                textStyles: blackTextSemiBold14,
                topValue: 0,
                bottomValue: 5,
              ),
              startDate != null && endDate != null && false
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
              speResponseArray?.isNotEmpty == true
                  ? Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: ListView.builder(
                            itemCount: speResponseArray?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {},
                                child: Card(
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
                                        custom_text(text: "${speResponseArray![index].fields?.specializationName?.trim()}", maxLines: 2, textStyles: primaryTextSemiBold16),
                                        custom_text(
                                          text: "${strings_name.str_number_of_new_students_placed}: ${speResponseArray![index].fields?.newPlaced}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_new_self_placed_students}: ${speResponseArray![index].fields?.newSelfPlaced}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_total_students}: ${speResponseArray![index].fields?.totalStudent}",
                                          maxLines: 2,
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_total_students_placed}: ${speResponseArray![index].fields?.totalPlacement}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_overall_student_placement}: ${speResponseArray![index].fields?.overallPlacement.toStringAsFixed(2)}%",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_hub, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
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

      placedStudentData.clear();
      fetchPlacedStudentData();
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
    for (int i = 0; i < (speResponseArray?.length ?? 0); i++) {
      int totalPlacement = 0;
      int totalStudent = 0;
      for (int j = 0; j < (hubResponse?.fields?.tblStudent?.length ?? 0); j++) {
        if (speResponseArray![i].fields?.specializationId == hubResponse?.fields?.studentSpecializationIds![j]) {
          if (hubResponse?.fields?.studentSemester![j] != "7") {
            totalStudent += 1;
            if (hubResponse?.fields?.isPlacedNow![j] == "1") {
              totalPlacement += 1;
            }
          }
        }
      }

      speResponseArray![i].fields?.totalPlacement = totalPlacement;
      speResponseArray![i].fields?.totalStudent = totalStudent;
      if (totalStudent > 0) {
        speResponseArray![i].fields?.overallPlacement = (totalPlacement * 100) / totalStudent;
      }

      int newPlaced = 0, newSelfPlaced = 0;
      for (int j = 0; j < (placedStudentData.length ?? 0); j++) {
        if (hubResponse?.fields?.hubId == placedStudentData[j].fields?.hubIdFromHubIds?.last) {
          if (speResponseArray![i].fields?.specializationId == placedStudentData[j].fields?.specializationIdFromSpecializationIds?.last) {
            if (placedStudentData[j].fields?.isSelfPlacedCurrently?.last == 1) {
              newSelfPlaced += 1;
            } else {
              newPlaced += 1;
            }
          }
        }
      }
      speResponseArray![i].fields?.newPlaced = newPlaced;
      speResponseArray![i].fields?.newSelfPlaced = newSelfPlaced;
    }
  }
}
