import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/request/add_units_request.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/ui/topic_selection.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class AddUnits extends StatefulWidget {
  const AddUnits({Key? key}) : super(key: key);

  @override
  State<AddUnits> createState() => _AddUnitsState();
}

class _AddUnitsState extends State<AddUnits> {
  TextEditingController titleController = TextEditingController();

  bool isVisible = false;
  List<BaseApiResponseWithSerializable<TopicsResponse>>? topicsData = [];

  final apiRepository = getIt.get<ApiRepository>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_add_units),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          custom_text(
            text: strings_name.str_unit_title,
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
          SizedBox(height: 10.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                custom_text(
                  text: strings_name.str_topics,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                GestureDetector(
                  child: custom_text(
                    text: topicsData?.isEmpty == true ? strings_name.str_add : strings_name.str_update,
                    alignment: Alignment.topLeft,
                    textStyles: primaryTextSemiBold16,
                  ),
                  onTap: () {
                    Get.to(const TopicSelection(), arguments: topicsData)?.then((result) {
                      if (result != null) {
                        setState(() {
                          topicsData = result;
                        });
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          topicsData!.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: topicsData?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          child: GestureDetector(
                            child: Container(
                              color: colors_name.colorWhite,
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [Text("${topicsData![index].fields!.topicTitle}", textAlign: TextAlign.center, style: blackText16), const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                              ),
                            ),
                            onTap: () {
                              // Get.to(const (), arguments: unitsData![index].fields?.ids);
                            },
                          ),
                        );
                      }))
              : Container(),
          SizedBox(height: 20.h),
          CustomButton(
            text: strings_name.str_submit,
            click: () {
              if (titleController.text.trim().isEmpty) {
                Utils.showSnackBar(context, strings_name.str_empty_unit_title);
              } else if (topicsData!.isEmpty) {
                Utils.showSnackBar(context, strings_name.str_select_topics);
              } else {
                addRecord();
              }
            },
          )
        ],
      ),
    ));
  }

  Future<void> addRecord() async {
    setState(() {
      isVisible = true;
    });
    AddUnitsRequest request = AddUnitsRequest();
    request.unitTitle = titleController.text.toString();

    List<String> selectedSubjectData = [];
    for (var i = 0; i < topicsData!.length; i++) {
      selectedSubjectData.add(topicsData![i].id.toString());
    }
    request.tBLTOPICS = selectedSubjectData;

    var resp = await apiRepository.addUnitsApi(request);
    if (resp.id!.isNotEmpty) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBar(context, strings_name.str_unit_added);
      await Future.delayed(const Duration(milliseconds: 2000));
      Get.back(closeOverlays: true, result: true);
    } else {
      setState(() {
        isVisible = false;
      });
    }
  }
}
