import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/ask_parameter_response.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/ask/add_ask_parameters.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AskParameters extends StatefulWidget {
  const AskParameters({super.key});

  @override
  State<AskParameters> createState() => _AskParametersState();
}

class _AskParametersState extends State<AskParameters> {
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  var controllerSearch = TextEditingController();
  String offset = "";

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  List<BaseApiResponseWithSerializable<ASKParameterResponse>>? mainList = [];
  List<BaseApiResponseWithSerializable<ASKParameterResponse>>? childList = [];

  bool canAddAskParameters = false, canUpdateAskParameter = false;

  @override
  void initState() {
    super.initState();
    hubResponseArray?.addAll(PreferenceUtils.getHubList().records!);

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

    getPermission();
  }

  getSpecializations() {
    speResponseArray = [];
    speResponseArray?.addAll(PreferenceUtils.getSpecializationList().records!);
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
    } else if (isLogin == 3) {
      roleId = TableNames.ORGANIZATION_ROLE_ID;
    }

    var query = "AND(FIND('$roleId',role_ids)>0,module_ids='${TableNames.MODULE_ASK_MODULE}')";
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_ASK_PARAMETERS) {
            canAddAskParameters = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_ASK_PARAMETERS) {
            canUpdateAskParameter = true;
          }
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
    } finally {
      setState(() {
        isVisible = false;
      });
      getRecords();
    }
  }

  getRecords() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });
    var query = "AND(";
    query += "OR(FIND('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",FIND('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
        }
      }
    }
    query += "),is_active=1)";
    debugPrint(query);

    try {
      var data = await apiRepository.getAskParametersApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mainList?.clear();
        }
        mainList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<ASKParameterResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          childList = [];
          childList = List.from(mainList!);

          filterData();
          debugPrint("Result size: ${childList?.length}");

          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            mainList = [];
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
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_ask_parameters),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              const custom_text(
                text: strings_name.str_select_hub_r,
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
                bottomValue: 0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                width: viewWidth,
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
                    filterData();
                    setState(() {});
                  },
                  items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
                    return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                      value: value,
                      child: Text(value.fields!.hubName!.toString()),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 5.h),
              const custom_text(
                text: strings_name.str_select_specialization,
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
                topValue: 0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                width: viewWidth,
                child: DropdownButtonFormField<BaseApiResponseWithSerializable<SpecializationResponse>>(
                  value: speResponse,
                  elevation: 16,
                  style: blackText16,
                  focusColor: Colors.white,
                  onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                    speValue = newValue!.fields!.id.toString();
                    speResponse = newValue;

                    filterData();
                    setState(() {});
                  },
                  items: speResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>((BaseApiResponseWithSerializable<SpecializationResponse> value) {
                    return DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>(
                      value: value,
                      child: Text(value.fields!.specializationName.toString()),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 5.h),
              childList?.isNotEmpty == true
                  ? Column(children: [
                      custom_text(
                        text: "Total Parameters: ${mainList?.length ?? 0}",
                        textStyles: primaryTextSemiBold16,
                        bottomValue: 5,
                      ),
                      ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: childList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                                  decoration: BoxDecoration(
                                    color: colors_name.colorOffWhite,
                                    border: Border.all(
                                        color: childList![index].fields?.askType?.contains(strings_name.str_ask_type_attitude) == true
                                            ? colors_name.colorPrimary
                                            : (childList![index].fields?.askType?.contains(strings_name.str_ask_type_knowledge) == true ? colors_name.green : colors_name.blue)),
                                    borderRadius: BorderRadius.circular(6.w),
                                  ),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(
                                          text: childList![index].fields!.parameterTitle?.trim() ?? '',
                                          textStyles: primaryTextSemiBold15,
                                          topValue: 5,
                                          bottomValue: 5,
                                        ),
                                        canUpdateAskParameter
                                            ? GestureDetector(
                                                onTap: () {
                                                  Get.to(const AddAskParameters(), arguments: childList![index].fields?.askParameterCode)?.then((value) {
                                                    if (value != null && value) {
                                                      childList?.clear();
                                                      mainList?.clear();

                                                      getRecords();
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: 25.w,
                                                  width: 25.w,
                                                  decoration: BoxDecoration(
                                                    color: colors_name.lightGreyColor.withOpacity(0.5),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.edit_outlined,
                                                    color: colors_name.colorBlack,
                                                    size: 15.w,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    Visibility(
                                      visible: childList![index].fields!.parameterDescription?.isNotEmpty == true,
                                      child: custom_text(
                                        text: childList![index].fields!.parameterDescription?.trim() ?? '',
                                        textStyles: greyDarkTextStyle,
                                        maxLines: 2,
                                        topValue: 5,
                                        bottomValue: 5,
                                      ),
                                    ),
                                    childList![index].fields!.askLevelTitle?.isNotEmpty == true
                                        ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                            Container(
                                                margin: EdgeInsets.fromLTRB(5.w, 10.h, 0, 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8.r),
                                                  color: colors_name.colorBlack.withOpacity(0.1),
                                                ),
                                                child: custom_text(
                                                  alignment: Alignment.centerRight,
                                                  text: childList![index].fields!.askLevelTitle?[0].trim() ?? '',
                                                  textStyles: childList![index].fields?.askType?.contains(strings_name.str_ask_type_attitude) == true
                                                      ? redTextSemiBold15
                                                      : (childList![index].fields?.askType?.contains(strings_name.str_ask_type_knowledge) == true ? greenTextSemiBold15 : blueTextSemiBold15),
                                                  maxLines: 2,
                                                  topValue: 5,
                                                  bottomValue: 5,
                                                )),
                                          ])
                                        : Container(),
                                  ]),
                                ));
                          }),
                    ])
                  : const custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
            ]),
          ),
          Visibility(
            visible: isVisible,
            child: Container(
              color: colors_name.colorWhite,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: canAddAskParameters
          ? FloatingActionButton(
              elevation: 0.0,
              backgroundColor: colors_name.colorPrimary,
              onPressed: () {
                Get.to(const AddAskParameters())?.then((value) {
                  if (value != null && value) {
                    childList?.clear();
                    mainList?.clear();

                    getRecords();
                  }
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ))
          : Container(),
    ));
  }

  void filterData() {
    if (mainList?.isNotEmpty == true) {
      if (hubValue.trim().isNotEmpty || speValue.trim().isNotEmpty) {
        childList?.clear();
        childList = [];

        for (int i = 0; i < mainList!.length; i++) {
          if (hubValue.trim().isNotEmpty && speValue.trim().isNotEmpty) {
            if (mainList![i].fields?.hubIdFromHubIds?.contains(hubResponse?.fields?.hubId) == true &&
                mainList![i].fields?.specializationIdFromSpecializationIds?.contains(speResponse?.fields?.specializationId) == true) {
              childList?.add(mainList![i]);
            }
          } else if (hubValue.trim().isNotEmpty) {
            if (mainList![i].fields?.hubIdFromHubIds?.contains(hubResponse?.fields?.hubId) == true) {
              childList?.add(mainList![i]);
            }
          } else if (speValue.trim().isNotEmpty) {
            if (mainList![i].fields?.specializationIdFromSpecializationIds?.contains(speResponse?.fields?.specializationId) == true) {
              childList?.add(mainList![i]);
            }
          }
        }
      }
    }
  }
}
