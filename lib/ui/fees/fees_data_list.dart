
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/fees_response.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../values/text_styles.dart';

class FeesDataList extends StatefulWidget {
  const FeesDataList({Key? key}) : super(key: key);

  @override
  State<FeesDataList> createState() => _FeesDataListState();
}

class _FeesDataListState extends State<FeesDataList> {
  List<BaseApiResponseWithSerializable<FeesResponse>> studentList = [];
  List<BaseApiResponseWithSerializable<FeesResponse>> test = [];

  bool isVisible = false;
  var controllerSearch = TextEditingController();

  double totalFees = 0;
  NumberFormat format = NumberFormat.currency(locale: 'HI', symbol: "₹");

  @override
  void initState() {
    super.initState();
    if (Get.arguments[0]["studentList"] != null) {
      test = Get.arguments[0]["studentList"];
      studentList = Get.arguments[0]["studentList"];
    }

    for (int i = 0; i < test.length; i++) {
      totalFees += test[i].fields?.feesPaid ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_fees_dashboard),
      body: Stack(children: [
        Column(
          children: [
            SizedBox(height: 5.h),
            Row(children: [
              custom_text(
                text: "Total Students who paid fees: ",
                textStyles: blackTextSemiBold16,
                maxLines: 2,
                bottomValue: 5,
                rightValue: 0,
              ),
              custom_text(
                text: test.length.toString(),
                textStyles: primaryTextSemiBold16,
                bottomValue: 5,
                maxLines: 2,
              ),
            ]),
            Row(children: [
              custom_text(
                text: "Total Fees Received: ",
                textStyles: blackTextSemiBold16,
                topValue: 0,
                maxLines: 2,
                rightValue: 0,
              ),
              custom_text(text: format.format(totalFees), textStyles: primaryTextSemiBold16, topValue: 0, maxLines: 2, leftValue: 5),
            ]),
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
                    if (test[i].fields!.studentName!.last.toLowerCase().contains(value.toLowerCase())) {
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
                            return GestureDetector(
                              onTap: () {
                                Get.to(const StudentHistory(), arguments: studentList[index].fields?.studentMobileNumber?.last);
                              },
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  color: colors_name.colorWhite,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      custom_text(text: "${studentList[index].fields?.studentName?.last}", textStyles: primaryTextSemiBold16),
                                      custom_text(
                                          topValue: 0,
                                          bottomValue: 5,
                                          maxLines: 2,
                                          text:
                                              "Specialization: ${Utils.getSpecializationNameFromId(studentList[index].fields?.studentSpecializationId![0])}",
                                          textStyles: blackTextSemiBold14),
                                      Row(
                                        children: [
                                          custom_text(
                                            text: "${strings_name.str_mobile}:",
                                            alignment: Alignment.topLeft,
                                            textStyles: blackTextSemiBold14,
                                            topValue: 0,
                                            bottomValue: 5,
                                            rightValue: 5,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _launchCaller(studentList[index].fields!.studentMobileNumber?.last ?? "");
                                            },
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              margin: const EdgeInsets.only(top: 0, bottom: 5),
                                              child: Text(
                                                "${studentList[index].fields!.studentMobileNumber?.last}",
                                                style: const TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      custom_text(
                                          topValue: 0,
                                          bottomValue: 5,
                                          text: "Paid for : Semester ${studentList[index].fields?.feesBySemester}",
                                          textStyles: blackTextSemiBold14),
                                      custom_text(
                                          topValue: 0,
                                          bottomValue: 5,
                                          text: "Amount : ${format.format(double.tryParse(studentList[index].fields?.feesPaid?.toStringAsFixed(2) ?? ""))}",
                                          textStyles: blackTextSemiBold14),
                                      Row(children: [
                                        custom_text(
                                          text: "${strings_name.str_proof_of_payment} : ",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 0,
                                          maxLines: 2,
                                          rightValue: 0,
                                        ),
                                        GestureDetector(
                                            onTap: () async {
                                              await launchUrl(Uri.parse(studentList[index].fields?.proofOfPayment?.first.url ?? ""),
                                                  mode: LaunchMode.externalApplication);
                                            },
                                            child: custom_text(text: "Show", textStyles: primaryTextSemiBold14, topValue: 0, maxLines: 2)),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
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
      await launchUrl(Uri.parse("tel:$mobile"), mode: LaunchMode.externalApplication);
    } catch (e) {
      Utils.showSnackBarUsingGet(strings_name.str_invalid_mobile);
    }
  }
}
