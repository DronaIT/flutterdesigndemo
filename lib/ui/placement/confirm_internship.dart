import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
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
  BaseLoginResponse<JobOpportunityResponse> jobOpportunityData = BaseLoginResponse();
  String jobCode = "";

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
      jobOpportunityData = await apiRepository.getJobOppoApi(query);
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

  bool value = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_selected_for_jobs),
      body: Stack(
        children: [
          jobOpportunityData.records != null && jobOpportunityData.records?.first.fields != null
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      custom_text(text: strings_name.str_congratulation_for_internship, alignment: Alignment.center, textStyles: blackTextSemiBold15, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 5),
                      custom_text(
                        text: "${jobOpportunityData.records?.first.fields!.companyName?.first}",
                        textStyles: centerTextStyle21,
                        topValue: 15,
                        alignment: Alignment.center,
                        maxLines: 10,
                        bottomValue: 15,
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
                          custom_text(text: strings_name.str_internship_tnc, textStyles: blackTextSemiBold14, topValue: 5, maxLines: 1000, bottomValue: 5, leftValue: 5), //Text
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          onPressed: () {
                            if (value) {
                              confirmationDialog();
                            } else {
                              Utils.showSnackBar(context, strings_name.str_empty_internship_tnc);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(
                              width: 5.0,
                              color: colors_name.colorPrimary,
                            ),
                            padding: const EdgeInsets.all(13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 7.0,
                          ),
                          child: const Text(
                            strings_name.str_accept_offer,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
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

  Future<void> confirmationDialog() async {
    Dialog errorDialog = Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            custom_text(text: 'Please confirm the offer acceptance', textStyles: boldTitlePrimaryColorStyle),
            SizedBox(height: 5.h),
            custom_text(
              text: "${strings_name.str_company_name} : ${jobOpportunityData.records?.first.fields!.companyName?.first}",
              textStyles: blackTextSemiBold14,
              maxLines: 100,
            ),
            custom_text(
              text: "${strings_name.str_job_title} : ${jobOpportunityData.records?.first.fields!.jobTitle}",
              textStyles: blackTextSemiBold14,
              maxLines: 100,
            ),
            Row(children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: CustomButton(
                    text: strings_name.str_cancle,
                    click: () {
                      Get.back(closeOverlays: true);
                    }),
              ),
              SizedBox(width: 5.h),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: CustomButton(
                    text: strings_name.str_confirm,
                    click: () async {
                      Get.back(closeOverlays: true);
                      performAction(jobOpportunityData.records?.first.id);
                    }),
              ),
            ])
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  Future<void> performAction(String? jobId) async {
    setState(() {
      isVisible = true;
    });
    var loginData = PreferenceUtils.getLoginData();
    var query = "SEARCH('${loginData.mobileNumber.toString()}', ${TableNames.TB_USERS_PHONE})";
    try{
      var data = await apiRepository.loginApi(query);
      if (data.records!.isNotEmpty) {
        await PreferenceUtils.setLoginData(data.records!.first.fields!);
        await PreferenceUtils.setLoginRecordId(data.records!.first.id!);

        Map<String, dynamic> requestParams = Map();

        var acceptedJobData = data.records!.first.fields?.placedJob ?? [];
        acceptedJobData.add(jobId!);

        requestParams[TableNames.CLM_PLACED_JOB] = acceptedJobData;
        requestParams[TableNames.CLM_IS_PLACED_NOW] = "1";

        var dataUpdate = await apiRepository.updateStudentDataApi(requestParams, data.records!.first.id!);
        if (dataUpdate.fields != null) {
          await PreferenceUtils.setLoginData(dataUpdate.fields!);
          await PreferenceUtils.setLoginRecordId(dataUpdate.id!);

          setState(() {
            isVisible = false;
          });
          Get.back(closeOverlays: true);
          Get.back(closeOverlays: true);
          Get.back(closeOverlays: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      }
    }on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }

  }
}
