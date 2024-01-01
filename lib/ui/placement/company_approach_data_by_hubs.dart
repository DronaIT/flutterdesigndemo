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
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CompanyApproachDataByHubs extends StatefulWidget {
  const CompanyApproachDataByHubs({super.key});

  @override
  State<CompanyApproachDataByHubs> createState() => _CompanyApproachDataByHubsState();
}

class _CompanyApproachDataByHubsState extends State<CompanyApproachDataByHubs> {
  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  bool isVisible = false;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  DateTime? startDate = DateTime.now().add(const Duration(days: -1));
  DateTime? endDate = DateTime.now();

  List<BaseApiResponseWithSerializable<CompanyApprochResponse>> companyApproachData = [];
  List<BaseApiResponseWithSerializable<CompanyDetailResponse>> companyData = [];
  List<BaseApiResponseWithSerializable<JobOpportunityResponse>> jobsData = [];

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
      if (Get.arguments[0]["companyApproachData"] != null) {
        companyApproachData = Get.arguments[0]["companyApproachData"];
      }
      if (Get.arguments[1]["startDate"] != null) {
        startDate = Get.arguments[1]["startDate"];
      }
      if (Get.arguments[2]["endDate"] != null) {
        endDate = Get.arguments[2]["endDate"];
      }
      if (Get.arguments[3]["companyData"] != null) {
        companyData = Get.arguments[3]["companyData"];
      }
      if (Get.arguments[4]["jobsData"] != null) {
        jobsData = Get.arguments[4]["jobsData"];
      }

      combineData();
      setState(() {});
    } else {
      fetchCompanyData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_company_approach),
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
                                        custom_text(text: "${hubResponseArray![index].fields?.hubName?.trim()}, ${hubResponseArray![index].fields?.city}", maxLines: 2, textStyles: primaryTextSemiBold16),
                                        custom_text(
                                          text: "${strings_name.str_number_of_company_registered}: ${hubResponseArray![index].fields?.newCompany}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_jobs_created}: ${hubResponseArray![index].fields?.newJobs}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 5,
                                          bottomValue: 0,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_number_of_vacancies_confirmed}: ${hubResponseArray![index].fields?.newVacancies}",
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

      companyData.clear();
      jobsData.clear();
      fetchCompanyData();
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
          fetchJobsData();
        }
      } else {
        jobsData.clear();
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
      int newCompany = 0;
      for (int j = 0; j < (companyData.length ?? 0); j++) {
        if (hubResponseArray![i].fields?.hubId == companyData[j].fields?.hubIdFromHubIds?.last) {
          newCompany += 1;
        }
      }
      hubResponseArray![i].fields?.newCompany = newCompany;

      int newJobs = 0;
      int newVacancies = 0;
      for (int j = 0; j < (jobsData.length ?? 0); j++) {
        if (hubResponseArray![i].fields?.hubId == jobsData[j].fields?.hubIdFromHubIds?.last) {
          newJobs += 1;
          newVacancies += jobsData[j].fields?.vacancies ?? 0;
        }
      }
      hubResponseArray![i].fields?.newJobs = newJobs;
      hubResponseArray![i].fields?.newVacancies = newVacancies;
    }
  }
}
