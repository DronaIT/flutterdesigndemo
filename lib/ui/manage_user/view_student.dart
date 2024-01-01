import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/manage_user/view_student_list.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class ViewStudent extends StatefulWidget {
  const ViewStudent({Key? key}) : super(key: key);

  @override
  State<ViewStudent> createState() => _ViewStudentState();
}

class _ViewStudentState extends State<ViewStudent> {
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  List<int> semesterResponseArray = <int>[1, 2, 3, 4, 5, 6];
  int semesterValue = 1;

  final apiRepository = getIt.get<ApiRepository>();

  //bool isVisible = false;

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? viewStudent = [];

  bool canUpdateStudent = false;
  String offset = "";

  @override
  void initState() {
    super.initState();
    hubResponseArray = PreferenceUtils.getHubList().records;
    canUpdateStudent = Get.arguments;

    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      if ((loginData.accessible_hub_ids?.length ?? 0) > 0) {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          var isAccessible = false;
          for (var j = 0; j < loginData.accessible_hub_ids!.length; j++) {
            if (loginData.accessible_hub_ids![j] == hubResponseArray![i].id) {
              isAccessible = true;
              break;
            }
            if (loginData.hubIdFromHubIds?.first == hubResponseArray![i].fields?.hubId) {
              isAccessible = true;
              break;
            }
          }
          if (!isAccessible) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      } else {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          if (loginData.hubIdFromHubIds?.first != hubResponseArray![i].fields?.hubId) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      }
    }

    // getSpecializations();
  }

  getSpecializations() {
    speResponseArray = [];
    speResponseArray?.addAll(PreferenceUtils.getSpecializationList().records!);

    for (int i = 0; i < (speResponseArray?.length ?? 0); i++) {
      bool contains = false;
      for (int j = 0; j < (hubResponseArray?.length ?? 0); j++) {
        if (speResponseArray![i].fields!.hubIdFromHubIds?.contains(hubResponseArray![j].fields?.hubId) == true) {
          contains = true;
          break;
        }
      }
      if (!contains) {
        speResponseArray?.removeAt(i);
        i--;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_students),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  custom_text(
                    text: strings_name.str_select_hub,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    bottomValue: 0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                      value: hubResponse,
                      elevation: 16,
                      style: blackText16,
                      focusColor: Colors.white,
                      onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                        hubValue = newValue!.fields!.id!.toString();
                        hubResponse = newValue;

                        getSpecializations();
                        if (hubValue.trim().isNotEmpty) {
                          for (int i = 0; i < speResponseArray!.length; i++) {
                            if (speResponseArray![i].fields?.hubIdFromHubIds?.contains(hubResponse?.fields?.hubId) != true) {
                              speResponseArray!.removeAt(i);
                              i--;
                            }
                          }
                        }
                        speValue = "";
                        speResponse = null;
                        if (speResponseArray?.isEmpty == true) {
                          Utils.showSnackBar(context, strings_name.str_no_specialization_linked);
                        }
                        setState(() {});
                      },
                      items: hubResponseArray
                          ?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
                        return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                          value: value,
                          child: Text(value.fields!.hubName!.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_select_specialization,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonFormField<BaseApiResponseWithSerializable<SpecializationResponse>>(
                      value: speResponse,
                      elevation: 16,
                      style: blackText16,
                      focusColor: Colors.white,
                      onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                        setState(() {
                          speValue = newValue!.fields!.id.toString();
                          speResponse = newValue;
                        });
                      },
                      items: speResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>(
                          (BaseApiResponseWithSerializable<SpecializationResponse> value) {
                        return DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>(
                          value: value,
                          child: Text(value.fields!.specializationName.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_semester,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonFormField<int>(
                      value: semesterValue,
                      elevation: 16,
                      style: blackText16,
                      focusColor: Colors.white,
                      onChanged: (int? newValue) {
                        setState(() {
                          semesterValue = newValue!;
                        });
                      },
                      items: semesterResponseArray.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text("Semester $value"),
                        );
                      }).toList(),
                    ),
                  ),
                  CustomButton(
                    click: () async {
                      if (hubValue.isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_hub);
                      } else if (speValue.isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_spe);
                      } else if (semesterValue == -1) {
                        Utils.showSnackBar(context, strings_name.str_empty_semester);
                      } else {
                        Get.to(const ViewStudentList(), arguments: [
                          {"canUpdate": canUpdateStudent},
                          {"hubValue": hubValue},
                          {"semValue": semesterValue},
                          {"speValue": speValue},
                        ]);
                        //fetchRecords();
                      }
                    },
                    text: strings_name.str_submit,
                  ),
                ],
              ),
            ),
          ),
          // Center(
          //   child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          // )
        ],
      ),
    ));
  }
}
