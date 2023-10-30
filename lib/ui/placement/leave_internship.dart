import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/request/add_placement_attendance_data.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_edittext.dart';
import '../../models/base_api_response.dart';
import '../../models/job_opportunity_response.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class LeaveInternShip extends StatefulWidget {
  const LeaveInternShip({Key? key}) : super(key: key);

  @override
  State<LeaveInternShip> createState() => _LeaveInternShipState();
}

class _LeaveInternShipState extends State<LeaveInternShip> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<JobOpportunityResponse> jobOpportunityData = BaseLoginResponse();
  String jobCode = "";
  TextEditingController reasonForLeavingController = TextEditingController();
  TextEditingController noticePeriodDateController = TextEditingController();
  String resignationFilePath = "", resignationFileTitle = "";
  var cloudinary;

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    if (Get.arguments != null) {
      jobCode = Get.arguments;
    }
    getRecords();
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    var query = "FIND('$jobCode', ${TableNames.CLM_JOB_CODE}, 0)";
    try {
      jobOpportunityData = await apiRepository.getJobOppoApi(query);
      setState(() {
        isVisible = false;
        resignationConfirmationDialog();
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
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_leave_internship),
        body: Stack(
          children: [
            jobOpportunityData.records != null && jobOpportunityData.records?.first.fields != null
                ? Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        custom_text(text: "${strings_name.str_company_name} : ${jobOpportunityData.records?.first.fields?.companyName?.first ?? ""}", textStyles: blackTextSemiBold15, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 5),
                        SizedBox(height: 5.h),
                        custom_text(text: "${strings_name.str_designation} : ${jobOpportunityData.records?.first.fields?.jobTitle ?? ""}", textStyles: blackTextSemiBold15, topValue: 10, maxLines: 3, bottomValue: 5, leftValue: 5),
                        SizedBox(height: 5.h),
                        custom_text(text: "${strings_name.str_joining_date} : ${jobOpportunityData.records?.first.fields?.joiningDate ?? ""}", textStyles: blackTextSemiBold15, topValue: 10, maxLines: 2, bottomValue: 5, leftValue: 5),
                        SizedBox(height: 5.h),
                        custom_edittext(
                          type: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          controller: reasonForLeavingController,
                          hintText: strings_name.str_reason_for_leaving,
                          maxLines: 3,
                          minLines: 3,
                          maxLength: 50000,
                          topValue: 0,
                          margin: EdgeInsets.all(5.h),
                        ),
                        InkWell(
                          child: IgnorePointer(
                            child: custom_edittext(
                              hintText: strings_name.str_notice_period_date,
                              type: TextInputType.none,
                              textInputAction: TextInputAction.next,
                              controller: noticePeriodDateController,
                              topValue: 0,
                              margin: EdgeInsets.all(5.h),
                            ),
                          ),
                          onTap: () {
                            DateTime dateSelected = DateTime.now();
                            if (noticePeriodDateController.text.isNotEmpty) {
                              dateSelected = DateFormat("yyyy-MM-dd").parse(noticePeriodDateController.text);
                            }
                            showDatePicker(context: context, initialDate: dateSelected, firstDate: DateTime.now(), lastDate: DateTime(2100)).then((pickedDate) {
                              if (pickedDate == null) {
                                return;
                              }
                              setState(() {
                                var dateTime = pickedDate;
                                var formatter = DateFormat('yyyy-MM-dd');
                                var time = DateTime(dateTime.year, dateTime.month, dateTime.day);
                                noticePeriodDateController.text = formatter.format(time);
                              });
                            });
                          },
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            custom_text(
                              text: strings_name.str_resignation_letter,
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                              leftValue: 10,
                            ),
                            GestureDetector(
                              child: Container(margin: const EdgeInsets.only(right: 10), child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black)),
                              onTap: () {
                                picResignationLetter();
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: resignationFilePath.isNotEmpty,
                          child: Column(
                            children: [
                              SizedBox(height: 5.h),
                              custom_text(text: resignationFileTitle, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CustomButton(
                            text: strings_name.str_apply_for_leave,
                            click: () {
                              if (reasonForLeavingController.text.trim().isEmpty) {
                                Utils.showSnackBar(context, strings_name.str_empty_reason_for_leaving);
                              } else if (noticePeriodDateController.text.trim().isEmpty) {
                                Utils.showSnackBar(context, strings_name.str_empty_notice_period_date);
                              } else if (resignationFilePath.isEmpty) {
                                Utils.showSnackBar(context, strings_name.str_empty_resignation_letter);
                              } else {
                                sendResignation();
                              }
                            })

                        //Text
                      ],
                    ),
                  )
                : Container(),
            Center(
              child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
            )
          ],
        ),
      ),
    );
  }

  submitResignationData() async {
    setState(() {
      isVisible = true;
    });

    var resignationPath = "";
    AddPlacementAttendanceData request = AddPlacementAttendanceData();
    if (resignationFilePath.isNotEmpty) {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(resignationFilePath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_PLACEMENT_ATTENDANCE),
      );
      resignationPath = response.secureUrl;
    }

    if (resignationPath.isNotEmpty) {
      Map<String, dynamic> map = Map();
      map["url"] = resignationPath;
      List<Map<String, dynamic>> listData = [];
      listData.add(map);

      request.resignation_letter = listData;
    }

    request.resignation_reason = reasonForLeavingController.text;
    request.notice_period_end_date = noticePeriodDateController.text;
    request.job_id = jobOpportunityData.records?.first.id?.split(",");
    request.student_id = PreferenceUtils.getLoginRecordId().split(",");

    var json = request.toJson();
    json.removeWhere((key, value) => value == null);
    try {
      var resp = await apiRepository.updatePlacementInfoApi(json);
      if (resp.id!.isNotEmpty) {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_resignation_sent);
        await Future.delayed(const Duration(milliseconds: 2000));
        Get.back(closeOverlays: true, result: true);
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

  Future<void> sendResignation() async {
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

        Map<String, dynamic> requestParams = Map();
        requestParams[TableNames.CLM_IS_PLACED_NOW] = "0";
        requestParams[TableNames.CLM_HAS_RESIGNED] = 1;
        requestParams[TableNames.CLM_BANNED_FROM_PLACEMENT] = 1;

        var dataUpdate = await apiRepository.updateStudentDataApi(requestParams, data.records!.first.id!);
        if (dataUpdate.fields != null) {
          await PreferenceUtils.setLoginData(dataUpdate.fields!);
          await PreferenceUtils.setLoginRecordId(dataUpdate.id!);

          submitResignationData();
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

  picResignationLetter() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        resignationFilePath = result.files.single.path!;
        resignationFileTitle = result.files.single.name;
      });
    }
  }

  Future<void> resignationConfirmationDialog() async {
    Dialog errorDialog = Dialog(
      insetPadding: EdgeInsets.all(10.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.h)), //this right here
      child: Container(
        padding: EdgeInsets.all(10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            custom_text(text: 'Please confirm before resigning', textStyles: boldTitlePrimaryColorStyle),
            custom_text(
              text: strings_name.str_resignation_disclaimer,
              textStyles: blackTextSemiBold14,
              maxLines: 100,
            ),
            Row(children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: CustomButton(
                    text: strings_name.str_cancle,
                    click: () {
                      Get.back(closeOverlays: true);
                      Get.back();
                    }),
              ),
              SizedBox(width: 5.h),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: CustomButton(
                    text: strings_name.str_confirm,
                    click: () async {
                      Get.back(closeOverlays: true);
                    }),
              ),
            ])
          ],
        ),
      ),
    );
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => errorDialog);
  }
}
