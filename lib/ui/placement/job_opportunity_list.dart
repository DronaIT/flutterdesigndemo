import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/placement/job_opportunity_form.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/service_locator.dart';
import '../../models/base_api_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../utils/tablenames.dart';
import '../../values/text_styles.dart';

class JobOpportunityList extends StatefulWidget {
  const JobOpportunityList({Key? key}) : super(key: key);

  @override
  State<JobOpportunityList> createState() => _JobOpportunityListState();
}

class _JobOpportunityListState extends State<JobOpportunityList> {
  bool updateJobOppList = false;
  int companyId = 0;
  String companyName = "";
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();

  BaseLoginResponse<JobOpportunityResponse> jobpportunityData = BaseLoginResponse();

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      updateJobOppList = Get.arguments[0]["updateJobOppList"];
      companyId = Get.arguments[1]["companyId"];
      companyName = Get.arguments[2]["companyName"];
    }
    getRecords();
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    var query = "FIND('$companyId', ${TableNames.CLM_COMPANY_ID}, 0)";
    jobpportunityData = await apiRepository.getJoboppoApi(query);
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(companyName.isNotEmpty ? companyName : strings_name.str_list_job_opp_detail),
      body: Stack(
        children: [
          jobpportunityData.records != null && jobpportunityData.records!.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: jobpportunityData.records?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    custom_text(
                                      text: "${jobpportunityData.records?[index].fields!.jobTitle}",
                                      textStyles: centerTextStyle20,
                                      topValue: 0,
                                      maxLines: 2,
                                      bottomValue: 5,
                                      leftValue: 5,
                                    ),
                                    Visibility(
                                        visible: updateJobOppList,
                                        child: GestureDetector(
                                          child: const Icon(Icons.edit, size: 22, color: Colors.black),
                                          onTap: () {
                                            Get.to(() => const JobOpportunityForm(), arguments: [
                                              {"company_id": companyId.toString()},
                                              {"job_code": jobpportunityData.records?[index].fields?.jobCode},
                                            ]);
                                          },
                                        ))
                                  ],
                                ),
                                jobpportunityData.records?[index].fields!.stipendRangeMin != null && jobpportunityData.records?[index].fields!.stipendRangeMax != null
                                    ? custom_text(
                                        text: "Stipend: ${jobpportunityData.records?[index].fields!.stipendRangeMin} - ${jobpportunityData.records?[index].fields!.stipendRangeMax}",
                                        textStyles: blackTextSemiBold12,
                                        topValue: 5,
                                        maxLines: 2,
                                        bottomValue: 5,
                                        leftValue: 5,
                                      )
                                    : Container(),
                                custom_text(text: "Timings: ${jobpportunityData.records?[index].fields!.timingStart} - ${jobpportunityData.records?[index].fields!.timingEnd}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                custom_text(text: "Vacancies: ${jobpportunityData.records?[index].fields!.vacancies}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                custom_text(
                                  text: "Location: ${jobpportunityData.records?[index].fields!.city?.first}",
                                  textStyles: blackTextSemiBold12,
                                  topValue: 5,
                                  maxLines: 2,
                                  bottomValue: 5,
                                  leftValue: 5,
                                ),
                                custom_text(
                                  text: "Internship : ${jobpportunityData.records?[index].fields!.internshipModes} - ${jobpportunityData.records?[index].fields!.internshipDuration}",
                                  textStyles: blackTextSemiBold12,
                                  topValue: 5,
                                  maxLines: 2,
                                  bottomValue: 5,
                                  leftValue: 5,
                                ),
                                custom_text(
                                  text: "Description: ${jobpportunityData.records![index].fields!.jobDescription!}",
                                  textStyles: blackTextSemiBold14,
                                  bottomValue: 5,
                                  topValue: 0,
                                  leftValue: 5,
                                  maxLines: 1000,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_no_jobs_created, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
