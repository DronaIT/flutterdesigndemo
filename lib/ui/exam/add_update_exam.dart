import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/semester_data.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/semester_selection.dart';
import 'package:flutterdesigndemo/ui/academic_detail/specialization_selection_from_hubs.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddUpdateExam extends StatefulWidget {
  const AddUpdateExam({super.key});

  @override
  State<AddUpdateExam> createState() => _AddUpdateExamState();
}

class _AddUpdateExamState extends State<AddUpdateExam> {
  bool isVisible = false, fromEdit = false;
  final apiRepository = getIt.get<ApiRepository>();

  TextEditingController examTitleController = TextEditingController();
  TextEditingController tentativeDateController = TextEditingController();

  List<String> examTypeArr = <String>[
    strings_name.str_select_category,
    strings_name.str_exam_type_cie,
    strings_name.str_exam_type_final,
    strings_name.str_exam_type_supplementry,
  ];
  String examTypeValue = strings_name.str_select_category;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];
  List<BaseApiResponseWithSerializable<HubResponse>>? hubsData = [];
  List<SemesterData>? semesterData = [];

  @override
  void initState() {
    super.initState();
    hubResponseArray = PreferenceUtils.getHubList().records;
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      if ((loginData.accessible_hub_ids?.length ?? 0) > 0) {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          var isAccessible = false;
          for (var j = 0; j < loginData.accessible_hub_ids!.length; j++) {
            if (loginData.accessible_hub_ids![j] == hubResponseArray![i].id) {
              isAccessible = true;
              break;
            }
            if (loginData.hubIdFromHubIds?.first == hubResponseArray![i].fields?.hubId) {
              isAccessible = true;
              break;
            }
          }
          if (!isAccessible) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      } else {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          if (loginData.hubIdFromHubIds?.first != hubResponseArray![i].fields?.hubId) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_exam_schedule),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                const custom_text(
                  text: "${strings_name.str_exam_title}*",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: examTitleController,
                  topValue: 0,
                ),
                const custom_text(
                  text: strings_name.str_exam_type,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  bottomValue: 0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<String>(
                          elevation: 16,
                          value: examTypeValue,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              examTypeValue = newValue!;
                            });
                          },
                          items: examTypeArr.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const custom_text(
                  text: strings_name.str_select_hub_r,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  bottomValue: 0,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  width: viewWidth,
                  child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                    value: hubResponse,
                    isExpanded: true,
                    elevation: 16,
                    style: blackText16,
                    focusColor: Colors.white,
                    onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                      setState(() {
                        hubValue = newValue!.fields!.id!.toString();
                        hubResponse = newValue;

                        specializationData?.clear();
                        specializationData = [];
                        setState(() {});
                      });
                    },
                    items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
                      return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                        value: value,
                        child: Text(value.fields!.hubName!.toString()),
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const custom_text(
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
                        if (hubValue.isNotEmpty) {
                          Get.to(const SpecializationSelectionFromHubs(), arguments: [
                            {"selectedData": specializationData},
                            {"hubData": hubResponse},
                          ])?.then((result) {
                            if (result != null) {
                              setState(() {
                                specializationData = result;
                              });
                            }
                          });
                        } else {
                          Utils.showSnackBar(context, strings_name.str_empty_hub);
                        }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const custom_text(
                      text: strings_name.str_semester,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    GestureDetector(
                      child: custom_text(
                        text: semesterData?.isEmpty == true ? strings_name.str_add : strings_name.str_update,
                        alignment: Alignment.topLeft,
                        textStyles: primaryTextSemiBold16,
                      ),
                      onTap: () {
                        Get.to(const SemesterSelection(), arguments: semesterData)?.then((result) {
                          if (result != null) {
                            setState(() {
                              semesterData = result;
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
                semesterData!.isNotEmpty
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: semesterData?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            child: Container(
                              color: colors_name.colorWhite,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text("Semester ${semesterData![index].semester}", textAlign: TextAlign.start, style: blackText16)),
                                  const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                ],
                              ),
                            ),
                          );
                        })
                    : Container(),
                const custom_text(
                  text: strings_name.str_exam_tentative_date,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                InkWell(
                  child: IgnorePointer(
                    child: custom_edittext(
                      hintText: strings_name.str_select_dates,
                      type: TextInputType.none,
                      textInputAction: TextInputAction.next,
                      controller: tentativeDateController,
                      topValue: 0,
                    ),
                  ),
                  onTap: () {
                    showDatePicker(context: context, initialDate: tentativeDateController.text.isNotEmpty ? DateTime.parse(tentativeDateController.text) : DateTime.now(), firstDate: DateTime(2005), lastDate: DateTime.now()).then((pickedDate) {
                      if (pickedDate == null) {
                        return;
                      }
                      setState(() {
                        var formatter = DateFormat('yyyy-MM-dd');
                        tentativeDateController.text = formatter.format(pickedDate);
                      });
                    });
                  },
                ),
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
}
