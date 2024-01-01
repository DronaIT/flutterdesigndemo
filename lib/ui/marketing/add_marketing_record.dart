import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/marketing_response.dart';
import 'package:flutterdesigndemo/models/request/marketing_request.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class AddMarketingRecord extends StatefulWidget {
  const AddMarketingRecord({super.key});

  @override
  State<AddMarketingRecord> createState() => _AddMarketingRecordState();
}

class _AddMarketingRecordState extends State<AddMarketingRecord> {
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  TextEditingController cityController = TextEditingController();
  TextEditingController approachController = TextEditingController();
  TextEditingController meetingController = TextEditingController();
  TextEditingController seminarsArrangedController = TextEditingController();
  TextEditingController seminarsCompletedController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  MarketingResponse? marketingResponse;
  String? marketingResponseId;
  var fromUpdate = false;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      marketingResponse = Get.arguments[0]["fields"];
      marketingResponseId = Get.arguments[1]["recordId"];
    }

    if (marketingResponse != null && marketingResponseId?.isNotEmpty == true) {
      fromUpdate = true;

      cityController.text = marketingResponse?.city ?? "";
      remarksController.text = marketingResponse?.remarks ?? "";
      approachController.text = "${marketingResponse?.numberOfApproach ?? 0}";
      meetingController.text = "${marketingResponse?.numberOfMeetings ?? 0}";
      seminarsArrangedController.text = "${marketingResponse?.numberOfSeminarArranged ?? 0}";
      seminarsCompletedController.text = "${marketingResponse?.numberOfSeminarsCompleted ?? 0}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(fromUpdate ? strings_name.str_update_marketing_record : strings_name.str_add_marketing_record),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                custom_text(
                  text: strings_name.str_city_r,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: cityController,
                  maxLength: 100,
                  topValue: 2,
                ),
                SizedBox(height: 5.h),
                custom_text(
                  text: "${strings_name.str_number_of_approach}*",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: approachController,
                  maxLength: 6,
                  topValue: 2,
                ),
                SizedBox(height: 5.h),
                custom_text(
                  text: "${strings_name.str_number_of_meeting}*",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: meetingController,
                  maxLength: 6,
                  topValue: 2,
                ),
                SizedBox(height: 5.h),
                custom_text(
                  text: "${strings_name.str_number_of_seminars_arranged}*",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: seminarsArrangedController,
                  maxLength: 6,
                  topValue: 2,
                ),
                SizedBox(height: 5.h),
                custom_text(
                  text: "${strings_name.str_number_of_seminars_completed}*",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: seminarsCompletedController,
                  maxLength: 6,
                  topValue: 2,
                ),
                SizedBox(height: 5.h),
                custom_text(
                  text: strings_name.str_remarks,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.multiline,
                  topValue: 2,
                  maxLines: 5,
                  minLines: 4,
                  maxLength: 5000,
                  textInputAction: TextInputAction.next,
                  controller: remarksController,
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    if (cityController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_city);
                    } else if (approachController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_number_of_approach);
                    } else if (meetingController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_number_of_meeting);
                    } else if (seminarsArrangedController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_number_of_seminars_arranged);
                    } else if (seminarsCompletedController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_number_of_seminars_completed);
                    } else {
                      submitData();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: isVisible,
          child: Container(
            color: colors_name.colorWhite,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary),
            ),
          ),
        )
      ]),
    ));
  }

  submitData() async {
    setState(() {
      isVisible = true;
    });

    try {
      MarketingRequest request = MarketingRequest();
      request.city = cityController.text.trim();
      request.numberOfMeetings = int.tryParse(meetingController.text.trim());
      request.numberOfApproach = int.tryParse(approachController.text.trim());
      request.numberOfSeminarArranged = int.tryParse(seminarsArrangedController.text.trim());
      request.numberOfSeminarsCompleted = int.tryParse(seminarsCompletedController.text.trim());
      request.detailsAddedBy = PreferenceUtils.getLoginRecordId().split(",");
      request.remarks = remarksController.text.trim();

      var json = request.toJson();
      json.removeWhere((key, value) => value == null);

      if (fromUpdate) {
        var resp = await apiRepository.updateMarketingRecord(json, marketingResponseId!);
        if (resp.id != null) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_updated_marketing_record);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      } else {
        var resp = await apiRepository.addMarketingRecordApi(request);
        if (resp.id != null) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_added_marketing_record);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      }
    } on Exception catch (e) {
      Utils.showSnackBar(context, strings_name.str_invalid_data);
      setState(() {
        isVisible = false;
      });
    }
  }
}
