
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import '../../customwidget/app_widgets.dart';

class JobOpportunityForm extends StatefulWidget {
  const JobOpportunityForm({Key? key}) : super(key: key);

  @override
  State<JobOpportunityForm> createState() => _JobOpportunityFormState();
}

class _JobOpportunityFormState extends State<JobOpportunityForm> {
  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_job_opp_detail),

    ));
  }
}
