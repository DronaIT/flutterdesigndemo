import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/home_module_response.dart';
import 'package:flutterdesigndemo/ui/login.dart';
import 'package:flutterdesigndemo/ui/manage_specializations.dart';
import 'package:flutterdesigndemo/ui/manage_user.dart';
import 'package:flutterdesigndemo/ui/setting.dart';
import 'package:flutterdesigndemo/ui/setup_collage.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

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

  Future<void> getRecords(String roleId) async {
    var query = "SEARCH('${roleId}',${TableNames.CLM_ROLE_ID},0)";
    setState(() {
      isVisible = true;
    });
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
              text: strings_name.str_settings,
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 0),
            ),
            buildMenuItem(
              text: strings_name.str_logout,
              icon: Icons.logout,
              onClicked: () => selectedItem(context, 1),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          homeModule.records?.isNotEmpty == true
              ? GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: List.generate(
                    homeModule.records != null ? homeModule.records!.length : 0,
                    (index) {
                      return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                              elevation: 10,
                              child: Container(
                                height: 300,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Image.network(homeModule.records![index].fields!.moduleImage.toString(), fit: BoxFit.fill),
                                        ),
                                        custom_text(
                                          text: homeModule.records![index].fields!.moduleTitle.toString(),
                                          alignment: Alignment.center,
                                          textStyles: blackTextSemiBold14,
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      if (homeModule.records![index].fields?.moduleId == "DM01")
                                        Get.to(ManageUser());
                                      else if (homeModule.records![index].fields?.moduleId == "DM05") Get.to(ManageSpecializations());
                                      else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_SETUP_COLLAGE) Get.to(SetupCollage());
                                    },
                                  ),
                                ),
                              )));
                    },
                  ),
                )
              : Container(margin: EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_module, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          Center(
            child: Visibility(child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary), visible: isVisible),
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
        Get.to(const Setting());
        break;
      case 1:
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
              child: const Text(
                strings_name.str_yes,
                style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal, fontFamily: strings_name.str_font_name),
              ),
              onPressed: () {
                Navigator.pop(context);
                yesOnPressed();
              },
            ),
            TextButton(
              child: const Text(strings_name.str_cancle, style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: strings_name.str_font_name)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
