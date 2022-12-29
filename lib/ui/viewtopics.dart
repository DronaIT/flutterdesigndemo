import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/ui/add_topic.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class ViewTopics extends StatefulWidget {
  const ViewTopics({Key? key}) : super(key: key);

  @override
  State<ViewTopics> createState() => _ViewTopicsState();
}

class _ViewTopicsState extends State<ViewTopics> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<TopicsResponse> topicData = BaseLoginResponse();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    setState(() {
      isVisible = true;
    });
    topicData = await apiRepository.getTopicsApi("");
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_topic),
      body: Stack(
        children: [
          Column(
            children: [
              topicData.records?.isNotEmpty == true
                  ? Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: topicData.records?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    custom_text(text: "${topicData.records![index].fields!.topicTitle}", textStyles: blackTextSemiBold16, topValue: 10, maxLines: 2),
                                    GestureDetector(
                                        onTap: () {
                                          Get.to(const AddTopic(), arguments: topicData.records?[index].fields?.ids)?.then((result) {
                                            if (result != null && result) {
                                              initialization();
                                            }
                                          });
                                        },
                                        child: Container(alignment: Alignment.centerRight, margin: const EdgeInsets.all(10), child: const Icon(Icons.edit))),
                                  ],
                                ),
                              );
                            }),
                      ),
                    )
                  : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_subjects, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                      text: strings_name.str_add_topics,
                      click: () async {
                        Get.to(const AddTopic())?.then((result) {
                          if (result != null && result) {
                            initialization();
                          }
                        });
                      })),
            ],
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
