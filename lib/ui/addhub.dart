import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/request/add_hub_request.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/specialization_detail.dart';
import 'package:flutterdesigndemo/ui/specialization_selection.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class AddHub extends StatefulWidget {
  const AddHub({Key? key}) : super(key: key);

  @override
  State<AddHub> createState() => _AddHubState();
}

class _AddHubState extends State<AddHub> {
  TextEditingController hubController = TextEditingController();
  bool isVisible = false;
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];
  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  final apiRepository = getIt.get<ApiRepository>();

  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_add_hub),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 10.h),
                custom_text(
                  text: strings_name.str_hub_name,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: hubController,
                  topValue: 5,
                ),
                SizedBox(height: 3.h),
                custom_text(
                  text: strings_name.str_address,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  topValue: 5,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: addressController,
                  topValue: 2,
                ),
                SizedBox(height: 3.h),
                custom_text(
                  text: strings_name.str_city,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  topValue: 5,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: cityController,
                  topValue: 2,
                ),
                SizedBox(height: 5.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      custom_text(
                        text: strings_name.str_specializations,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                      ),
                      GestureDetector(
                        child: custom_text(
                          text: specializationData?.isEmpty == true ? strings_name.str_add : strings_name.str_update,
                          alignment: Alignment.topLeft,
                          textStyles: primaryTextSemiBold16,
                        ),
                        onTap: () {
                          Get.to(const SpecializationSelection(), arguments: specializationData)?.then((result) {
                            if (result != null) {
                              setState(() {
                                specializationData = result;
                              });
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                specializationData!.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: specializationData?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 5,
                                child: GestureDetector(
                                  child: Container(
                                    color: colors_name.colorWhite,
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [Text("${specializationData![index].fields!.specializationName}", textAlign: TextAlign.center, style: blackText16), const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(const SpecializationDetail(), arguments: specializationData![index].fields?.id);
                                  },
                                ),
                              );
                            }))
                    : Container(),
                SizedBox(height: 20.h),
                CustomButton(
                    text: strings_name.str_submit,
                    click: () {
                      if (hubController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_hubname);
                      } else if (addressController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_address);
                      } else if (cityController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_city);
                      } else if (specializationData!.isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_select_spelization);
                      } else {
                        addRecord();
                      }
                    })
              ],
            ),
            Center(
              child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addRecord() async {
    setState(() {
      isVisible = true;
    });
    AddHubRequest request = AddHubRequest();
    request.hub_name = hubController.text.toString();
    request.city = cityController.text.toString();
    request.address = addressController.text.toString();

    List<String> selectedSpecializationData = [];
    for (var i = 0; i < specializationData!.length; i++) {
      selectedSpecializationData.add(specializationData![i].id.toString());
    }
    request.tBLSPECIALIZATION = selectedSpecializationData;

    var resp = await apiRepository.addHubApi(request);
    if (resp.id!.isNotEmpty) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBar(context, strings_name.str_hub_added);
      await Future.delayed(const Duration(milliseconds: 2000));
      Get.back(closeOverlays: true, result: true);
    } else {
      setState(() {
        isVisible = false;
      });
    }
  }
}
