import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/ask_level_response.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/request/ask_parameter_request.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/specialization_selection.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../academic_detail/hub_selection.dart';

class AddAskParameters extends StatefulWidget {
  const AddAskParameters({super.key});

  @override
  State<AddAskParameters> createState() => _AddAskParametersState();
}

class _AddAskParametersState extends State<AddAskParameters> {
  bool isVisible = false, fromEdit = false;
  final apiRepository = getIt.get<ApiRepository>();

  TextEditingController askTitleController = TextEditingController();
  TextEditingController askDescController = TextEditingController();
  TextEditingController askTotalMarksController = TextEditingController();

  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];
  List<BaseApiResponseWithSerializable<HubResponse>>? hubsData = [];

  BaseApiResponseWithSerializable<ASKLevelResponse>? askLevelResponse;
  String askLevelValue = "";
  List<BaseApiResponseWithSerializable<ASKLevelResponse>>? askLevelList = [];

  String offset = "";
  String askParameterId = "";

  getAskLevels() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });
    var query = "AND()";
    debugPrint(query);

    try {
      var data = await apiRepository.getAskLevelsApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          askLevelList?.clear();
        }
        askLevelList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<ASKLevelResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getAskLevels();
        } else {
          askLevelList?.sort((a, b) {
            var adate = a.fields?.askLevelTitle?.trim();
            var bdate = b.fields?.askLevelTitle?.trim();
            return adate!.compareTo(bdate!);
          });

          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            askLevelList = [];
          }
        });
        offset = "";
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    } finally {
      if (Get.arguments != null) {
        fromEdit = true;
        getAskParameterData();
      }
    }
  }

  getAskParameterData() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });
    var query = "AND(ask_parameter_code='${Get.arguments}')";
    debugPrint(query);

    try {
      var data = await apiRepository.getAskParametersApi(query, offset);
      if (data.records!.isNotEmpty) {
        askTitleController.text = data.records![0].fields?.parameterTitle ?? "";
        askDescController.text = data.records![0].fields?.parameterDescription ?? "";
        askTotalMarksController.text = '${data.records![0].fields?.parameterTotalValue ?? 0}';
        askLevelValue = data.records![0].fields?.askCode?.last ?? "";

        for (int i = 0; i < (askLevelList?.length ?? 0); i++) {
          if (askLevelList![i].fields?.askCode == askLevelValue) {
            askLevelResponse = askLevelList![i];
            break;
          }
        }

        hubsData?.clear();
        hubsData = [];
        List<BaseApiResponseWithSerializable<HubResponse>>? hubListData = PreferenceUtils.getHubList().records;

        for (var i = 0; i < (data.records![0].fields?.hubIdFromHubIds?.length ?? 0); i++) {
          for (var j = 0; j < (hubListData?.length ?? 0); j++) {
            if (data.records![0].fields?.hubIdFromHubIds![i] == hubListData![j].fields!.hubId) {
              hubsData?.add(hubListData[j]);
              break;
            }
          }
        }

        specializationData?.clear();
        specializationData = [];
        List<BaseApiResponseWithSerializable<SpecializationResponse>>? speListData = PreferenceUtils.getSpecializationList().records;

        for (var i = 0; i < (data.records![0].fields?.specializationIdFromSpecializationIds?.length ?? 0); i++) {
          for (var j = 0; j < (speListData?.length ?? 0); j++) {
            if (data.records![0].fields?.specializationIdFromSpecializationIds![i] == speListData![j].fields!.specializationId) {
              specializationData?.add(speListData[j]);
              break;
            }
          }
        }

        askParameterId = data.records![0].id ?? "";
      }
      setState(() {
        isVisible = false;
      });
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  @override
  void initState() {
    super.initState();
    getAskLevels();
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_ask_parameters),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                const custom_text(
                  text: "${strings_name.str_ask_parameter_title}*",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: askTitleController,
                  topValue: 0,
                ),
                SizedBox(height: 5.h),
                const custom_text(
                  text: "${strings_name.str_ask_parameter_desc}*",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: askDescController,
                  minLines: 3,
                  maxLines: 3,
                  maxLength: 50000,
                  topValue: 0,
                ),
                SizedBox(height: 5.h),
                const custom_text(
                  text: strings_name.str_select_ask_level,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  topValue: 0,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  width: viewWidth,
                  child: DropdownButtonFormField<BaseApiResponseWithSerializable<ASKLevelResponse>>(
                    value: askLevelResponse,
                    elevation: 16,
                    style: blackText16,
                    focusColor: Colors.white,
                    onChanged: (BaseApiResponseWithSerializable<ASKLevelResponse>? newValue) {
                      askLevelValue = newValue!.fields!.askCode.toString();
                      askLevelResponse = newValue;

                      setState(() {});
                    },
                    items: askLevelList?.map<DropdownMenuItem<BaseApiResponseWithSerializable<ASKLevelResponse>>>((BaseApiResponseWithSerializable<ASKLevelResponse> value) {
                      return DropdownMenuItem<BaseApiResponseWithSerializable<ASKLevelResponse>>(
                        value: value,
                        child: Text(value.fields!.askLevelTitle.toString()),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 5.h),
                const custom_text(
                  text: "${strings_name.str_ask_parameter_total_marks}*",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: askTotalMarksController,
                  topValue: 5,
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const custom_text(
                      text: strings_name.str_select_hub_r,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    GestureDetector(
                      child: custom_text(
                        text: hubsData?.isEmpty == true ? strings_name.str_add : strings_name.str_update,
                        alignment: Alignment.topLeft,
                        textStyles: primaryTextSemiBold16,
                      ),
                      onTap: () {
                        Get.to(const HubSelection(), arguments: hubsData)?.then((result) {
                          if (result != null) {
                            setState(() {
                              hubsData = result;
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
                hubsData!.isNotEmpty
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: hubsData?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            child: GestureDetector(
                              child: Container(
                                color: colors_name.colorWhite,
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text("${hubsData![index].fields!.hubName}", textAlign: TextAlign.start, style: blackText16)),
                                    const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                  ],
                                ),
                              ),
                              onTap: () {
                                // Get.to(const (), arguments: unitsData![index].fields?.ids);
                              },
                            ),
                          );
                        })
                    : Container(),
                SizedBox(height: 5.h),
                Row(
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
                specializationData!.isNotEmpty
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: specializationData?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            child: Container(
                              color: colors_name.colorWhite,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text("${specializationData![index].fields!.specializationName}", textAlign: TextAlign.start, style: blackText16)),
                                  const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                ],
                              ),
                            ),
                          );
                        })
                    : Container(),
                SizedBox(height: 10.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    if (askTitleController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_ask_parameter_title);
                    } else if (askDescController.text.toString().trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_ask_parameter_desc);
                    } else if (askLevelValue.isEmpty == true) {
                      Utils.showSnackBar(context, strings_name.str_empty_ask_level);
                    } else if (askTotalMarksController.text.toString().trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_ask_parameter_total_marks);
                    } else if (int.tryParse(askTotalMarksController.text.toString().trim()) == null) {
                      Utils.showSnackBar(context, strings_name.str_invalid_ask_parameter_total_marks);
                    } else if (hubsData?.isEmpty == true) {
                      Utils.showSnackBar(context, strings_name.str_empty_hub_data);
                    } else {
                      submitData();
                    }
                  },
                )
              ],
            ),
          ),
          Visibility(
            visible: isVisible,
            child: Container(
              color: colors_name.colorWhite,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary),
              ),
            ),
          )
        ],
      ),
    ));
  }

  submitData() async {
    setState(() {
      isVisible = true;
    });

    ASKParameterRequest request = ASKParameterRequest();
    request.parameterTitle = askTitleController.text.trim().toString();
    request.parameterDescription = askDescController.text.trim().toString();
    request.parameterTotalValue = int.parse(askTotalMarksController.text.trim().toString()) ?? 0;
    request.askLevel = askLevelResponse?.id?.split(",");
    List<String>? hubReqData = [];
    for (int i = 0; i < (hubsData?.length ?? 0); i++) {
      hubReqData.add(hubsData![i].id.toString());
    }
    List<String>? speReqData = [];
    for (int i = 0; i < (specializationData?.length ?? 0); i++) {
      speReqData.add(specializationData![i].id.toString());
    }
    request.hubIds = hubReqData;
    request.specializationIds = speReqData;

    try {
      if (fromEdit && askParameterId.isNotEmpty) {
        var resp = await apiRepository.updateAskParametersApi(request.toJson(), askParameterId);
        if (resp.id != null) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_ask_parameter_updated);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(closeOverlays: true, result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      } else {
        var resp = await apiRepository.addAskParametersApi(request);
        if (resp.id != null) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_ask_parameter_added);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(closeOverlays: true, result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }
}
