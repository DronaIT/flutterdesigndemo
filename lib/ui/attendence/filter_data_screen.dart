import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../values/text_styles.dart';

class FilterData extends StatefulWidget {
  const FilterData({Key? key}) : super(key: key);

  @override
  State<FilterData> createState() => _FilterDataState();
}

class _FilterDataState extends State<FilterData> {
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> studentList = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> test = [];

  bool isVisible = false;

  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (Get.arguments[0]["studentList"] != null) {
      test = Get.arguments[0]["studentList"];
      studentList = Get.arguments[0]["studentList"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_students),
      body: Stack(children: [
        Column(
          children: [
            SizedBox(height: 5.h),
            custom_text(text: "Total Students: ${test.length}", textStyles: primaryTextSemiBold16),
            SizedBox(height: 10.h),
            CustomEditTextSearch(
              type: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: controllerSearch,
              onChanges: (value) {
                if (value.isEmpty) {
                  studentList = [];
                  studentList = List.from(test);
                  setState(() {});
                } else {
                  studentList = [];
                  for (var i = 0; i < test.length; i++) {
                    if (test[i].fields!.name!.toLowerCase().contains(value.toLowerCase())) {
                      studentList.add(test[i]);
                    }
                  }
                  setState(() {});
                }
              },
            ),
            studentList.isNotEmpty
                ? Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ListView.builder(
                          itemCount: studentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 5,
                              child: Container(
                                color: colors_name.colorWhite,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    custom_text(text: "${studentList[index].fields?.name}", textStyles: primaryTextSemiBold16),
                                    custom_text(topValue: 0, bottomValue: 5, text: "Enrollment No: ${studentList[index].fields?.enrollmentNumber}", textStyles: blackTextSemiBold14),
                                    custom_text(topValue: 0, bottomValue: 5, text: "Specialization: ${Utils.getSpecializationName(studentList[index].fields?.specializationIds![0])}", textStyles: blackTextSemiBold14),
                                    custom_text(topValue: 0, bottomValue: 5, text: "Mobile No: ${studentList[index].fields?.mobileNumber}", textStyles: blackTextSemiBold14),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: CustomButton(
                                          text: strings_name.str_call,
                                          bWidth: MediaQuery.of(context).size.width * 0.25,
                                          click: () async {
                                            _launchCaller(studentList[index].fields?.mobileNumber ?? "");
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          ],
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }

  _launchCaller(String mobile) async {
    try {
      await launchUrl(Uri.parse("tel:$mobile"));
    } catch (e) {
      Utils.showSnackBarUsingGet(strings_name.str_invalid_mobile);
    }
  }
}
