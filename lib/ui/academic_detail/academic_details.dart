import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/add_specialization.dart';
import 'package:flutterdesigndemo/ui/academic_detail/specialization_detail.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class AcademicDetails extends StatefulWidget {
  const AcademicDetails({Key? key}) : super(key: key);

  @override
  State<AcademicDetails> createState() => _AcademicDetailsState();
}

class _AcademicDetailsState extends State<AcademicDetails> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationMainData = [];

  final apiRepository = getIt.get<ApiRepository>();
  bool canAddSpe = false, canAddSubject = false, canViewSpe = false, canEditSpe = false;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  @override
  void initState() {
    super.initState();
    checkHubs();
    getPermission();
    initialization();
  }

  void checkHubs() {
    hubResponseArray = PreferenceUtils.getHubList().records;

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

      for (var i = 0; i < hubResponseArray!.length; i++) {
        if (loginData.hubIdFromHubIds?.first == hubResponseArray![i].fields?.hubId) {
          hubValue = hubResponseArray![i].fields!.hubId!.toString();
          hubResponse = hubResponseArray![i];
        }
      }
    }
  }

  void filterBasedOnHub() {
    if (hubValue.isNotEmpty) {
      specializationData = [];
      for (var i = 0; i < specializationMainData!.length; i++) {
        if(specializationMainData![i].fields?.hubIdFromHubIds?.contains(hubValue) == true){
          specializationData?.add(specializationMainData![i]);
        }
      }
    } else {
      specializationData = specializationMainData;
    }
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
    try {
      var data = await apiRepository.getSpecializationApi();
      if (data.records!.isNotEmpty) {
        data.records?.sort((a, b) => a.fields!.specializationName!.compareTo(b.fields!.specializationName!));
        if (PreferenceUtils.getIsLogin() == 1) {
          for (var i = 0; i < data.records!.length; i++) {
            if (data.records![i].fields!.specializationId == PreferenceUtils.getLoginData().specializationIdFromSpecializationIds?[0]) {
              PreferenceUtils.setSpecializationList(data);
              specializationData?.add(data.records![i]);
            }
          }
        } else {
          PreferenceUtils.setSpecializationList(data);
          specializationMainData = data.records;

          filterBasedOnHub();
        }
      } else {
        setState(() {
          isVisible = false;
        });
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_specializations),
      body: Stack(children: [
        Column(
          children: [
            Visibility(
                visible: PreferenceUtils.getIsLogin() != 1,
                child: Column(
                  children: [
                    SizedBox(height: 5.h),
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
                          setState(() {
                            hubValue = newValue!.fields!.hubId!.toString();
                            hubResponse = newValue;

                            filterBasedOnHub();
                          });
                        },
                        items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
                          return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                            value: value,
                            child: Text(value.fields!.hubName!.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )),
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
                                        Expanded(child: custom_text(text: "${specializationData![index].fields!.specializationName}", textStyles: blackTextSemiBold16, topValue: 10, maxLines: 2)),
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
