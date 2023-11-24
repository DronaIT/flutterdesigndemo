import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
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
import 'shortlisted_student_detail.dart';

class ShortListStudent extends StatefulWidget {
  const ShortListStudent({Key? key}) : super(key: key);

  @override
  State<ShortListStudent> createState() => _ShortListStudentState();
}

class _ShortListStudentState extends State<ShortListStudent> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();

  List<BaseApiResponseWithSerializable<JobOpportunityResponse>>? jobOpportunityListMain = [];
  List<BaseApiResponseWithSerializable<JobOpportunityResponse>>? jobOpportunityList = [];
  String offset = "";
  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    getRecords();
  }

  getRecords() async {
    if(!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND(${TableNames.CLM_STATUS}='${strings_name.str_job_status_published}',${TableNames.CLM_DISPLAY_INTERNSHIP}='2')";
    try {
      var data = await apiRepository.getJobOppoApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          jobOpportunityListMain?.clear();
          jobOpportunityList?.clear();
        }
        jobOpportunityListMain?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<JobOpportunityResponse>>);
        jobOpportunityList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<JobOpportunityResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          setState(() {
            jobOpportunityListMain?.sort((a, b) => a.fields!.companyName!.last.trim().compareTo(b.fields!.companyName!.last.trim()));
            jobOpportunityList?.sort((a, b) => a.fields!.companyName!.last.trim().compareTo(b.fields!.companyName!.last.trim()));
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            jobOpportunityListMain = [];
            jobOpportunityList = [];
          }
        });
        offset = "";
      }
    } on DioError catch (e) {
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_sortlist_student),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 8),
                Visibility(
                  visible: jobOpportunityListMain != null && jobOpportunityListMain!.isNotEmpty,
                  child: CustomEditTextSearch(
                    hintText: "Search by company name..",
                    type: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    controller: controllerSearch,
                    onChanges: (value) {
                      if (value.isEmpty) {
                        jobOpportunityList = [];
                        jobOpportunityList = jobOpportunityListMain;
                        setState(() {});
                      } else {
                        jobOpportunityList = [];
                        for (var i = 0; i < jobOpportunityListMain!.length; i++) {
                          if (jobOpportunityListMain![i].fields!.companyName!.first.toLowerCase().contains(value.toLowerCase())) {
                            jobOpportunityList?.add(jobOpportunityListMain![i]);
                          }
                        }
                        setState(() {});
                      }
                    },
                  ),
                ),
                SizedBox(height: 5),
                jobOpportunityList != null && jobOpportunityList?.isNotEmpty == true
                    ? Container(
                        margin: const EdgeInsets.all(10),
                        child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: jobOpportunityList?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => const ShortListedStudentDetail(), arguments: [
                                    {"company_name": jobOpportunityList?[index].fields!.companyName?.first},
                                    {"jobcode": jobOpportunityList?[index].fields!.jobCode}
                                  ]);
                                },
                                child: Card(
                                  elevation: 5,
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        custom_text(
                                          text: "${jobOpportunityList?[index].fields!.companyName?.first}",
                                          textStyles: centerTextStyle16,
                                          topValue: 0,
                                          maxLines: 2,
                                          bottomValue: 5,
                                          leftValue: 5,
                                        ),
                                        custom_text(text: "${strings_name.str_job_title_} ${jobOpportunityList?[index].fields!.jobTitle}", textStyles: blackTextSemiBold12, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 5),
                                        custom_text(text: "${strings_name.str_city}: ${jobOpportunityList?[index].fields!.city?.first}", textStyles: blackTextSemiBold12, topValue: 0, maxLines: 2, bottomValue: 5, leftValue: 5),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_no_jobs, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
              ],
            ),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
