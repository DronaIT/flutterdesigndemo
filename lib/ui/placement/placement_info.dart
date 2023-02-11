import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/models/update_job_opportunity.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../values/text_styles.dart';

class PlacementInfo extends StatefulWidget {
  const PlacementInfo({Key? key}) : super(key: key);

  @override
  State<PlacementInfo> createState() => _PlacementInfoState();
}

class _PlacementInfoState extends State<PlacementInfo> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  UpdateJobOpportunity jobOpportunityData = UpdateJobOpportunity();
  String jobRecordId = "";

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      jobRecordId = Get.arguments;
    }
    getRecords();
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    jobOpportunityData = await apiRepository.getJobOpportunityWithRecordIdApi(jobRecordId);
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_placement_info),
      body: Stack(
        children: [
          jobOpportunityData != null && jobOpportunityData.fields != null
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      custom_text(text: strings_name.str_congratulation_for_internship, alignment: Alignment.center, textStyles: blackTextSemiBold15, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 5),
                      custom_text(
                        text: "${jobOpportunityData.fields!.companyName?.first}",
                        textStyles: centerTextStyle21,
                        topValue: 15,
                        alignment: Alignment.center,
                        maxLines: 10,
                        bottomValue: 15,
                        leftValue: 5,
                      ),
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
