
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';

class AttendenceHistoryDetail extends StatefulWidget {
  const AttendenceHistoryDetail({Key? key}) : super(key: key);

  @override
  State<AttendenceHistoryDetail> createState() => _AttendenceHistoryDetailState();
}

class _AttendenceHistoryDetailState extends State<AttendenceHistoryDetail> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppWidgets.appBarWithoutBack(strings_name.str_attendence_his_detail),
          body: Stack(
            children: [


              Center(
                child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
              )

            ],
          ),
    ));
  }
}
