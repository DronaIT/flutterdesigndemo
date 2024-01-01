import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/ui/announcements/announcement_detail.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/add_button.dart';
import '../../customwidget/announcements_card.dart';
import '../../customwidget/app_widgets.dart';
import '../../models/announcement_response.dart';
import '../../models/base_api_response.dart';
import '../../utils/preference.dart';
import '../../utils/tablenames.dart';
import '../../utils/utils.dart';
import 'add_announcement.dart';

class AllAnnouncements extends StatefulWidget {
  const AllAnnouncements({super.key});

  @override
  State<AllAnnouncements> createState() => _AllAnnouncementsState();
}

class _AllAnnouncementsState extends State<AllAnnouncements> {
  final apiRepository = getIt.get<ApiRepository>();

  var loginId = "";
  var isLogin = 0;

  bool isVisible = false;

  bool canAddAnnouncements = false;
  bool canEditAnnouncements = false;
  bool canShowAnnouncements = false;
  bool announcementsEmpty = false;

  List<BaseApiResponseWithSerializable<AnnouncementResponse>> announcement = [];

  var employeeId;

  String loginType = "";
  var loginData;

  bool isListUpdate = false;

  @override
  initState() {
    super.initState();
    getPermission();
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
      loginData = PreferenceUtils.getLoginData();
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
      var data = await apiRepository.getPermissionsApi(query);
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
      // Utils.showSnackBarUsingGet(errorMessage);
    } finally {
      if (canShowAnnouncements) {
        fetchAnnouncements();
      }
      setState(() {});
      // setState(() {
      //   isVisible = false;
      // });
    }
  }

  String offset = "";

  fetchAnnouncements() async {
    try {
      var query = "AND(OR(${TableNames.ANNOUNCEMENT_ROLE_EMPLOYEE == loginType ? '{created_by} = $loginId,' : ''}{for}=\"everyone\",AND({for}=\"$loginType\",{is_all}=1),AND({for}=\"$loginType\",{is_all}=0,";

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
        // for(var data in loginData.semester??[]){
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

      var data = await apiRepository.fetchAnnouncementListApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          announcement.clear();
        }
        announcement.addAll(data.records as Iterable<BaseApiResponseWithSerializable<AnnouncementResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchAnnouncements();
        } else {
          await filterData();
        }
        setState(() {
          announcementsEmpty = announcement.isEmpty;
          isVisible = false;
        });
      } else {
        setState(() {
          announcementsEmpty = true;
          isVisible = false;
        });
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
      setState(() {
        announcementsEmpty = true;
        isVisible = false;
      });
    } catch (e) {
      final errorMessage = e.toString();
      Utils.showSnackBarUsingGet(errorMessage);
      setState(() {
        announcementsEmpty = true;
        isVisible = false;
      });
    }
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (isListUpdate) {
            Get.back(result: 'updateAnnouncement');
          } else {
            Get.back();
          }
          return true;
        },
        child: Scaffold(
          appBar: AppWidgets.appBarWithAction(
            strings_name.announcements,
            [
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.filter_alt),
              // ),
            ],
          ),
          body: isVisible
              ? const Center(
                  child: CircularProgressIndicator(
                    color: colors_name.colorPrimary,
                    strokeWidth: 5.0,
                  ),
                )
              : ListView(
                  children: [
                    Visibility(
                      visible: canAddAnnouncements,
                      child: Container(
                        margin: EdgeInsets.only(top: 14.h, bottom: 10.h),
                        child: AddButton(
                          onTap: () async {
                            var result = await Get.to(AddAnnouncement());
                            if (result == 'updateAnnouncement') {
                              isListUpdate = true;
                              announcement.clear();
                              fetchAnnouncements();
                            } else if (result == 'addAnnouncement') {
                              isListUpdate = true;
                              announcement.clear();
                              fetchAnnouncements();
                            }
                          },
                          title: strings_name.add_announcements_icon,
                        ),
                      ),
                    ),
                    announcementsEmpty
                        ? SizedBox(
                            height: 0.5.sh,
                            child: const Center(
                              child: Text('No Announcement Found'),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 10.h),
                            itemCount: announcement.length,
                            itemBuilder: (context, index) {
                              var data = announcement[index];
                              return AnnouncementsCard(
                                margin: EdgeInsets.symmetric(vertical: 5.h),
                                onEdit: canEditAnnouncements && data.fields!.employeeIdFromCreatedBy.contains(employeeId)
                                    ? () async {
                                        var result = await Get.to(
                                          AddAnnouncement(
                                            announcementData: data,
                                          ),
                                        );
                                        if (result == 'updateAnnouncement') {
                                          Utils.showSnackBar(context, strings_name.str_announcement_updated);
                                          isListUpdate = true;
                                          announcement.clear();
                                          fetchAnnouncements();
                                        } else if (result == 'addAnnouncement') {
                                          Utils.showSnackBar(context, strings_name.str_announcement_added);
                                          isListUpdate = true;
                                          announcement.clear();
                                          fetchAnnouncements();
                                        }
                                      }
                                    : null,
                                // margin: EdgeInsets.symmetric(horizontal: 10.w),
                                data: data,
                                onTap: () async {
                                  var result = await Get.to(AnnouncementDetail(
                                    announcement: data,
                                    isEdit: canEditAnnouncements && data.fields!.employeeIdFromCreatedBy.contains(employeeId),
                                  ));
                                  if (result == 'updateAnnouncement') {
                                    Utils.showSnackBar(context, strings_name.str_announcement_updated);
                                    announcement.clear();
                                    isListUpdate = true;
                                    fetchAnnouncements();
                                  } else if (result == 'addAnnouncement') {
                                    Utils.showSnackBar(context, strings_name.str_announcement_added);
                                    isListUpdate = true;
                                    announcement.clear();
                                    fetchAnnouncements();
                                  }
                                },
                              );
                            }),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}
