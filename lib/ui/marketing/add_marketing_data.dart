import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';

class AddMarketingData extends StatefulWidget {
  const AddMarketingData({super.key});

  @override
  State<AddMarketingData> createState() => _AddMarketingDataState();
}

class _AddMarketingDataState extends State<AddMarketingData> {
  bool isVisible = false;

  TextEditingController approachController = TextEditingController();
  TextEditingController meetingController = TextEditingController();
  TextEditingController seminarsArrangedController = TextEditingController();
  TextEditingController seminarsCompletedController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_add_marketing_record),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                custom_text(
                  text: strings_name.str_number_of_approach,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  controller: approachController,
                  maxLength: 6,
                  topValue: 2,
                ),
                SizedBox(height: 5.h),
                custom_text(
                  text: strings_name.str_number_of_meeting,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  controller: meetingController,
                  maxLength: 6,
                  topValue: 2,
                ),
                SizedBox(height: 5.h),
                custom_text(
                  text: strings_name.str_number_of_seminars_arranged,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  controller: seminarsArrangedController,
                  maxLength: 6,
                  topValue: 2,
                ),
                SizedBox(height: 5.h),
                custom_text(
                  text: strings_name.str_number_of_seminars_completed,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  controller: seminarsCompletedController,
                  maxLength: 6,
                  topValue: 2,
                ),
                custom_text(
                  text: strings_name.str_remarks,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: remarksController,
                  topValue: 2,
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {},
                ),
              ],
            ),
          ),
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
