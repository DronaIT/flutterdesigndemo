import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/request/add_subject_request.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/models/units_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/unit_selection.dart';

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

class AddSubject extends StatefulWidget {
  const AddSubject({Key? key}) : super(key: key);

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  TextEditingController titleController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController creditController = TextEditingController();

  bool isVisible = false;
  List<BaseApiResponseWithSerializable<UnitsResponse>>? unitsData = [];
  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectData = [];

  final apiRepository = getIt.get<ApiRepository>();
  bool fromEdit = false;

  List<String> semesterResponseArray = <String>["1", "2", "3", "4", "5", "6"];
  String semesterValue = "1";

  List<String> specializationIds = [];

  Future<void> initialization() async {
    if (Get.arguments != null && Get.arguments[0]["subjectId"] != null) {
      setState(() {
        isVisible = true;
      });
      var query = "SEARCH('${Get.arguments[0]["subjectId"]}', ${TableNames.CLM_SUBJECT_ID})";
      try{
        var data = await apiRepository.getSubjectsApi(query);
        if (data.records?.isNotEmpty == true) {
          setState(() {
            fromEdit = true;
          });

          subjectData = data.records;
          if (subjectData?.isNotEmpty == true) {
            setState(() {
              titleController.text = subjectData![0].fields!.subjectTitle.toString();
              codeController.text = subjectData![0].fields!.subjectCode.toString();
              creditController.text = subjectData![0].fields!.subjectCredit.toString();
              semesterValue = subjectData![0].fields!.semester!;
              specializationIds = subjectData![0].fields!.specializationIds!;
            });
            var query = "SEARCH('${subjectData![0].fields!.ids}', ${TableNames.CLM_SUBJECT_IDS})";
            try{
              var data = await apiRepository.getUnitsApi(query);
              if (data.records?.isNotEmpty == true) {
                data.records!.sort((a, b) => a.fields!.unitTitle!.toLowerCase().compareTo(b.fields!.unitTitle!.toLowerCase()));
                unitsData = data.records;
              }
            }on DioError catch (e) {
              setState(() {
                isVisible = false;
              });
              final errorMessage = DioExceptions.fromDioError(e).toString();
              Utils.showSnackBarUsingGet(errorMessage);
            }

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

    if (Get.arguments != null && Get.arguments[0]["specializationId"] != null) {
      specializationIds.add(Get.arguments[0]["specializationId"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(fromEdit ? strings_name.str_update_subjects : strings_name.str_add_subjects),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
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
                custom_text(
                  text: strings_name.str_subject_code,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: codeController,
                  topValue: 2,
                  maxLength: 200,
                  capitalization: TextCapitalization.characters,
                ),
                SizedBox(height: 10.h),
                custom_text(
                  text: strings_name.str_subject_credit,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  controller: creditController,
                  topValue: 2,
                  maxLength: 200,
                ),
                SizedBox(height: 10.h),
                custom_text(
                  text: strings_name.str_semester,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<String>(
                          elevation: 16,
                          style: blackText16,
                          value: semesterValue,
                          focusColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              semesterValue = newValue!;
                            });
                          },
                          items: semesterResponseArray.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text("Semester $value"),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
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
                    ? ListView.builder(
                        primary: false,
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
                                  children: [Expanded(child: Text("${unitsData![index].fields!.unitTitle}", textAlign: TextAlign.start, style: blackText16)), const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                                ),
                              ),
                              onTap: () {
                                // Get.to(const (), arguments: unitsData![index].fields?.ids);
                              },
                            ),
                          );
                        })
                    : Container(),
                SizedBox(height: 20.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    if (titleController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_subject_title);
                    } else if (semesterValue.isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_semester);
/*
                    } else if (unitsData!.isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_select_units);
*/
                    } else {
                      addRecord();
                    }
                  },
                ),
              ],
            ),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
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
    request.code = codeController.text.toString();
    request.credit = creditController.text.toString();
    request.semester = semesterValue.toString();
    request.specializationIds = specializationIds;

    List<String> selectedSubjectData = [];
    for (var i = 0; i < unitsData!.length; i++) {
      selectedSubjectData.add(unitsData![i].id.toString());
    }
    request.tBLUNITS = selectedSubjectData;

    try{
      if (!fromEdit) {
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
      } else {
        var resp = await apiRepository.updateSubjectApi(request.toJson(), subjectData![0].id.toString());
        if (resp.id!.isNotEmpty) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_subject_updated);
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

  @override
  void initState() {
    super.initState();
    initialization();
  }
}
