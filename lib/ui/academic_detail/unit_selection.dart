import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
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
  List<BaseApiResponseWithSerializable<UnitsResponse>>? mainData = [];

  final apiRepository = getIt.get<ApiRepository>();
  var controllerSearch = TextEditingController();

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
        data.records?.sort((a, b) => a.fields!.unitTitle!.toLowerCase().compareTo(b.fields!.unitTitle!.toLowerCase()));
        mainData = data.records;

        for (var i = 0; i < selectedData!.length; i++) {
          for (var j = 0; j < mainData!.length; j++) {
            if (mainData![j].fields!.unitId == selectedData[i].fields!.unitId) {
              mainData![j].fields!.selected = true;
              break;
            }
          }
        }

        unitsData = List.from(mainData!);
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
        mainData?.isNotEmpty == true
            ? Column(children: [
                SizedBox(height: 10.h),
                CustomEditTextSearch(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: controllerSearch,
                  onChanges: (value) {
                    if (value.isEmpty) {
                      unitsData = [];
                      unitsData = List.from(mainData!);
                      setState(() {});
                    } else {
                      unitsData = [];
                      for (var i = 0; i < mainData!.length; i++) {
                        if (mainData![i].fields!.unitTitle!.toLowerCase().contains(value.toLowerCase())) {
                          unitsData?.add(mainData![i]);
                        }
                      }
                      setState(() {});
                    }
                  },
                ),
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
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(child: Text("${unitsData![index].fields!.unitTitle}", textAlign: TextAlign.start, style: blackTextSemiBold16)),
                                if (unitsData![index].fields!.selected) const Icon(Icons.check, size: 20, color: colors_name.colorPrimary)
                              ]),
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
