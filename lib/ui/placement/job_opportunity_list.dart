import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';

class JobOpportunityList extends StatefulWidget {
  const JobOpportunityList({Key? key}) : super(key: key);

  @override
  State<JobOpportunityList> createState() => _JobOpportunityListState();
}

class _JobOpportunityListState extends State<JobOpportunityList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_list_job_opp_detail),
      body: Stack(
        children: [

        ],
      ),
    ));
  }
}
