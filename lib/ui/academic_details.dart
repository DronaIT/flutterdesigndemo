import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/add_specialization.dart';
import 'package:flutterdesigndemo/ui/specialization_detail.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class AcademicDetails extends StatefulWidget {
  const AcademicDetails({Key? key}) : super(key: key);

  @override
  State<AcademicDetails> createState() => _AcademicDetailsState();
}

class _AcademicDetailsState extends State<AcademicDetails> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];

  final apiRepository = getIt.get<ApiRepository>();
  bool canAddSpe = false, canAddSubject = false, canViewSpe = false, canEditSpe = false;

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
    var data = await apiRepository.getPermissionsApi(query);
    if (data.records!.isNotEmpty) {
      for (var i = 0; i < data.records!.length; i++) {
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_SPECILIZATION) {
          setState(() {
            canAddSpe = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_SPECILIZATION) {
          setState(() {
            canEditSpe = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_SPECILIZATION) {
          setState(() {
            canViewSpe = true;
          });
        }
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
  }

  Future<void> initialization() async {
    setState(() {
      isVisible = true;
    });
    var data = await apiRepository.getSpecializationApi();
    if (data.records!.isNotEmpty) {
      setState(() {
        isVisible = false;
      });
      PreferenceUtils.setSpecializationList(data);
      specializationData = data.records;
    } else {
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_specializations),
      body: Stack(children: [
        Column(
          children: [
            Visibility(
              visible: canViewSpe,
              child: specializationData!.isNotEmpty
                  ? Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: specializationData?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 5,
                                child: GestureDetector(
                                  child: Container(
                                    color: colors_name.colorWhite,
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${specializationData![index].fields!.specializationName}", textAlign: TextAlign.center, style: blackTextSemiBold16),
                                        Visibility(
                                            visible: canEditSpe,
                                            child: GestureDetector(
                                              child: Icon(Icons.edit, size: 22, color: Colors.black),
                                              onTap: () {
                                                Get.to(const AddSpecialization(), arguments: specializationData![index].fields?.id)?.then((result) {
                                                  if (result != null && result) {
                                                    initialization();
                                                  }
                                                });
                                              },
                                            ))
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(const SpecializationDetail(), arguments: specializationData![index].fields?.id);
                                  },
                                ),
                              );
                            }),
                      ),
                    )
                  : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
            ),
            Visibility(
              visible: canAddSpe,
              child: Container(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                      text: strings_name.str_add_specilization,
                      fontSize: 18,
                      click: () async {
                        Get.to(const AddSpecialization())?.then((result) {
                          if (result != null && result) {
                            initialization();
                          }
                        });
                      })),
            ),
          ],
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
