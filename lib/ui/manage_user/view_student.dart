import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/manage_user/addsinglestudent.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:get/get.dart';

class ViewStudent extends StatefulWidget {
  const ViewStudent({Key? key}) : super(key: key);

  @override
  State<ViewStudent> createState() => _ViewStudentState();
}

class _ViewStudentState extends State<ViewStudent> {
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  List<int> semesterResponseArray = <int>[1, 2, 3, 4, 5, 6];
  int semesterValue = 1;

  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? viewStudent = [];

  bool canUpdateStudent = false;

  @override
  void initState() {
    super.initState();
    hubResponseArray = PreferenceUtils.getHubList().records;
    speResponseArray = PreferenceUtils.getSpecializationList().records;
    canUpdateStudent = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_students),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  custom_text(
                    text: strings_name.str_select_hub,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    bottomValue: 0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                      value: hubResponse,
                      elevation: 16,
                      style: blackText16,
                      focusColor: Colors.white,
                      onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                        setState(() {
                          hubValue = newValue!.fields!.id!.toString();
                          hubResponse = newValue;
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
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_select_spelization,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonFormField<BaseApiResponseWithSerializable<SpecializationResponse>>(
                      value: speResponse,
                      elevation: 16,
                      style: blackText16,
                      focusColor: Colors.white,
                      onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                        setState(() {
                          speValue = newValue!.fields!.id.toString();
                          speResponse = newValue;
                        });
                      },
                      items: speResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>((BaseApiResponseWithSerializable<SpecializationResponse> value) {
                        return DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>(
                          value: value,
                          child: Text(value.fields!.specializationName.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_semester,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButtonFormField<int>(
                      value: semesterValue,
                      elevation: 16,
                      style: blackText16,
                      focusColor: Colors.white,
                      onChanged: (int? newValue) {
                        setState(() {
                          semesterValue = newValue!;
                        });
                      },
                      items: semesterResponseArray.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text("Semester $value"),
                        );
                      }).toList(),
                    ),
                  ),
                  CustomButton(
                    click: () async {
                      if (hubValue.isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_hub);
                      } else if (speValue.isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_spe);
                      } else if (semesterValue == -1) {
                        Utils.showSnackBar(context, strings_name.str_empty_semester);
                      } else {
                        var query = "AND(${TableNames.CLM_HUB_IDS}='${hubValue}',${TableNames.CLM_SPE_IDS}='${speValue}',${TableNames.CLM_SEMESTER}='${semesterValue.toString()}')";
                        setState(() {
                          isVisible = true;
                        });
                        var data = await apiRepository.loginApi(query);
                        if (data.records!.isNotEmpty) {
                          setState(() {
                            isVisible = false;
                            viewStudent?.clear();
                            viewStudent = data.records;
                          });
                        } else {
                          setState(() {
                            isVisible = false;
                            viewStudent = [];
                          });
                        }
                      }
                    },
                    text: strings_name.str_submit,
                  ),
                  SizedBox(height: 3.h),
                  Visibility(
                      visible: viewStudent?.isNotEmpty == true,
                      child: custom_text(
                        text: "Total Students : ${viewStudent!.length}",
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
                      )),
                  viewStudent!.length > 0
                      ? ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: viewStudent?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 5,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Column(
                                      children: [
                                        custom_text(text: "${viewStudent![index].fields!.name!} (${viewStudent![index].fields!.enrollmentNumber!})", textStyles: blackTextSemiBold16, topValue: 10, maxLines: 2),
                                        Visibility(visible: viewStudent![index].fields!.email != null, child: custom_text(text: viewStudent![index].fields!.email != null ? viewStudent![index].fields!.email! : "", textStyles: blackTextSemiBold14, bottomValue: 5, topValue: 0)),
                                        custom_text(text: viewStudent![index].fields!.mobileNumber!, textStyles: blackTextSemiBold14, bottomValue: 10, topValue: 0)
                                      ],
                                    ),
                                  ),
                                  canUpdateStudent
                                      ? GestureDetector(
                                          onTap: () async {
                                            var response = await Get.to(const AddSingleStudent(), arguments: viewStudent![index].fields?.mobileNumber);
                                            if (response) {
                                              var query = "AND(${TableNames.CLM_HUB_IDS}='${hubValue}',${TableNames.CLM_SPE_IDS}='${speValue}')";
                                              setState(() {
                                                isVisible = true;
                                              });
                                              var data = await apiRepository.loginApi(query);
                                              if (data.records!.isNotEmpty) {
                                                setState(() {
                                                  isVisible = false;
                                                  viewStudent = data.records;
                                                });
                                              } else {
                                                setState(() {
                                                  isVisible = false;
                                                  viewStudent = [];
                                                });
                                              }
                                            }
                                          },
                                          child: Container(margin: EdgeInsets.all(10), child: Icon(Icons.edit)))
                                      : Container()
                                ],
                              ),
                            );
                          })
                      : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
                ],
              ),
            ),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}