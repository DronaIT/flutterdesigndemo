import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/ui/attendence/custom_filter_screen.dart';
import 'package:flutterdesigndemo/ui/attendence/filter_screen.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../customwidget/app_widgets.dart';

class AttendanceReportDay extends StatefulWidget {
  const AttendanceReportDay({Key? key}) : super(key: key);

  @override
  State<AttendanceReportDay> createState() => _AttendanceReportDayState();
}

class _AttendanceReportDayState extends State<AttendanceReportDay> {
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
                        {"isFromEligible": false},
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
                        {"isFromEligible": false},
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
                        {"isFromEligible": false},
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
                        {"isFromEligible": false},
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
                          children: const [Text(strings_name.str_eligiblity_report, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const Filter(), arguments: [
                        {"days": 1},
                        {"title": strings_name.str_eligiblity_report},
                        {"isFromEligible": true},
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
                          children: const [Text(strings_name.str_past_data, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const Filter(), arguments: [
                        {"days": 1},
                        {"title": strings_name.str_past_data},
                        {"isFromEligible": true},
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
                          children: const [Text(strings_name.str_custom_days_report, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const CustomFilterScreen(), arguments: [
                        {"title": strings_name.str_custom_days_report},
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
