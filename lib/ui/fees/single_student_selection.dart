import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../customwidget/custom_edittext_search.dart';

class SingleStudentSelection extends StatefulWidget {
  const SingleStudentSelection({Key? key}) : super(key: key);

  @override
  State<SingleStudentSelection> createState() => _SingleStudentSelectionState();
}

class _SingleStudentSelectionState extends State<SingleStudentSelection> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? studentData = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? mainStudentData = [];

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? selectedData = [];

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(Get.arguments != null) {
      mainStudentData = Get.arguments[0]["studentList"];
      selectedData = Get.arguments[1]["selectedStudentData"];

      mainStudentData?.sort((a, b) {
        var adate = a.fields!.name;
        var bdate = b.fields!.name;
        return adate!.compareTo(bdate!);
      });

      if (selectedData != null && (selectedData?.length ?? 0) > 0) {
        for (var i = 0; i < selectedData!.length; i++) {
          for (var j = 0; j < mainStudentData!.length; j++) {
            if (mainStudentData![j].fields!.mobileNumber == selectedData![i].fields!.mobileNumber) {
              mainStudentData![j].fields!.selected = true;
              break;
            }
          }
        }
      }

      studentData = [];
      studentData = List.from(mainStudentData!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_students),
      body: Stack(children: [
        mainStudentData?.isNotEmpty == true
            ? Column(children: [
                SizedBox(height: 10.h),
                CustomEditTextSearch(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: controllerSearch,
                  onChanges: (value) {
                    if (value.isEmpty) {
                      studentData = [];
                      studentData = List.from(mainStudentData as Iterable);
                      setState(() {});
                    } else {
                      studentData = [];
                      if (mainStudentData != null && mainStudentData?.isNotEmpty == true) {
                        for (var i = 0; i < mainStudentData!.length; i++) {
                          if (mainStudentData![i].fields!.name!.toLowerCase().contains(value.toLowerCase())) {
                            studentData?.add(mainStudentData![i]);
                          }
                        }
                      }
                      setState(() {});
                    }
                  },
                ),
                studentData?.isNotEmpty == true
                    ? Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: ListView.builder(
                              itemCount: studentData?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 5,
                                  margin: const EdgeInsets.all(5),
                                  child: GestureDetector(
                                    child: Container(
                                      color: colors_name.colorWhite,
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Text("${studentData![index].fields!.name}",
                                                  textAlign: TextAlign.start, style: blackTextSemiBold16)),
                                          if (studentData![index].fields!.selected)
                                            const Icon(Icons.check, size: 20, color: colors_name.colorPrimary),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      studentData![index].fields!.selected = !studentData![index].fields!.selected;
                                      for (int i = 0; i < studentData!.length; i++) {
                                        if (studentData![index].fields!.mobileNumber != studentData![i].fields!.mobileNumber) {
                                          studentData![i].fields!.selected = false;
                                        }
                                      }
                                      for (int i = 0; i < mainStudentData!.length; i++) {
                                        if (studentData![index].fields!.mobileNumber != mainStudentData![i].fields!.mobileNumber) {
                                          mainStudentData![i].fields!.selected = false;
                                        }
                                      }
                                      setState(() {});
                                    },
                                  ),
                                );
                              }),
                        ),
                      )
                    : Container(),
                SizedBox(height: 20.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? selectedStudentData = [];
                    for (var i = 0; i < mainStudentData!.length; i++) {
                      if (mainStudentData![i].fields!.selected) {
                        selectedStudentData.add(mainStudentData![i]);
                      }
                    }
                    if (selectedStudentData.isNotEmpty) {
                      Get.back(result: selectedStudentData);
                    } else {
                      Utils.showSnackBar(context, strings_name.str_empty_select_student);
                    }
                  },
                )
              ])
            : Container(
                margin: const EdgeInsets.only(top: 100),
                child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
