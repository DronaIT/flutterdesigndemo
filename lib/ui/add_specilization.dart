import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';

class AddSpecilization extends StatefulWidget {
  const AddSpecilization({Key? key}) : super(key: key);

  @override
  State<AddSpecilization> createState() => _AddSpecilizationState();
}

class _AddSpecilizationState extends State<AddSpecilization> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_add_specilization),
      body: Stack(
        children: [

        ],
      ),
    ));
  }
}
