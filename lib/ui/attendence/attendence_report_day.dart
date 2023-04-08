

import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
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


    ),));
  }
}
