import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../models/base_api_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';
import 'selected_student_detail.dart';

class SelectedStudentList extends StatefulWidget {
  const SelectedStudentList({Key? key}) : super(key: key);

  @override
  State<SelectedStudentList> createState() => _SelectedStudentListState();
}

class _SelectedStudentListState extends State<SelectedStudentList> {

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
    var query = "AND(${TableNames.CLM_STATUS}='${strings_name.str_job_status_interview_scheduled}')";
    try{
      jobpportunityData = await apiRepository.getJoboppoApi(query);
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
                          Get.to(() => const SelectedStudentDetail(), arguments: [
                            {"company_name": jobpportunityData.records?[index].fields!.companyName?.first},
                            {"jobcode": jobpportunityData.records?[index].fields!.jobCode}
                          ]);
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
                  : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
              Center(
                child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
              )
            ],
          ),
        ));
  }
}
