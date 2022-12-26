import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/models/units_response.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UnitSelection extends StatefulWidget {
  const UnitSelection({Key? key}) : super(key: key);

  @override
  State<UnitSelection> createState() => _UnitSelectionState();
}

class _UnitSelectionState extends State<UnitSelection> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<UnitsResponse>>? unitsData = [];

  final apiRepository = getIt.get<ApiRepository>();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    List<BaseApiResponseWithSerializable<UnitsResponse>>? selectedData = [];
    selectedData = Get.arguments;

    setState(() {
      isVisible = true;
    });
    var data = await apiRepository.getUnitsApi("");
    if (data.records?.isNotEmpty == true) {
      setState(() {
        unitsData = data.records;
        for (var i = 0; i < selectedData!.length; i++) {
          for (var j = 0; j < unitsData!.length; j++) {
            if (unitsData![j].fields!.unitId == selectedData[i].fields!.unitId) {
              unitsData![j].fields!.selected = true;
              break;
            }
          }
        }
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_units),
      body: Stack(children: [
        unitsData?.isNotEmpty == true
            ? Column(children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: unitsData?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.all(5),
                          child: GestureDetector(
                            child: Container(
                              color: colors_name.colorWhite,
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [Text("${unitsData![index].fields!.unitTitle}", textAlign: TextAlign.center, style: blackTextSemiBold16), if (unitsData![index].fields!.selected) Icon(Icons.check, size: 20, color: colors_name.colorPrimary)]),
                            ),
                            onTap: () {
                              setState(() {
                                unitsData![index].fields!.selected = !unitsData![index].fields!.selected;
                              });
                            },
                          ),
                        );
                      }),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    List<BaseApiResponseWithSerializable<UnitsResponse>>? selectedUnitsData = [];
                    for (var i = 0; i < unitsData!.length; i++) {
                      if (unitsData![i].fields!.selected) {
                        selectedUnitsData.add(unitsData![i]);
                      }
                    }
                    if (selectedUnitsData.isNotEmpty) {
                      Get.back(result: selectedUnitsData);
                    } else {
                      Utils.showSnackBar(context, strings_name.str_select_units);
                    }
                  },
                )
              ])
            : Container(margin: EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_units, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
