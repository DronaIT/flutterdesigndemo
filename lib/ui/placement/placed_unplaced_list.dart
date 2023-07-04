import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import '../../customwidget/app_widgets.dart';

class Placed_unplaced_SList extends StatefulWidget {
  const Placed_unplaced_SList({super.key});

  @override
  State<Placed_unplaced_SList> createState() => _Placed_unplaced_SListState();
}

class _Placed_unplaced_SListState extends State<Placed_unplaced_SList> {




  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_placed_unplaced_student),


    ));
  }
}
