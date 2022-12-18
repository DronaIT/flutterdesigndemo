import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';

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
    hubResponse = await apiRepository.getHubApi();
    if (hubResponse.records!.isNotEmpty) {
      PreferenceUtils.setHubList(hubResponse);
      print("Hub ${PreferenceUtils.getHubList().records!.length}");
      setState(() {
        canViewHub = true;
      });
    }
  }

  Future<void> initialization() async {
    setState(() {
      isVisible = true;
    });
    var loginData = PreferenceUtils.getLoginDataEmployee();
    var query = "AND(FIND('${loginData.roleIdFromRoleIds!.join(',')}',role_ids)>0,module_ids='${TableNames.MODULE_SETUP_COLLAGE}')";
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
    setState(() {
      isVisible = false;
    });
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
                                    custom_text(text: "${hubResponse.records![index].fields!.hubName! }", textStyles: blackTextSemiBold16, topValue: 10, maxLines: 2),
                                    custom_text(text: hubResponse.records![index].fields!.city!, textStyles: blackTextSemiBold14, bottomValue: 5, topValue: 0),
                                    custom_text(text: hubResponse.records![index].fields!.address!, textStyles: blackTextSemiBold14, bottomValue: 10, topValue: 0)
                                  ],
                                ),
                              ),
                              canUpdateHub ? GestureDetector(
                                  onTap: () async {
                                    // var response = await Get.to(const UpdateEmployee(), arguments: viewEmployee![index]);
                                    // if (response) {
                                    //   setState(() async {
                                    //     var query = "SEARCH('${hubValue}',${TableNames.CLM_HUB_IDS},0)";
                                    //     setState(() {
                                    //       isVisible = true;
                                    //     });
                                    //     var data = await apiRepository.viewEmployeeApi(query);
                                    //     if (data.records!.isNotEmpty) {
                                    //       setState(() {
                                    //         isVisible = false;
                                    //         viewEmployee = data.records;
                                    //       });
                                    //     } else {
                                    //       setState(() {
                                    //         isVisible = false;
                                    //         viewEmployee = [];
                                    //       });
                                    //       Utils.showSnackBar(context, strings_name.str_something_wrong);
                                    //     }
                                    //   });
                                    // }
                                  },
                                  child: Container(margin: EdgeInsets.all(10), child: Icon(Icons.edit))) : Container(),
                            ],
                          ),
                        );
                      }),)
                    : canViewHub  ? Container(margin: EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_employee, textStyles: centerTextStyleBlack18, alignment: Alignment.center)) : Container(),
                canAddHub ? Container(alignment: Alignment.bottomCenter, child: CustomButton(text: strings_name.str_add_hub, click: () {})) : Container()
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
