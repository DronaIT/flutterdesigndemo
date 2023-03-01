import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/authentication/login.dart';
import 'package:flutterdesigndemo/ui/authentication/custom_webview.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            Scaffold(
              appBar: AppWidgets.appBarWithoutBack(strings_name.str_settings),
              body: Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Image.asset(
                        alignment: Alignment.center,
                        AppImage.ic_launcher,
                        height: 120,
                        width: 120,
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          // Get.to(const CustomWebView(), arguments: [
                          //   {"title": "Terms & condition"},
                          //   {"url": "https://pastebin.com/raw/HAHds12N"}
                          // ]);
                          await launchUrl(Uri.parse("https://pastebin.com/raw/HAHds12N"), mode: LaunchMode.inAppWebView);
                        },
                        child: Card(
                          elevation: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Expanded(child: custom_text(text: "Terms & condition", textStyles: blackTextSemiBold16, topValue: 10, maxLines: 2)), Container(alignment: Alignment.centerRight, margin: const EdgeInsets.all(10), child: const Icon(Icons.arrow_forward_ios))],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Get.to(const CustomWebView(), arguments: [
                          //   {"title": "Privacy policy"},
                          //   {"url": "https://pastebin.com/raw/QwwednCb"}
                          // ]);
                          await launchUrl(Uri.parse("https://pastebin.com/raw/QwwednCb"), mode: LaunchMode.inAppWebView);
                        },
                        child: Card(
                          elevation: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Expanded(child: custom_text(text: "Privacy policy", textStyles: blackTextSemiBold16, topValue: 10, maxLines: 2)), Container(alignment: Alignment.centerRight, margin: const EdgeInsets.all(10), child: const Icon(Icons.arrow_forward_ios))],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          showAlertDialog(context, strings_name.str_sure_want_delete, () async {
                            Map<String, String> password = {
                              "password": "",
                            };
                            setState(() {
                              isVisible = false;
                            });
                            if(PreferenceUtils.getIsLogin() == 1){
                              var dataUpdate = await apiRepository.createPasswordApi(password, PreferenceUtils.getLoginRecordId());
                              if(dataUpdate.isBlank != true){
                                setState(() {
                                  isVisible = false;
                                });
                                PreferenceUtils.clearPreference();
                                Get.offAll(const Login());
                              }else{
                                setState(() {
                                  isVisible = false;
                                });
                                Utils.showSnackBar(context, strings_name.str_something_wrong);
                              }
                            } else if(PreferenceUtils.getIsLogin() == 2) {
                              var dataUpdate = await apiRepository.createPasswordEmpApi(password, PreferenceUtils.getLoginRecordId());
                              if(dataUpdate.isBlank != true){
                                setState(() {
                                  isVisible = false;
                                });
                                PreferenceUtils.clearPreference();
                                Get.offAll(const Login());
                              }else{
                                setState(() {
                                  isVisible = false;
                                });
                                Utils.showSnackBar(context, strings_name.str_something_wrong);
                              }
                            } else {
                              setState(() {
                                isVisible = false;
                              });
                              Utils.showSnackBar(context, strings_name.str_something_wrong);
                            }

                          });
                        },
                        child: Card(
                          elevation: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Expanded(child: custom_text(text: "Delete account", textStyles: blackTextSemiBold16, topValue: 10, maxLines: 2)), Container(alignment: Alignment.centerRight, margin: const EdgeInsets.all(10), child: const Icon(Icons.arrow_forward_ios))],
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
            Center(
              child: Visibility(child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary), visible: isVisible),
            )
          ]
        ));
  }

  void showAlertDialog(BuildContext context, String message, Function yesOnPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message, style: blackTextSemiBold14),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: <Widget>[
            TextButton(
              child: const Text(strings_name.str_cancle, style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500, fontFamily: strings_name.str_font_name)),
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
