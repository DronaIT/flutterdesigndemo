import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../customwidget/custom_edittext_search.dart';

class EmployeeSelection extends StatefulWidget {
  const EmployeeSelection({Key? key}) : super(key: key);

  @override
  State<EmployeeSelection> createState() => _EmployeeSelectionState();
}

class _EmployeeSelectionState extends State<EmployeeSelection> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? employeeData = [];
  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? testEmployeeData = [];

  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? selectedData = [];

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedData = Get.arguments;

    getRecords();
  }

  getRecords() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });

    // var query = "OR(FIND('${PreferenceUtils.getLoginDataEmployee().hubIds![0]}','${TableNames.CLM_HUB_IDS}',0)";
    // if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids?.isNotEmpty == true) {
    //   for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids!.length; i++) {
    //     query += ",FIND('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids![i]}','${TableNames.CLM_HUB_IDS}',0)";
    //   }
    // }
    // query += ")";

    var query = "FIND(1,is_working,0)";
    print(query);

    try {
      var data = await apiRepository.getEmployeeListApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          employeeData?.clear();
        }
        employeeData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<ViewEmployeeResponse>>);
        testEmployeeData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<ViewEmployeeResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          employeeData?.sort((a, b) {
            var adate = a.fields!.employeeName;
            var bdate = b.fields!.employeeName;
            return adate!.compareTo(bdate!);
          });
          testEmployeeData?.sort((a, b) {
            var adate = a.fields!.employeeName;
            var bdate = b.fields!.employeeName;
            return adate!.compareTo(bdate!);
          });
          for (var i = 0; i < selectedData!.length; i++) {
            for (var j = 0; j < employeeData!.length; j++) {
              if (employeeData![j].fields!.employeeId == selectedData![i].fields!.employeeId) {
                employeeData![j].fields!.selected = true;
                break;
              }
            }
          }
          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            employeeData = [];
            testEmployeeData = [];
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_employee),
      body: Stack(children: [
        employeeData?.isNotEmpty == true
            ? Column(children: [
                SizedBox(height: 10.h),
                CustomEditTextSearch(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: controllerSearch,
                  onChanges: (value) {
                    if (value.isEmpty) {
                      employeeData = [];
                      employeeData = List.from(testEmployeeData as Iterable);
                      setState(() {});
                    } else {
                      employeeData = [];
                      if (testEmployeeData != null && testEmployeeData?.isNotEmpty == true) {
                        for (var i = 0; i < testEmployeeData!.length; i++) {
                          if (testEmployeeData![i].fields!.employeeName!.toLowerCase().contains(value.toLowerCase())) {
                            employeeData?.add(testEmployeeData![i]);
                          }
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
                        itemCount: employeeData?.length,
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
                                    Expanded(child: Text("${employeeData![index].fields!.employeeName}", textAlign: TextAlign.start, style: blackTextSemiBold16)),
                                    if (employeeData![index].fields!.selected) const Icon(Icons.check, size: 20, color: colors_name.colorPrimary),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  employeeData![index].fields!.selected = !employeeData![index].fields!.selected;
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
                    List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? selectedEmployeeData = [];
                    for (var i = 0; i < employeeData!.length; i++) {
                      if (employeeData![i].fields!.selected) {
                        selectedEmployeeData.add(employeeData![i]);
                      }
                    }
                    if (selectedEmployeeData.isNotEmpty) {
                      Get.back(result: selectedEmployeeData);
                    } else {
                      Utils.showSnackBar(context, strings_name.str_select_employee);
                    }
                  },
                )
              ])
            : Container(margin: EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_employee, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
