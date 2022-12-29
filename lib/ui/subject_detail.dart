import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/models/units_response.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

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

  final apiRepository = getIt.get<ApiRepository>();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    setState(() {
      isVisible = true;
    });
    var query = "FIND(${Get.arguments}, ${TableNames.CLM_SUBJECT_IDS}, 0)";
    var data = await apiRepository.getUnitsApi(query);
    if (data.records?.isNotEmpty == true) {
      unitsData = data.records;
      if (unitsData?.isNotEmpty == true) {
        var queryData = "";
        for (var i = 0; i < unitsData!.length; i++) {
          if (i != 0) {
            queryData += ",";
          }
          queryData += "${TableNames.CLM_UNIT_IDS}=${unitsData![i].fields!.ids}";
        }
        var query = "OR($queryData)";
        var data = await apiRepository.getTopicsApi(query);
        if (data.records?.isNotEmpty == true) {
          topicsData = data.records;
          for (var i = 0; i < unitsData!.length; i++) {
            List<TopicsResponse> topics = [];
            for (var j = 0; j < topicsData!.length; j++) {
              if (topicsData![j].fields!.unitIdFromUnitIds != null && topicsData![j].fields!.unitIdFromUnitIds![0] == unitsData![i].fields!.unitId) {
                topics.add(topicsData![j].fields!);
              }
            }
            listData[unitsData![i].fields] = topics;
          }
        } else {
          for (var i = 0; i < unitsData!.length; i++) {
            listData[unitsData![i].fields] = [];
          }
        }
      }
    } else {
      Utils.showSnackBar(context, strings_name.str_no_units_added);
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
            listData.entries.toList().isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: listData.entries.toList().length,
                        itemBuilder: (BuildContext context, int mainIndex) {
                          return ExpansionTile(
                              title: custom_text(text: (listData.entries.toList()[mainIndex].key as UnitsResponse).unitTitle!, textStyles: blackTextSemiBold16),
                              children: <Widget>[
                            ListView.builder(
                                shrinkWrap: true, // 1st add
                                physics: const ClampingScrollPhysics(),
                                itemCount: listData.entries.toList()[mainIndex].value.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return custom_text(text: listData.entries.toList()[mainIndex].value[index].topicTitle!, textStyles: blackTextSemiBold14 ,leftValue: 20,rightValue: 20,);
                                })
                          ]);
                        }),
                  )
                : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),

          ],
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
