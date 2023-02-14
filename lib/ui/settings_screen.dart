import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
              onTap: (){

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
              onTap: (){

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
    ));
  }
}
