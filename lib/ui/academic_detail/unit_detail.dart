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
import 'package:flutterdesigndemo/ui/academic_detail/add_topic.dart';
import 'package:flutterdesigndemo/ui/academic_detail/add_units.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class UnitDetail extends StatefulWidget {
  const UnitDetail({Key? key}) : super(key: key);

  @override
  State<UnitDetail> createState() => _UnitDetailState();
}

class _UnitDetailState extends State<UnitDetail> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<UnitsResponse>>? unitsData = [];
  List<BaseApiResponseWithSerializable<TopicsResponse>>? topicsData = [];

  HashMap<dynamic, List<TopicsResponse>> listData = HashMap();

  late BaseApiResponseWithSerializable<UnitsResponse> unitData;

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
    if (Get.arguments != null && Get.arguments[0]["unitId"] != null) {
      unitData = Get.arguments[0]["unitId"];
    }
    if (Get.arguments != null && Get.arguments[1]["addSubjectPermission"] != null) {
      canAddSubject = Get.arguments[1]["addSubjectPermission"];
    }

    var query = "FIND(${unitData.fields?.ids}, ${TableNames.CLM_UNIT_IDS}, 0)";
    try {
      var data = await apiRepository.getTopicsApi(query);
      if (data.records?.isNotEmpty == true) {
        topicsData = data.records;
        topicsData!.sort((a, b) => a.fields!.topicTitle!.toLowerCase().compareTo(b.fields!.topicTitle!.toLowerCase()));
      } else {
        Utils.showSnackBar(context, strings_name.str_no_topic_added);
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_unit_detail),
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  custom_text(text: unitData.fields?.unitTitle ?? "", maxLines: 5, textStyles: centerTextStyle24),
                  Visibility(visible: topicsData?.isNotEmpty ?? false, child: custom_text(text: strings_name.str_topics, textStyles: blackTextSemiBold16)),
                  topicsData?.isNotEmpty == true
                      ? Expanded(
                          child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: topicsData?.length,
                              itemBuilder: (BuildContext context, int mainIndex) {
                                return Card(
                                  elevation: 5,
                                  child: Container(
                                    color: colors_name.colorWhite,
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: custom_text(text: topicsData![mainIndex].fields?.topicTitle ?? "", textStyles: blackText16, topValue: 10, maxLines: 2)),
                                        Visibility(
                                            visible: canAddSubject,
                                            child: GestureDetector(
                                              child: const Icon(Icons.edit, size: 22, color: Colors.black),
                                              onTap: () {
                                                Get.to(const AddTopic(), arguments: [
                                                  {"topicId": topicsData![mainIndex].fields?.topicId}
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
                                );
                              }),
                        )
                      : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_topic, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
                ],
              ),
            ),
            canAddSubject
                ? Container(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                        text: strings_name.str_add_topics,
                        click: () async {
                          Get.to(const AddTopic(), arguments: [
                            {"unitId": unitData.id}
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
