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
import 'package:flutterdesigndemo/models/company_detail_response.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/request/create_company_det_req.dart';
import 'package:flutterdesigndemo/models/request/create_job_opportunity_request.dart';
import 'package:flutterdesigndemo/ui/placement/company_selection.dart';
import 'package:flutterdesigndemo/ui/placement/selfplace_company_detail.dart';
import 'package:flutterdesigndemo/ui/placement/selfplace_job_opportunity_form.dart';
import 'package:flutterdesigndemo/ui/placement/student_selection.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class SelfPlacementStudent extends StatefulWidget {
  const SelfPlacementStudent({super.key});

  @override
  State<SelfPlacementStudent> createState() => _SelfPlacementStudentState();
}

class _SelfPlacementStudentState extends State<SelfPlacementStudent> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  var canEdit = false;
  BaseApiResponseWithSerializable<CompanyDetailResponse>? companyInfo;
  BaseApiResponseWithSerializable<JobOpportunityResponse>? jobInfo;
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? selectedAppliedData = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? selectedPlacedData = [];

  String companyRecordId = "";
  CreateCompanyDetailRequest? companyRequest;

  @override
  void initState() {
    super.initState();
    if (PreferenceUtils.getIsLogin() == 1) {
      fetchSelfPlacementDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppWidgets.appBarWithoutBack(strings_name.str_self_placement),
            body: Stack(children: [
              Container(
                  margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.h),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      companyInfo != null && companyInfo?.fields?.status == TableNames.SELFPLACE_STATUS_REJECTED
                          ? custom_text(
                              text: companyInfo?.fields?.rejection_reason ?? "",
                              textStyles: primaryTextSemiBold16,
                              maxLines: 100,
                              leftValue: 5.h,
                              rightValue: 5.h,
                            )
                          : Container(),
                      GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            color: colors_name.colorWhite,
                            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.h),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const Text(strings_name.str_company_detail, textAlign: TextAlign.center, style: blackTextSemiBold16),
                              Icon(canEdit || companyInfo != null ? Icons.edit_outlined : Icons.keyboard_arrow_right,
                                  size: 30.h, color: colors_name.colorPrimary),
                            ]),
                          ),
                        ),
                        onTap: () {
                          if (companyInfo != null) {
                            Get.to(() => const SelfPlaceCompanyDetail(), arguments: companyInfo)?.then((result) {
                              if (result != null) {
                                companyInfo = result;
                                setState(() {});
                              }
                            });
                          } else {
                            selectCompanyTypeDialog();
                          }
                        },
                      ),
                      GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            color: colors_name.colorWhite,
                            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.h),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              const Text(strings_name.str_internship_detail, textAlign: TextAlign.center, style: blackTextSemiBold16),
                              Icon(canEdit || jobInfo != null ? Icons.edit_outlined : Icons.keyboard_arrow_right,
                                  size: 30.h, color: colors_name.colorPrimary),
                            ]),
                          ),
                        ),
                        onTap: () {
                          if (jobInfo != null) {
                            Get.to(() => const SelfPlaceJobOpportunityForm(), arguments: jobInfo)?.then((result) {
                              if (result != null) {
                                jobInfo = result;
                                setState(() {});
                              }
                            });
                          } else {
                            Get.to(() => const SelfPlaceJobOpportunityForm())?.then((result) {
                              if (result != null) {
                                jobInfo = result;
                                setState(() {});
                              }
                            });
                          }
                        },
                      ),
                      Visibility(
                        visible: PreferenceUtils.getIsLogin() == 2,
                        child: GestureDetector(
                          child: Card(
                            elevation: 5,
                            child: Container(
                              color: colors_name.colorWhite,
                              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.h),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                const Text(strings_name.str_applied_student, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                Icon(canEdit || (selectedAppliedData?.length ?? 0) > 0 ? Icons.edit_outlined : Icons.keyboard_arrow_right,
                                    size: 30.h, color: colors_name.colorPrimary),
                              ]),
                            ),
                          ),
                          onTap: () {
                            if ((selectedAppliedData?.length ?? 0) > 0) {
                              Get.to(() => const StudentSelection(), arguments: selectedAppliedData)?.then((result) {
                                if (result != null) {
                                  selectedAppliedData = result;
                                  setState(() {});
                                }
                              });
                            } else {
                              Get.to(() => const StudentSelection())?.then((result) {
                                if (result != null) {
                                  selectedAppliedData = result;
                                  setState(() {});
                                }
                              });
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: PreferenceUtils.getIsLogin() == 2,
                        child: GestureDetector(
                          child: Card(
                            elevation: 5,
                            child: Container(
                              color: colors_name.colorWhite,
                              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.h),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                const Text(strings_name.str_placed_student, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                Icon(canEdit || (selectedPlacedData?.length ?? 0) > 0 ? Icons.edit_outlined : Icons.keyboard_arrow_right,
                                    size: 30.h, color: colors_name.colorPrimary),
                              ]),
                            ),
                          ),
                          onTap: () {
                            if ((selectedPlacedData?.length ?? 0) > 0) {
                              Get.to(() => const StudentSelection(), arguments: selectedPlacedData)?.then((result) {
                                if (result != null) {
                                  selectedPlacedData = result;
                                  setState(() {});
                                }
                              });
                            } else {
                              Get.to(() => const StudentSelection())?.then((result) {
                                if (result != null) {
                                  selectedPlacedData = result;
                                  setState(() {});
                                }
                              });
                            }
                          },
                        ),
                      ),
                      CustomButton(
                        text: PreferenceUtils.getIsLogin() == 1 ? strings_name.str_apply_for_self_placement : strings_name.str_submit,
                        click: () async {
                          if (companyInfo == null) {
                            Utils.showSnackBarUsingGet(strings_name.str_empty_selfplace_company);
                          } else if (jobInfo == null) {
                            Utils.showSnackBarUsingGet(strings_name.str_empty_selfplace_job);
                          } else if (PreferenceUtils.getIsLogin() == 2) {
                            if ((selectedAppliedData?.length ?? 0) <= 0) {
                              Utils.showSnackBarUsingGet(strings_name.str_empty_applied_students);
                            } else if ((selectedPlacedData?.length ?? 0) <= 0) {
                              Utils.showSnackBarUsingGet(strings_name.str_empty_placed_students);
                            } else {
                              submitData();
                            }
                          } else if (PreferenceUtils.getIsLogin() == 1) {
                            BaseApiResponseWithSerializable<LoginFieldsResponse>? studentData =
                                BaseApiResponseWithSerializable<LoginFieldsResponse>();
                            studentData.id = PreferenceUtils.getLoginRecordId();
                            studentData.fields = PreferenceUtils.getLoginData();

                            selectedAppliedData?.add(studentData);
                            selectedPlacedData?.add(studentData);

                            submitData();
                          }
                        },
                      )
                    ]),
                  )),
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
              ),
            ])));
  }

  selectCompanyTypeDialog() {
    return Get.defaultDialog(
      title: strings_name.str_select_company_option,
      titlePadding: EdgeInsets.symmetric(vertical: 12.h),
      contentPadding: EdgeInsets.symmetric(horizontal: 30.w),
      content: Column(
        children: [
          CustomButton(
            text: strings_name.str_option_create_company,
            click: () {
              Get.to(() => const SelfPlaceCompanyDetail())?.then((result) {
                if (result != null) {
                  companyInfo = result;
                  Get.back();
                  setState(() {});
                }
              });
            },
          ),
          CustomButtonOutline(
            text: strings_name.str_option_select_company,
            click: () {
              Get.to(() => const CompanySelection())?.then((result) {
                if (result != null) {
                  companyInfo = result;
                  if (PreferenceUtils.getIsLogin() == 1) {
                    companyInfo?.id = "";
                  }
                  Get.back();
                  setState(() {});
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> submitData() async {
    setState(() {
      isVisible = true;
    });
    try {
      createCompanyRequest();
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  Future<void> fetchSelfPlacementDetails() async {
    setState(() {
      isVisible = true;
    });
    try {
      var loginData = PreferenceUtils.getLoginData();
      var query = "FIND('${loginData.mobileNumber.toString()}', ${TableNames.TB_USERS_PHONE}, 0)";

      var data = await apiRepository.loginApi(query);
      if (data.records!.isNotEmpty) {
        await PreferenceUtils.setLoginData(data.records!.first.fields!);
        await PreferenceUtils.setLoginRecordId(data.records!.first.id!);

        var lastSelfPlaceCompanyDetail = data.records!.last.fields!.self_place_company_code;
        if (lastSelfPlaceCompanyDetail?.isNotEmpty == true) {
          fetchCompanyInfo(lastSelfPlaceCompanyDetail!.last);
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

  Future<void> fetchCompanyInfo(String lastSelfPlaceCompanyDetail) async {
    setState(() {
      isVisible = true;
    });
    try {
      var query = "AND(${TableNames.CLM_COMPANY_CODE}='$lastSelfPlaceCompanyDetail')";

      var data = await apiRepository.getSelfPlaceCompanyDetailApi(query);
      if (data.records!.isNotEmpty) {
        companyRecordId = data.records!.last.id ?? "";
        companyInfo = data.records!.last;

        canEdit = true;
        if (companyInfo!.fields!.self_job_code?.isNotEmpty == true) {
          var lastSelfPlaceJobDetail = companyInfo!.fields?.self_job_code?.last;
          if (lastSelfPlaceJobDetail?.isNotEmpty == true) {
            fetchJobInfo(lastSelfPlaceJobDetail!);
          }
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

  Future<void> fetchJobInfo(String lastSelfPlaceJobDetail) async {
    setState(() {
      isVisible = true;
    });
    try {
      var query = "AND(${TableNames.CLM_JOB_CODE}='$lastSelfPlaceJobDetail')";

      var data = await apiRepository.getSelfPlaceJobDetailApi(query);
      if (data.records!.isNotEmpty) {
        jobInfo = data.records!.first;
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

  Future<void> createCompanyRequest() async {
    companyRequest = CreateCompanyDetailRequest();
    companyRequest?.company_name = companyInfo?.fields?.companyName?.trim() ?? "";
    companyRequest?.company_identity_number = companyInfo?.fields?.companyIdentityNumber?.trim() ?? "";
    companyRequest?.company_sector = companyInfo?.fields?.companySector;
    companyRequest?.contact_name = companyInfo?.fields?.contactName?.trim() ?? "";
    companyRequest?.contact_designation = companyInfo?.fields?.contactDesignation?.trim() ?? "";
    companyRequest?.contact_number = companyInfo?.fields?.contactNumber?.trim() ?? "";
    companyRequest?.contact_whatsapp_number = companyInfo?.fields?.contactWhatsappNumber?.trim() ?? "";
    companyRequest?.company_landline = companyInfo?.fields?.company_landline?.trim() ?? "";
    companyRequest?.contact_email = companyInfo?.fields?.contactEmail?.trim() ?? "";
    companyRequest?.company_website = companyInfo?.fields?.companyWebsite?.trim() ?? "";
    companyRequest?.reporting_branch = companyInfo?.fields?.reporting_branch?.trim() ?? "";
    companyRequest?.reporting_address = companyInfo?.fields?.reporting_address?.trim() ?? "";
    companyRequest?.city = companyInfo?.fields?.city?.trim() ?? "";
    companyRequest?.hub_id = companyInfo?.fields?.hubIds;
    if (PreferenceUtils.getIsLogin() == 1) {
      companyRequest?.status = strings_name.str_company_status_pending;
    } else {
      companyRequest?.status = strings_name.str_company_status_approved;
    }

    if (companyInfo?.fields?.company_logo?.last.url?.isNotEmpty == true) {
      Map<String, dynamic> map = Map();
      map["url"] = companyInfo?.fields?.company_logo?.last.url;
      List<Map<String, dynamic>> listData = [];
      listData.add(map);
      companyRequest?.company_logo = listData;
    }

    if (companyInfo?.fields?.company_loi?.last.url?.isNotEmpty == true) {
      Map<String, dynamic> map = Map();
      map["url"] = companyInfo?.fields?.company_loi?.last.url;
      List<Map<String, dynamic>> listData = [];
      listData.add(map);
      companyRequest?.company_loi = listData;
    }

    if (companyInfo?.id?.trim().isNotEmpty == true) {
      try {
        var json = companyRequest?.toJson();
        json?.removeWhere((key, value) => value == null);

        var resp;
        if (PreferenceUtils.getIsLogin() == 1) {
          resp = await apiRepository.updateSelfPlaceCompanyApi(json!, companyInfo?.id?.trim() ?? "");
        } else {
          resp = await apiRepository.updateCompanyDetailApi(json!, companyInfo?.id?.trim() ?? "");
        }
        if (resp.id!.isNotEmpty) {
          createJobOpportunityRequest();
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
    } else {
      try {
        if (PreferenceUtils.getIsLogin() == 1) {
          companyRequest?.is_self_place = "1";
          companyRequest?.created_by_student = PreferenceUtils.getLoginRecordId().trim().split(" ");
        } else {
          companyRequest?.is_self_place = "2";
        }

        List<Map<String, CreateCompanyDetailRequest>> list = [];
        Map<String, CreateCompanyDetailRequest> map = Map();
        map["fields"] = companyRequest!;
        list.add(map);

        var resp;
        if (PreferenceUtils.getIsLogin() == 1) {
          resp = await apiRepository.createSelfPlaceCompanyApi(list);
        } else {
          resp = await apiRepository.createCompanyDetailApi(list);
        }
        if (resp.records!.isNotEmpty) {
          companyInfo?.id = resp.records?.last.id;
          createJobOpportunityRequest();
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

  Future<void> createJobOpportunityRequest() async {
    if (companyInfo?.id?.trim().isNotEmpty == true) {
      CreateJobOpportunityRequest request = CreateJobOpportunityRequest();
      request.companyId = companyInfo?.id?.trim().split(" ") ?? [];
      request.jobTitle = jobInfo?.fields?.jobTitle?.trim() ?? "";
      request.jobDescription = jobInfo?.fields?.jobDescription?.trim() ?? "";
      request.specificRequirements = jobInfo?.fields?.specificRequirements?.trim() ?? "";
      request.stipendType = jobInfo?.fields?.stipendType?.toString();
      if (jobInfo?.fields?.stipendType?.toString() == strings_name.str_amount_type_range) {
        if (jobInfo?.fields?.stipendRangeMin?.toString().trim().isNotEmpty == true) {
          request.stipendRangeMin = int.parse(jobInfo!.fields!.stipendRangeMin!.toString().trim());
        }
        if (jobInfo?.fields?.stipendRangeMax.toString().trim().isNotEmpty == true) {
          request.stipendRangeMax = int.parse(jobInfo!.fields!.stipendRangeMax!.toString().trim());
        }
      }
      request.vacancies = jobInfo?.fields?.vacancies;
      if (PreferenceUtils.getIsLogin() == 1) {
        request.gender = PreferenceUtils.getLoginData().gender;
      } else {
        request.gender = jobInfo?.fields?.gender ?? strings_name.str_both;
      }
      if (jobInfo?.fields?.minimumAge?.toString().trim().isNotEmpty == true) {
        if (int.tryParse(jobInfo!.fields!.minimumAge!.toString().trim()) != null) {
          request.minimumAge = int.tryParse(jobInfo!.fields!.minimumAge!.toString().trim());
        }
      }
      request.timingStart = jobInfo?.fields?.timingStart?.trim().toString();
      request.timingEnd = jobInfo?.fields?.timingEnd?.trim().toString();
      request.internshipModes = jobInfo?.fields?.internshipModes?.trim().toString();
      request.internshipDuration = jobInfo?.fields?.internshipDuration?.trim().toString();
      if (PreferenceUtils.getIsLogin() == 1) {
        request.status = strings_name.str_job_status_pending;
      } else {
        request.status = strings_name.str_job_status_process_complete;
      }

      if (jobInfo?.fields?.bond_structure?.last.url?.isNotEmpty == true) {
        Map<String, dynamic> map = Map();
        map["url"] = jobInfo?.fields?.bond_structure?.last.url;
        List<Map<String, dynamic>> listData = [];
        listData.add(map);
        request.bondStructure = listData;
      }
      if (jobInfo?.fields?.incentive_structure?.last.url?.isNotEmpty == true) {
        Map<String, dynamic> map = Map();
        map["url"] = jobInfo?.fields?.incentive_structure?.last.url;
        List<Map<String, dynamic>> listData = [];
        listData.add(map);
        request.incentiveStructure = listData;
      }

      request.hubIds = jobInfo?.fields?.hubIds;
      request.specializationIds = jobInfo?.fields?.specializationIds;
      request.semester = jobInfo?.fields?.semester;
      List<String>? placedStudentsMobileNumber = [];

      if (selectedAppliedData?.isNotEmpty == true) {
        List<String>? appliedStudents = [];
        for (int i = 0; i < (selectedAppliedData?.length ?? 0); i++) {
          appliedStudents.add(selectedAppliedData?[i].id ?? "");
        }
        request.applied_students = appliedStudents;
      }
      if (selectedPlacedData?.isNotEmpty == true) {
        List<String>? placedStudents = [];
        for (int i = 0; i < (selectedPlacedData?.length ?? 0); i++) {
          placedStudents.add(selectedPlacedData?[i].id ?? "");
          placedStudentsMobileNumber.add(selectedPlacedData?[i].fields?.mobileNumber ?? "");
        }
        request.placed_students = placedStudents;
      }

      var json = request.toJson();
      json.removeWhere((key, value) => value == null);

      try {
        if (jobInfo?.id?.isNotEmpty == true) {
          var resp;
          if (PreferenceUtils.getIsLogin() == 2) {
            resp = await apiRepository.updateJobOpportunityApi(json, jobInfo?.id ?? "");
          } else {
            resp = await apiRepository.updateSelfPlaceJobApi(json, jobInfo?.id ?? "");
          }
          if (resp.id!.isNotEmpty) {
            setState(() {
              isVisible = false;
            });
            if (PreferenceUtils.getIsLogin() == 2) {

              Utils.showSnackBar(context, strings_name.str_job_updated);
            } else {
              Utils.showSnackBar(context, strings_name.str_job_approval_sent);
            }
            await Future.delayed(const Duration(milliseconds: 2000));
            Get.back(closeOverlays: true, result: true);
          } else {
            setState(() {
              isVisible = false;
            });
          }
        } else {
          var json = request.toJson();
          json.removeWhere((key, value) => value == null);

          var resp;
          if (PreferenceUtils.getIsLogin() == 2) {
            resp = await apiRepository.createJobOpportunityApi(request);
          } else {
            resp = await apiRepository.createSelfPlaceJobApi(json);
          }
          if (resp.id!.isNotEmpty) {
            setState(() {
              isVisible = false;
            });
            if (PreferenceUtils.getIsLogin() == 2) {
              Utils.showSnackBar(context, strings_name.str_job_added);
            } else {
              Utils.showSnackBar(context, strings_name.str_job_approval_sent);
            }
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
    } else {
      Utils.showSnackBar(context, strings_name.str_err_company_setup);
    }
  }

  Future<void> placeStudent(String studentMobileNumber) async {
    if (studentMobileNumber.isNotEmpty == true) {
      setState(() {
        isVisible = true;
      });
      try {
        var query = "SEARCH('$studentMobileNumber', ${TableNames.TB_USERS_PHONE})";
        var data = await apiRepository.loginApi(query);
        if (data.records!.isNotEmpty) {
          Map<String, dynamic> requestParams = Map();
          requestParams[TableNames.CLM_IS_PLACED_NOW] = "1";
          requestParams[TableNames.CLM_HAS_RESIGNED] = 0;
          if (data.records?.last != null) {
            if (data.records?.last.fields?.is_banned == 1) {
              requestParams[TableNames.CLM_BANNED_FROM_PLACEMENT] = 2;
            }
          }

          var dataUpdate = await apiRepository.updateStudentDataApi(requestParams, data.records?.first.id ?? "");
          if (dataUpdate.fields != null) {
            setState(() {
              isVisible = false;
            });
            Utils.showSnackBar(context, strings_name.str_self_place_job_updated);
            await Future.delayed(const Duration(milliseconds: 2000));
            Get.back(closeOverlays: true, result: true);
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
      }
    }
  }
}
