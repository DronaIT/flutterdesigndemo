import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/company_detail_response.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/request/create_company_det_req.dart';
import 'package:flutterdesigndemo/models/request/create_job_opportunity_request.dart';
import 'package:flutterdesigndemo/ui/placement/approve_self_placements_detail.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class ApproveSelfPlacements extends StatefulWidget {
  const ApproveSelfPlacements({super.key});

  @override
  State<ApproveSelfPlacements> createState() => _ApproveSelfPlacementsState();
}

class _ApproveSelfPlacementsState extends State<ApproveSelfPlacements> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? studentData = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? mainStudentData = [];

  TextEditingController rejectionReasonController = TextEditingController();

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (PreferenceUtils.getIsLogin() == 2) {
      getRecords();
    }
  }

  getRecords() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });

    var query = "AND(";
    query += "OR(FIND('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
    if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
      for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
        if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
          query += ",FIND('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
        }
      }
    }
    query += "), ${TableNames.CLM_IS_PLACED_NOW}='0', OR("
        "FIND('${TableNames.SELFPLACE_STATUS_PENDING}', ARRAYJOIN({${TableNames.CLM_SELF_PLACE_STATUS}}))"
        // "FIND('${TableNames.SELFPLACE_STATUS_REJECTED}', ARRAYJOIN({${TableNames.CLM_SELF_PLACE_STATUS}}))"
        "))";
    debugPrint(query);

    try {
      var data = await apiRepository.loginApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mainStudentData?.clear();
        }
        for (int i = 0; i < (data.records?.length ?? 0); i++) {
          if (data.records![i].fields?.is_placed_now == "1" || data.records![i].fields?.self_place_company_status?.last == TableNames.SELFPLACE_STATUS_APPROVED) {
            data.records!.removeAt(i);
            i--;
          }
        }

        mainStudentData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          mainStudentData?.sort((a, b) {
            var adate = a.fields!.name;
            var bdate = b.fields!.name;
            return adate!.compareTo(bdate!);
          });

          studentData = [];
          studentData = List.from(mainStudentData!);

          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            studentData = [];
            mainStudentData = [];
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
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_approve_self_placement),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),
              Visibility(
                visible: mainStudentData != null && mainStudentData!.isNotEmpty,
                child: Column(children: [
                  CustomEditTextSearch(
                    type: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    controller: controllerSearch,
                    onChanges: (value) {
                      if (value.isEmpty) {
                        studentData = [];
                        studentData = mainStudentData;
                        setState(() {});
                      } else {
                        studentData = [];
                        for (var i = 0; i < mainStudentData!.length; i++) {
                          if (mainStudentData![i].fields!.name!.toLowerCase().contains(value.toLowerCase())) {
                            studentData?.add(mainStudentData![i]);
                          }
                        }
                        setState(() {});
                      }
                    },
                  ),
                  custom_text(
                    text: "Total students: ${mainStudentData?.length ?? 0}",
                    textStyles: blackTextSemiBold16,
                    leftValue: 12.w,
                    bottomValue: 0,
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                child: studentData != null && studentData!.isNotEmpty
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: studentData?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                              child: Column(
                                children: [
                                  custom_text(text: "${studentData?[index].fields!.name}", textStyles: centerTextStyle16, topValue: 0, maxLines: 2, bottomValue: 5, leftValue: 5),
                                  custom_text(topValue: 0, bottomValue: 5, maxLines: 2, leftValue: 5, text: "Specialization: ${Utils.getSpecializationName(studentData?[index].fields?.specializationIds![0])}", textStyles: blackTextSemiBold14),
                                  custom_text(topValue: 0, bottomValue: 5, leftValue: 5, text: "Semester: ${studentData?[index].fields?.semester}", textStyles: blackTextSemiBold14),
                                  custom_text(topValue: 0, text: "Company name: ${studentData?[index].fields!.self_place_company_name?.last}", textStyles: blackTextSemiBold14, maxLines: 2, bottomValue: 5, leftValue: 5),
                                  custom_text(
                                    text: "Job title: ${studentData?[index].fields!.applied_self_place_job_title?.last}",
                                    textStyles: blackTextSemiBold14,
                                    topValue: 0,
                                    maxLines: 2,
                                    bottomValue: 5,
                                    leftValue: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(const ApproveSelfPlacementDetail(), arguments: [
                                        {"selfPlacementDetail": studentData?[index]},
                                      ])?.then((result) {
                                        if (result != null) {
                                          if (result) {
                                            updateStatus(true, studentData?[index]);
                                          } else {
                                            mainStudentData?.clear();
                                            studentData?.clear();

                                            getRecords();
                                          }
                                        }
                                      });
                                    },
                                    child: const custom_text(
                                      text: strings_name.str_view_details,
                                      textStyles: primaryTextSemiBold15,
                                      alignment: Alignment.centerRight,
                                      topValue: 10,
                                      bottomValue: 0,
                                    ),
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(right: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              approveDialog(studentData?[index]);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: colors_name.presentColor,
                                              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              elevation: 5.0,
                                            ),
                                            child: const Text(
                                              strings_name.str_approve,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(right: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              rejectionDialog(studentData?[index]);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: colors_name.errorColor,
                                              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              elevation: 5.0,
                                            ),
                                            child: const Text(
                                              strings_name.str_reject,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                    : Container(margin: const EdgeInsets.only(top: 10), child: const custom_text(text: strings_name.str_no_jobs_approval_pending, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
              )
            ],
          )),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }

  Future<void> approveDialog(BaseApiResponseWithSerializable<LoginFieldsResponse>? studentData) async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const custom_text(
            text: 'Are you sure you want to approve this placement?',
            textStyles: primaryTextSemiBold16,
            maxLines: 3,
          ),
          Row(
            children: [
              SizedBox(width: 5.h),
              Expanded(
                  child: CustomButton(
                      text: strings_name.str_yes,
                      click: () {
                        updateStatus(true, studentData);
                      })),
              SizedBox(width: 10.h),
              Expanded(
                  child: CustomButton(
                      text: strings_name.str_cancle,
                      click: () {
                        Get.back(closeOverlays: true);
                      })),
              SizedBox(width: 5.h),
            ],
          )
        ],
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  Future<void> rejectionDialog(BaseApiResponseWithSerializable<LoginFieldsResponse>? studentData) async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const custom_text(
            text: 'Provide rejection reason',
            textStyles: primaryTextSemiBold16,
            maxLines: 2,
          ),
          custom_edittext(
            type: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: rejectionReasonController,
            minLines: 3,
            maxLines: 3,
            maxLength: 50000,
            topValue: 0,
          ),
          Row(
            children: [
              SizedBox(width: 5.h),
              Expanded(
                  child: CustomButton(
                      text: strings_name.str_reject,
                      click: () {
                        if (rejectionReasonController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_rejection_reason);
                        } else {
                          updateStatus(false, studentData);
                        }
                        // submitAttendance();
                      })),
              SizedBox(width: 10.h),
              Expanded(
                  child: CustomButton(
                      text: strings_name.str_cancle,
                      click: () {
                        Get.back(closeOverlays: true);
                      })),
              SizedBox(width: 5.h),
            ],
          )
        ],
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  updateStatus(bool isApproved, BaseApiResponseWithSerializable<LoginFieldsResponse>? data) async {
    if (data!.fields?.self_place_company?.last.isNotEmpty == true) {
      var companyRequest = CreateCompanyDetailRequest();
      if (isApproved) {
        companyRequest.status = strings_name.str_company_status_approved;
      } else {
        companyRequest.status = strings_name.str_company_status_rejected;
        companyRequest.rejection_reason = rejectionReasonController.text.trim();
      }

      var json = companyRequest.toJson();
      json.removeWhere((key, value) => value == null);

      try {
        var resp = await apiRepository.updateSelfPlaceCompanyApi(json, data.fields?.self_place_company?.last ?? "");
        if (resp.id!.isNotEmpty) {
          setState(() {
            isVisible = false;
          });
          if (!isApproved) {
            Utils.showSnackBar(context, strings_name.str_self_place_rejected);
            Get.back(closeOverlays: true);

            mainStudentData?.clear();
            studentData?.clear();

            getRecords();
          } else {
            var lastSelfPlaceJobCode = data.fields?.self_place_company_code?.last ?? "";
            fetchCompanyInfo(lastSelfPlaceJobCode);
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

  Future<void> fetchCompanyInfo(String lastSelfPlaceCompanyDetail) async {
    setState(() {
      isVisible = true;
    });
    try {
      var query = "AND(${TableNames.CLM_COMPANY_CODE}='$lastSelfPlaceCompanyDetail')";

      var data = await apiRepository.getSelfPlaceCompanyDetailApi(query);
      if (data.records!.isNotEmpty) {
        var companyRecordId = data.records!.last.id ?? "";
        var companyInfo = data.records!.last;

        if (companyInfo.fields!.self_job_code?.isNotEmpty == true) {
          var lastSelfPlaceJobDetail = companyInfo.fields?.self_job_code?.last;
          if (lastSelfPlaceJobDetail?.isNotEmpty == true) {
            fetchJobInfo(lastSelfPlaceJobDetail!, companyInfo);
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

  Future<void> fetchJobInfo(String lastSelfPlaceJobDetail, BaseApiResponseWithSerializable<CompanyDetailResponse>? companyInfo) async {
    setState(() {
      isVisible = true;
    });
    try {
      var query = "AND(${TableNames.CLM_JOB_CODE}='$lastSelfPlaceJobDetail')";

      var data = await apiRepository.getSelfPlaceJobDetailApi(query);
      if (data.records!.isNotEmpty) {
        var jobInfo = data.records!.first;
        createCompanyRequest(companyInfo, jobInfo);
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

  Future<void> createCompanyRequest(BaseApiResponseWithSerializable<CompanyDetailResponse>? companyInfo, BaseApiResponseWithSerializable<JobOpportunityResponse>? jobInfo) async {
    var companyRequest = CreateCompanyDetailRequest();
    companyRequest.company_name = companyInfo?.fields?.companyName?.trim() ?? "";
    companyRequest.company_identity_number = companyInfo?.fields?.companyIdentityNumber?.trim() ?? "";
    companyRequest.company_sector = companyInfo?.fields?.companySector;
    companyRequest.contact_name = companyInfo?.fields?.contactName?.trim() ?? "";
    companyRequest.contact_designation = companyInfo?.fields?.contactDesignation?.trim() ?? "";
    companyRequest.contact_number = companyInfo?.fields?.contactNumber?.trim() ?? "";
    companyRequest.contact_whatsapp_number = companyInfo?.fields?.contactWhatsappNumber?.trim() ?? "";
    companyRequest.company_landline = companyInfo?.fields?.company_landline?.trim() ?? "";
    companyRequest.contact_email = companyInfo?.fields?.contactEmail?.trim() ?? "";
    companyRequest.company_website = companyInfo?.fields?.companyWebsite?.trim() ?? "";
    companyRequest.reporting_branch = companyInfo?.fields?.reporting_branch?.trim() ?? "";
    companyRequest.reporting_address = companyInfo?.fields?.reporting_address?.trim() ?? "";
    companyRequest.city = companyInfo?.fields?.city?.trim() ?? "";
    companyRequest.hub_id = companyInfo?.fields?.hubIds;
    companyRequest.status = strings_name.str_company_status_approved;
    companyRequest.existing_slab = companyInfo?.fields?.existing_slab;
    companyRequest.probable_vacancy = 1;

    if (companyInfo?.fields?.company_logo?.last.url?.isNotEmpty == true) {
      Map<String, dynamic> map = Map();
      map["url"] = companyInfo?.fields?.company_logo?.last.url;
      List<Map<String, dynamic>> listData = [];
      listData.add(map);
      companyRequest.company_logo = listData;
    }

    if (companyInfo?.fields?.company_loi?.last.url?.isNotEmpty == true) {
      Map<String, dynamic> map = Map();
      map["url"] = companyInfo?.fields?.company_loi?.last.url;
      List<Map<String, dynamic>> listData = [];
      listData.add(map);
      companyRequest.company_loi = listData;
    }

    try {
      companyRequest.is_self_place = "1";
      // companyRequest.created_by_student = companyInfo?.fields?.created_by_student;

      List<Map<String, CreateCompanyDetailRequest>> list = [];
      Map<String, CreateCompanyDetailRequest> map = Map();
      map["fields"] = companyRequest;
      list.add(map);

      var resp = await apiRepository.createCompanyDetailApi(list);
      if (resp.records!.isNotEmpty) {
        companyInfo?.id = resp.records?.last.id;
        createJobOpportunityRequest(companyInfo, jobInfo);
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

  Future<void> createJobOpportunityRequest(BaseApiResponseWithSerializable<CompanyDetailResponse>? companyInfo, BaseApiResponseWithSerializable<JobOpportunityResponse>? jobInfo) async {
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
          request.minimumAge = int.tryParse(jobInfo.fields!.minimumAge!.toString().trim());
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
      request.applied_students = jobInfo?.fields?.appliedStudents;
      request.placed_students = jobInfo?.fields?.placedStudents;

      var json = request.toJson();
      json.removeWhere((key, value) => value == null);

      try {
        var json = request.toJson();
        json.removeWhere((key, value) => value == null);

        var resp = await apiRepository.createJobOpportunityApi(request);
        if (resp.id!.isNotEmpty) {
          placeStudent(companyInfo, jobInfo);
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
      Utils.showSnackBar(context, strings_name.str_err_company_setup);
    }
  }

  Future<void> placeStudent(BaseApiResponseWithSerializable<CompanyDetailResponse>? companyInfo, BaseApiResponseWithSerializable<JobOpportunityResponse>? jobInfo) async {
    if (jobInfo?.fields?.placedStudents?.last.isNotEmpty == true) {
      setState(() {
        isVisible = true;
      });
      try {
        var query = "SEARCH('${companyInfo?.fields?.created_by_student_number?.last.toString()}', ${TableNames.TB_USERS_PHONE})";
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

          var dataUpdate = await apiRepository.updateStudentDataApi(requestParams, jobInfo?.fields?.placedStudents?.last ?? "");
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
