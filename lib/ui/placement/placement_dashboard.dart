import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/ui/placement/assign_placement_executive.dart';
import 'package:flutterdesigndemo/ui/placement/assign_placement_executive_new.dart';
import 'package:flutterdesigndemo/ui/placement/job_opportunity_form.dart';
import 'package:flutterdesigndemo/ui/placement/job_opportunity_list.dart';
import 'package:flutterdesigndemo/ui/placement/placement_attendance_data_reports.dart';
import 'package:flutterdesigndemo/ui/placement/add_placement_marks.dart';
import 'package:flutterdesigndemo/ui/placement/appear_for_interview_student.dart';
import 'package:flutterdesigndemo/ui/placement/applied_internship.dart';
import 'package:flutterdesigndemo/ui/placement/apply_for_internship.dart';
import 'package:flutterdesigndemo/ui/placement/approve_placement_attendance.dart';
import 'package:flutterdesigndemo/ui/placement/approve_self_placements.dart';
import 'package:flutterdesigndemo/ui/placement/company_approach.dart';
import 'package:flutterdesigndemo/ui/placement/company_detail.dart';
import 'package:flutterdesigndemo/ui/placement/company_list.dart';
import 'package:flutterdesigndemo/ui/placement/completed_internship_list.dart';
import 'package:flutterdesigndemo/ui/placement/issue_warning_letter.dart';
import 'package:flutterdesigndemo/ui/placement/placement_info.dart';
import 'package:flutterdesigndemo/ui/placement/selected_for_internship.dart';
import 'package:flutterdesigndemo/ui/placement/self_placement_student.dart';
import 'package:flutterdesigndemo/ui/placement/shortlisted_for_internship.dart';
import 'package:flutterdesigndemo/ui/placement/upload_documents_placement.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../models/base_api_response.dart';
import '../../models/typeofsectoreresponse.dart';
import 'approved_internship.dart';
import 'filter_placement_screen_student.dart';
import 'published_internship.dart';
import 'selected_student.dart';
import 'shortlist_students.dart';

class PlacementDashboard extends StatefulWidget {
  const PlacementDashboard({Key? key}) : super(key: key);

  @override
  State<PlacementDashboard> createState() => _PlacementDashboardState();
}

class _PlacementDashboardState extends State<PlacementDashboard> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();

  // For employee
  bool companyApproach = false, createCompany = false, getCompanyDetail = false, editCompanyDetail = false, createJobsAlerts = false, viewJobAlerts = false;
  bool pendingForApprovalPhase = false, publishedPhase = false, shortListingPhase = false, appearForInterviewPhase = false, selectStudentPhase = false, completedInternShip = false, isBanned = false;
  bool pendingForApprovalPhaseFinal = false,
      publishedPhaseFinal = false,
      shortListingPhaseFinal = false,
      appearForInterviewPhaseFinal = false,
      selectStudentPhaseFinal = false,
      completedInternShipFinal = false;
  bool approveSelfPlacements = false, placementDrive = false, issueWarningLetter = false, approvePlacementAttendance = false;
  bool companyProcessVisible = false, internshipProcessVisible = false, finalPlacementProcessVisible = false, placementReportsVisible = false, warningLettersVisible = false;
  bool placedUnplacedList = false, placementAttendanceDataReports = false;

  // For employees and company
  bool addPlacementMarks = false, assignPlacementExecutives = false;

  // For student
  bool applyInternship = false, appliedInternship = false;
  bool shortListedInternship = false, selectedInternship = false, uploadResume = false, selfPlacement = false;
  bool applyInternshipFinal = false, appliedInternshipFinal = false, shortListedInternshipFinal = false, selectedInternshipFinal = false;
  bool placementProcessStudent = false, finalPlacementProcessStudent = false;

  BaseLoginResponse<TypeOfSectorResponse> typeOfResponse = BaseLoginResponse();

  @override
  void initState() {
    super.initState();
    if (PreferenceUtils.getIsLogin() == 1 && PreferenceUtils.getLoginData().is_banned.toString() == "1") {
      isBanned = true;
      getPermission();
    } else if (PreferenceUtils.getIsLogin() == 1 && (PreferenceUtils.getLoginData().placedJob?.length ?? 0) > 0 && PreferenceUtils.getLoginData().is_placed_now == "1") {
      Get.to(const PlacementInfo(), arguments: PreferenceUtils.getLoginData().placedJob?.first);
    } else {
      getPermission();
    }
  }

  Future<void> getPermission() async {
    setState(() {
      isVisible = true;
    });
    try {
      typeOfResponse = await apiRepository.getSectorApi();
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
    if (typeOfResponse.records!.isNotEmpty) {
      PreferenceUtils.setTypeofList(typeOfResponse);
    }
    var query = "";
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      query = "AND(FIND('${TableNames.STUDENT_ROLE_ID}',role_ids)>0,module_ids='${TableNames.MODULE_PLACEMENT}')";
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      query = "AND(FIND('${loginData.roleIdFromRoleIds!.join(',')}',role_ids)>0,module_ids='${TableNames.MODULE_PLACEMENT}')";
    } else if (isLogin == 3) {
      query = "AND(FIND('${TableNames.ORGANIZATION_ROLE_ID}',role_ids)>0,module_ids='${TableNames.MODULE_PLACEMENT}')";
    }
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          /*
          *   Company Process
          */
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_COMPANY_APPROCH) {
            companyApproach = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_CREATE_COMPANY) {
            createCompany = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_GET_COMPANY_DETAIL) {
            getCompanyDetail = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_EDIT_COMPANY_DETAIL) {
            editCompanyDetail = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_JOBALERTS) {
            createJobsAlerts = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEWJOBS) {
            viewJobAlerts = true;
          }

          /*
          *   Regular Internship Process
          */
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPROVED_INTERSHIP) {
            pendingForApprovalPhase = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_PUBLISHED_INTERSHIP) {
            publishedPhase = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_SHORTlIST_STUDENTS) {
            shortListingPhase = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPEAR_FOR_INTERVIEW) {
            appearForInterviewPhase = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_SELECTED_STUDENT) {
            selectStudentPhase = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_COMPLETED_INTERNSHIP) {
            completedInternShip = true;
          }

          /*
          *   Final Placement Process
          */
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPROVED_INTERSHIP_FINAL) {
            pendingForApprovalPhaseFinal = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_PUBLISHED_INTERSHIP_FINAL) {
            publishedPhaseFinal = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_SHORTlIST_STUDENTS_FINAL) {
            shortListingPhaseFinal = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPEAR_FOR_INTERVIEW_FINAL) {
            appearForInterviewPhaseFinal = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_SELECTED_STUDENT_FINAL) {
            selectStudentPhaseFinal = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_COMPLETED_INTERNSHIP_FINAL) {
            completedInternShipFinal = true;
          }

          /*
          *   Regular Internship Process - For students
          */
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPLY_INTERNSHIP) {
            applyInternship = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPLIED_INTERNSHIP) {
            appliedInternship = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_SHORT_LISTED_INTERNSHIP) {
            shortListedInternship = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_SELECTED_INTERNSHIP) {
            selectedInternship = true;
          }

          /*
          *   Final Placement Process - For students
          */
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPLY_INTERNSHIP_FINAL) {
            applyInternshipFinal = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPLIED_INTERNSHIP_FINAL) {
            appliedInternshipFinal = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_SHORT_LISTED_INTERNSHIP_FINAL) {
            shortListedInternshipFinal = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_SELECTED_INTERNSHIP_FINAL) {
            selectedInternshipFinal = true;
          }

          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPLOAD_RESUME) {
            uploadResume = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_PLACED_UNPLACED_STUDENT_LIST) {
            placedUnplacedList = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_PLACEMENT_ATTENDANCE_DATA_REPORTS) {
            placementAttendanceDataReports = false;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ENABLE_SELFPLACE) {
            selfPlacement = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPROVE_SELF_PLACEMENTS) {
            approveSelfPlacements = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_PLACEMENT_DRIVE) {
            placementDrive = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ISSUE_WARNING_LETTER) {
            issueWarningLetter = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPROVE_PLACEMENT_ATTENDANCE_DATA) {
            approvePlacementAttendance = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_PLACEMENT_MARKS) {
            addPlacementMarks = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ASSIGN_PLACEMENT_EXECUTIVE) {
            assignPlacementExecutives = true;
          }
        }
        setState(() {});
      } else {
        Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }

    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_placement),
      body: Stack(
        children: [
          Visibility(
            visible: !isBanned,
            child: Container(
              margin: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Visibility(
                        visible: companyApproach || createCompany || getCompanyDetail,
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(strings_name.str_company_process, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                      Icon(companyProcessVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  companyProcessVisible = !companyProcessVisible;
                                  setState(() {});
                                },
                              ),
                              Container(
                                height: companyProcessVisible ? 1.h : 0,
                                color: colors_name.darkGrayColor,
                              ),
                              Visibility(
                                visible: companyApproach && companyProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_company_approach, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const CompanyApproach());
                                  },
                                ),
                              ),
                              Visibility(
                                visible: createCompany && companyProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_create_company, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const CompanyDetail());
                                  },
                                ),
                              ),
                              Visibility(
                                visible: getCompanyDetail && companyProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      custom_text(
                                          text: PreferenceUtils.getIsLogin() != 3 ? strings_name.str_view_create_company : strings_name.str_company_detail,
                                          textAlign: TextAlign.center,
                                          textStyles: blackTextSemiBold14,
                                          topValue: 0,
                                          bottomValue: 0),
                                      const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                    ]),
                                  ),
                                  onTap: () {
                                    if (PreferenceUtils.getIsLogin() != 3) {
                                      Get.to(() => const CompanyList(), arguments: editCompanyDetail);
                                    } else {
                                      var companyData = PreferenceUtils.getLoginDataOrganization();
                                      Get.to(const CompanyDetail(), arguments: companyData.company_code);
                                    }
                                  },
                                ),
                              ),
                              Visibility(
                                visible: createJobsAlerts && companyProcessVisible && PreferenceUtils.getIsLogin() == 3,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      custom_text(
                                          text: strings_name.str_create_job_alert,
                                          textAlign: TextAlign.center,
                                          textStyles: blackTextSemiBold14,
                                          topValue: 0.h,
                                          bottomValue: 0),
                                      const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                    ]),
                                  ),
                                  onTap: () {
                                    if (PreferenceUtils.getIsLogin() == 3) {
                                      Get.to(() => const JobOpportunityForm(), arguments: [
                                        {"company_id": PreferenceUtils.getLoginRecordId()},
                                        {"job_code": ""},
                                      ]);
                                    }
                                  }
                                ),
                              ),
                              Visibility(
                                visible: viewJobAlerts && companyProcessVisible && PreferenceUtils.getIsLogin() == 3,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      custom_text(
                                          text: strings_name.str_list_job_opp_detail,
                                          textAlign: TextAlign.center,
                                          textStyles: blackTextSemiBold14,
                                          topValue: 0.h,
                                          bottomValue: 0),
                                      const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                    ]),
                                  ),
                                  onTap: () {
                                    if (PreferenceUtils.getIsLogin() == 3) {
                                      var companyData = PreferenceUtils.getLoginDataOrganization();
                                      Get.to(() => const JobOpportunityList(), arguments: [
                                        {"updateJobOppList": true},
                                        {"companyId": companyData.id},
                                        {"companyName": companyData.companyName}
                                      ]);
                                    }
                                  }
                                ),
                              )
                            ],
                          ),
                        )),
                    Visibility(
                        visible: pendingForApprovalPhase || publishedPhase || shortListingPhase || appearForInterviewPhase || selectStudentPhase || completedInternShip,
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(strings_name.str_internship_process, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                      Icon(internshipProcessVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  internshipProcessVisible = !internshipProcessVisible;
                                  setState(() {});
                                },
                              ),
                              Container(
                                height: internshipProcessVisible ? 1.h : 0,
                                color: colors_name.darkGrayColor,
                              ),
                              Visibility(
                                visible: pendingForApprovalPhase && internshipProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_approved_internship, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const ApprovedInternship(), arguments: [
                                      {"placementType": 0}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: publishedPhase && internshipProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_published_internship, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const PublishedInternship(), arguments: [
                                      {"placementType": 0}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: shortListingPhase && internshipProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_sortlist_student, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const ShortListStudent(), arguments: [
                                      {"placementType": 0}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: appearForInterviewPhase && internshipProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_appear_for_interview_student, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const AppearForInterviewStudent(), arguments: [
                                      {"placementType": 0}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: selectStudentPhase && internshipProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_select_student, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const SelectedStudentList(), arguments: [
                                      {"placementType": 0}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: completedInternShip && internshipProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_completed_placement, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const CompletedInternList(), arguments: [
                                      {"placementType": 0}
                                    ]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                    Visibility(
                        visible: pendingForApprovalPhaseFinal || publishedPhaseFinal || shortListingPhaseFinal || appearForInterviewPhaseFinal || selectStudentPhaseFinal || completedInternShipFinal,
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(strings_name.str_final_placement_process, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                      Icon(finalPlacementProcessVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  finalPlacementProcessVisible = !finalPlacementProcessVisible;
                                  setState(() {});
                                },
                              ),
                              Container(
                                height: finalPlacementProcessVisible ? 1.h : 0,
                                color: colors_name.darkGrayColor,
                              ),
                              Visibility(
                                visible: pendingForApprovalPhaseFinal && finalPlacementProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_approved_jobs, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const ApprovedInternship(), arguments: [
                                      {"placementType": 1}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: publishedPhaseFinal && finalPlacementProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_published_jobs, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const PublishedInternship(), arguments: [
                                      {"placementType": 1}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: shortListingPhaseFinal && finalPlacementProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_sortlist_student, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const ShortListStudent(), arguments: [
                                      {"placementType": 1}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: appearForInterviewPhaseFinal && finalPlacementProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_appear_for_interview_student, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const AppearForInterviewStudent(), arguments: [
                                      {"placementType": 1}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: selectStudentPhaseFinal && finalPlacementProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_select_student, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const SelectedStudentList(), arguments: [
                                      {"placementType": 1}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: completedInternShipFinal && finalPlacementProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_completed_jobs, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const CompletedInternList(), arguments: [
                                      {"placementType": 1}
                                    ]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                    Visibility(
                        visible: applyInternship || appliedInternship || shortListedInternship || selectedInternship,
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(strings_name.str_internship_process, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                      Icon(internshipProcessVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  internshipProcessVisible = !internshipProcessVisible;
                                  setState(() {});
                                },
                              ),
                              Container(
                                height: internshipProcessVisible ? 1.h : 0,
                                color: colors_name.darkGrayColor,
                              ),
                              Visibility(
                                visible: applyInternship && internshipProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_apply_internship, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const ApplyForInternship(), arguments: [
                                      {"placementType": 0}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: appliedInternship && internshipProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_applied_jobs, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const AppliedInternship(), arguments: [
                                      {"placementType": 0}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: shortListedInternship && internshipProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_short_listed_jobs, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const ShortListedForInternship(), arguments: [
                                      {"placementType": 0}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: selectedInternship && internshipProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_selected_for_jobs, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const SelectedForInternship(), arguments: [
                                      {"placementType": 0}
                                    ]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                    Visibility(
                        visible: applyInternshipFinal || appliedInternshipFinal || shortListedInternshipFinal || selectedInternshipFinal,
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(strings_name.str_final_placement_process, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                      Icon(finalPlacementProcessVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  finalPlacementProcessVisible = !finalPlacementProcessVisible;
                                  setState(() {});
                                },
                              ),
                              Container(
                                height: finalPlacementProcessVisible ? 1.h : 0,
                                color: colors_name.darkGrayColor,
                              ),
                              Visibility(
                                visible: applyInternshipFinal && finalPlacementProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_apply_jobs, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const ApplyForInternship(), arguments: [
                                      {"placementType": 1}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: appliedInternshipFinal && finalPlacementProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_applied_job, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const AppliedInternship(), arguments: [
                                      {"placementType": 1}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: shortListedInternshipFinal && finalPlacementProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_short_listed_job, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const ShortListedForInternship(), arguments: [
                                      {"placementType": 1}
                                    ]);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: selectedInternshipFinal && finalPlacementProcessVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_selected_for_job, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const SelectedForInternship(), arguments: [
                                      {"placementType": 1}
                                    ]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                    Visibility(
                      visible: uploadResume,
                      child: GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(strings_name.str_upload_resume, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const UploadDocumentsPlacement());
                        },
                      ),
                    ),
                    Visibility(
                      visible: selfPlacement,
                      child: GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(strings_name.str_self_placement, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const SelfPlacementStudent());
                        },
                      ),
                    ),
                    Visibility(
                      visible: placementDrive,
                      child: GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(strings_name.str_placement_drive, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const SelfPlacementStudent());
                        },
                      ),
                    ),
                    Visibility(
                      visible: approveSelfPlacements,
                      child: GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(strings_name.str_approve_self_placement, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const ApproveSelfPlacements());
                        },
                      ),
                    ),
                    Visibility(
                      visible: approvePlacementAttendance,
                      child: GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(strings_name.str_approve_placement_attendance, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const ApprovePlacementAttendance());
                        },
                      ),
                    ),
                    Visibility(
                      visible: placedUnplacedList || placementAttendanceDataReports,
                      child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(strings_name.str_placement_reports, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                      Icon(placementReportsVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  placementReportsVisible = !placementReportsVisible;
                                  setState(() {});
                                },
                              ),
                              Container(
                                height: placementReportsVisible ? 1.h : 0,
                                color: colors_name.darkGrayColor,
                              ),
                              Visibility(
                                visible: placedUnplacedList && placementReportsVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_placed_unplaced_student, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const FilterPlacementScreenStudent());
                                  },
                                ),
                              ),
                              Visibility(
                                visible: placementAttendanceDataReports && placementReportsVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_placement_attendance_data_reports, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const PlacementAttendanceDataReport());
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                    Visibility(
                      visible: issueWarningLetter,
                      child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(strings_name.str_warning_letters, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                      Icon(warningLettersVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  warningLettersVisible = !warningLettersVisible;
                                  setState(() {});
                                },
                              ),
                              Container(
                                height: warningLettersVisible ? 1.h : 0,
                                color: colors_name.darkGrayColor,
                              ),
                              Visibility(
                                visible: issueWarningLetter && warningLettersVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_issue_warning_letter_1, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const IssueWarningLetter(), arguments: [
                                      {"title": strings_name.str_issue_warning_letter_1},
                                      {"letterType": 1},
                                    ])?.then((result) {
                                      if (result != null && result) {
                                        // Get.back(closeOverlays: true);
                                      }
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: issueWarningLetter && warningLettersVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_issue_warning_letter_2, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const IssueWarningLetter(), arguments: [
                                      {"title": strings_name.str_issue_warning_letter_2},
                                      {"letterType": 2},
                                    ])?.then((result) {
                                      if (result != null && result) {
                                        // Get.back(closeOverlays: true);
                                      }
                                    });
                                  },
                                ),
                              ),
                              Visibility(
                                visible: issueWarningLetter && warningLettersVisible,
                                child: GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        custom_text(text: strings_name.str_issue_warning_letter_3, textAlign: TextAlign.center, textStyles: blackTextSemiBold14, topValue: 0, bottomValue: 0),
                                        Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => const IssueWarningLetter(), arguments: [
                                      {"title": strings_name.str_issue_warning_letter_3},
                                      {"letterType": 3},
                                    ])?.then((result) {
                                      if (result != null && result) {
                                        // Get.back(closeOverlays: true);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                    Visibility(
                      visible: addPlacementMarks,
                      child: GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(strings_name.str_add_placement_marks, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          if (PreferenceUtils.getIsLogin() == 3) {
                            var companyData = PreferenceUtils.getLoginDataOrganization();
                            Get.to(() => const AddPlacementMarks(), arguments: [
                              {"companyCode": companyData.company_code},
                              {"companyId": PreferenceUtils.getLoginRecordId()},
                            ]);
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: assignPlacementExecutives,
                      child: GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(strings_name.str_assign_placement_executive, textAlign: TextAlign.center, style: blackTextSemiBold16),
                                Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          if (PreferenceUtils.getIsLogin() == 2) {
                            Get.to(() => const AssignPlacementExecutiveNew());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: isBanned,
                child: Card(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  elevation: 5,
                  child: Container(
                    color: colors_name.colorWhite,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: const Text(strings_name.str_banned_from_placement, textAlign: TextAlign.start, style: blackTextSemiBold16),
                  ),
                ),
              ),
              Visibility(
                visible: isBanned && selfPlacement,
                child: GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(strings_name.str_self_placement, textAlign: TextAlign.center, style: blackTextSemiBold16),
                            Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(() => const SelfPlacementStudent());
                  },
                ),
              ),
            ],
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
