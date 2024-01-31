import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/ui/hub_setup/addhub.dart';
import 'package:flutterdesigndemo/ui/hub_setup/updatehub.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class SetupCollage extends StatefulWidget {
  const SetupCollage({Key? key}) : super(key: key);

  @override
  State<SetupCollage> createState() => _SetupCollageState();
}

class _SetupCollageState extends State<SetupCollage> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  bool canAddHub = false, canUpdateHub = false, canViewHub = false;

  BaseLoginResponse<HubResponse> hubResponse = BaseLoginResponse();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> getRecords() async {
    try{
      hubResponse = await apiRepository.getHubApi();
      if (hubResponse.records!.isNotEmpty) {
        PreferenceUtils.setHubList(hubResponse);
        setState(() {
          canViewHub = true;
        });
      }
    }on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }

  }

  Future<void> initialization() async {
    setState(() {
      isVisible = true;
    });
    var loginData = PreferenceUtils.getLoginDataEmployee();
    var query = "AND(FIND('${loginData.roleIdFromRoleIds!.join(',')}',role_ids)>0,module_ids='${TableNames.MODULE_SETUP_COLLAGE}')";
    try{
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_HUB) {
            setState(() {
              canAddHub = true;
            });
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_HUB) {
            setState(() {
              canUpdateHub = true;
            });
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_HUB) {
            getRecords();
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

    debugPrint("updates==>${canViewHub}==>${canUpdateHub}==>${canAddHub}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_setup_collage),
        body: Stack(
          children: [
            Column(
              children: [
                canViewHub && hubResponse.records?.isNotEmpty == true
                    ? Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: ListView.builder(
                              itemCount: hubResponse.records?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 5,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Column(
                                          children: [
                                            custom_text(text: "${hubResponse.records![index].fields!.hubName!}", textStyles: centerTextStylePrimary18, topValue: 10, maxLines: 2),
                                            custom_text(text: "Code : ${hubResponse.records![index].fields!.hubId!}", textStyles: blackTextSemiBold16, bottomValue: 5, topValue: 0),
                                            custom_text(
                                              text: "Address: ${hubResponse.records![index].fields!.address!}",
                                              textStyles: blackTextSemiBold14,
                                              bottomValue: 5,
                                              topValue: 0,
                                              maxLines: 2,
                                            ),
                                            custom_text(text: "City: ${hubResponse.records![index].fields!.city!}", textStyles: blackTextSemiBold14, bottomValue: 10, topValue: 0)
                                          ],
                                        ),
                                      ),
                                      canUpdateHub
                                          ? GestureDetector(
                                              onTap: () async {
                                                var response = await Get.to(const UpdateHub(), arguments: hubResponse.records?[index]);
                                                if (response) {
                                                  initialization();
                                                }
                                              },
                                              child: Container(margin: EdgeInsets.all(10), child: Icon(Icons.edit)))
                                          : Container(),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      )
                    : canViewHub
                        ? Container(margin: EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_hub, textStyles: centerTextStyleBlack18, alignment: Alignment.center))
                        : Container(),
                canAddHub
                    ? Container(
                        alignment: Alignment.bottomCenter,
                        child: CustomButton(
                            text: strings_name.str_add_hub,
                            click: () async {
                              var response = await Get.to(const AddHub());
                              if (response) {
                                initialization();
                              }
                            }))
                    : Container()
              ],
            ),
            Center(
              child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
            )
          ],
        ),
      ),
    );
  }
}
