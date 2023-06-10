import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_edittext.dart';
import '../../customwidget/custom_text.dart';
import '../../values/text_styles.dart';

class HelpdeskDetail extends StatefulWidget {
  const HelpdeskDetail({Key? key}) : super(key: key);

  @override
  State<HelpdeskDetail> createState() => _HelpdeskDetailState();
}

class _HelpdeskDetailState extends State<HelpdeskDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_help_desk_detail),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  custom_text(
                    text: strings_name.str_help_desk_type,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
