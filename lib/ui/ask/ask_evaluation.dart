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
import 'package:flutterdesigndemo/models/ask_parameter_response.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/parameter_selection.dart';
import 'package:flutterdesigndemo/models/request/evaluation_request.dart';
import 'package:flutterdesigndemo/models/student_response.dart';
import 'package:flutterdesigndemo/ui/manage_user/single_student_selection_local.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class ASKEvaluation extends StatefulWidget {
  const ASKEvaluation({super.key});

  @override
  State<ASKEvaluation> createState() => _ASKEvaluationState();
}

class _ASKEvaluationState extends State<ASKEvaluation> {
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  List<StudentResponse>? selectedStudentResponse = [];

  BaseApiResponseWithSerializable<ASKLevelResponse>? askLevelResponse;
  String askLevelValue = "";
  List<BaseApiResponseWithSerializable<ASKLevelResponse>>? askLevelList = [];

  List<TextEditingController>? paramValueController = [];
  List<BaseApiResponseWithSerializable<ASKParameterResponse>>? parameterList = [];

  String offset = "";

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
    }
  }

  @override
  void initState() {
    super.initState();
    getAskLevels();
  }

  getAskParameterData() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });
    var query = "AND(ask_code='${askLevelResponse?.fields?.askCode ?? ''}', is_active=1";
    if (selectedStudentResponse != null && selectedStudentResponse?.isNotEmpty == true) {
      query += ",FIND(\"${selectedStudentResponse![0].studentHubIds}\", ARRAYJOIN({hub_id (from hub_ids)}))";
      query += ",FIND(\"${selectedStudentResponse![0].studentSpecializationIds}\", ARRAYJOIN({specialization_id (from specialization_ids)}))";
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getAskParametersApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          parameterList?.clear();
        }
        parameterList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<ASKParameterResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getAskLevels();
        } else {
          parameterList?.sort((a, b) {
            var adate = a.fields?.parameterTitle?.trim();
            var bdate = b.fields?.parameterTitle?.trim();
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
            parameterList = [];
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
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_new_evaluation),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(children: [
                  SizedBox(height: 10.h),
                  GestureDetector(
                    child: Card(
                      elevation: 5,
                      color: colors_name.colorWhite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          custom_text(
                            text: selectedStudentResponse != null && selectedStudentResponse?.isNotEmpty == true ? strings_name.str_selected_student : strings_name.str_select_student,
                            alignment: Alignment.topLeft,
                            textStyles: blackTextSemiBold16,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Icon(selectedStudentResponse != null && selectedStudentResponse?.isNotEmpty == true ? Icons.edit : Icons.arrow_forward_ios_rounded, size: 22, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Get.to(const SingleStudentSelectionLocal(), arguments: selectedStudentResponse)?.then((result) {
                        if (result != null) {
                          selectedStudentResponse = result;
                          setState(() {});
                        }
                      });
                    },
                  ),
                  selectedStudentResponse != null && selectedStudentResponse?.isNotEmpty == true
                      ? Card(
                          elevation: 1,
                          child: Column(
                            children: [
                              GestureDetector(
                                child: custom_text(
                                  text: "${selectedStudentResponse![0].studentName}",
                                  textAlign: TextAlign.start,
                                  textStyles: linkTextSemiBold14,
                                  topValue: 5,
                                  bottomValue: 5,
                                ),
                                onTap: () {
                                  Get.to(const StudentHistory(), arguments: selectedStudentResponse![0].studentMobileNumber);
                                },
                              ),
                              custom_text(
                                text: "${Utils.getHubName(selectedStudentResponse![0].studentHubIds)}",
                                textAlign: TextAlign.start,
                                textStyles: blackText14,
                                topValue: 0,
                                maxLines: 2,
                                bottomValue: 5,
                              ),
                              custom_text(
                                text: "${Utils.getSpecializationNameFromId(selectedStudentResponse![0].studentSpecializationIds)}",
                                textAlign: TextAlign.start,
                                textStyles: blackText14,
                                topValue: 0,
                                maxLines: 2,
                                bottomValue: 5,
                              ),
                              custom_text(
                                text: "Semester: ${selectedStudentResponse![0].studentSemester}",
                                textAlign: TextAlign.start,
                                textStyles: blackText14,
                                topValue: 0,
                                bottomValue: 5,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(height: 10.h),
                  if (selectedStudentResponse != null && selectedStudentResponse?.isNotEmpty == true)
                    Column(
                      children: [
                        const custom_text(
                          text: strings_name.str_select_ask_level_for_evaluation,
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                          topValue: 0,
                          bottomValue: 0,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 0),
                          width: viewWidth,
                          child: DropdownButtonFormField<BaseApiResponseWithSerializable<ASKLevelResponse>>(
                            value: askLevelResponse,
                            elevation: 16,
                            style: blackText16,
                            focusColor: Colors.white,
                            onChanged: (BaseApiResponseWithSerializable<ASKLevelResponse>? newValue) {
                              askLevelValue = newValue!.fields!.askCode.toString();
                              askLevelResponse = newValue;

                              getAskParameterData();
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
                        parameterList?.isNotEmpty == true
                            ? Column(children: [
                                ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: parameterList?.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    paramValueController?.add(TextEditingController());
                                    return Column(
                                      children: [
                                        custom_text(
                                          text: "${parameterList![index].fields?.parameterTitle}*",
                                          alignment: Alignment.topLeft,
                                          textStyles: blackTextSemiBold16,
                                        ),
                                        parameterList![index].fields?.parameterType == strings_name.str_ask_param_type_normal
                                            ? custom_edittext(
                                                type: TextInputType.text,
                                                hintText: (parameterList![index].fields?.parameterTotalValue ?? 0) > 0 ? "Max value ${parameterList![index].fields?.parameterTotalValue}" : "",
                                                textInputAction: TextInputAction.next,
                                                controller: paramValueController![index],
                                                topValue: 0,
                                              )
                                            : const custom_text(
                                                text: strings_name.str_ask_param_type_other_msg,
                                                alignment: Alignment.topLeft,
                                                textStyles: blackText16,
                                                maxLines: 3,
                                                topValue: 0,
                                                bottomValue: 5,
                                              ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 10.h),
                                CustomButton(
                                  text: strings_name.str_submit,
                                  click: () {
                                    var paramCheckAlert = "";
                                    var valuesToSend = 0;
                                    if (parameterList?.isNotEmpty == true) {
                                      for (int i = 0; i < (parameterList?.length ?? 0); i++) {
                                        if (parameterList![i].fields?.parameterType == strings_name.str_ask_param_type_normal) {
                                          valuesToSend += 1;
                                          if (paramValueController![i].text.toString().isEmpty == true) {
                                            paramCheckAlert = "Please enter value for ${parameterList![i].fields!.parameterTitle}";
                                            break;
                                          }
                                          if (parameterList![i].fields!.parameterTotalValue != null) {
                                            if (int.tryParse(paramValueController![i].text.toString()) != null) {
                                              if ((parameterList![i].fields!.parameterTotalValue ?? 0) < (int.tryParse(paramValueController![i].text.toString()) ?? 0)) {
                                                paramCheckAlert = "Please enter valid value for ${parameterList![i].fields!.parameterTitle}";
                                                break;
                                              }
                                            } else {
                                              paramCheckAlert = "Please enter valid value for ${parameterList![i].fields!.parameterTitle}";
                                              break;
                                            }
                                          }
                                        }
                                      }
                                    }

                                    if (selectedStudentResponse?.isNotEmpty == false) {
                                      Utils.showSnackBar(context, strings_name.str_empty_select_student);
                                    } else if (askLevelValue.isEmpty) {
                                      Utils.showSnackBar(context, strings_name.str_empty_ask_level);
                                    } else if (valuesToSend > 0 && paramCheckAlert.isNotEmpty) {
                                      Utils.showSnackBar(context, paramCheckAlert);
                                    } else if (valuesToSend == 0) {
                                      Utils.showSnackBar(context, strings_name.str_ask_param_type_other_msg);
                                    } else {
                                      submitData();
                                    }
                                  },
                                ),
                              ])
                            : custom_text(
                                text: strings_name.str_no_parameter_linked,
                                textStyles: blackTextSemiBold14,
                                maxLines: 2,
                              ),
                      ],
                    )
                  else
                    Container(),
                ]),
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
      ),
    );
  }

  submitData() async {
    setState(() {
      isVisible = true;
    });

    EvaluationRequest request = EvaluationRequest();
    request.student = selectedStudentResponse![0].studentId?.split(",");
    request.semesterWhenAdded = selectedStudentResponse![0].studentSemester;
    request.askLevel = askLevelResponse?.id?.split(",");
    request.askAddedBy = PreferenceUtils.getLoginRecordId().split(",");

    List<String> params = [];
    List<String> paramsValue = [];
    int totalMarks = 0;
    for (int i = 0; i < (parameterList?.length ?? 0); i++) {
      if (parameterList![i].fields?.parameterType == strings_name.str_ask_param_type_normal) {
        params.add(parameterList![i].id ?? '');
        paramsValue.add(paramValueController![i].text.toString());

        totalMarks += int.tryParse(paramValueController![i].text.trim().toString()) ?? 0;
      }
    }
    request.askParameters = params;
    request.parameterMarksReceived = paramsValue;
    request.askTotalMarksReceived = totalMarks;

    try {
      var resp = await apiRepository.addAskEvaluationApi(request);
      if (resp.id != null) {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_new_evaluation_added);
        await Future.delayed(const Duration(milliseconds: 2000));
        Get.back(closeOverlays: true, result: true);
      } else {
        setState(() {
          isVisible = false;
        });
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
