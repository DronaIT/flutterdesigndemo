import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../models/base_api_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class InterViewScheduleDetail extends StatefulWidget {
  const InterViewScheduleDetail({Key? key}) : super(key: key);

  @override
  State<InterViewScheduleDetail> createState() => _InterViewScheduleDetailState();
}

class _InterViewScheduleDetailState extends State<InterViewScheduleDetail> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobOpportunityData = BaseLoginResponse();
  String jobCode = "";
  var formatterShow = DateFormat('dd-MM-yyyy hh:mm aa');

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      jobCode = Get.arguments;
    }
    getRecords();
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    var query = "FIND('$jobCode', ${TableNames.CLM_JOB_CODE}, 0)";
    try{
      jobOpportunityData = await apiRepository.getJoboppoApi(query);
      setState(() {
        isVisible = false;
      });
    }on DioError catch (e) {
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_interview_schedule),
      body: Stack(
        children: [
          jobOpportunityData.records != null && jobOpportunityData.records?.first.fields != null
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      custom_text(
                        text: "${strings_name.str_company_name}: ${jobOpportunityData.records?.first.fields!.companyName?.first}",
                        textStyles: centerTextStyle21,
                        topValue: 0,
                        maxLines: 2,
                        bottomValue: 5,
                        leftValue: 5,
                      ),
                      custom_text(text: "${strings_name.str_interview_date_time} : ${formatterShow.format(DateTime.parse(jobOpportunityData.records!.first.fields!.interviewDatetime!))}", textStyles: blackTextSemiBold15, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 5),
                      custom_text(text: "${strings_name.str_special_instrcutor} :", textStyles: blackTextSemiBold15, topValue: 8, maxLines: 1000, bottomValue: 0, leftValue: 5),
                      custom_text(text: "${jobOpportunityData.records?.first.fields!.interviewInstruction}", textStyles: blackTextSemiBold14, topValue: 5, maxLines: 1000, bottomValue: 5, leftValue: 5),
                      custom_text(text: "${strings_name.str_interview_address} :", textStyles: blackTextSemiBold15, topValue: 8, bottomValue: 5, leftValue: 5),
                      custom_text(text: "${jobOpportunityData.records?.first.fields!.interviewPlaceAddress}", textStyles: blackTextSemiBold14, topValue: 2, maxLines: 100, bottomValue: 5, leftValue: 5),
                      Visibility(
                        visible: jobOpportunityData.records?.first.fields!.interviewPlaceUrl != null,
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Column(children: [
                              custom_text(text: "${strings_name.str_google_map_link} : ", textStyles: blackTextSemiBold15, topValue: 5, bottomValue: 3, leftValue: 0),
                              Align(
                                alignment: Alignment.topLeft,
                                child: SelectableLinkify(
                                  text: "${jobOpportunityData.records?.first.fields!.interviewPlaceUrl}",
                                  style: blackTextSemiBold15,
                                  onOpen: (link) async {
                                    await launchUrl(Uri.parse(link.url), mode: LaunchMode.externalApplication);
                                  },
                                ),
                              ),
                            ])),
                      ),
                      custom_text(text: "${strings_name.str_contact_person}: ${jobOpportunityData.records?.first.fields!.contactNameFromCompanyId?.first}", textStyles: blackTextSemiBold15, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                      custom_text(text: "${strings_name.str_codinator_name}: ${jobOpportunityData.records?.first.fields!.coordinatorName}", textStyles: blackTextSemiBold15, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                      custom_text(text: "${strings_name.str_codinator_number}: ${jobOpportunityData.records?.first.fields!.coordinatorMobileNumber}", textStyles: blackTextSemiBold15, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                    ],
                  ),
                )
              : Container(),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
