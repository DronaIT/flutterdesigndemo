import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class SpecializationDetail extends StatefulWidget {
  const SpecializationDetail({Key? key}) : super(key: key);

  @override
  State<SpecializationDetail> createState() => _SpecializationDetailState();
}

class _SpecializationDetailState extends State<SpecializationDetail> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];

  final apiRepository = getIt.get<ApiRepository>();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    setState(() {
      isVisible = true;
    });
    var query = "FIND('${Get.arguments}', ${TableNames.TBL_SPECIALIZATION}, 0)";
    var data = await apiRepository.getSpecializationDetailApi(query);
    if (data.records!.isNotEmpty) {
      specializationData = data.records;
    } else {
      Utils.showSnackBar(context, strings_name.str_something_wrong);
    }
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_academic_detail),
      body: Stack(children: [
        specializationData!.isNotEmpty ? Container() : Container(margin: EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
