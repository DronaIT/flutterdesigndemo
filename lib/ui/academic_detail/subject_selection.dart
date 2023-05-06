import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/main.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class SubjectSelection extends StatefulWidget {
  const SubjectSelection({Key? key}) : super(key: key);

  @override
  State<SubjectSelection> createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<SubjectSelection> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectData = [];
  List<BaseApiResponseWithSerializable<SubjectResponse>>? mainData = [];

  final apiRepository = getIt.get<ApiRepository>();
  var controllerSearch = TextEditingController();

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
    try{
      var data = await apiRepository.getSubjectsApi("");
      if (data.records?.isNotEmpty == true) {
        setState(() {
          data.records?.sort((a, b) => a.fields!.subjectTitle!.toLowerCase().compareTo(b.fields!.subjectTitle!.toLowerCase()));
          mainData = data.records;

          for (var i = 0; i < selectedData!.length; i++) {
            for (var j = 0; j < mainData!.length; j++) {
              if (mainData![j].fields!.subjectId == selectedData[i].fields!.subjectId) {
                mainData![j].fields!.selected = true;
                break;
              }
            }
          }

          subjectData = List.from(mainData!);
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_subjects),
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
                    subjectData = [];
                    subjectData = List.from(mainData!);
                    setState(() {});
                  } else {
                    subjectData = [];
                    for (var i = 0; i < mainData!.length; i++) {
                      if (mainData![i].fields!.subjectTitle!.toLowerCase().contains(value.toLowerCase())) {
                        subjectData?.add(mainData![i]);
                      }
                    }
                    setState(() {});
                  }
                },
              ),
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
