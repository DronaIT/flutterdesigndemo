import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/models/units_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/add_units.dart';
import 'package:flutterdesigndemo/ui/academic_detail/unit_detail.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class SubjectDetail extends StatefulWidget {
  const SubjectDetail({Key? key}) : super(key: key);

  @override
  State<SubjectDetail> createState() => _SubjectDetailState();
}

class _SubjectDetailState extends State<SubjectDetail> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<UnitsResponse>>? unitsData = [];
  List<BaseApiResponseWithSerializable<TopicsResponse>>? topicsData = [];

  HashMap<dynamic, List<TopicsResponse>> listData = HashMap();

  late BaseApiResponseWithSerializable<SubjectResponse> subjectData;

  final apiRepository = getIt.get<ApiRepository>();
  bool canAddSubject = false;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    setState(() {
      isVisible = true;
    });
    if (Get.arguments != null && Get.arguments[0]["subjectId"] != null) {
      subjectData = Get.arguments[0]["subjectId"];
    }
    if (Get.arguments != null && Get.arguments[1]["addSubjectPermission"] != null) {
      canAddSubject = Get.arguments[1]["addSubjectPermission"];
    }

    var query = "FIND(${subjectData.fields?.ids}, ${TableNames.CLM_SUBJECT_IDS}, 0)";
    try {
      var data = await apiRepository.getUnitsApi(query);
      if (data.records?.isNotEmpty == true) {
        unitsData = data.records;
        unitsData!.sort((a, b) => a.fields!.unitTitle!.toLowerCase().compareTo(b.fields!.unitTitle!.toLowerCase()));
      } else {
        Utils.showSnackBar(context, strings_name.str_no_units_added);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }

    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_subject_detail),
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  custom_text(text: subjectData.fields?.subjectTitle ?? "", maxLines: 5, textStyles: centerTextStyle24),
                  Visibility(
                      visible: subjectData.fields?.subjectCode?.isNotEmpty ?? false,
                      child: custom_text(text: "Code : ${subjectData.fields?.subjectCode ?? ""}", textStyles: blackTextSemiBold14, bottomValue: 2)),
                  Visibility(
                      visible: subjectData.fields?.subjectCredit?.isNotEmpty ?? false,
                      child: custom_text(text: "Credit : ${subjectData.fields?.subjectCredit ?? ""}", textStyles: blackTextSemiBold14)),
                  // Container(
                  //   alignment: Alignment.centerRight,
                  //   margin: const EdgeInsets.only(left: 10, right: 20),
                  //   child: CustomButton(
                  //       text: strings_name.str_materials,
                  //       bWidth: 130,
                  //       click: () async {
                  //         Get.to(const UploadDocumentsAcademic(),arguments: subjectData.fields?.subjectId);
                  //       }),
                  // ),
                  Visibility(visible: unitsData?.isNotEmpty ?? false, child: custom_text(text: strings_name.str_units, textStyles: blackTextSemiBold16)),
                  unitsData?.isNotEmpty == true
                      ? Expanded(
                          child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: unitsData?.length,
                              itemBuilder: (BuildContext context, int mainIndex) {
                                return Card(
                                  elevation: 5,
                                  child: GestureDetector(
                                    child: Container(
                                      color: colors_name.colorWhite,
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: custom_text(text: unitsData![mainIndex].fields?.unitTitle ?? "", textStyles: blackText16, topValue: 10, maxLines: 2)),
                                          Visibility(
                                              visible: canAddSubject,
                                              child: GestureDetector(
                                                child: const Icon(Icons.edit, size: 22, color: Colors.black),
                                                onTap: () {
                                                  Get.to(const AddUnits(), arguments: [
                                                    {"unitId": unitsData![mainIndex].fields?.unitId}
                                                  ])?.then((result) {
                                                    if (result != null && result) {
                                                      initialization();
                                                    }
                                                  });
                                                },
                                              ))
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Get.to(const UnitDetail(), arguments: [
                                        {"unitId": unitsData![mainIndex]},
                                        {"addSubjectPermission": canAddSubject}
                                      ]);
                                    },
                                  ),
                                );
                              }),
                        )
                      : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_units, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
                ],
              ),
            ),
            canAddSubject
                ? Container(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                        text: strings_name.str_add_units,
                        click: () async {
                          Get.to(const AddUnits(), arguments: [
                            {"subjectId": subjectData.id}
                          ])?.then((result) {
                            if (result != null && result) {
                              initialization();
                            }
                          });
                        }))
                : Container(),
          ],
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
