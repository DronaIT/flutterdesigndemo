import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class HubSelection extends StatefulWidget {
  const HubSelection({Key? key}) : super(key: key);

  @override
  State<HubSelection> createState() => _HubSelectionState();
}

class _HubSelectionState extends State<HubSelection> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<HubResponse>>? hubData = [];

  final apiRepository = getIt.get<ApiRepository>();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    List<BaseApiResponseWithSerializable<HubResponse>>? selectedData = [];
    selectedData = Get.arguments;

    setState(() {
      isVisible = true;
    });

    try {
      var data = await apiRepository.getHubApi();
      if (data.records?.isNotEmpty == true) {
        hubData = data.records;
        for (var i = 0; i < selectedData!.length; i++) {
          for (var j = 0; j < hubData!.length; j++) {
            if (hubData![j].fields!.hubId == selectedData[i].fields!.hubId) {
              hubData![j].fields!.selected = true;
              break;
            }
          }
        }
        hubData?.sort((a, b) => a.fields!.hubName!.trim().compareTo(b.fields!.hubName!.trim()));
        setState(() {});
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }

    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_accessible_hub),
      body: Stack(children: [
        hubData?.isNotEmpty == true
            ? Column(children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: hubData?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(5),
                          child: GestureDetector(
                            child: Container(
                              color: colors_name.colorWhite,
                              padding: const EdgeInsets.all(15),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Expanded(child: Text("${hubData![index].fields!.hubName}", textAlign: TextAlign.start, style: blackTextSemiBold16)),
                                if (hubData![index].fields!.selected) const Icon(Icons.check, size: 20, color: colors_name.colorPrimary)
                              ]),
                            ),
                            onTap: () {
                              setState(() {
                                hubData![index].fields!.selected = !hubData![index].fields!.selected;
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
                    List<BaseApiResponseWithSerializable<HubResponse>>? selectedHubsData = [];
                    for (var i = 0; i < hubData!.length; i++) {
                      if (hubData![i].fields!.selected) {
                        selectedHubsData.add(hubData![i]);
                      }
                    }
                    Get.back(result: selectedHubsData);
                  },
                )
              ])
            : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_hub, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
