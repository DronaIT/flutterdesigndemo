import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/add_button.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/student_response.dart';
import 'package:flutterdesigndemo/ui/ask/add_ask_levels.dart';
import 'package:flutterdesigndemo/ui/ask/add_ask_parameters.dart';
import 'package:flutterdesigndemo/ui/ask/ask_evaluation.dart';
import 'package:flutterdesigndemo/ui/ask/ask_parameters.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class AskDashboard extends StatefulWidget {
  const AskDashboard({super.key});

  @override
  State<AskDashboard> createState() => _AskDashboardState();
}

class _AskDashboardState extends State<AskDashboard> {
  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  bool isVisible = false;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  bool canAddAskLevels = false, canAddAskParameters = false, canAddNewEvaluation = false, canUpdateEvaluation = false;
  String loginId = "";
  var isLogin = 0;

  List<StudentResponse>? studentData = [];
  List<StudentResponse>? mainStudentData = [];

  List<int> semesterResponseArray = <int>[-1, 1, 2, 3, 4, 5, 6];
  int semesterValue = -1;

  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 2) {
      getHubs();
    } else {
      getHubStudent();
    }
  }

  Future<void> getHubs() async {
    try {
      setState(() {
        isVisible = true;
      });
      var hubResponse = await apiRepository.getHubApi();
      if (hubResponse.records!.isNotEmpty) {
        PreferenceUtils.setHubList(hubResponse);
        debugPrint("Hubs ${PreferenceUtils.getHubList().records!.length}");

        for (int i = 0; i < hubResponse.records!.length; i++) {
          if (hubResponse.records![i].fields?.hubId == TableNames.CANCELLED_HUB_ID) {
            hubResponse.records?.removeAt(i);
            i--;
          } else if (hubResponse.records![i].fields?.hubId == TableNames.SUSPENDED_HUB_ID) {
            hubResponse.records?.removeAt(i);
            i--;
          }
        }

        hubResponseArray = hubResponse.records;
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

        this.hubResponse = hubResponseArray![0];
        hubValue = hubResponseArray![0].id!;

        getSpecializations();
        if (hubValue.trim().isNotEmpty) {
          for (int i = 0; i < speResponseArray!.length; i++) {
            if (speResponseArray![i].fields?.hubIdFromHubIds?.contains(this.hubResponse?.fields?.hubId) != true) {
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

        getStudentRecords();
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = true;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    } finally {
      getPermission();
    }
  }

  Future<void> getHubStudent() async {
    try {
      setState(() {
        isVisible = true;
      });
      var hubResponse = await apiRepository.getHubApi();
      if (hubResponse.records!.isNotEmpty) {
        PreferenceUtils.setHubList(hubResponse);
        debugPrint("Hubs ${PreferenceUtils.getHubList().records!.length}");

        for (int i = 0; i < hubResponse.records!.length; i++) {
          if (hubResponse.records![i].fields?.hubId == TableNames.CANCELLED_HUB_ID) {
            hubResponse.records?.removeAt(i);
            i--;
          } else if (hubResponse.records![i].fields?.hubId == TableNames.SUSPENDED_HUB_ID) {
            hubResponse.records?.removeAt(i);
            i--;
          }
        }

        hubResponseArray = hubResponse.records;
        var loginData = PreferenceUtils.getLoginData();
        for (var i = 0; i < hubResponseArray!.length; i++) {
          if (loginData.hubIdFromHubIds?.first != hubResponseArray![i].fields?.hubId) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }

        this.hubResponse = hubResponseArray![0];
        hubValue = hubResponseArray![0].id!;

        getSpecializations();
        if (hubValue.trim().isNotEmpty) {
          for (int i = 0; i < speResponseArray!.length; i++) {
            if (speResponseArray![i].fields?.hubIdFromHubIds?.contains(this.hubResponse?.fields?.hubId) != true) {
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

        getStudentRecords();
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = true;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    } finally {
      getPermission();
    }
  }

  getStudentRecords() {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    mainStudentData = [];
    studentData = [];
    for (int i = 0; i < (hubResponse?.fields?.tblStudent?.length ?? 0); i++) {
      if (hubResponse?.fields!.studentSemester![i] != "7") {
        StudentResponse data = StudentResponse();
        data.studentId = hubResponse!.fields!.tblStudent![i];
        data.studentName = hubResponse!.fields!.studentName![i];
        data.studentMobileNumber = hubResponse!.fields!.studentMobileNumber![i];
        data.studentSemester = hubResponse!.fields!.studentSemester![i];
        data.studentSpecializationIds = hubResponse!.fields!.studentSpecializationIds![i];
        data.askScore = hubResponse!.fields!.studentAskScore![i].toString();
        data.askTotal = hubResponse!.fields!.studentAskTotal![i].toString();
        data.studentHubIds = hubResponse!.fields!.hubId;

        mainStudentData?.add(data);
      }
    }

    if (speValue.isNotEmpty && speResponse?.fields!.specializationId?.isNotEmpty == true) {
      for (int i = 0; i < (mainStudentData?.length ?? 0); i++) {
        if (speResponse?.fields!.specializationId != mainStudentData![i].studentSpecializationIds) {
          mainStudentData?.removeAt(i);
          i--;
        }
      }
    }

    if (semesterValue != -1) {
      for (int i = 0; i < (mainStudentData?.length ?? 0); i++) {
        if (semesterValue.toString() != mainStudentData![i].studentSemester) {
          mainStudentData?.removeAt(i);
          i--;
        }
      }
    }

    if (mainStudentData?.isNotEmpty == true) {
      mainStudentData?.sort((a, b) {
        var adate = int.tryParse(a.askScore!.trim());
        var bdate = int.tryParse(b.askScore!.trim());
        return bdate!.compareTo(adate!);
      });
    }

    studentData = List.from(mainStudentData!);
    isVisible = false;

    setState(() {});
  }

  getSpecializations() {
    speResponseArray = [];
    speResponseArray?.addAll(PreferenceUtils.getSpecializationList().records!);
  }

  Future<void> getPermission() async {
    setState(() {
      isVisible = true;
    });
    var roleId = "";
    isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      roleId = TableNames.STUDENT_ROLE_ID;
      loginId = PreferenceUtils.getLoginData().studentId.toString();
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      roleId = loginData.roleIdFromRoleIds!.join(',');
      loginId = loginData.employeeId.toString();
    } else if (isLogin == 3) {
      roleId = TableNames.ORGANIZATION_ROLE_ID;
      loginId = PreferenceUtils.getLoginDataOrganization().id.toString();
    }

    var query = "AND(FIND('$roleId',role_ids)>0,module_ids='${TableNames.MODULE_ASK_MODULE}')";
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_ASK_LEVELS) {
            canAddAskLevels = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_ASK_PARAMETERS) {
            canAddAskParameters = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_NEW_EVALUATION) {
            canAddNewEvaluation = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_EVALUATION) {
            canUpdateEvaluation = true;
          }
        }
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
    } finally {
      setState(() {
        isVisible = false;
      });
      // getRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_ask_dashboard),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              canAddAskParameters
                  ? Column(
                      children: [
                        SizedBox(height: 5.h),
                        AddButton(
                          onTap: () async {
                            Get.to(const AskParameters())?.then((value) {
                              if (value != null && value) {
                                // getStudentRecords();
                              }
                            });
                          },
                          title: strings_name.str_ask_parameters,
                        ),
                      ],
                    )
                  : Container(),
              canAddNewEvaluation
                  ? Column(
                      children: [
                        SizedBox(height: 5.h),
                        AddButton(
                          onTap: () async {
                            Get.to(const ASKEvaluation())?.then((value) {
                              if (value != null && value) {
                                // getStudentRecords();
                              }
                            });
                          },
                          title: "+ ${strings_name.str_new_evaluation}",
                        ),
                      ],
                    )
                  : Container(),
              custom_text(
                text: strings_name.str_select_hub,
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
                bottomValue: 0,
              ),
              Container(
                margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
                width: MediaQuery.of(context).size.width,
                child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                  value: hubResponse,
                  elevation: 16,
                  style: blackText16,
                  focusColor: Colors.white,
                  onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                    hubValue = newValue!.id!.toString();
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

                    getStudentRecords();
                  },
                  items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
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
                    });

                    getStudentRecords();
                  },
                  items: speResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>((BaseApiResponseWithSerializable<SpecializationResponse> value) {
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
                  value: semesterValue,
                  elevation: 16,
                  style: blackText16,
                  focusColor: Colors.white,
                  onChanged: (int? newValue) {
                    setState(() {
                      semesterValue = newValue!;
                    });
                    getStudentRecords();
                  },
                  items: semesterResponseArray.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value == -1 ? "Select semester" : "Semester $value"),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 10.h),
              mainStudentData?.isNotEmpty == true
                  ? Column(children: [
                      CustomEditTextSearch(
                        type: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: controllerSearch,
                        onChanges: (value) {
                          if (value.isEmpty) {
                            studentData = [];
                            studentData = List.from(mainStudentData as Iterable);
                            setState(() {});
                          } else {
                            studentData = [];
                            if (mainStudentData != null && mainStudentData?.isNotEmpty == true) {
                              for (var i = 0; i < mainStudentData!.length; i++) {
                                if (mainStudentData![i].studentName!.toLowerCase().contains(value.toLowerCase())) {
                                  studentData?.add(mainStudentData![i]);
                                }
                              }
                            }
                            setState(() {});
                          }
                        },
                      ),
                      custom_text(
                        text: "Total Students: ${mainStudentData?.length}",
                        textAlign: TextAlign.start,
                        textStyles: primaryTextSemiBold14,
                        bottomValue: 0,
                      ),
                      SizedBox(height: 5.h),
                      studentData?.isNotEmpty == true
                          ? ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: studentData?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.h),
                                  child: GestureDetector(
                                    child: Container(
                                      color: colors_name.colorWhite,
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  child: custom_text(
                                                    text: "#${index + 1} ${studentData![index].studentName}",
                                                    textAlign: TextAlign.start,
                                                    textStyles: linkTextSemiBold16,
                                                    topValue: 5,
                                                    maxLines: 2,
                                                    bottomValue: 5,
                                                  ),
                                                  onTap: () {
                                                    if(PreferenceUtils.getIsLogin() == 2) {
                                                      Get.to(const StudentHistory(), arguments: studentData![index].studentMobileNumber);
                                                    }
                                                  },
                                                ),
                                                custom_text(
                                                  text: "${Utils.getSpecializationNameFromId(studentData![index].studentSpecializationIds)}",
                                                  textAlign: TextAlign.start,
                                                  textStyles: blackText14,
                                                  topValue: 0,
                                                  bottomValue: 5,
                                                ),
                                                custom_text(
                                                  text: "Semester: ${studentData![index].studentSemester}",
                                                  textAlign: TextAlign.start,
                                                  textStyles: blackText14,
                                                  topValue: 0,
                                                  bottomValue: 5,
                                                ),
                                                custom_text(
                                                  text: "ASK Score: ${studentData![index].askScore}/${studentData![index].askTotal}",
                                                  textAlign: TextAlign.start,
                                                  textStyles: primaryTextSemiBold15,
                                                  topValue: 0,
                                                  bottomValue: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (studentData![index].selected) const Icon(Icons.check, size: 20, color: colors_name.colorPrimary),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      studentData![index].selected = !studentData![index].selected;
                                      for (int i = 0; i < mainStudentData!.length; i++) {
                                        if (studentData![index].studentId == mainStudentData![i].studentId) {
                                          mainStudentData![i].selected = studentData![index].selected;
                                          break;
                                        }
                                      }
                                      setState(() {});
                                      if (studentData![index].selected) {
                                        Get.back(result: [studentData![index]]);
                                      }
                                    },
                                  ),
                                );
                              })
                          : custom_text(
                              text: strings_name.str_no_students,
                              textStyles: blackTextSemiBold14,
                              maxLines: 2,
                              alignment: Alignment.center,
                            ),
                    ])
                  : custom_text(
                      text: strings_name.str_no_students,
                      textStyles: blackTextSemiBold16,
                      maxLines: 2,
                      alignment: Alignment.center,
                    ),
              SizedBox(height: 10.h),
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
      ]),
    ));
  }
}
