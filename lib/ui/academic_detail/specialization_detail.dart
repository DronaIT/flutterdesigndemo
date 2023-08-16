import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/add_subject.dart';
import 'package:flutterdesigndemo/ui/academic_detail/subject_detail.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../utils/preference.dart';

class SpecializationDetail extends StatefulWidget {
  const SpecializationDetail({Key? key}) : super(key: key);

  @override
  State<SpecializationDetail> createState() => _SpecializationDetailState();
}

class _SpecializationDetailState extends State<SpecializationDetail> {
  bool isVisible = false;

  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];
  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectData = [];

  List<String> semesterResponseArray = <String>["1", "2", "3", "4", "5", "6"];
  String semesterValue = "1";

  final apiRepository = getIt.get<ApiRepository>();

  String query = "";
  bool canAddSubject = false;

  @override
  void initState() {
    super.initState();
    getPermission();
    initialization();
  }

  Future<void> getPermission() async {
    setState(() {
      isVisible = true;
    });
    var roleId = "";
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      roleId = TableNames.STUDENT_ROLE_ID;
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      roleId = loginData.roleIdFromRoleIds!.join(',');
    }
    var query = "AND(FIND('${roleId}',role_ids)>0,module_ids='${TableNames.MODULE_ACADEMIC_DETAIL}')";
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_SUBJECT) {
            setState(() {
              canAddSubject = true;
            });
          }
        }
        setState(() {
          isVisible = false;
        });
      } else {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  Future<void> initialization() async {
    setState(() {
      isVisible = true;
    });
    var query = "FIND('${Get.arguments}', ${TableNames.CLM_SPE_ID}, 0)";
    //query = "AND(FIND('${Get.arguments}',${TableNames.CLM_SPE_ID}) 0 ,1='${TableNames.MODULE_ATTENDANCE}')";
    //var query = "AND(FIND('${Get.arguments}', ${TableNames.CLM_SPE_ID}, 0),FIND('${semesterValue}',${TableNames.CLM_SEMESTER}, 0))";

    print("test=>${query}");
    try {
      var data = await apiRepository.getSpecializationDetailApi(query);
      if (data.records?.isNotEmpty == true) {
        specializationData = data.records;
        callSubjectData();
      } else {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  callSubjectData() async {
    setState(() {
      isVisible = true;
    });
    try {
      if (specializationData?.isNotEmpty == true) {
        //var query = "AND(FIND('${Get.arguments}', ${TableNames.CLM_SPE_ID}, 0),FIND('${semesterValue}',${TableNames.CLM_SEMESTER}, 0))";
        if (PreferenceUtils.getIsLogin() == 1) {
          semesterValue = PreferenceUtils.getLoginData().semester!;
          query = "AND(FIND('${specializationData![0].fields!.id}', ${TableNames.CLM_SPE_IDS}, 0),FIND('${semesterValue}',${TableNames.CLM_SEMESTER}, 0))";
        } else {
          query = "AND(FIND('${specializationData![0].fields!.id}', ${TableNames.CLM_SPE_IDS}, 0),FIND('${semesterValue}',${TableNames.CLM_SEMESTER}, 0))";
        }
        var data = await apiRepository.getSubjectsApi(query);
        if (data.records?.isNotEmpty == true) {
          data.records?.sort((a, b) => a.fields!.subjectTitle!.toLowerCase().compareTo(b.fields!.subjectTitle!.toLowerCase()));
          subjectData = data.records;
        }
      }
    } on DioError catch (e) {
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_spe_detail),
      body: Stack(children: [
        specializationData?.isNotEmpty == true
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    custom_text(text: specializationData![0].fields!.specializationName.toString(), maxLines: 5, textStyles: centerTextStyle24),
                    custom_text(text: "Code : ${specializationData![0].fields!.specializationId}", textStyles: blackTextSemiBold16),
                    custom_text(text: specializationData![0].fields!.specializationDesc.toString(), maxLines: 5000, textStyles: blackTextSemiBold14),

                    Visibility(
                      visible: PreferenceUtils.getIsLogin() == 2,
                      child: custom_text(
                        text: strings_name.str_semester,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                      ),
                    ),
                    Visibility(
                      visible: PreferenceUtils.getIsLogin() == 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                              width: MediaQuery.of(context).size.width,
                              child: DropdownButtonFormField<String>(
                                elevation: 16,
                                style: blackText16,
                                value: semesterValue,
                                focusColor: Colors.white,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    semesterValue = newValue!;
                                  });
                                  subjectData?.clear();
                                  callSubjectData();
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
                    ),
                    Visibility(visible: subjectData?.isNotEmpty == true, child: custom_text(text: "Subjects", textStyles: blackTextSemiBold16)),
                    subjectData?.isNotEmpty == true
                        ? Container(
                            margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
                            child: ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: subjectData?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 5,
                                    child: GestureDetector(
                                      child: Container(
                                        color: colors_name.colorWhite,
                                        padding: const EdgeInsets.all(10),
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                          Expanded(child: Text("${subjectData![index].fields!.subjectTitle}", textAlign: TextAlign.start, style: blackTextSemiBold14)),
                                          Visibility(
                                              visible: canAddSubject,
                                              child: GestureDetector(
                                                child: const Icon(Icons.edit, size: 22, color: Colors.black),
                                                onTap: () {
                                                  Get.to(const AddSubject(), arguments: [
                                                    {"subjectId": subjectData![index].fields?.ids}
                                                  ])?.then((result) {
                                                    if (result != null && result) {
                                                      getPermission();
                                                      initialization();
                                                    }
                                                  });
                                                },
                                              ))
                                        ]),
                                      ),
                                      onTap: () {
                                        Get.to(const SubjectDetail(), arguments: [
                                          {"subjectId": subjectData![index]},
                                          {"addSubjectPermission": canAddSubject}
                                        ]);
                                      },
                                    ),
                                  );
                                }),
                          )
                        : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_subjects, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
                    // Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_employee, textStyles: centerTextStyleBlack18, alignment: Alignment.center))
                  ],
                ),
              )
            : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        canAddSubject
            ? Container(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                    text: strings_name.str_add_subjects,
                    click: () async {
                      Get.to(const AddSubject(), arguments: [
                        {"specializationId": specializationData![0].id}
                      ])?.then((result) {
                        if (result != null && result) {
                          getPermission();
                          initialization();
                        }
                      });
                    }))
            : Container(),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
