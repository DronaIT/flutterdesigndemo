import 'package:dio/dio.dart';
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
import 'package:flutterdesigndemo/ui/academic_detail/specialization_detail.dart';
import 'package:flutterdesigndemo/ui/academic_detail/specialization_selection.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class UpdateHub extends StatefulWidget {
  const UpdateHub({Key? key}) : super(key: key);

  @override
  State<UpdateHub> createState() => _UpdateHubState();
}

class _UpdateHubState extends State<UpdateHub> {
  TextEditingController hubController = TextEditingController();
  bool isVisible = false;
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];

  final apiRepository = getIt.get<ApiRepository>();
  var id;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    var data = Get.arguments;

    hubController.text = data.fields!.hubName;
    addressController.text = data.fields!.address;
    cityController.text = data.fields!.city;
    id = data.id;

    setState(() {
      isVisible = true;
    });
    // var query = "SEARCH('${data.fields!.hubId}',${TableNames.CLM_HUB_IDS},0)";
    var query = "FIND('${Utils.getHubIds(data.id)}',${TableNames.CLM_HUB_IDS}, 0)";
    try{
      var speData = await apiRepository.getSpecializationDetailApi(query);
      if (speData.records?.isNotEmpty == true) {
        setState(() {
          specializationData = speData.records;
        });
      }
    }on DioError catch (e) {
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
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_update_hub),
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
                        child: Container(
                        margin: const EdgeInsets.all(10),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: specializationData?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 5,
                                child: GestureDetector(
                                  child: Container(
                                    color: colors_name.colorWhite,
                                    padding: const EdgeInsets.all(10),
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
                            }),
                      ))
                    : Container(),
                SizedBox(height: 20.h),
                CustomButton(
                    text: strings_name.str_submit,
                    click: () async {
                      if (hubController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_hubname);
                      } else if (addressController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_address);
                      } else if (cityController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_city);
/*
                      } else if (specializationData!.isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_select_spelization);
*/
                      } else {
                        List<String> selectedSpecializationData = [];
                        for (var i = 0; i < specializationData!.length; i++) {
                          selectedSpecializationData.add(specializationData![i].id.toString());
                        }

                        Map<String, dynamic> updateEmployee = {"hub_name": hubController.text.toString(), "city": cityController.text.toString(), "address": addressController.text.toString(), "TBL_SPECIALIZATION": selectedSpecializationData};
                        setState(() {
                          isVisible = true;
                        });
                        try{
                          var updatehub = await apiRepository.updateHubApi(updateEmployee, id);
                          if (updatehub != null) {
                            setState(() {
                              isVisible = false;
                            });
                            Utils.showSnackBar(context, strings_name.str_hub_update);
                            await Future.delayed(const Duration(milliseconds: 2000));
                            Get.back(closeOverlays: true, result: true);
                          } else {
                            setState(() {
                              isVisible = false;
                            });
                            Utils.showSnackBar(context, strings_name.str_something_wrong);
                          }
                        }on DioError catch (e) {
                          setState(() {
                            isVisible = false;
                          });
                          final errorMessage = DioExceptions.fromDioError(e).toString();
                          Utils.showSnackBarUsingGet(errorMessage);
                        }

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
    try{
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
    }on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }

  }
}
