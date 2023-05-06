import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class TopicSelection extends StatefulWidget {
  const TopicSelection({Key? key}) : super(key: key);

  @override
  State<TopicSelection> createState() => _TopicSelectionState();
}

class _TopicSelectionState extends State<TopicSelection> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<TopicsResponse>>? topicData = [];
  List<BaseApiResponseWithSerializable<TopicsResponse>>? mainData = [];

  final apiRepository = getIt.get<ApiRepository>();
  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    List<BaseApiResponseWithSerializable<TopicsResponse>>? selectedData = [];
    selectedData = Get.arguments;

    setState(() {
      isVisible = true;
    });
    try{
      var data = await apiRepository.getTopicsApi("");
      if (data.records?.isNotEmpty == true) {
        setState(() {
          data.records?.sort((a, b) => a.fields!.topicTitle!.toLowerCase().compareTo(b.fields!.topicTitle!.toLowerCase()));
          mainData = data.records;

          for (var i = 0; i < selectedData!.length; i++) {
            for (var j = 0; j < mainData!.length; j++) {
              if (mainData![j].fields!.topicId == selectedData[i].fields!.topicId) {
                mainData![j].fields!.selected = true;
                break;
              }
            }
          }

          topicData = List.from(mainData!);
        });
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_topics),
      body: Stack(children: [
        mainData?.isNotEmpty == true
            ? Column(children: [
                SizedBox(height: 10.h),
                CustomEditTextSearch(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: controllerSearch,
                  onChanges: (value) {
                    if (value.isEmpty) {
                      topicData = [];
                      topicData = List.from(mainData!);
                      setState(() {});
                    } else {
                      topicData = [];
                      for (var i = 0; i < mainData!.length; i++) {
                        if (mainData![i].fields!.topicTitle!.toLowerCase().contains(value.toLowerCase())) {
                          topicData?.add(mainData![i]);
                        }
                      }
                      setState(() {});
                    }
                  },
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: topicData?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.all(5),
                          child: GestureDetector(
                            child: Container(
                              color: colors_name.colorWhite,
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [Expanded(child: Text("${topicData![index].fields!.topicTitle}", textAlign: TextAlign.start, style: blackTextSemiBold16)), if (topicData![index].fields!.selected) const Icon(Icons.check, size: 20, color: colors_name.colorPrimary)]),
                            ),
                            onTap: () {
                              setState(() {
                                topicData![index].fields!.selected = !topicData![index].fields!.selected;
                              });
                            },
                          ),
                        );
                      }),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    List<BaseApiResponseWithSerializable<TopicsResponse>>? selectedTopicData = [];
                    for (var i = 0; i < topicData!.length; i++) {
                      if (topicData![i].fields!.selected) {
                        selectedTopicData.add(topicData![i]);
                      }
                    }
                    if (selectedTopicData.isNotEmpty) {
                      Get.back(result: selectedTopicData);
                    } else {
                      Utils.showSnackBar(context, strings_name.str_select_topics);
                    }
                  },
                )
              ])
            : Container(margin: EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_topic, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
