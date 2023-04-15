import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/ui/attendence/filter_screen.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import '../../customwidget/app_widgets.dart';

class AttendenceReportDay extends StatefulWidget {
  const AttendenceReportDay({Key? key}) : super(key: key);

  @override
  State<AttendenceReportDay> createState() => _AttendenceReportDayState();
}

class _AttendenceReportDayState extends State<AttendenceReportDay> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppWidgets.appBarWithoutBack(strings_name.str_attendence_report),
            body: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_3_days, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const Filter(), arguments: [
                        {"days": 3},
                        {"title": strings_name.str_3_days},
                      ])?.then((result) {
                        if (result != null && result) {
                          // Get.back(closeOverlays: true);
                        }
                      });
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_5_days, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const Filter(), arguments: [
                        {"days": 5},
                        {"title": strings_name.str_5_days},
                      ])?.then((result) {
                        if (result != null && result) {
                          // Get.back(closeOverlays: true);
                        }
                      });
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_10_days, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const Filter(), arguments: [
                        {"days": 10},
                        {"title": strings_name.str_10_days},
                      ])?.then((result) {
                        if (result != null && result) {
                          // Get.back(closeOverlays: true);
                        }
                      });
                    },
                  ),


                  GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_today_days, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const Filter(), arguments: [
                        {"days": 1},
                        {"title": strings_name.str_today_days},
                      ])?.then((result) {
                        if (result != null && result) {
                          // Get.back(closeOverlays: true);
                        }
                      });
                    },
                  ),

                ],
              ),
            )));
  }
}
