import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/help_desk_type_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/ui/student_history/filter_data_screen_student.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class FilterScreenHelpdesk extends StatefulWidget {
  const FilterScreenHelpdesk({Key? key}) : super(key: key);

  @override
  State<FilterScreenHelpdesk> createState() => _FilterScreenHelpdeskState();
}

class _FilterScreenHelpdeskState extends State<FilterScreenHelpdesk> {
  bool isVisible = false, fromTask = false;
  var type = 0;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  List<int> semesterResponseArray = <int>[1, 2, 3, 4, 5, 6];
  int semesterValue = -1;

  List<String> divisionResponseArray = <String>[TableNames.DIVISION_A, TableNames.DIVISION_B, TableNames.DIVISION_C, TableNames.DIVISION_D];
  String divisionValue = "";

  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectResponseArray = [];
  BaseApiResponseWithSerializable<SubjectResponse>? subjectResponse;
  String subjectValue = "";
  String subjectRecordId = "";

  List<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>? helpDeskTypeResponse = [];
  BaseApiResponseWithSerializable<HelpDeskTypeResponse>? helpDeskTypeResponses;
  int helpDeskId = 0;

  List<String> ticketStatusArray = <String>[
    TableNames.TICKET_STATUS_OPEN,
    TableNames.TICKET_STATUS_INPROGRESS,
    TableNames.TICKET_STATUS_HOLD,
    TableNames.TICKET_STATUS_RESOLVED,
    TableNames.TICKET_STATUS_SUGGESTION,
    TableNames.TICKET_STATUS_COMPLETED
  ];
  String ticketValue = "";

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? viewStudent = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? studentList = [];
  String title = strings_name.str_filter;

  @override
  void initState() {
    super.initState();
    fromTask = Get.arguments;

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

      getSpecializations();
      helpDeskType();
    }
  }

  getSpecializations(){
    speResponseArray = PreferenceUtils.getSpecializationList().records;
    for (int i = 0; i < (speResponseArray?.length ?? 0); i++) {
      bool contains = false;
      for (int j = 0; j < (hubResponseArray?.length ?? 0); j++) {
        if (speResponseArray![i].fields!.hubIdFromHubIds?.contains(hubResponseArray![j].fields?.hubId) == true) {
          contains = true;
          break;
        }
      }
      if (!contains) {
        speResponseArray?.removeAt(i);
        i--;
      }
    }
  }

  bool onlyTask = false;

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            appBar: AppWidgets.appBarWithoutBack(title),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      fromTask
                          ? Row(
                              children: <Widget>[
                                Checkbox(
                                  value: onlyTask,
                                  onChanged: (bool? value) {
                                    onlyTask = value!;
                                    if (onlyTask) {
                                      helpDeskTypeResponses = null;
                                      helpDeskId = 0;
                                    }
                                    setState(() {});
                                  },
                                ),
                                custom_text(
                                    text: strings_name.str_only_task,
                                    textStyles: blackTextSemiBold14,
                                    topValue: 5,
                                    maxLines: 1,
                                    bottomValue: 5,
                                    leftValue: 0), //Text
                              ],
                            )
                          : Container(),
                      custom_text(
                        text: strings_name.str_ticket_category,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Container(
                              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                              width: viewWidth,
                              child: DropdownButtonFormField<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>(
                                value: helpDeskTypeResponses,
                                elevation: 16,
                                style: blackText16,
                                focusColor: Colors.white,
                                onChanged: (BaseApiResponseWithSerializable<HelpDeskTypeResponse>? newValue) {
                                  setState(() {
                                    helpDeskId = newValue!.fields!.id!;
                                    helpDeskTypeResponses = newValue;
                                    onlyTask = false;
                                  });
                                },
                                items: helpDeskTypeResponse?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>>(
                                    (BaseApiResponseWithSerializable<HelpDeskTypeResponse> value) {
                                  return DropdownMenuItem<BaseApiResponseWithSerializable<HelpDeskTypeResponse>>(
                                    value: value,
                                    child: Text(value.fields!.title.toString()),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_ticket_status,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
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
                                style: blackText16,
                                focusColor: Colors.white,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    ticketValue = newValue!;
                                  });
                                },
                                items: ticketStatusArray.map<DropdownMenuItem<String>>((String value) {
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
                      SizedBox(height: 5.h),
                      custom_text(
                        text: fromTask ? strings_name.str_select_hub : strings_name.str_select_hub_r,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        bottomValue: 0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                          value: hubResponse,
                          elevation: 16,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                            setState(() {
                              hubValue = newValue!.fields!.id!.toString();
                              hubResponse = newValue;

                              getSpecializations();
                              if (hubValue.trim().isNotEmpty) {
                                for (int i = 0; i < speResponseArray!.length; i++) {
                                  if (speResponseArray![i].fields?.hubIdFromHubIds?.contains(hubResponse?.fields?.hubId) != true) {
                                    speResponseArray!.removeAt(i);
                                    i--;
                                  }
                                }
                              }
                              speValue = "";
                              speResponse = null;
                              if (speResponseArray?.isEmpty == true) {
                                Utils.showSnackBar(context, strings_name.str_no_specialization_linked);
                              }
                              setState(() {});
                            });
                          },
                          items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>(
                              (BaseApiResponseWithSerializable<HubResponse> value) {
                            return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                              value: value,
                              child: Text(value.fields!.hubName!.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_select_specialization,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<BaseApiResponseWithSerializable<SpecializationResponse>>(
                          value: speResponse,
                          elevation: 16,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                            setState(() {
                              speValue = newValue!.fields!.id.toString();
                              speResponse = newValue;
                              getSubjects();
                            });
                          },
                          items: speResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>(
                              (BaseApiResponseWithSerializable<SpecializationResponse> value) {
                            return DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>(
                              value: value,
                              child: Text(value.fields!.specializationName.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_semester,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<int>(
                          elevation: 16,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (int? newValue) {
                            setState(() {
                              semesterValue = newValue!;
                              getSubjects();
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
                      SizedBox(height: 5.h),
                      custom_text(
                        text: strings_name.str_division,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
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
                                style: blackText16,
                                focusColor: Colors.white,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    divisionValue = newValue!;
                                    getSubjects();
                                  });
                                },
                                items: divisionResponseArray.map<DropdownMenuItem<String>>((String value) {
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
                      subjectResponseArray!.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(height: 5.h),
                                custom_text(
                                  text: strings_name.str_view_subject,
                                  alignment: Alignment.topLeft,
                                  textStyles: blackTextSemiBold16,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                                        width: viewWidth,
                                        child: DropdownButtonFormField<BaseApiResponseWithSerializable<SubjectResponse>>(
                                          value: subjectResponse,
                                          elevation: 16,
                                          isExpanded: true,
                                          style: blackText16,
                                          focusColor: Colors.white,
                                          onChanged: (BaseApiResponseWithSerializable<SubjectResponse>? newValue) {
                                            setState(() {
                                              subjectValue = newValue!.fields!.ids!.toString();
                                              subjectResponse = newValue;
                                              subjectRecordId = newValue.id!;
                                              // getUnits();
                                            });
                                          },
                                          items: subjectResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SubjectResponse>>>(
                                              (BaseApiResponseWithSerializable<SubjectResponse> value) {
                                            return DropdownMenuItem<BaseApiResponseWithSerializable<SubjectResponse>>(
                                              value: value,
                                              child: Text(value.fields!.subjectTitle!.toString(), overflow: TextOverflow.visible),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(height: 10.h),
                      CustomButton(
                        click: () async {
                          if (!fromTask && hubValue.isEmpty) {
                            Utils.showSnackBar(context, strings_name.str_empty_hub);
                          } else {
                            Get.back(result: [
                              {"hubName": hubResponse?.fields?.hubName ?? ""},
                              {"specializationName": speResponse?.fields?.specializationName ?? ""},
                              {"semester": semesterValue != -1 ? semesterValue.toString() : ""},
                              {"division": divisionValue.toString() ?? ""},
                              {"helpdeskTypeId": helpDeskId ?? 0},
                              {"ticketValue": ticketValue.toString() ?? ""},
                              {"onlyTask": fromTask && onlyTask ?? false},
                            ]);
                          }
                        },
                        text: strings_name.str_submit,
                      ),
                      SizedBox(height: 5.h),
                    ],
                  ),
                ),
                Center(
                  child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
                )
              ],
            )));
  }

  Future<void> getSubjects() async {
    if (semesterValue != -1 && divisionValue.isNotEmpty) {
      setState(() {
        isVisible = true;
      });
      subjectValue = "";

      var query =
          "AND(FIND('$semesterValue', ${TableNames.CLM_SEMESTER}, 0),FIND('${Utils.getSpecializationIds(speValue)}',${TableNames.CLM_SPE_IDS}, 0))";
      try {
        var data = await apiRepository.getSubjectsApi(query);
        setState(() {
          subjectResponse = null;
          subjectResponseArray = data.records;

          isVisible = false;
        });
        if (data.records?.isEmpty == true) {
          Utils.showSnackBar(context, strings_name.str_no_subject_assigned);
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

  Future<void> fetchRecords() async {
    var query = "AND(${TableNames.CLM_HUB_IDS}='$hubValue'";

    if (speValue.isNotEmpty) {
      query += ",${TableNames.CLM_SPE_IDS}='$speValue'";
    }
    query += ",${TableNames.CLM_SEMESTER}='${semesterValue.toString()}'";
    if (divisionValue.isNotEmpty) {
      query += ",${TableNames.CLM_DIVISION}='${divisionValue.toString()}'";
    }

    query += ")";
    debugPrint(query);

    setState(() {
      isVisible = true;
    });
    try {
      var data = await apiRepository.loginApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          viewStudent?.clear();
        }
        viewStudent?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchRecords();
        } else {
          setState(() {
            viewStudent?.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
            isVisible = false;

            filterData();
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            viewStudent = [];
          }
        });
        offset = "";
        Utils.showSnackBarUsingGet(strings_name.str_no_students);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  void filterData() {
    debugPrint(viewStudent?.length.toString());

    if (viewStudent != null && viewStudent?.isNotEmpty == true) {
      studentList?.addAll(viewStudent!);

      if (studentList?.isNotEmpty == true) {
        studentList?.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
        Get.to(const FilterDataStudent(), arguments: [
          {"studentList": studentList},
          {"subject": subjectResponse?.fields?.subjectTitle},
          {"specialization": speResponse?.fields?.specializationName},
          {"hub": hubResponse?.fields?.hubName},
          {"subjectid": subjectResponse?.id},
        ])?.then((result) {
          if (result != null && result) {
            // Get.back(closeOverlays: true);
          }
        });
      } else {
        Utils.showSnackBarUsingGet(strings_name.str_no_students);
      }
    }
  }

  Future<void> helpDeskType() async {
    setState(() {
      isVisible = true;
    });
    try {
      var resp = await apiRepository.getHelpdesk();
      if (resp != null) {
        setState(() {
          isVisible = false;
          helpDeskTypeResponse = resp.records;
        });
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
