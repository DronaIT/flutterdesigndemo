import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/units_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/add_units.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class ViewUnits extends StatefulWidget {
  const ViewUnits({Key? key}) : super(key: key);

  @override
  State<ViewUnits> createState() => _ViewUnitsState();
}

class _ViewUnitsState extends State<ViewUnits> {
  bool isVisible = false;

  BaseLoginResponse<UnitsResponse> unitData = BaseLoginResponse();
  final apiRepository = getIt.get<ApiRepository>();

  bool canUpdateSubject = false, canViewSubject = false, canAddSubject = false;

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  Future<void> viewUnits() async {
    setState(() {
      isVisible = true;
    });
    unitData = await apiRepository.getUnitsApi("");
    setState(() {
      isVisible = false;
    });
  }

  getPermission() async {
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
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_SUBJECT) {
          setState(() {
            canUpdateSubject = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_SUBJECT) {
          setState(() {
            canViewSubject = true;
          });
          viewUnits();
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_SUBJECT) {
          setState(() {
            canAddSubject = true;
          });
        }
      }
    } else {
      Utils.showSnackBar(context, strings_name.str_something_wrong);
    }
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_unit),
      body: Stack(
        children: [
          Column(
            children: [
              canViewSubject && unitData.records?.isNotEmpty == true
                  ? Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: unitData.records?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: custom_text(text: "${unitData.records![index].fields!.unitTitle}", textStyles: blackTextSemiBold16, topValue: 10, maxLines: 2)),
                                    canUpdateSubject
                                        ? GestureDetector(
                                            onTap: () {
                                              Get.to(const AddUnits(), arguments: unitData.records?[index].fields?.ids)?.then((result) {
                                                if (result != null && result) {
                                                  getPermission();
                                                }
                                              });
                                            },
                                            child: Container(alignment: Alignment.centerRight, margin: const EdgeInsets.all(10), child: const Icon(Icons.edit)))
                                        : Container(),
                                  ],
                                ),
                              );
                            }),
                      ),
                    )
                  : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_subjects, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
              canAddSubject
                  ? Container(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                          text: strings_name.str_add_units,
                          click: () async {
                            Get.to(const AddUnits())?.then((result) {
                              if (result != null && result) {
                                getPermission();
                              }
                            });
                          }))
                  : Container(),
            ],
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}