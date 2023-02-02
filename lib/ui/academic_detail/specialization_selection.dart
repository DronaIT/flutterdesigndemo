import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SpecializationSelection extends StatefulWidget {
  const SpecializationSelection({Key? key}) : super(key: key);

  @override
  State<SpecializationSelection> createState() => _SpecializationSelectionState();
}

class _SpecializationSelectionState extends State<SpecializationSelection> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];

  final apiRepository = getIt.get<ApiRepository>();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    List<BaseApiResponseWithSerializable<SpecializationResponse>>? selectedData = [];
    selectedData = Get.arguments;

    setState(() {
      isVisible = true;
    });
    var data = await apiRepository.getSpecializationApi();
    if (data.records?.isNotEmpty == true) {
      PreferenceUtils.setSpecializationList(data);
      setState(() {
        specializationData = data.records;
        for (var i = 0; i < selectedData!.length; i++) {
          for (var j = 0; j < specializationData!.length; j++) {
            if (specializationData![j].fields!.specializationId == selectedData[i].fields!.specializationId) {
              specializationData![j].fields!.selected = true;
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_specializations),
      body: Stack(children: [
        specializationData?.isNotEmpty == true
            ? Column(children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: ListView.builder(
                        itemCount: specializationData?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.all(5),
                            child: GestureDetector(
                              child: Container(
                                color: colors_name.colorWhite,
                                padding: const EdgeInsets.all(12),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Expanded(child: Text("${specializationData![index].fields!.specializationName}", textAlign: TextAlign.start, style: blackTextSemiBold16)),
                                  if (specializationData![index].fields!.selected) const Icon(Icons.check, size: 20, color: colors_name.colorPrimary)
                                ]),
                              ),
                              onTap: () {
                                setState(() {
                                  specializationData![index].fields!.selected = !specializationData![index].fields!.selected;
                                });
                              },
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    List<BaseApiResponseWithSerializable<SpecializationResponse>>? selectedSpecializationData = [];
                    for (var i = 0; i < specializationData!.length; i++) {
                      if (specializationData![i].fields!.selected) {
                        selectedSpecializationData.add(specializationData![i]);
                      }
                    }
                    if (selectedSpecializationData.isNotEmpty) {
                      Get.back(result: selectedSpecializationData);
                    } else {
                      Utils.showSnackBar(context, strings_name.str_select_spelization);
                    }
                  },
                )
              ])
            : Container(margin: EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_specialization, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
