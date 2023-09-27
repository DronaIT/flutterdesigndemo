import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_edittext.dart';
import '../../models/base_api_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class LeaveInternShip extends StatefulWidget {
  const LeaveInternShip({Key? key}) : super(key: key);

  @override
  State<LeaveInternShip> createState() => _LeaveInternShipState();
}

class _LeaveInternShipState extends State<LeaveInternShip> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobOpportunityData = BaseLoginResponse();
  String jobCode = "";
  TextEditingController reasonForLeavingController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  String loiPath = "", loiTitle = "";
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
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_leave_internship),
        body: Stack(
          children: [
            jobOpportunityData.records != null && jobOpportunityData.records?.first.fields != null
                ? Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        custom_text(text: strings_name.str_company_name, alignment: Alignment.center, textStyles: blackTextSemiBold15, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 5),
                        custom_text(
                          text: "${jobOpportunityData.records?.first.fields!.companyName?.first}",
                          textStyles: centerTextStyle21,
                          topValue: 15,
                          alignment: Alignment.center,
                          maxLines: 10,
                          bottomValue: 15,
                          leftValue: 5,
                        ),
                        const SizedBox(height: 5),
                        custom_text(text: "${strings_name.str_joining_date} : ${jobOpportunityData.records?.first.fields!.joiningDate ?? ""}", textStyles: blackTextSemiBold14, topValue: 5, bottomValue: 5, leftValue: 5),
                        const SizedBox(height: 5),
                        custom_edittext(
                          type: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          controller: reasonForLeavingController,
                          hintText: strings_name.str_reason_for_leaving,
                          maxLines: 2,
                          minLines: 2,
                          maxLength: 50000,
                          topValue: 0,
                        ),
                        const SizedBox(height: 5),
                        InkWell(
                          child: IgnorePointer(
                            child: custom_edittext(
                              hintText: strings_name.str_notice_period_date,
                              type: TextInputType.none,
                              textInputAction: TextInputAction.next,
                              controller: startTimeController,
                              topValue: 0,
                            ),
                          ),
                          onTap: () {
                            DateTime dateSelected = DateTime.now();
                            if (startTimeController.text.isNotEmpty) {
                              dateSelected = DateFormat("yyyy-MM-dd").parse(startTimeController.text);
                            }
                            showDatePicker(context: context, initialDate: dateSelected, firstDate: DateTime.now(), lastDate: DateTime(2100)).then((pickedDate) {
                              if (pickedDate == null) {
                                return;
                              }
                              setState(() {
                                var dateTime = pickedDate;
                                var formatter = DateFormat('yyyy-MM-dd');
                                var time = DateTime(dateTime.year, dateTime.month, dateTime.day);
                                startTimeController.text = formatter.format(time);
                              });
                            });
                          },
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            custom_text(
                              text: strings_name.str_resignation_letter,
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                              leftValue: 10,
                            ),
                            GestureDetector(
                              child: Container(margin: const EdgeInsets.only(right: 10), child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black)),
                              onTap: () {

                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: loiPath.isNotEmpty,
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              custom_text(text: loiTitle, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                            text: strings_name.str_apply_for_leave,
                            click: () {
                              if (startTimeController.text.trim().isEmpty) {
                                Utils.showSnackBar(context, strings_name.str_joing_date);
                              } else {
                                Get.back();
                              }
                            })

                        //Text
                      ],
                    ),
                  )
                : Container(),
            Center(
              child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
            )
          ],
        ),
      ),
    );
  }
}
