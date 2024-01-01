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
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ApproveSelfPlacementDetail extends StatefulWidget {
  const ApproveSelfPlacementDetail({super.key});

  @override
  State<ApproveSelfPlacementDetail> createState() => _ApproveSelfPlacementDetailState();
}

class _ApproveSelfPlacementDetailState extends State<ApproveSelfPlacementDetail> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? studentData = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? mainStudentData = [];

  BaseApiResponseWithSerializable<CompanyDetailResponse>? companyInfo;
  BaseApiResponseWithSerializable<JobOpportunityResponse>? jobInfo;

  TextEditingController rejectionReasonController = TextEditingController();

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (PreferenceUtils.getIsLogin() == 2 && Get.arguments != null) {
      if (Get.arguments[0]["selfPlacementDetail"] != null) {
        studentData?.add(Get.arguments[0]["selfPlacementDetail"]);

        if (studentData?[0].fields?.self_place_company_code?.isNotEmpty == true) {
          fetchCompanyInfo(studentData![0].fields!.self_place_company_code!.last);
        }
      }
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
              Container(
                margin: const EdgeInsets.all(10),
                child: studentData != null && studentData!.isNotEmpty
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: studentData?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                custom_text(
                                    text: strings_name.str_student_details,
                                    textStyles: centerTextStyle16,
                                    topValue: 0,
                                    maxLines: 2,
                                    bottomValue: 5,
                                    leftValue: 5),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(const StudentHistory(), arguments: studentData?[index].fields?.mobileNumber);
                                  },
                                  child: custom_text(
                                      text: "${studentData?[index].fields!.name}",
                                      textStyles: linkTextSemiBold14,
                                      topValue: 0,
                                      maxLines: 2,
                                      bottomValue: 5,
                                      leftValue: 5),
                                ),
                                custom_text(
                                    topValue: 0,
                                    bottomValue: 5,
                                    maxLines: 2,
                                    leftValue: 5,
                                    text: "Hub: ${Utils.getHubName(studentData?[index].fields?.hubIdFromHubIds![0])}",
                                    textStyles: blackTextSemiBold14),
                                custom_text(
                                    topValue: 0,
                                    bottomValue: 5,
                                    maxLines: 2,
                                    leftValue: 5,
                                    text: "Specialization: ${Utils.getSpecializationName(studentData?[index].fields?.specializationIds![0])}",
                                    textStyles: blackTextSemiBold14),
                                custom_text(
                                    topValue: 0,
                                    bottomValue: 5,
                                    leftValue: 5,
                                    text: "Semester: ${studentData?[index].fields?.semester}",
                                    textStyles: blackTextSemiBold14),
                                Visibility(
                                    visible: companyInfo != null,
                                    child: Column(
                                      children: [
                                        custom_text(
                                            text: strings_name.str_company_details,
                                            textStyles: centerTextStyle16,
                                            topValue: 0,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            topValue: 0,
                                            text: "Company name: ${companyInfo?.fields?.companyName}",
                                            textStyles: blackTextBold14,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            topValue: 0,
                                            text: "${strings_name.str_company_id_no}: ${companyInfo?.fields?.companyIdentityNumber}",
                                            textStyles: blackTextSemiBold14,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            topValue: 0,
                                            text: "${strings_name.str_contact_person}: ${companyInfo?.fields?.contactName}",
                                            textStyles: blackTextSemiBold14,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            topValue: 0,
                                            text: "${strings_name.str_contact_person_designation}: ${companyInfo?.fields?.contactDesignation}",
                                            textStyles: blackTextSemiBold14,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            topValue: 0,
                                            text: "${strings_name.str_contact_person_number}: ${companyInfo?.fields?.contactNumber}",
                                            textStyles: blackTextSemiBold14,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            topValue: 0,
                                            text: "${strings_name.str_contact_person_wanumber}: ${companyInfo?.fields?.contactWhatsappNumber}",
                                            textStyles: blackTextSemiBold14,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            topValue: 0,
                                            text: "${strings_name.str_contact_person_email}: ${companyInfo?.fields?.contactEmail}",
                                            textStyles: blackTextSemiBold14,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            topValue: 0,
                                            text: "${strings_name.str_company_website}: ${companyInfo?.fields?.companyWebsite}",
                                            textStyles: blackTextSemiBold14,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            topValue: 0,
                                            text: "${strings_name.str_reporting_branch}: ${companyInfo?.fields?.reporting_branch}",
                                            textStyles: blackTextSemiBold14,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            topValue: 0,
                                            text: "${strings_name.str_reporting_address}: ${companyInfo?.fields?.reporting_address}",
                                            textStyles: blackTextSemiBold14,
                                            maxLines: 3,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            topValue: 0,
                                            text: "${strings_name.str_city}: ${companyInfo?.fields?.city}",
                                            textStyles: blackTextSemiBold14,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        Row(children: [
                                          custom_text(
                                              text: "${strings_name.str_letter_of_intent}:",
                                              textStyles: blackTextSemiBold14,
                                              topValue: 0,
                                              maxLines: 2,
                                              bottomValue: 5,
                                              leftValue: 5),
                                          GestureDetector(
                                              onTap: () async {
                                                launchUrl(Uri.parse(companyInfo?.fields?.company_loi?.last.url ?? ""),
                                                    mode: LaunchMode.externalApplication);
                                              },
                                              child: custom_text(
                                                  text: "Show",
                                                  textStyles: primaryTextSemiBold16,
                                                  topValue: 0,
                                                  maxLines: 2,
                                                  bottomValue: 5,
                                                  leftValue: 0)),
                                        ]),
                                      ],
                                    )),
                                Visibility(
                                    visible: jobInfo != null,
                                    child: Column(
                                      children: [
                                        custom_text(
                                            text: strings_name.str_job_details,
                                            textStyles: centerTextStyle16,
                                            topValue: 0,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                          text: "${strings_name.str_job_title}: ${jobInfo?.fields?.jobTitle}",
                                          textStyles: blackTextBold14,
                                          topValue: 0,
                                          maxLines: 2,
                                          bottomValue: 5,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_job_desc}: ${jobInfo?.fields?.jobDescription}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 0,
                                          maxLines: 50000,
                                          bottomValue: 5,
                                          leftValue: 5,
                                        ),
                                        jobInfo?.fields?.stipendType == strings_name.str_amount_type_range
                                            ? custom_text(
                                                text:
                                                    "${strings_name.str_stipend_amount} ₹${jobInfo?.fields?.stipendRangeMin ?? 0} - ₹${jobInfo?.fields?.stipendRangeMax ?? 0}",
                                                textStyles: blackTextSemiBold14,
                                                topValue: 0,
                                                maxLines: 50000,
                                                bottomValue: 5,
                                                leftValue: 5,
                                              )
                                            : custom_text(
                                                text: "${strings_name.str_stipend_amount} ${strings_name.str_amount_type_interview}",
                                                textStyles: blackTextSemiBold14,
                                                topValue: 0,
                                                maxLines: 50000,
                                                bottomValue: 5,
                                                leftValue: 5,
                                              ),
                                        custom_text(
                                          text:
                                              "${strings_name.str_internship_timing}: ${jobInfo?.fields?.timingStart} - ${jobInfo?.fields?.timingEnd}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 0,
                                          maxLines: 50000,
                                          bottomValue: 5,
                                          leftValue: 5,
                                        ),
                                        jobInfo?.fields?.bond_structure?.isNotEmpty == true
                                            ? Row(children: [
                                                custom_text(
                                                    text: strings_name.str_bond_contract,
                                                    textStyles: blackTextSemiBold14,
                                                    topValue: 0,
                                                    maxLines: 2,
                                                    bottomValue: 5,
                                                    leftValue: 5),
                                                GestureDetector(
                                                    onTap: () async {
                                                      launchUrl(Uri.parse(jobInfo?.fields?.bond_structure?.last.url ?? ""),
                                                          mode: LaunchMode.externalApplication);
                                                    },
                                                    child: custom_text(
                                                        text: "Show",
                                                        textStyles: primaryTextSemiBold16,
                                                        topValue: 0,
                                                        maxLines: 2,
                                                        bottomValue: 5,
                                                        leftValue: 0)),
                                              ])
                                            : Container(),
                                        jobInfo?.fields?.incentive_structure?.isNotEmpty == true
                                            ? Row(children: [
                                                custom_text(
                                                    text: "${strings_name.str_incentive_structure} :",
                                                    textStyles: blackTextSemiBold14,
                                                    topValue: 0,
                                                    maxLines: 2,
                                                    bottomValue: 5,
                                                    leftValue: 5),
                                                GestureDetector(
                                                    onTap: () async {
                                                      launchUrl(Uri.parse(jobInfo?.fields?.incentive_structure?.last.url ?? ""),
                                                          mode: LaunchMode.externalApplication);
                                                    },
                                                    child: custom_text(
                                                        text: "Show",
                                                        textStyles: primaryTextSemiBold16,
                                                        topValue: 0,
                                                        maxLines: 2,
                                                        bottomValue: 5,
                                                        leftValue: 0)),
                                              ])
                                            : Container(),
                                        custom_text(
                                          text: "${strings_name.str_internship_mode}: ${jobInfo?.fields?.internshipModes}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 0,
                                          maxLines: 50000,
                                          bottomValue: 5,
                                          leftValue: 5,
                                        ),
                                        custom_text(
                                          text: "${strings_name.str_internship_min_duration} ${jobInfo?.fields?.internshipDuration}",
                                          textStyles: blackTextSemiBold14,
                                          topValue: 0,
                                          maxLines: 50000,
                                          bottomValue: 5,
                                          leftValue: 5,
                                        ),
                                      ],
                                    )),
                                Visibility(
                                    visible: companyInfo != null && companyInfo?.fields?.rejection_reason?.isNotEmpty == true,
                                    child: Column(
                                      children: [
                                        custom_text(
                                            text: strings_name.str_rejection_remarks,
                                            textStyles: centerTextStyle16,
                                            topValue: 0,
                                            maxLines: 2,
                                            bottomValue: 5,
                                            leftValue: 5),
                                        custom_text(
                                            text: companyInfo?.fields?.rejection_reason ?? "",
                                            textStyles: blackTextSemiBold14,
                                            topValue: 0,
                                            maxLines: 5000,
                                            bottomValue: 5,
                                            leftValue: 5),
                                      ],
                                    )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          approveDialog(studentData?[index]);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: colors_name.presentColor,
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
                                          primary: colors_name.errorColor,
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
                                )
                              ],
                            ),
                          );
                        })
                    : Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: custom_text(
                            text: strings_name.str_no_jobs_approval_pending, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
              )
            ],
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
          )
        ],
      ),
    ));
  }

  Future<void> fetchCompanyInfo(String lastSelfPlaceCompanyDetail) async {
    setState(() {
      isVisible = true;
    });
    try {
      var query = "AND(${TableNames.CLM_COMPANY_CODE}='$lastSelfPlaceCompanyDetail')";

      var data = await apiRepository.getSelfPlaceCompanyDetailApi(query);
      if (data.records!.isNotEmpty) {
        companyInfo = data.records!.last;

        if (companyInfo?.fields!.self_job_code?.isNotEmpty == true) {
          var lastSelfPlaceJobDetail = companyInfo?.fields?.self_job_code?.last;
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

  Future<void> rejectionDialog(BaseApiResponseWithSerializable<LoginFieldsResponse>? studentData) async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          custom_text(
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

  Future<void> approveDialog(BaseApiResponseWithSerializable<LoginFieldsResponse>? studentData) async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          custom_text(
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
                        Get.back(closeOverlays: true);
                        Get.back(result: true);
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

            // getRecords();
            await Future.delayed(const Duration(milliseconds: 2000));
            Get.back(result: false);
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
