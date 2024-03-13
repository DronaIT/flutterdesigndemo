import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/request/add_placement_attendance_data.dart';
import 'package:flutterdesigndemo/models/update_job_opportunity.dart';
import 'package:flutterdesigndemo/ui/placement/leave_internship.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/dio_exception.dart';
import '../../values/text_styles.dart';

class PlacementInfo extends StatefulWidget {
  const PlacementInfo({Key? key}) : super(key: key);

  @override
  State<PlacementInfo> createState() => _PlacementInfoState();
}

class _PlacementInfoState extends State<PlacementInfo> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  UpdateJobOpportunity jobOpportunityData = UpdateJobOpportunity();
  String jobRecordId = "";
  String attendanceFilePath = "", consentFilePath = "", workbookFilePath = "";
  String attendanceFileName = "", consentFileName = "", workbookFileName = "";

  var cloudinary;
  bool canEnableResignationPermission = false;

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    if (Get.arguments != null) {
      jobRecordId = Get.arguments;
    }
    fetchUserDetail();
    getRecords();
    getPermission();
  }

  Future<void> fetchUserDetail() async {
    setState(() {
      isVisible = true;
    });
    var loginData = PreferenceUtils.getLoginData();
    var query = "FIND('${loginData.mobileNumber.toString()}', ${TableNames.TB_USERS_PHONE}, 0)";
    try {
      var data = await apiRepository.loginApi(query);
      if (data.records!.isNotEmpty) {
        await PreferenceUtils.setLoginData(data.records!.first.fields!);
        await PreferenceUtils.setLoginRecordId(data.records!.first.id!);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  Future<void> getPermission() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    var query = "";
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      query = "AND(FIND('${TableNames.STUDENT_ROLE_ID}',role_ids)>0,module_ids='${TableNames.MODULE_PLACEMENT}')";
    }
    try {
      if (isLogin == 1) {
        var data = await apiRepository.getPermissionsApi(query);
        if (data.records!.isNotEmpty) {
          for (var i = 0; i < data.records!.length; i++) {
            if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ENABLE_RESIGNATION) {
              canEnableResignationPermission = true;
            }
          }
        } else {
          Utils.showSnackBar(context, strings_name.str_something_wrong);
        }
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

  getRecords() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }
    try {
      jobOpportunityData = await apiRepository.getJobOpportunityWithRecordIdApi(jobRecordId);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_placement_info),
      body: Stack(
        children: [
          jobOpportunityData != null && jobOpportunityData.fields != null
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: custom_text(
                              text: strings_name.str_placement_info_upload_warning,
                              alignment: Alignment.topLeft,
                              maxLines: 10,
                              textStyles: primaryTextSemiBold16,
                              leftValue: 5,
                            ),
                          ),
                          Visibility(
                            visible: canEnableResignationPermission,
                            child: GestureDetector(
                              child: Image.asset(
                                AppImage.ic_resignation,
                                height: 24,
                                width: 24,
                              ),
                              onTap: () {
                                Get.to(const LeaveInternShip(), arguments: jobOpportunityData.fields?.jobCode)?.then((result) {
                                  if (result != null && result) {
                                    Get.back(closeOverlays: true);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      custom_text(
                          text: "${strings_name.str_company_name} : ${jobOpportunityData.fields?.companyName?.first}",
                          textStyles: blackTextSemiBold15,
                          topValue: 10,
                          maxLines: 2,
                          bottomValue: 5,
                          leftValue: 5),
                      SizedBox(height: 5.h),
                      custom_text(
                          text: "${strings_name.str_designation} : ${jobOpportunityData.fields?.jobTitle ?? ""}",
                          textStyles: blackTextSemiBold15,
                          topValue: 10,
                          maxLines: 3,
                          bottomValue: 5,
                          leftValue: 5),
                      SizedBox(height: 5.h),
                      custom_text(
                          text: "${strings_name.str_joining_date} : ${jobOpportunityData.fields?.joiningDate ?? ""}",
                          textStyles: blackTextSemiBold15,
                          topValue: 10,
                          maxLines: 2,
                          bottomValue: 5,
                          leftValue: 5),
                      SizedBox(height: 5.h),
                      Row(children: [
                        custom_text(text: "${strings_name.str_letter_of_intent} : ", textStyles: blackTextSemiBold15, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 5),
                        GestureDetector(
                            onTap: () async {
                              await launchUrl(Uri.parse(jobOpportunityData.fields?.company_loi?.last.url ?? ""), mode: LaunchMode.externalApplication);
                            },
                            child: custom_text(text: "Show", textStyles: primaryTextSemiBold16, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 0)),
                      ]),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          custom_text(
                            text: strings_name.str_letter_of_consent,
                            leftValue: 5,
                            alignment: Alignment.topLeft,
                            textStyles: blackTextSemiBold16,
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Row(children: [
                              GestureDetector(
                                child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black),
                                onTap: () {
                                  picConsent();
                                },
                              ),
                              custom_text(
                                text: strings_name.str_upload_file,
                                textStyles: blackTextSemiBold14,
                                leftValue: 5,
                              ),
                            ]),
                          ),
                        ],
                      ),
                      Visibility(
                          visible: consentFileName.isNotEmpty,
                          child: custom_text(text: consentFileName, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0, leftValue: 5)),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          custom_text(
                            leftValue: 5,
                            text: strings_name.str_attendance,
                            alignment: Alignment.topLeft,
                            textStyles: blackTextSemiBold16,
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Row(children: [
                              GestureDetector(
                                child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black),
                                onTap: () {
                                  picAttendanceFile();
                                },
                              ),
                              custom_text(
                                text: strings_name.str_upload_file,
                                textStyles: blackTextSemiBold14,
                                leftValue: 5,
                              ),
                            ]),
                          ),
                        ],
                      ),
                      Visibility(
                          visible: attendanceFileName.isNotEmpty,
                          child: custom_text(text: attendanceFileName, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0, leftValue: 5)),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          custom_text(
                            leftValue: 5,
                            text: strings_name.str_workbook,
                            alignment: Alignment.topLeft,
                            textStyles: blackTextSemiBold16,
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Row(children: [
                              GestureDetector(
                                child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black),
                                onTap: () {
                                  picWorkbookFile();
                                },
                              ),
                              custom_text(
                                text: strings_name.str_upload_file,
                                textStyles: blackTextSemiBold14,
                                leftValue: 5,
                              ),
                            ]),
                          ),
                        ],
                      ),
                      Visibility(
                          visible: workbookFileName.isNotEmpty,
                          child: custom_text(text: workbookFileName, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0, leftValue: 5)),
                      CustomButton(
                          text: strings_name.str_submit,
                          click: () async {
                            if (workbookFilePath.isEmpty && attendanceFilePath.isEmpty && consentFilePath.isEmpty) {
                              Utils.showSnackBar(context, strings_name.str_empty_documents);
                            } else {
                              if (attendanceFilePath.isNotEmpty) {
                                submitPlacementData(1);
                              }
                              if (consentFilePath.isNotEmpty) {
                                submitPlacementData(2);
                              }
                              if (workbookFilePath.isNotEmpty) {
                                submitPlacementData(3);
                              }
                            }
                          }),
                    ],
                  ),
                )
              : Container(),
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

  picAttendanceFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      if (result.files.single.size / (1024 * 1024) < 2) {
        setState(() {
          attendanceFilePath = result.files.single.path!;
          attendanceFileName = result.files.single.name;
        });
      } else {
        Utils.showSnackBar(context, strings_name.str_file_size_limit);
      }
    }
  }

  picWorkbookFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      if (result.files.single.size / (1024 * 1024) < 2) {
        setState(() {
          workbookFilePath = result.files.single.path!;
          workbookFileName = result.files.single.name;
        });
      } else {
        Utils.showSnackBar(context, strings_name.str_file_size_limit);
      }
    }
  }

  picConsent() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      if (result.files.single.size / (1024 * 1024) < 2) {
        setState(() {
          consentFilePath = result.files.single.path!;
          consentFileName = result.files.single.name;
        });
      } else {
        Utils.showSnackBar(context, strings_name.str_file_size_limit);
      }
    }
  }

  submitPlacementData(int type) async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }

    var attendancePath = "", consentPath = "", workbookPath = "";
    AddPlacementAttendanceData request = AddPlacementAttendanceData();
    if (type == 1 && attendanceFilePath.isNotEmpty) {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(attendanceFilePath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_PLACEMENT_ATTENDANCE),
      );
      attendancePath = response.secureUrl;
    }
    if (type == 2 && consentFilePath.isNotEmpty) {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(consentFilePath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_LOC),
      );
      consentPath = response.secureUrl;
    }
    if (type == 3 && workbookFilePath.isNotEmpty) {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(workbookFilePath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_WORKBOOK),
      );
      workbookPath = response.secureUrl;
    }

    if (attendancePath.isNotEmpty) {
      Map<String, dynamic> map = Map();
      map["url"] = attendancePath;
      List<Map<String, dynamic>> listData = [];
      listData.add(map);

      request.attendance_form = listData;
      request.placement_attendance_status = strings_name.str_pending;
    }
    if (consentPath.isNotEmpty) {
      Map<String, dynamic> map = Map();
      map["url"] = consentPath;
      List<Map<String, dynamic>> listData = [];
      listData.add(map);

      request.company_loc = listData;
      request.placement_company_loc_status = strings_name.str_pending;
    }
    if (workbookPath.isNotEmpty) {
      Map<String, dynamic> map = Map();
      map["url"] = workbookPath;
      List<Map<String, dynamic>> listData = [];
      listData.add(map);

      request.workbook = listData;
      request.placement_workbook_status = strings_name.str_pending;
    }
    request.job_id = jobRecordId.split(",");
    request.student_id = PreferenceUtils.getLoginRecordId().split(",");

    var json = request.toJson();
    json.removeWhere((key, value) => value == null);
    try {
      var resp = await apiRepository.updatePlacementInfoApi(json);
      if (resp.id!.isNotEmpty) {
        bool closeNow = false;
        if (type == 1 && consentFilePath.isEmpty && workbookFilePath.isEmpty) {
          closeNow = true;
        } else if (type == 2 && workbookFilePath.isEmpty) {
          closeNow = true;
        } else if (type == 3) {
          closeNow = true;
        }

        if (closeNow) {
          setState(() {
            isVisible = false;
          });

          Utils.showSnackBar(context, strings_name.str_placement_info_updated);
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
