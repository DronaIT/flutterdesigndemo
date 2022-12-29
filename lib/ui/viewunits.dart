import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/units_response.dart';
import 'package:flutterdesigndemo/ui/add_units.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class ViewUnits extends StatefulWidget {
  const ViewUnits({Key? key}) : super(key: key);

  @override
  State<ViewUnits> createState() => _ViewUnitsState();
}

class _ViewUnitsState extends State<ViewUnits> {
  bool isVisible = false;

  BaseLoginResponse<UnitsResponse> unitData = BaseLoginResponse();
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
    unitData = await apiRepository.getUnitsApi("");
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_unit),
      body: Stack(
        children: [
          Column(
            children: [
              unitData.records?.isNotEmpty == true
                  ? Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: unitData.records?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              custom_text(text: "${unitData.records![index].fields!.unitTitle}", textStyles: blackTextSemiBold16, topValue: 10, maxLines: 2),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(const AddUnits(), arguments: unitData.records?[index].fields?.ids)?.then((result) {
                                      if (result != null && result) {
                                        initialization();
                                      }
                                    });
                                  },
                                  child: Container(alignment: Alignment.centerRight, margin: const EdgeInsets.all(10), child: const Icon(Icons.edit))),
                            ],
                          ),
                        );
                      }),
                ),
              )
                  : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_subjects, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                      text: strings_name.str_add_units,
                      click: () async {
                        Get.to(const AddUnits())?.then((result) {
                          if (result != null && result) {
                            initialization();
                          }
                        });
                      })),
            ],
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
