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
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/company_detail_response.dart';
import 'package:flutterdesigndemo/models/request/add_placement_marks_request.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class AddPlacementMarks extends StatefulWidget {
  const AddPlacementMarks({super.key});

  @override
  State<AddPlacementMarks> createState() => _AddPlacementMarksState();
}

class _AddPlacementMarksState extends State<AddPlacementMarks> {
  bool isVisible = false;

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";

  String companyCode = "", companyId = "";
  List<BaseApiResponseWithSerializable<CompanyDetailResponse>>? companyDetailData = [];

  List<String>? studentIds = [];
  List<String>? studentNames = [];
  List<String>? studentNumbers = [];

  String selectedStudent = "";

  List<String> marksList = <String>[
    strings_name.str_select_marks,
    strings_name.str_marks_0,
    strings_name.str_marks_1,
    strings_name.str_marks_2,
    strings_name.str_marks_3,
    strings_name.str_marks_4,
    strings_name.str_marks_5
  ];
  String punctualityMarks = strings_name.str_select_marks;
  String groomingMarks = strings_name.str_select_marks;
  String attitudeMarks = strings_name.str_select_marks;
  String improvementsMarks = strings_name.str_select_marks;
  String overallMarks = strings_name.str_select_marks;

  TextEditingController feedbackController = TextEditingController();

  bool isMarksAddedOnce = false;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      if (Get.arguments[0]["companyCode"] != null) {
        companyCode = Get.arguments[0]["companyCode"];
      }
      if (Get.arguments[1]["companyId"] != null) {
        companyId = Get.arguments[1]["companyId"];
      }
    }

    if (mounted && companyCode.isNotEmpty) {
      fetchStudents();
    }
  }

  fetchStudents() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "FIND('$companyCode', ${TableNames.CLM_COMPANY_CODE}, 0)";
    try {
      var data = await apiRepository.getCompanyDetailApi(query);
      if (data.records?.isNotEmpty == true) {
        companyDetailData = data.records;

        if (companyDetailData?.isNotEmpty == true && companyDetailData![0].fields?.placed_students_is_placed_now?.isNotEmpty == true) {
          studentNames?.add(strings_name.str_select_student);

          for (int i = 0; i < companyDetailData![0].fields!.placed_students_is_placed_now!.length; i++) {
            if (companyDetailData![0].fields!.placed_students_is_placed_now![i] == "1") {
              if (studentNames?.contains(companyDetailData![0].fields!.placed_student_name![i]) == false) {
                studentIds?.add(companyDetailData![0].fields!.placed_students![i]);
                studentNames?.add(companyDetailData![0].fields!.placed_student_name![i]);
                studentNumbers?.add(companyDetailData![0].fields!.placed_student_mobile_number![i]);
              }
            }
          }
        }
      }

      if (studentNames?.isNotEmpty == true) {
        selectedStudent = studentNames!.first;
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
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: AppWidgets.appBarWithoutBack(strings_name.str_add_placement_marks),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      custom_text(
                        text: strings_name.str_add_placement_marks_desc,
                        alignment: Alignment.topLeft,
                        textStyles: primaryTextSemiBold15,
                        topValue: 10.h,
                        maxLines: 5000,
                        bottomValue: 0,
                      ),
                      custom_text(
                        text: "${strings_name.str_select_student}*",
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 10.h,
                        bottomValue: 0,
                      ),
                      studentNames?.isNotEmpty == true
                          ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                                    width: viewWidth,
                                    child: DropdownButtonFormField<String>(
                                      elevation: 16,
                                      value: selectedStudent,
                                      style: blackText15,
                                      focusColor: Colors.white,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedStudent = newValue!;
                                        });
                                        checkMarks();
                                      },
                                      items: studentNames?.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  )),
                            ])
                          : Container(),
                      Visibility(
                        visible: isMarksAddedOnce,
                        child: custom_text(
                          text: "$selectedStudent's marks have already been submitted once. Proceed with the mark submission only if you want to revise.",
                          alignment: Alignment.topLeft,
                          textStyles: primaryTextSemiBold15,
                          topValue: 10.h,
                          maxLines: 5000,
                          bottomValue: 0,
                        ),
                      ),
                      custom_text(
                        text: strings_name.str_marks_desc,
                        alignment: Alignment.topLeft,
                        textStyles: primaryTextSemiBold15,
                        topValue: 10.h,
                        maxLines: 5000,
                        bottomValue: 0,
                      ),
                      custom_text(
                        text: strings_name.str_punctuality_marks,
                        alignment: Alignment.topLeft,
                        topValue: 10.h,
                        bottomValue: 0,
                        textStyles: blackTextSemiBold16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<String>(
                          elevation: 16,
                          value: punctualityMarks,
                          style: blackText15,
                          focusColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              punctualityMarks = newValue!;
                            });
                          },
                          items: marksList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      custom_text(
                        text: strings_name.str_grooming_marks,
                        alignment: Alignment.topLeft,
                        topValue: 10.h,
                        bottomValue: 0,
                        textStyles: blackTextSemiBold16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<String>(
                          elevation: 16,
                          value: groomingMarks,
                          style: blackText15,
                          focusColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              groomingMarks = newValue!;
                            });
                          },
                          items: marksList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      custom_text(
                        text: strings_name.str_attitude_marks,
                        alignment: Alignment.topLeft,
                        topValue: 10.h,
                        bottomValue: 0,
                        textStyles: blackTextSemiBold16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<String>(
                          elevation: 16,
                          value: attitudeMarks,
                          style: blackText15,
                          focusColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              attitudeMarks = newValue!;
                            });
                          },
                          items: marksList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      custom_text(
                        text: strings_name.str_improvements_marks,
                        alignment: Alignment.topLeft,
                        topValue: 10.h,
                        bottomValue: 0,
                        textStyles: blackTextSemiBold16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<String>(
                          elevation: 16,
                          value: improvementsMarks,
                          style: blackText15,
                          focusColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              improvementsMarks = newValue!;
                            });
                          },
                          items: marksList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      custom_text(
                        text: strings_name.str_overall_marks,
                        alignment: Alignment.topLeft,
                        topValue: 10.h,
                        bottomValue: 0,
                        textStyles: blackTextSemiBold16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<String>(
                          elevation: 16,
                          value: overallMarks,
                          style: blackText15,
                          focusColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              overallMarks = newValue!;
                            });
                          },
                          items: marksList.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      custom_edittext(
                        type: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        controller: feedbackController,
                        topValue: 5,
                        maxLines: 5,
                        minLines: 4,
                        hintText: strings_name.str_other_feedback,
                        maxLength: 5000,
                      ),
                      CustomButton(
                        click: () async {
                          if (selectedStudent.isEmpty || selectedStudent == strings_name.str_select_student) {
                            Utils.showSnackBar(context, strings_name.str_empty_select_student);
                          } else if (punctualityMarks == strings_name.str_select_marks) {
                            Utils.showSnackBar(context, strings_name.str_empty_punctuality_marks);
                          } else if (groomingMarks == strings_name.str_select_marks) {
                            Utils.showSnackBar(context, strings_name.str_empty_grooming_marks);
                          } else if (attitudeMarks == strings_name.str_select_marks) {
                            Utils.showSnackBar(context, strings_name.str_empty_attitude_marks);
                          } else if (improvementsMarks == strings_name.str_select_marks) {
                            Utils.showSnackBar(context, strings_name.str_empty_improvements_marks);
                          } else if (overallMarks == strings_name.str_select_marks) {
                            Utils.showSnackBar(context, strings_name.str_empty_overall_marks);
                          } else {
                            updateMarks();
                          }
                        },
                        text: strings_name.str_submit,
                      ),
                      SizedBox(height: 5.h),
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
            )));
  }

  Future<void> checkMarks() async {
    punctualityMarks = strings_name.str_select_marks;
    groomingMarks = strings_name.str_select_marks;
    attitudeMarks = strings_name.str_select_marks;
    improvementsMarks = strings_name.str_select_marks;
    overallMarks = strings_name.str_select_marks;

    isMarksAddedOnce = false;
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "AND("
        "SEARCH('$companyCode', ARRAYJOIN({${TableNames.CLM_COMPANY_CODE}}), 0),"
        "SEARCH('$selectedStudent', ARRAYJOIN({student_name}), 0))";
    debugPrint(query);
    try {
      var data = await apiRepository.getMarksApi(query);
      if (data.records?.isNotEmpty == true) {
        isMarksAddedOnce = true;
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

  void updateMarks() async {
    setState(() {
      isVisible = true;
    });

    try {
      var studentId = studentIds![studentNames!.indexOf(selectedStudent) - 1];

      AddPlacementMarksRequest request = AddPlacementMarksRequest();
      request.studentNumber = studentId.split(",");
      request.companyId = companyId.split(",");
      request.otherFeedback = feedbackController.text.trim();
      request.addedType = strings_name.str_added_type_company;

      request.punctualityMarks = punctualityMarks;
      request.groomingMarks = groomingMarks;
      request.attitudeMarks = attitudeMarks;
      request.improvementsMarks = improvementsMarks;
      request.overallMarks = overallMarks;

      var json = request.toJson();
      json.removeWhere((key, value) => value == null);

      var resp = await apiRepository.addPlacementMarksApi(request);
      if (resp.id != null) {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_added_placement_marks);
        await Future.delayed(const Duration(milliseconds: 2000));
        Get.back(result: true);
      } else {
        setState(() {
          isVisible = false;
        });
      }
    } on Exception catch (e) {
      Utils.showSnackBar(context, strings_name.str_invalid_data);
      setState(() {
        isVisible = false;
      });
    }
  }
}
