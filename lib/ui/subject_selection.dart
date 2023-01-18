import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SubjectSelection extends StatefulWidget {
  const SubjectSelection({Key? key}) : super(key: key);

  @override
  State<SubjectSelection> createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<SubjectSelection> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectData = [];

  final apiRepository = getIt.get<ApiRepository>();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    List<BaseApiResponseWithSerializable<SubjectResponse>>? selectedData = [];
    selectedData = Get.arguments;

    setState(() {
      isVisible = true;
    });
    var data = await apiRepository.getSubjectsApi("");
    if (data.records?.isNotEmpty == true) {
      setState(() {
        subjectData = data.records;
        for (var i = 0; i < selectedData!.length; i++) {
          for (var j = 0; j < subjectData!.length; j++) {
            if (subjectData![j].fields!.subjectId == selectedData[i].fields!.subjectId) {
              subjectData![j].fields!.selected = true;
              break;
            }
          }
        }
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_subjects),
      body: Stack(children: [
        subjectData?.isNotEmpty == true
            ? Column(children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: ListView.builder(
                        itemCount: subjectData?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            child: GestureDetector(
                              child: Container(
                                color: colors_name.colorWhite,
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [Expanded(child: Text("${subjectData![index].fields!.subjectTitle}", textAlign: TextAlign.start, style: blackTextSemiBold16)), if (subjectData![index].fields!.selected) const Icon(Icons.check, size: 20, color: colors_name.colorPrimary)]),
                              ),
                              onTap: () {
                                setState(() {
                                  subjectData![index].fields!.selected = !subjectData![index].fields!.selected;
                                });
                              },
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    List<BaseApiResponseWithSerializable<SubjectResponse>>? selectedSubjectData = [];
                    for (var i = 0; i < subjectData!.length; i++) {
                      if (subjectData![i].fields!.selected) {
                        selectedSubjectData.add(subjectData![i]);
                      }
                    }
                    if (selectedSubjectData.isNotEmpty) {
                      Get.back(result: selectedSubjectData);
                    } else {
                      Utils.showSnackBar(context, strings_name.str_select_subject);
                    }
                  },
                )
              ])
            : Container(margin: EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_subjects, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
