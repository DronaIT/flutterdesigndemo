
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../models/base_api_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../values/text_styles.dart';
import 'package:flutter/material.dart';

import 'completed_student_detail.dart';


class CompletedInternList extends StatefulWidget {
  const CompletedInternList({Key? key}) : super(key: key);

  @override
  State<CompletedInternList> createState() => _CompletedInternListState();
}

class _CompletedInternListState extends State<CompletedInternList> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobpportunityData = BaseLoginResponse();

  @override
  void initState() {
    super.initState();
    getRecords();
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    var query = "AND(${TableNames.CLM_STATUS}='${strings_name.str_job_status_process_complete}',${TableNames.CLM_DISPLAY_INTERNSHIP}='2')";
    jobpportunityData = await apiRepository.getJoboppoApi(query);
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_create_company),
          body: Stack(
            children: [
              jobpportunityData.records != null && jobpportunityData.records!.length > 0
                  ? Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: jobpportunityData.records?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => const CompletedStudentDetail(), arguments: jobpportunityData.records?[index].fields!.jobCode);
                        },
                        child: Card(
                          elevation: 5,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                custom_text(
                                  text: "${jobpportunityData.records?[index].fields!.companyName?.first}",
                                  textStyles: centerTextStyle16,
                                  topValue: 0,
                                  maxLines: 2,
                                  bottomValue: 5,
                                  leftValue: 5,
                                ),
                                custom_text(text: "${strings_name.str_job_title_} ${jobpportunityData.records?[index].fields!.jobTitle}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                custom_text(text: "${strings_name.str_city}: ${jobpportunityData.records?[index].fields!.city?.first}", textStyles: blackTextSemiBold12, topValue: 0, maxLines: 2, bottomValue: 5, leftValue: 5),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
                  : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_no_jobs, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
              Center(
                child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
              )
            ],
          ),
        ));
  }
}