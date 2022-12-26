import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/request/add_subject_request.dart';
import 'package:flutterdesigndemo/models/units_response.dart';
import 'package:flutterdesigndemo/ui/add_topic.dart';
import 'package:flutterdesigndemo/ui/add_units.dart';
import 'package:flutterdesigndemo/ui/unit_selection.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({Key? key}) : super(key: key);

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  TextEditingController titleController = TextEditingController();

  bool isVisible = false;
  List<BaseApiResponseWithSerializable<UnitsResponse>>? unitsData = [];

  final apiRepository = getIt.get<ApiRepository>();






  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_add_subjects),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          custom_text(
            text: strings_name.str_subject_title,
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
                  text: strings_name.str_units,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                GestureDetector(
                  child: custom_text(
                    text: unitsData?.isEmpty == true ? strings_name.str_add : strings_name.str_update,
                    alignment: Alignment.topLeft,
                    textStyles: primaryTextSemiBold16,
                  ),
                  onTap: () {
                    Get.to(const UnitSelection(), arguments: unitsData)?.then((result) {
                      if (result != null) {
                        setState(() {
                          unitsData = result;
                        });
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          unitsData!.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: unitsData?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          child: GestureDetector(
                            child: Container(
                              color: colors_name.colorWhite,
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [Text("${unitsData![index].fields!.unitTitle}", textAlign: TextAlign.center, style: blackText16), const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
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
                Utils.showSnackBar(context, strings_name.str_empty_subject_title);
              } else if (unitsData!.isEmpty) {
                Utils.showSnackBar(context, strings_name.str_select_units);
              } else {
                addRecord();
              }
            },
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30, top: 10, left: 5, right: 5),
            child: Row(
              children: [
                Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                            text: strings_name.str_add_units,
                            fontSize: 15,
                            click: () async {
                              Get.to(const AddUnits());
                            }))),
                const SizedBox(width: 2),
                Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                            text: strings_name.str_add_topics,
                            fontSize: 15,
                            click: () async {
                              Get.to(const AddTopic());
                            }))),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Future<void> addRecord() async {
    setState(() {
      isVisible = true;
    });
    AddSubjectRequest request = AddSubjectRequest();
    request.subjectTitle = titleController.text.toString();

    List<String> selectedSubjectData = [];
    for (var i = 0; i < unitsData!.length; i++) {
      selectedSubjectData.add(unitsData![i].id.toString());
    }
    request.tBLUNITS = selectedSubjectData;

    var resp = await apiRepository.addSubjectApi(request);
    if (resp.id!.isNotEmpty) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBar(context, strings_name.str_subject_added);
      await Future.delayed(const Duration(milliseconds: 2000));
      Get.back(closeOverlays: true, result: true);
    } else {
      setState(() {
        isVisible = false;
      });
    }
  }
}
