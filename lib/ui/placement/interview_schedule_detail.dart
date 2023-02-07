import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/api_repository.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import '../../models/base_api_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../values/text_styles.dart';

class InterViewScheudleDetail extends StatefulWidget {
  const InterViewScheudleDetail({Key? key}) : super(key: key);

  @override
  State<InterViewScheudleDetail> createState() => _InterViewScheudleDetailState();
}

class _InterViewScheudleDetailState extends State<InterViewScheudleDetail> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobpportunityData = BaseLoginResponse();
  String jobId = "";
  var formatterShow = DateFormat('dd-MM-yyyy hh:mm aa');

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      jobId = Get.arguments;
    }
    getRecords();
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    var query = "FIND('2', ${TableNames.CLM_JOB_CODE}, 0)";
    jobpportunityData = await apiRepository.getJoboppoApi(query);
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_interview_schedule),
      body: Stack(
        children: [
          jobpportunityData.records !=null && jobpportunityData.records?.first.fields != null ? Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                custom_text(
                  text: "${strings_name.str_company_name}: ${jobpportunityData.records?.first.fields!.companyName?.first}",
                  textStyles: centerTextStyle21,
                  topValue: 0,
                  maxLines: 2,
                  bottomValue: 5,
                  leftValue: 5,
                ),
                custom_text(text: "${strings_name.str_interview_date_time}:  ${formatterShow.format(DateTime.parse(jobpportunityData.records!.first.fields!.interviewDatetime!))}", textStyles: blackTextSemiBold15,
                    topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 5),

                custom_text(text: "${strings_name.str_special_instrcutor}: ${jobpportunityData.records?.first.fields!.interviewInstruction}",
                    textStyles: blackTextSemiBold15, topValue: 5, maxLines: 1000, bottomValue: 5, leftValue: 5),
                custom_text(text: "${strings_name.str_interview_address}: ${jobpportunityData.records?.first.fields!.interviewPlaceAddress}",
                    textStyles: blackTextSemiBold15, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),

                custom_text(text: "${strings_name.str_google_map_link}: ${jobpportunityData.records?.first.fields!.interviewPlaceUrl}",
                    textStyles: blackTextSemiBold15, topValue: 5, maxLines: 1000, bottomValue: 5, leftValue: 5),

                custom_text(text: "${strings_name.str_contact_person}: ${jobpportunityData.records?.first.fields!.contactNameFromCompanyId?.first}",
                    textStyles: blackTextSemiBold15, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),


                custom_text(text: "${strings_name.str_codinator_name}: ${jobpportunityData.records?.first.fields!.coordinatorName}",
                    textStyles: blackTextSemiBold15, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),


                custom_text(text: "${strings_name.str_codinator_number}: ${jobpportunityData.records?.first.fields!.coordinatorMobileNumber}",
                    textStyles: blackTextSemiBold15, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
              ],
            ),
          ):Container(),


          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )

        ],
      ),
    ));
  }
}
