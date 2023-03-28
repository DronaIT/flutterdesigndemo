import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/home_module_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/academic_list.dart';
import 'package:flutterdesigndemo/ui/attendence/attendance.dart';
import 'package:flutterdesigndemo/ui/authentication/login.dart';
import 'package:flutterdesigndemo/ui/hub_setup/setup_collage.dart';
import 'package:flutterdesigndemo/ui/manage_user/manage_user.dart';
import 'package:flutterdesigndemo/ui/placement/placement_dashboard.dart';
import 'package:flutterdesigndemo/ui/placement/placement_info.dart';
import 'package:flutterdesigndemo/ui/profile.dart';
import 'package:flutterdesigndemo/ui/settings_screen.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../api/dio_exception.dart';
import '../utils/utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isVisible = false;

  final homeRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<homeModuleResponse> homeModule = BaseLoginResponse();

  String name = "";
  String phone = "";
  String roleName = "";

  Future<void> getRecords(String roleId) async {
    var query = "SEARCH('${roleId}',${TableNames.CLM_ROLE_ID},0)";
    setState(() {
      isVisible = true;
    });
    try {
      homeModule = await homeRepository.getHomeModulesApi(query);
      if (homeModule.records!.isNotEmpty) {
        setState(() {
          isVisible = false;
        });
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
  }

  @override
  void initState() {
    super.initState();
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      var loginData = PreferenceUtils.getLoginData();
      name = loginData.name.toString();
      phone = loginData.mobileNumber.toString();
      getRecords(TableNames.STUDENT_ROLE_ID);
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      name = loginData.employeeName.toString();
      phone = loginData.mobileNumber.toString();
      getRecords(loginData.roleIdFromRoleIds![0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_home),
      drawer: Drawer(
        width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 200,
              child: DrawerHeader(
                child: Column(
                  children: [
                    Image.asset(
                      AppImage.ic_launcher,
                      height: 100,
                      width: 100,
                    ),
                    custom_text(
                      text: name,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      bottomValue: 0,
                    ),
                    custom_text(
                      text: phone,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      topValue: 5,
                      bottomValue: 0,
                    ),
                  ],
                ),
              ),
            ),
            buildMenuItem(
              text: strings_name.str_profile,
              icon: Icons.person,
              onClicked: () => selectedItem(context, 0),
            ),
            buildMenuItem(
              text: strings_name.str_settings,
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 1),
            ),
            buildMenuItem(
              text: strings_name.str_logout,
              icon: Icons.logout,
              onClicked: () => selectedItem(context, 2),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          homeModule.records?.isNotEmpty == true
              ? Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    children: List.generate(
                      homeModule.records != null ? homeModule.records!.length : 0,
                      (index) {
                        return Padding(
                            padding: const EdgeInsets.all(2),
                            child: Card(
                                elevation: 10,
                                child: Container(
                                  height: 300,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: GestureDetector(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Image.network(homeModule.records![index].fields!.moduleImage.toString(), fit: BoxFit.fill),
                                            ),
                                          ),
                                          custom_text(
                                            text: homeModule.records![index].fields!.moduleTitle.toString(),
                                            alignment: Alignment.center,
                                            textStyles: blackTextbold14,
                                            topValue: 10,
                                            bottomValue: 10,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_MANAGE_USER) {
                                          Get.to(const ManageUser());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_ACADEMIC_DETAIL) {
                                          Get.to(const AcademicList());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_SETUP_COLLAGE) {
                                          Get.to(const SetupCollage());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_ATTENDANCE) {
                                          Get.to(const Attendance());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_PLACEMENT) {
                                          if (PreferenceUtils.getIsLogin() == 1 && (PreferenceUtils.getLoginData().placedJob?.length ?? 0) > 0) {
                                            Get.to(const PlacementInfo(), arguments: PreferenceUtils.getLoginData().placedJob?.first);
                                          } else {
                                            Get.to(const PlacementDashboard());
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                )));
                      },
                    ),
                  ),
                )
              : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_module, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.black;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Get.back();
        Get.to(const Profile());
        break;
      case 1:
        Get.back();
        Get.to(const Settings());
        break;
      case 2:
        Get.back();
        showAlertDialog(context, strings_name.str_sure_want_logout, () {
          PreferenceUtils.clearPreference();
          Get.offAll(const Login());
        });
        break;
    }
  }

  void showAlertDialog(BuildContext context, String message, Function yesOnPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message, style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal, fontFamily: 'Roboto')),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: <Widget>[
            TextButton(
              child: const Text(strings_name.str_cancle, style: blackTextSemiBold14),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                strings_name.str_yes,
                style: blackTextSemiBold14,
              ),
              onPressed: () {
                Navigator.pop(context);
                yesOnPressed();
              },
            )
          ],
        );
      },
    );
  }
}