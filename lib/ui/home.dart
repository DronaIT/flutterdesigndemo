import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/home_module_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/academic_details.dart';
import 'package:flutterdesigndemo/ui/ask/ask_dashboard.dart';
import 'package:flutterdesigndemo/ui/attendance/attendance.dart';
import 'package:flutterdesigndemo/ui/student_referral/my_referrals.dart';
import 'package:flutterdesigndemo/ui/student_referral/referral_terms.dart';
import 'package:flutterdesigndemo/ui/authentication/login.dart';
import 'package:flutterdesigndemo/ui/fees/fees_dashboard.dart';
import 'package:flutterdesigndemo/ui/helpdesk/helpdesk_dashboard.dart';
import 'package:flutterdesigndemo/ui/hub_setup/setup_collage.dart';
import 'package:flutterdesigndemo/ui/manage_user/manage_user.dart';
import 'package:flutterdesigndemo/ui/manage_user/student_extra_detail.dart';
import 'package:flutterdesigndemo/ui/marketing/marketing_dashboard.dart';
import 'package:flutterdesigndemo/ui/mis/mis_dashboard.dart';
import 'package:flutterdesigndemo/ui/placement/placement_dashboard.dart';
import 'package:flutterdesigndemo/ui/placement/placement_info.dart';
import 'package:flutterdesigndemo/ui/profile.dart';
import 'package:flutterdesigndemo/ui/punch_leaves/punch_dashboard.dart';
import 'package:flutterdesigndemo/ui/settings_screen.dart';
import 'package:flutterdesigndemo/ui/student_history/filter_screen_student.dart';
import 'package:flutterdesigndemo/ui/student_referral/add_student_referral.dart';
import 'package:flutterdesigndemo/ui/student_referral/student_referrals.dart';
import 'package:flutterdesigndemo/ui/task/task_dashboard.dart';
import 'package:flutterdesigndemo/ui/time_table/time_table_list.dart';
import 'package:flutterdesigndemo/ui/upload_documents.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

import '../../customwidget/announcements_card.dart';
import '../api/dio_exception.dart';
import '../customwidget/custom_pageIndicator.dart';
import '../models/announcement_response.dart';
import '../utils/pdf_api.dart';
import '../utils/utils.dart';
import 'announcements/add_announcement.dart';
import 'announcements/all_announcements.dart';
import 'announcements/announcement_detail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isVisible = false;

  final homeRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<homeModuleResponse> homeModule = BaseLoginResponse();

  String name = "";
  String phone = "";
  String roleName = "";

  bool isNoNewAnnouncements = false;
  bool canAddAnnouncements = false;
  bool canEditAnnouncements = false;
  bool canShowAnnouncements = false;

  List<BaseApiResponseWithSerializable<AnnouncementResponse>> announcement = [];
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String warningLetterDisplayType = "";
  String warningLetterString = "";

  Future<void> getRecords(String roleId) async {
    // var query = "AND(SEARCH('$roleId',${TableNames.CLM_ROLE_ID},0))";
    var query = "AND(SEARCH('$roleId',${TableNames.CLM_ROLE_ID},0),is_active=1)";
    setState(() {
      isVisible = true;
    });
    try {
      homeModule = await homeRepository.getHomeModulesApi(query);
      if (homeModule.records!.isNotEmpty) {
        setState(() {
          isVisible = false;
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

    getPermission();
  }

  var loginId = "";
  var isLogin = 0;
  var employeeId;
  String loginType = "";
  var loginData;

  PageController pageController = PageController();
  int currentPageValue = 0;
  Timer? _timer;

  Future<void> getPermission() async {
    var roleId = "";
    isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      roleId = TableNames.STUDENT_ROLE_ID;
      loginData = PreferenceUtils.getLoginData();
      // loginId = PreferenceUtils.getLoginData().studentId.toString();
      loginId = loginData.studentId.toString();
      loginType = TableNames.ANNOUNCEMENT_ROLE_STUDENT;
    } else if (isLogin == 2) {
      loginData = PreferenceUtils.getLoginDataEmployee();
      roleId = loginData.roleIdFromRoleIds!.join(',');
      loginId = loginData.employeeId.toString();
      employeeId = loginData.employeeId;
      loginType = TableNames.ANNOUNCEMENT_ROLE_EMPLOYEE;
    } else if (isLogin == 3) {
      loginData = PreferenceUtils.getLoginDataOrganization();
      roleId = TableNames.ORGANIZATION_ROLE_ID;
      loginId = PreferenceUtils.getLoginDataOrganization().id.toString();
      loginType = TableNames.ANNOUNCEMENT_ROLE_ORGANIZATION;
    }

    var query = "AND(FIND('$roleId',role_ids)>0,module_ids='${TableNames.MODULE_ANNOUNCEMENT}')";

    try {
      var data = await homeRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_ANNOUNCEMENT) {
            canShowAnnouncements = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_ANNOUNCEMENT) {
            canAddAnnouncements = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_ANNOUNCEMENT) {
            canEditAnnouncements = true;
          }
        }
        if (canShowAnnouncements) {
          fetchAnnouncements();
        }
      } else {
        setState(() {});
      }
    } on DioError catch (e) {
      setState(() {});
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  String offset = "";
  bool isAnnouncementLoading = false;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (currentPageValue < announcement.length) {
        currentPageValue += 1;
      } else {
        currentPageValue = 0;
      }
      pageController.animateToPage(
        currentPageValue.toInt(),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  fetchAnnouncements() async {
    setState(() {
      isAnnouncementLoading = true;
    });
    try {
      var query =
          "AND(AND(IS_AFTER({created_on},DATETIME_PARSE(DATETIME_FORMAT(DATEADD(NOW(),-1,'day'),'YYYY-MM-DDTHH:mm:ss.SSSZ'),'YYYY-MM-DDTHH:mm:ss.SSSZ')),IS_BEFORE({created_on},DATETIME_PARSE(DATETIME_FORMAT(NOW(),'YYYY-MM-DDTHH:mm:ss.SSSZ'),'YYYY-MM-DDTHH:mm:ss.SSSZ'))),";
      query += "OR(${TableNames.ANNOUNCEMENT_ROLE_EMPLOYEE == loginType ? '{created_by} = $loginId,' : ''}{for}=\"everyone\",AND({for}=\"$loginType\",{is_all}=1),AND({for}=\"$loginType\",{is_all}=0,";
      query += "OR(";
      if (isLogin == 1) {
        if (loginData.semester != null) {
          query += "FIND(\"${loginData.semester}\", ARRAYJOIN({semesters}))";
        }
        if (loginData.hubIdFromHubIds != null) {
          for (int i = 0; i < loginData.hubIdFromHubIds.length; i++) {
            query += "${i == 0 ? ',' : ''}FIND(\"${loginData.hubIdFromHubIds[i]}\", ARRAYJOIN({hub_id (from hub_ids)}))";
          }
        }
        if (loginData.specializationIdFromSpecializationIds != null) {
          for (var data in loginData.specializationIdFromSpecializationIds) {
            query += ",FIND(\"$data\", ARRAYJOIN({specialization_id (from specialization_ids)}))";
          }
        }
        if (loginData.division != null) {
          query += ",FIND(\"${loginData.division}\", ARRAYJOIN({divisions}))";
        }
      }

      /// Employee
      else if (isLogin == 2) {
        if (loginData.hubIdFromHubIds != null) {
          for (int i = 0; i < loginData.hubIdFromHubIds.length; i++) {
            query += "${i == 0 ? '' : ','}FIND(\"${loginData.hubIdFromHubIds[i]}\", ARRAYJOIN({hub_id (from hub_ids)}))";
          }
        }
        if (loginData.accessible_hub_ids != null) {
          for (int i = 0; i < loginData.accessible_hub_ids.length; i++) {
            query += ",FIND(\"${loginData.accessible_hub_ids[i]}\", ARRAYJOIN({hub_id (from hub_ids)}))";
          }
        }
      }
      query += '))))';
      isNoNewAnnouncements = true;

      var data = await homeRepository.fetchAnnouncementListApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          announcement.clear();
        }
        announcement.addAll(data.records as Iterable<BaseApiResponseWithSerializable<AnnouncementResponse>>);
        await filterData();
        offset = data.offset;
        if (_timer == null) {
          _startTimer();
        }
        setState(() {
          isNoNewAnnouncements = announcement.isEmpty;
          isAnnouncementLoading = false;
        });
      } else {
        setState(() {
          isNoNewAnnouncements = true;
          isAnnouncementLoading = false;
        });
      }
    } on DioError catch (e) {
      setState(() {
        isAnnouncementLoading = false;
        isNoNewAnnouncements = true;
      });
    } catch (e) {
      final errorMessage = e.toString();
      Utils.showSnackBarUsingGet(errorMessage);
      setState(() {
        isAnnouncementLoading = false;
        isNoNewAnnouncements = true;
      });
    }
    debugPrint('../ fetchAnnouncement ');
  }

  filterData() {
    if (announcement.isNotEmpty) {
      if (PreferenceUtils.getIsLogin() == 1) {
        var loginData = PreferenceUtils.getLoginData();
        for (int i = 0; i < announcement.length; i++) {
          if (announcement[i].fields?.isActive == 1) {
            if (announcement[i].fields?.isAll != true) {
              if (announcement[i].fields?.announcementResponseFor == TableNames.ANNOUNCEMENT_ROLE_STUDENT) {
                bool removed = false;
                if (announcement[i].fields?.hubIdFromHubIds?.isNotEmpty == true) {
                  if (announcement[i].fields?.hubIdFromHubIds?.contains(loginData.hubIdFromHubIds?.last) != true) {
                    announcement.removeAt(i);
                    i--;
                    removed = true;
                  }
                }
                if (!removed && announcement[i].fields?.specializationIdFromSpecializationIds?.isNotEmpty == true) {
                  if (announcement[i].fields?.specializationIdFromSpecializationIds?.contains(loginData.specializationIdFromSpecializationIds?.last) != true) {
                    announcement.removeAt(i);
                    i--;
                    removed = true;
                  }
                }
                if (!removed && announcement[i].fields?.semesters?.isNotEmpty == true) {
                  if (announcement[i].fields?.semesters?.contains(loginData.semester) != true) {
                    announcement.removeAt(i);
                    i--;
                    removed = true;
                  }
                }
                if (!removed && announcement[i].fields?.divisions?.isNotEmpty == true) {
                  if (announcement[i].fields?.divisions?.contains(loginData.division) != true) {
                    announcement.removeAt(i);
                    i--;
                    removed = true;
                  }
                }
              }
            }
          } else {
            announcement.removeAt(i);
            i--;
          }
        }
      } else if (PreferenceUtils.getIsLogin() == 2) {
        var loginData = PreferenceUtils.getLoginDataEmployee();
        for (int i = 0; i < announcement.length; i++) {
          if (announcement[i].fields?.isActive == 1) {
            if (announcement[i].fields?.isAll != true) {
              if (announcement[i].fields?.announcementResponseFor == TableNames.ANNOUNCEMENT_ROLE_EMPLOYEE) {
                if (announcement[i].fields?.hubIdFromHubIds?.isNotEmpty == true) {
                  bool contains = false;
                  if (announcement[i].fields?.hubIdFromHubIds?.contains(loginData.hubIdFromHubIds?.last) == true) {
                    contains = true;
                  }
                  if (!contains && loginData.accessible_hub_ids?.isNotEmpty == true) {
                    for (int j = 0; j < loginData.accessible_hub_ids!.length; j++) {
                      if (announcement[i].fields?.hubIdFromHubIds?.contains(loginData.accessible_hub_ids![j]) == true) {
                        contains = true;
                        break;
                      }
                    }
                  }

                  if (!contains) {
                    announcement.removeAt(i);
                    i--;
                  }
                }
              }
            }
          } else {
            announcement.removeAt(i);
            i--;
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      var loginData = PreferenceUtils.getLoginData();
      name = loginData.name.toString();
      phone = loginData.mobileNumber.toString();
      getRecords(TableNames.STUDENT_ROLE_ID);
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      name = loginData.employeeName.toString();
      phone = loginData.mobileNumber.toString();
      getRecords(loginData.roleIdFromRoleIds![0]);
    } else if (isLogin == 3) {
      var loginData = PreferenceUtils.getLoginDataOrganization();
      name = loginData.companyName.toString();
      phone = loginData.contactNumber.toString();
      getRecords(TableNames.ORGANIZATION_ROLE_ID);
    }

    if (isLogin == 1) {
      LoginFieldsResponse loginData = PreferenceUtils.getLoginData();
      if (loginData.warning_letter_3_for_appearing?.isNotEmpty == true) {
        warningLetterDisplayType = strings_name.str_warning_letter_3_issued;
        warningLetterString = loginData.warning_letter_3_for_appearing!;
      } else if (loginData.warning_letter_3_for_applying?.isNotEmpty == true) {
        warningLetterDisplayType = strings_name.str_warning_letter_3_issued;
        warningLetterString = loginData.warning_letter_3_for_applying!;
      } else if (loginData.warning_letter_2_for_appearing?.isNotEmpty == true) {
        warningLetterDisplayType = strings_name.str_warning_letter_2_issued;
        warningLetterString = loginData.warning_letter_2_for_appearing!;
      } else if (loginData.warning_letter_2_for_applying?.isNotEmpty == true) {
        warningLetterDisplayType = strings_name.str_warning_letter_2_issued;
        warningLetterString = loginData.warning_letter_2_for_applying!;
      } else if (loginData.warning_letter_1_for_appearing?.isNotEmpty == true) {
        warningLetterDisplayType = strings_name.str_warning_letter_1_issued;
        warningLetterString = loginData.warning_letter_1_for_appearing!;
      } else if (loginData.warning_letter_1_for_applying?.isNotEmpty == true) {
        warningLetterDisplayType = strings_name.str_warning_letter_1_issued;
        warningLetterString = loginData.warning_letter_1_for_applying!;
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_home),
      drawer: Drawer(
        width: 300,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 200,
              child: DrawerHeader(
                child: Column(
                  children: [
                    Image.asset(
                      AppImage.ic_launcher,
                      height: 100,
                      width: 100,
                    ),
                    custom_text(
                      text: name,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      bottomValue: 0,
                      leftValue: 5,
                      rightValue: 5,
                    ),
                    custom_text(
                      text: phone,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      topValue: 5,
                      bottomValue: 0,
                      leftValue: 5,
                      rightValue: 5,
                    ),
                  ],
                ),
              ),
            ),
            buildMenuItem(
              text: strings_name.str_profile,
              icon: Icons.person,
              onClicked: () => selectedItem(context, 0),
            ),
            buildMenuItem(
              text: strings_name.str_settings,
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 1),
            ),
            buildMenuItem(
              text: strings_name.str_logout,
              icon: Icons.logout,
              onClicked: () => selectedItem(context, 2),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          homeModule.records?.isNotEmpty == true
              ? ListView(
                  children: [
                    Visibility(visible: canShowAnnouncements, child: announcementSection()),
                    Visibility(
                        visible: warningLetterString.isNotEmpty,
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(color: colors_name.colorWhite, borderRadius: BorderRadius.circular(10.r)),
                            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(warningLetterDisplayType, textAlign: TextAlign.center, style: primaryTextSemiBold16, maxLines: 2),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.error_outline_sharp, color: colors_name.colorPrimary),
                                  label: const Text("View", style: primaryTextSemiBold15),
                                  onPressed: () async {
                                    final pdfFile = await PdfApi.generateCenteredText(warningLetterString, warningLetterDisplayType);
                                    OpenFilex.open(pdfFile.path);
                                  },
                                ),
                              ],
                            ),
                          ),
                        )),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 0, bottom: 20.h),
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      children: List.generate(
                        homeModule.records != null ? homeModule.records!.length : 0,
                        (index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                              child: Card(
                                  elevation: 10,
                                  child: Container(
                                    height: 300.h,
                                    decoration: BoxDecoration(color: colors_name.colorWhite, borderRadius: BorderRadius.circular(10.r)),
                                    child: GestureDetector(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.all(10.h),
                                              child: Image.network(homeModule.records![index].fields!.moduleImage.toString(),
                                                  fit: BoxFit.fill, errorBuilder: (context, url, error) => const Center(child: Icon(Icons.error))),
                                            ),
                                          ),
                                          custom_text(
                                            text: homeModule.records![index].fields!.moduleTitle.toString(),
                                            alignment: Alignment.center,
                                            textAlign: TextAlign.center,
                                            textStyles: blackTextSemiBold14,
                                            maxLines: 3,
                                            topValue: 0,
                                            bottomValue: 5.h,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_MANAGE_USER) {
                                          Get.to(const ManageUser());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_ACADEMIC_DETAIL) {
                                          Get.to(const AcademicDetails());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_SETUP_COLLAGE) {
                                          Get.to(const SetupCollage());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_ATTENDANCE) {
                                          Get.to(const Attendance());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_PLACEMENT) {
                                          if (PreferenceUtils.getIsLogin() == 1) {
                                            if (PreferenceUtils.getLoginData().is_banned != 1 &&
                                                (PreferenceUtils.getLoginData().placedJob?.length ?? 0) > 0 &&
                                                PreferenceUtils.getLoginData().is_placed_now == "1") {
                                              Get.to(const PlacementInfo(), arguments: PreferenceUtils.getLoginData().placedJob?.last);
                                            } else {
                                              Get.to(const PlacementDashboard());
                                            }
                                          } else if (PreferenceUtils.getIsLogin() == 3) {
                                            Get.to(const PlacementDashboard());
                                          } else {
                                            Get.to(const PlacementDashboard());
                                          }
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_UPLOAD_DOCUMENT) {
                                          Get.to(const UploadDocuments());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_STUDENT_DIRECTORY) {
                                          Get.to(const FilterScreenStudent());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_HELP_DESK) {
                                          Get.to(const HelpdeskDashboard());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_TASK) {
                                          Get.to(const TaskDashboard());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_ANNOUNCEMENT) {
                                          Get.to(const AllAnnouncements());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_TIME_TABLE) {
                                          Get.to(const TimeTableList());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_NSDC_SKILL_INDIA) {
                                          Get.to(const StudentExtraDetail());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_MARKETING) {
                                          Get.to(const MarketingDashboard());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_FEES) {
                                          Get.to(const FeesDashboard());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_PUNCH_LEAVES) {
                                          Get.to(const PunchDashboard());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_MIS) {
                                          Get.to(const MISDashboard());
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_STUDENT_REFERRAL) {
                                          if (PreferenceUtils.getIsLogin() == 1) {
                                            Get.to(const MyReferrals());
                                          }else if (PreferenceUtils.getIsLogin() == 2) {
                                            Get.to(const StudentReferrals());
                                          }
                                        } else if (homeModule.records![index].fields?.moduleId == TableNames.MODULE_ASK_MODULE) {
                                          Get.to(const AskDashboard());
                                        }
                                      },
                                    ),
                                  )));
                        },
                      ),
                    ),
                  ],
                )
              : Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: custom_text(text: strings_name.str_no_module, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
                ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }

  Widget announcementSection() => Column(
        children: [
          Visibility(
            visible: isNoNewAnnouncements || canAddAnnouncements || canShowAnnouncements,
            child: SizedBox(height: 14.h),
          ),
          Visibility(
            visible: canShowAnnouncements,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    strings_name.announcements_ex,
                    style: blackTextSemiBold16,
                  ),
                  InkWell(
                      onTap: () async {
                        var result = await Get.to(() => const AllAnnouncements());
                        if (result == 'updateAnnouncement') {
                          announcement.clear();
                          fetchAnnouncements();
                        }
                      },
                      child: const Text(
                        strings_name.view_all,
                        style: primaryTextSemiBold14,
                      ))
                ],
              ),
            ),
          ),
          Visibility(
            // visible: !isNoNewAnnouncements && canAddAnnouncements,
            visible: canAddAnnouncements || canShowAnnouncements,
            child: SizedBox(height: 5.h),
          ),
          Visibility(
            visible: canAddAnnouncements,
            child: SizedBox(height: 6.h),
          ),
          Visibility(
              visible: !isNoNewAnnouncements,
              child: SizedBox(
                height: kIsWeb ? MediaQuery.of(context).size.height * 0.35 : 200.h,
                child: PageView.builder(
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: announcement.length,
                    onPageChanged: (int page) {
                      currentPageValue = page;
                    },
                    itemBuilder: (context, index) {
                      var item = announcement[index];
                      return AnnouncementsCard(
                        onEdit: canEditAnnouncements && item.fields!.employeeIdFromCreatedBy.contains(employeeId)
                            ? () async {
                                var result = await Get.to(() => AddAnnouncement(
                                      announcementData: item,
                                    ));
                                if (result == 'updateAnnouncement') {
                                  Utils.showSnackBar(context, strings_name.str_announcement_updated);
                                  announcement.clear();
                                  fetchAnnouncements();
                                } else if (result == 'addAnnouncement') {
                                  Utils.showSnackBar(context, strings_name.str_announcement_added);
                                  announcement.clear();
                                  fetchAnnouncements();
                                }
                              }
                            : null,
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        data: item,
                        onTap: () async {
                          var result = await Get.to(AnnouncementDetail(announcement: item, isEdit: canEditAnnouncements && item.fields!.employeeIdFromCreatedBy.contains(employeeId)));
                          if (result == 'updateAnnouncement') {
                            Utils.showSnackBar(context, strings_name.str_announcement_updated);
                            announcement.clear();
                            fetchAnnouncements();
                          }
                        },
                      );
                    }),
              )),
          Visibility(
              visible: !isNoNewAnnouncements,
              child: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: CustomPageIndicatorScrolling(
                  totalItems: announcement.length,
                  controller: pageController,
                ),
              )),
          Visibility(
            visible: isNoNewAnnouncements && !isAnnouncementLoading,
            child: Container(
              margin: EdgeInsets.only(top: 5.h, right: 10.w, left: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 25.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(color: colors_name.textColorGreyLight), borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    strings_name.no_new_announcements,
                    style: blackText18,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Get.to(() => const AllAnnouncements());
                          },
                          child: const Text(
                            strings_name.tap_here,
                            style: primryTextSemiBold14,
                          )),
                      SizedBox(width: 3.w),
                      const Text(
                        strings_name.to_see_all_announcements,
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.black;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Get.back();
        Get.to(const Profile());
        break;
      case 1:
        Get.back();
        Get.to(const Settings());
        break;
      case 2:
        Get.back();
        showAlertDialog(context, strings_name.str_sure_want_logout, () {
          PreferenceUtils.clearPreference();
          Get.offAll(const Login());
        });
        break;
    }
  }

  void showAlertDialog(BuildContext context, String message, Function yesOnPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message, style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal, fontFamily: 'Roboto')),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: <Widget>[
            TextButton(
              child: const Text(strings_name.str_cancle, style: blackTextSemiBold14),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                strings_name.str_yes,
                style: blackTextSemiBold14,
              ),
              onPressed: () {
                Navigator.pop(context);
                yesOnPressed();
              },
            )
          ],
        );
      },
    );
  }
}
