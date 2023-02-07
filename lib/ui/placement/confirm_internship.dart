import 'package:flutter/material.dart';
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

class ConfirmInternShip extends StatefulWidget {
  const ConfirmInternShip({Key? key}) : super(key: key);

  @override
  State<ConfirmInternShip> createState() => _ConfirmInternShipState();
}

class _ConfirmInternShipState extends State<ConfirmInternShip> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobpportunityData = BaseLoginResponse();
  String jobId = "";

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
    var query = "FIND('$jobId', ${TableNames.CLM_JOB_CODE}, 0)";
    jobpportunityData = await apiRepository.getJoboppoApi(query);
    setState(() {
      isVisible = false;
    });
  }

  bool value = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_interview_schedule),
      body: Stack(
        children: [
          jobpportunityData.records != null && jobpportunityData.records?.first.fields != null
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      custom_text(text: "Congratulations for getting selected at", textStyles: blackTextSemiBold15, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 5),
                      custom_text(
                        text: "${strings_name.str_company_name}: ${jobpportunityData.records?.first.fields!.companyName?.first}",
                        textStyles: centerTextStyle21,
                        topValue: 0,
                        maxLines: 2,
                        bottomValue: 5,
                        leftValue: 5,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: value,
                            onChanged: (bool? value) {
                              setState(() {
                                this.value = value!;
                              });
                            },
                          ),
                          const SizedBox(width: 5), //SizedBox
                          custom_text(text: "I hereby accept the placement SOP & Terms", textStyles: blackTextSemiBold14, topValue: 5, maxLines: 1000, bottomValue: 5, leftValue: 5), //Text
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: colors_name.presentColor,
                                padding: const EdgeInsets.all(13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 7.0,
                              ),
                              child: const Text(
                                strings_name.str_schadule_interview,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                side: const BorderSide(
                                  width: 5.0,
                                  color: colors_name.presentColor,
                                ),
                                padding: const EdgeInsets.all(13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 7.0,
                              ),
                              child: const Text(
                                strings_name.str_schadule_interview,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
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
