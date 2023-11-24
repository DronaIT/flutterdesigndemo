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

class StudentSelection extends StatefulWidget {
  const StudentSelection({Key? key}) : super(key: key);

  @override
  State<StudentSelection> createState() => _StudentSelectionState();
}

class _StudentSelectionState extends State<StudentSelection> {
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
    selectedData = Get.arguments;

    if(PreferenceUtils.getIsLogin() == 2) {
      getRecords();
    }
  }

  getRecords() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });

    var query = "OR(FIND('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if(PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",FIND('${PreferenceUtils
              .getLoginDataEmployee()
              .accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
        }
      }
    }
    query += ")";
    print(query);

    try {
      var data = await apiRepository.loginApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mainStudentData?.clear();
        }
        mainStudentData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {

          mainStudentData?.sort((a, b) {
            var adate = a.fields!.name;
            var bdate = b.fields!.name;
            return adate!.compareTo(bdate!);
          });

          if(selectedData != null && (selectedData?.length ?? 0) > 0) {
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

          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            studentData = [];
            mainStudentData = [];
          }
        });
        offset = "";
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
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
                                          Expanded(child: Text("${studentData![index].fields!.name}", textAlign: TextAlign.start, style: blackTextSemiBold16)),
                                          if (studentData![index].fields!.selected) const Icon(Icons.check, size: 20, color: colors_name.colorPrimary),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        studentData![index].fields!.selected = !studentData![index].fields!.selected;
                                        for (int i = 0; i < mainStudentData!.length; i++) {
                                          if (studentData![index].fields!.mobileNumber == mainStudentData![i].fields!.mobileNumber) {
                                            mainStudentData![i].fields!.selected = studentData![index].fields!.selected;
                                          }
                                        }
                                        setState(() {});
                                      });
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
                      Utils.showSnackBar(context, strings_name.str_select_student);
                    }
                  },
                )
              ])
            : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
