import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/ui/placement/applied_internship.dart';
import 'package:flutterdesigndemo/ui/placement/apply_for_internship.dart';
import 'package:flutterdesigndemo/ui/placement/company_approach.dart';
import 'package:flutterdesigndemo/ui/placement/company_detail.dart';
import 'package:flutterdesigndemo/ui/placement/company_list.dart';
import 'package:flutterdesigndemo/ui/placement/completed_internship_list.dart';
import 'package:flutterdesigndemo/ui/placement/placement_info.dart';
import 'package:flutterdesigndemo/ui/placement/selected_for_internship.dart';
import 'package:flutterdesigndemo/ui/placement/shortlisted_for_internship.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../models/base_api_response.dart';
import '../../models/typeofsectoreresponse.dart';
import 'approved_internship.dart';
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
  bool companyApproach = false, createCompany = false, getCompanyDetail = false, editCompanyDetail = false, createJobsAlerts = false;
  bool publishedList = false, approvedList = false, shortListed = false, selectedStudent = false, isBanned = false;

  // For student
  bool applyInternship = false, appliedInternship = false, completedInternShip = false, shortListedInternship = false, selectedInternship = false;

  BaseLoginResponse<TypeOfsectoreResponse> typeOfResponse = BaseLoginResponse();

  @override
  void initState() {
    super.initState();
    if (PreferenceUtils.getIsLogin() == 1 && PreferenceUtils.getLoginData().is_banned.toString() == "1") {
      isBanned = true;
    } else if (PreferenceUtils.getIsLogin() == 1 && (PreferenceUtils.getLoginData().placedJob?.length ?? 0) > 0) {
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
    }
    var data = await apiRepository.getPermissionsApi(query);
    if (data.records!.isNotEmpty) {
      for (var i = 0; i < data.records!.length; i++) {
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_COMPANY_APPROCH) {
          setState(() {
            companyApproach = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_CREATE_COMPANY) {
          setState(() {
            createCompany = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_GET_COMPANY_DETAIL) {
          setState(() {
            getCompanyDetail = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_EDIT_COMPANY_DETAIL) {
          setState(() {
            editCompanyDetail = true;
          });
        }

        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_JOBALERTS) {
          setState(() {
            createJobsAlerts = true;
          });
        }

        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPLY_INTERNSHIP) {
          setState(() {
            applyInternship = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPLIED_INTERNSHIP) {
          setState(() {
            appliedInternship = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_SHORT_LISTED_INTERNSHIP) {
          setState(() {
            shortListedInternship = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_PUBLISHED_INTERSHIP) {
          setState(() {
            publishedList = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPROVED_INTERSHIP) {
          setState(() {
            approvedList = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_SELECTED_STUDENT) {
          setState(() {
            selectedStudent = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_SHORTlIST_STUDENTS) {
          setState(() {
            shortListed = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_SELECTED_INTERNSHIP) {
          setState(() {
            selectedInternship = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_COMPLETED_INTERNSHIP) {
          setState(() {
            completedInternShip = true;
          });
        }
      }
    } else {
      Utils.showSnackBar(context, strings_name.str_something_wrong);
    }
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_dashboard),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                Visibility(
                  visible: companyApproach,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_company_approach, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const CompanyApproach());
                    },
                  ),
                ),
                Visibility(
                  visible: createCompany,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_create_company, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const CompanyDetail());
                    },
                  ),
                ),
                Visibility(
                  visible: getCompanyDetail,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_view_create_company, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const GetCompanyDetail(), arguments: editCompanyDetail);
                    },
                  ),
                ),
                // Visibility(
                //   visible: createJobsAlerts,
                //   child: GestureDetector(
                //     child: Card(
                //       elevation: 5,
                //       child: Container(
                //         color: colors_name.colorWhite,
                //         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: const [Text(strings_name.str_create_job_alert, textAlign: TextAlign.center, style: blackTextSemiBold16),
                //             Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                //         ),
                //       ),
                //     ),
                //     onTap: () {
                //       Get.to(() => const JobOpportunityForm());
                //     },
                //   ),
                // ),
                //SizedBox(height: 5.h),
                Visibility(
                  visible: applyInternship,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_apply_internship, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const ApplyForInternship());
                    },
                  ),
                ),
                Visibility(
                  visible: appliedInternship,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_applied_jobs, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const AppliedInternship());
                    },
                  ),
                ),
                Visibility(
                  visible: shortListedInternship,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_short_listed_jobs, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const ShortListedForInternship());
                    },
                  ),
                ),
                Visibility(
                  visible: approvedList,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_approved_internship, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const ApprovedInternship());
                    },
                  ),
                ),
                Visibility(
                  visible: publishedList,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_published_internship, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const PublishInternship());
                    },
                  ),
                ),
                Visibility(
                  visible: shortListed,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_sortlist_student, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const ShortListStudent());
                    },
                  ),
                ),

                Visibility(
                  visible: selectedStudent,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_selected_student, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const SelectedStudentList());
                    },
                  ),
                ),

                Visibility(
                  visible: selectedInternship,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_selected_for_jobs, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const SelectedForInternship());
                    },
                  ),
                ),
                Visibility(
                  visible: completedInternShip,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_completed_placement, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const CompletedInternList());
                    },
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isBanned,
            child: Card(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              elevation: 5,
              child: Container(
                color: colors_name.colorWhite,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: const Text(strings_name.str_banned_from_placement, textAlign: TextAlign.start, style: blackTextSemiBold16),
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
