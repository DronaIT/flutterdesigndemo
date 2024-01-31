import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../models/announcement_response.dart';
import '../../models/base_api_response.dart';
import '../../models/request/update_announcement_request.dart';
import '../../utils/preference.dart';
import '../../utils/tablenames.dart';
import '../../values/text_styles.dart';
import 'add_announcement.dart';

class AnnouncementDetail extends StatefulWidget {
  final BaseApiResponseWithSerializable<AnnouncementResponse> announcement;
  final bool isEdit;

  const AnnouncementDetail({super.key, required this.announcement, required this.isEdit});

  @override
  State<AnnouncementDetail> createState() => _AnnouncementDetailState();
}

class _AnnouncementDetailState extends State<AnnouncementDetail> {
  bool isEdit = false;

  @override
  void initState() {
    isEdit = widget.isEdit;
    super.initState();
    getPermission();
    addViewBy();
  }

  var isLogin = 0;
  bool isVisible = false;
  bool canAddAnnouncements = false;
  bool canRemoveAnnouncements = false;
  var loginData;
  String loginType = "";
  var loginId = "";
  var employeeId;

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
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_ANNOUNCEMENT) {
            canAddAnnouncements = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_REMOVE_ANNOUNCEMENT) {
            canRemoveAnnouncements = true;
          }
        }
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
    } catch (e) {
      setState(() {
        isVisible = false;
      });
    }
  }

  addViewBy() {
    var data = widget.announcement;
    isLogin = PreferenceUtils.getIsLogin();
    String createdBy = PreferenceUtils.getLoginRecordId();
    if (isLogin == 2 && data.fields?.createdBy.first == createdBy) {
    } else {
      updateReadyBy();
    }
  }

  final apiRepository = getIt.get<ApiRepository>();

  updateReadyBy() async {
    try {
      var announcementData = widget.announcement;

      List<UpdateAttachment>? updateAttachments = [];
      for (var data in announcementData.fields?.attachments ?? []) {
        updateAttachments.add(UpdateAttachment(url: data.url));
      }

      List<String>? seenByEmployees = announcementData.fields?.seenByEmployees ?? [];
      List<String>? seenByStudents = announcementData.fields?.seenByStudents ?? [];

      String createdBy = PreferenceUtils.getLoginRecordId();

      if (seenByEmployees.contains(createdBy) || seenByStudents.contains(createdBy)) {
        return;
      }

      if (isLogin == 2) {
        if (!seenByEmployees.contains(createdBy)) {
          seenByEmployees.add(createdBy);
        }
      } else if (isLogin == 1) {
        if (!seenByStudents.contains(createdBy)) {
          seenByStudents.add(createdBy);
        }
      }

      // return;
      UpdateAnnouncementRequest updateAnnouncementRequest = UpdateAnnouncementRequest(records: [
        UpdateRecord(
          id: announcementData.id ?? '',
          fields: UpdateFields(
            title: announcementData.fields?.title ?? '',
            description: announcementData.fields?.description ?? '',
            image: announcementData.fields?.image ?? '',
            fieldsFor: announcementData.fields?.announcementResponseFor ?? '',
            isAll: announcementData.fields?.isAll ?? false,
            isActive: 1,
            attachments: updateAttachments,
            createdBy: [announcementData.fields?.createdBy.first ?? ''],
            updatedBy: [announcementData.fields?.createdBy.first ?? ''],
            hubIds: announcementData.fields?.hubIds ?? [],
            specializationIds: announcementData.fields?.specializationIds ?? [],
            semesters: announcementData.fields?.semesters ?? [],
            divisions: announcementData.fields?.divisions ?? [],
            seenByEmployees: seenByEmployees,
            seenByStudents: seenByStudents,
          ),
        )
      ]);

      var dataUpdate = await apiRepository.updateAnnouncementDataApi(updateAnnouncementRequest.toJson(), announcementData.id ?? '');
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppWidgets.appBarWithAction(strings_name.announcements, [
          Visibility(
            visible: canAddAnnouncements,
            child: GestureDetector(
              onTap: () async {
                var result = await Get.to(const AddAnnouncement(isFromDetailScreen: true));
                if (result == 'updateAnnouncement') {
                  Get.back(result: 'addAnnouncement');
                }
                // Utils.showSnackBar(context, strings_name.str_announcement_added);
              },
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                height: 32.h,
                width: 32.h,
                decoration: BoxDecoration(
                  color: colors_name.colorWhite.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: colors_name.colorWhite,
                ),
              ),
            ),
          ),
          Visibility(
            visible: isEdit && !isVisible,
            child: GestureDetector(
              onTap: () async {
                var result = await Get.to(AddAnnouncement(
                  announcementData: widget.announcement,
                ));
                if (result == 'updateAnnouncement') {
                  Get.back(result: 'updateAnnouncement');
                }
                // Utils.showSnackBar(context, strings_name.str_announcement_updated);
              },
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                height: 32.h,
                width: 32.h,
                decoration: BoxDecoration(
                  color: colors_name.colorWhite.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: colors_name.colorWhite,
                ),
              ),
            ),
          ),
        ]),
        body: isVisible
            ? const Center(
                child: CircularProgressIndicator(
                  color: colors_name.colorPrimary,
                ),
              )
            : ListView(
                children: [
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: kIsWeb ? MediaQuery.of(context).size.height * 0.35 : 200.h,
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.announcement.fields?.image ?? '',
                          fit: BoxFit.fill,
                          width: 1.sw,
                          height: kIsWeb ? MediaQuery.of(context).size.height * 0.35 : 200.h,
                          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: colors_name.colorBlack.withOpacity(0.4),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.w, bottom: 16.h, right: 10.w),
                            child: Text(
                              widget.announcement.fields?.title ?? '',
                              style: whiteTextSemiBold20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: SelectableLinkify(
                      text: widget.announcement.fields?.description ?? '',
                      style: blackText16,
                      onOpen: (link) async {
                        await launchUrl(Uri.parse(link.url), mode: LaunchMode.externalApplication);
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.announcement.fields?.attachments?.isNotEmpty ?? false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          SizedBox(
                            height: 8.h,
                          ),
                          const Text(
                            '${strings_name.str_attachments} : ',
                            style: blackTextSemiBold16,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.announcement.fields?.attachments?.length ?? 0,
                              itemBuilder: (context, index) {
                                var data = widget.announcement.fields?.attachments?[index];
                                return Card(
                                  elevation: 5,
                                  child: Container(
                                    color: colors_name.colorWhite,
                                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text("${data?.filename}", textAlign: TextAlign.start, style: blackTextSemiBold16)),
                                        GestureDetector(
                                            onTap: () async {
                                              await launchUrl(Uri.parse(data?.url ?? ''), mode: LaunchMode.externalApplication);
                                            },
                                            child: const Icon(Icons.download, size: 30, color: colors_name.colorPrimary))
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                      visible: canRemoveAnnouncements,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.h),
                        child: CustomButton(
                          text: strings_name.str_remove_announcement,
                          click: () {
                            confirmationDialog();
                          },
                        ),
                      )),
                ],
              ),
      ),
    );
  }

  Future<void> confirmationDialog() async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          custom_text(
            text: 'Are you sure you want to remove this announcement?',
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
                        removeAnnouncement();
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

  removeAnnouncement() async {
    try {
      Map<String, dynamic> request = {"is_active": 0};

      var dataUpdate = await apiRepository.removeAnnouncementDataApi(request, widget.announcement.id ?? '');

      if (dataUpdate.records != null) {
        setState(() {
          isVisible = false;
        });
        // Utils.showSnackBar(context, strings_name.str_announcement_removed);
        // await Future.delayed(const Duration(milliseconds: 2000));
        Get.back(result: 'updateAnnouncement');
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
