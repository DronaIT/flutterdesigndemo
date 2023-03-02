import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/models/request/add_placement_attendance_data.dart';
import 'package:flutterdesigndemo/models/request/create_job_opportunity_request.dart';
import 'package:flutterdesigndemo/models/update_job_opportunity.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
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
  String attendanceFilePath = "", consentFilePath = "";

  var cloudinary;

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    if (Get.arguments != null) {
      jobRecordId = Get.arguments;
    }
    getRecords();
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    try{
      jobOpportunityData = await apiRepository.getJobOpportunityWithRecordIdApi(jobRecordId);
      setState(() {
        isVisible = false;
      });
    }on DioError catch (e) {
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
                      SizedBox(height: 5.h),
                      custom_text(text: "${strings_name.str_company_name} : ${jobOpportunityData.fields?.companyName?.first}", textStyles: blackTextSemiBold15, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 5),
                      SizedBox(height: 5.h),
                      custom_text(text: "${strings_name.str_joining_date} : ${jobOpportunityData.fields?.joiningDate}", textStyles: blackTextSemiBold15, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 5),
                      SizedBox(height: 5.h),
                      Row(children: [
                        custom_text(text: "${strings_name.str_letter_of_intent} : ", textStyles: blackTextSemiBold15, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 5),
                        GestureDetector(
                            onTap: () async {
                              await launchUrl(Uri.parse(jobOpportunityData.fields?.company_loi?.first.url ?? ""), mode: LaunchMode.externalApplication);
                            },
                            child: custom_text(text: "Show", textStyles: primaryTextSemiBold14, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 0)),
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
                      Visibility(visible: consentFilePath.isNotEmpty, child: custom_text(text: attendanceFilePath, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0)),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          custom_text(
                            leftValue: 5,
                            text: strings_name.str_attendence,
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
                      Visibility(visible: attendanceFilePath.isNotEmpty, child: custom_text(text: attendanceFilePath, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0)),
                      SizedBox(height: 8.h),
                      CustomButton(
                          text: strings_name.str_submit,
                          click: () async {
                            if (attendanceFilePath.isEmpty && consentFilePath.isEmpty) {
                              Utils.showSnackBar(context, strings_name.str_empty_placement_attendance_data);
                            } else {
                              setState(() {
                                isVisible = true;
                              });

                              var attendancePath = "", consentPath = "";
                              AddPlacementAttendanceData request = AddPlacementAttendanceData();
                              if (attendanceFilePath.isNotEmpty) {
                                CloudinaryResponse response = await cloudinary.uploadFile(
                                  CloudinaryFile.fromFile(attendanceFilePath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_PLACEMENT_ATTENDANCE),
                                );
                                attendancePath = response.secureUrl;
                              }
                              if (consentFilePath.isNotEmpty) {
                                CloudinaryResponse response = await cloudinary.uploadFile(
                                  CloudinaryFile.fromFile(consentFilePath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_LOC),
                                );
                                consentPath = response.secureUrl;
                              }

                              if (attendancePath.isNotEmpty) {
                                Map<String, dynamic> map = Map();
                                map["url"] = attendancePath;
                                List<Map<String, dynamic>> listData = [];
                                listData.add(map);

                                request.attendance_form = listData;
                              }
                              if (consentPath.isNotEmpty) {
                                Map<String, dynamic> map = Map();
                                map["url"] = consentPath;
                                List<Map<String, dynamic>> listData = [];
                                listData.add(map);

                                request.company_loc = listData;
                              }
                              request.job_id = jobRecordId.split(",");
                              request.student_id = PreferenceUtils.getLoginRecordId().split(",");

                              var json = request.toJson();
                              json.removeWhere((key, value) => value == null);
                               try{
                                 var resp = await apiRepository.updatePlacementInfoApi(json);
                                 if (resp.id!.isNotEmpty) {
                                   setState(() {
                                     isVisible = false;
                                   });
                                   Utils.showSnackBar(context, strings_name.str_placement_info_updated);
                                   await Future.delayed(const Duration(milliseconds: 2000));
                                   Get.back(closeOverlays: true, result: true);
                                 } else {
                                   setState(() {
                                     isVisible = false;
                                   });
                                 }
                               }on DioError catch (e) {
                                 setState(() {
                                   isVisible = false;
                                 });
                                 final errorMessage = DioExceptions.fromDioError(e).toString();
                                 Utils.showSnackBarUsingGet(errorMessage);
                               }

                            }
                          }),
                    ],
                  ),
                )
              : Container(),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }

  picAttendanceFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        attendanceFilePath = result.files.single.path!;
      });
    }
  }

  picConsent() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        consentFilePath = result.files.single.path!;
      });
    }
  }
}
