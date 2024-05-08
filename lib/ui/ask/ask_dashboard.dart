import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/add_button.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/ask/add_ask_levels.dart';
import 'package:flutterdesigndemo/ui/ask/add_ask_parameters.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

class AskDashboard extends StatefulWidget {
  const AskDashboard({super.key});

  @override
  State<AskDashboard> createState() => _AskDashboardState();
}

class _AskDashboardState extends State<AskDashboard> {
  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  bool isVisible = false;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  bool canAddAskLevels = false, canAddAskParameters = false, canAddNewEvaluation = false, canUpdateEvaluation = false;
  String loginId = "";
  var isLogin = 0;

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
    isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      roleId = TableNames.STUDENT_ROLE_ID;
      loginId = PreferenceUtils.getLoginData().studentId.toString();
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      roleId = loginData.roleIdFromRoleIds!.join(',');
      loginId = loginData.employeeId.toString();
    } else if (isLogin == 3) {
      roleId = TableNames.ORGANIZATION_ROLE_ID;
      loginId = PreferenceUtils.getLoginDataOrganization().id.toString();
    }

    var query = "AND(FIND('$roleId',role_ids)>0,module_ids='${TableNames.MODULE_ASK_MODULE}')";
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_ASK_LEVELS) {
            canAddAskLevels = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_ASK_PARAMETERS) {
            canAddAskParameters = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_NEW_EVALUATION) {
            canAddNewEvaluation = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_EVALUATION) {
            canUpdateEvaluation = true;
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
      // getRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_ask_dashboard),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              canAddAskLevels
                  ? Column(
                      children: [
                        AddButton(
                          onTap: () async {
                            Get.to(const AddAskLevels())?.then((value) {
                              if (value != null && value) {
                                // getRecords();
                              }
                            });
                          },
                          title: strings_name.str_add_ask_levels,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    )
                  : Container(),
              canAddAskParameters
                  ? Column(
                      children: [
                        AddButton(
                          onTap: () async {
                            Get.to(const AddAskParameters())?.then((value) {
                              if (value != null && value) {
                                // getRecords();
                              }
                            });
                          },
                          title: strings_name.str_add_ask_parameters,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    )
                  : Container(),
              canAddNewEvaluation
                  ? Column(
                      children: [
                        AddButton(
                          onTap: () async {
                            Get.to(const AddAskParameters())?.then((value) {
                              if (value != null && value) {
                                // getRecords();
                              }
                            });
                          },
                          title: strings_name.str_new_evaluation,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    )
                  : Container(),
            ],
          ),
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
      ]),
    ));
  }
}
