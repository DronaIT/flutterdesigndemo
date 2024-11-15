import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/request/add_topics_request.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class AddTopic extends StatefulWidget {
  const AddTopic({Key? key}) : super(key: key);

  @override
  State<AddTopic> createState() => _AddTopicState();
}

class _AddTopicState extends State<AddTopic> {
  TextEditingController titleController = TextEditingController();
  bool isVisible = false;
  bool fromEdit = false;

  final apiRepository = getIt.get<ApiRepository>();

  List<BaseApiResponseWithSerializable<TopicsResponse>>? topicsData = [];

  String topicId = "";
  List<String> unitId = [];

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    if(Get.arguments != null && Get.arguments[0]["topicId"] != null){
      topicId = Get.arguments[0]["topicId"];
    }

    if(Get.arguments != null && Get.arguments[0]["unitId"] != null){
      unitId.add(Get.arguments[0]["unitId"]);
    }

    if (topicId.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      var query = "FIND('$topicId', ${TableNames.CLM_TOPIC_ID}, 0)";
      try{
        var data = await apiRepository.getTopicsApi(query);
        if (data.records?.isNotEmpty == true) {
          setState(() {
            fromEdit = true;
          });

          topicsData = data.records;
          if (topicsData?.isNotEmpty == true) {
            titleController.text = topicsData![0].fields!.topicTitle.toString();
            unitId.add(topicsData![0].fields?.unitIds?.first ?? "");
          }
        } else {
          Utils.showSnackBar(context, strings_name.str_something_wrong);
        }
      }on DioError catch (e) {
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(fromEdit ? strings_name.str_update_topics : strings_name.str_add_topics),
      body: Stack(children: [
        Column(
          children: [
            SizedBox(height: 10.h),
            custom_text(
              text: strings_name.str_topic_title,
              alignment: Alignment.topLeft,
              textStyles: blackTextSemiBold16,
            ),
            custom_edittext(
              type: TextInputType.text,
              textInputAction: TextInputAction.next,
              controller: titleController,
              topValue: 2,
              maxLength: 200,
            ),
            SizedBox(height: 20.h),
            CustomButton(
              text: strings_name.str_submit,
              click: () {
                if (titleController.text.trim().isEmpty) {
                  Utils.showSnackBar(context, strings_name.str_empty_topic_title);
                } else {
                  addRecord();
                }
              },
            )
          ],
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }

  Future<void> addRecord() async {
    setState(() {
      isVisible = true;
    });
    AddTopicsRequest request = AddTopicsRequest();
    request.topicTitle = titleController.text.toString();
    request.unitIds = unitId; 

    try{
      if (!fromEdit) {
        var resp = await apiRepository.addTopicApi(request);
        if (resp.id!.isNotEmpty) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_topic_added);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(closeOverlays: true, result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      } else {
        var resp = await apiRepository.updateTopicsApi(request.toJson(), topicsData![0].id.toString());
        if (resp.id!.isNotEmpty) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_topic_updated);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(closeOverlays: true, result: true);
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
