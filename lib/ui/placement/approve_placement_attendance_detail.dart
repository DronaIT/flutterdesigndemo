import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/request/add_placement_attendance_response.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ApprovePlacementAttendanceDetail extends StatefulWidget {
  const ApprovePlacementAttendanceDetail({super.key});

  @override
  State<ApprovePlacementAttendanceDetail> createState() => _ApprovePlacementAttendanceDetailState();
}

class _ApprovePlacementAttendanceDetailState extends State<ApprovePlacementAttendanceDetail> {
  bool isVisible = false;
  BaseApiResponseWithSerializable<LoginFieldsResponse> studentData = BaseApiResponseWithSerializable();
  List<BaseApiResponseWithSerializable<AddPlacementAttendanceResponse>>? placementData = [];

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";

  TextEditingController rejectionReasonController = TextEditingController();
  TextEditingController attendanceHourController = TextEditingController();
  TextEditingController skpHourController = TextEditingController();
  TextEditingController skpMarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      studentData = Get.arguments;
      setState(() {});
    }
    if (studentData.id != null && PreferenceUtils.getIsLogin() == 2) {
      getRecords();
    }
  }

  getRecords() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }

    var query = "";
    query += "SEARCH('${studentData.fields?.mobileNumber}', ARRAYJOIN(${TableNames.CLM_STUDENT_MOBILE_NUMBER}))";
    debugPrint(query);

    try {
      var data = await apiRepository.getPlacementInfoApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          placementData?.clear();
        }
        placementData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<AddPlacementAttendanceResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          placementData?.sort((b, a) {
            var adate = a.fields!.uploadedOn;
            var bdate = b.fields!.uploadedOn;
            return adate!.compareTo(bdate!);
          });

          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            placementData = [];
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_placement_data),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),
              GestureDetector(
                child: custom_text(
                  text: "${studentData.fields!.name}",
                  textStyles: linkTextSemiBold16,
                  topValue: 0,
                  maxLines: 2,
                  bottomValue: 5,
                ),
                onTap: () {
                  Get.to(const StudentHistory(), arguments: studentData.fields?.mobileNumber);
                },
              ),
              custom_text(topValue: 0, bottomValue: 5, maxLines: 2, text: "Specialization: ${Utils.getSpecializationName(studentData.fields?.specializationIds![0])}", textStyles: blackTextSemiBold14),
              custom_text(
                topValue: 0,
                bottomValue: 5,
                text: "Semester: ${studentData.fields?.semester}",
                textStyles: blackTextSemiBold14,
              ),
              custom_text(
                text: "Total Documents: ${studentData.fields!.placement_attendance_form?.length ?? 0}",
                textStyles: blackTextSemiBold14,
                topValue: 0,
                maxLines: 2,
                bottomValue: 5,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: placementData != null && placementData!.isNotEmpty
                    ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: placementData?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  custom_text(
                                    text: placementData?[index].fields!.company_name?.last ?? "",
                                    textStyles: primaryTextSemiBold16,
                                    topValue: 0,
                                    maxLines: 2,
                                    bottomValue: 5,
                                    leftValue: 5,
                                  ),
                                  custom_text(
                                    text: "Job Title: ${placementData?[index].fields!.job_title?.last ?? ""}",
                                    textStyles: blackTextSemiBold14,
                                    topValue: 0,
                                    maxLines: 2,
                                    bottomValue: 5,
                                    leftValue: 5,
                                  ),
                                  custom_text(
                                    text: "Uploaded On: ${placementData?[index].fields!.uploadedOn ?? ""}",
                                    textStyles: blackText14,
                                    topValue: 0,
                                    maxLines: 2,
                                    leftValue: 5,
                                  ),
                                  placementData?[index].fields?.attendance_form?.isNotEmpty == true
                                      ? Column(
                                          children: [
                                            const custom_text(
                                              text: strings_name.str_attendance,
                                              textStyles: blackTextSemiBold15,
                                              topValue: 0,
                                              bottomValue: 5,
                                              leftValue: 5,
                                            ),
                                            Container(height: 1.h, color: colors_name.darkGrayColor),
                                            Row(children: [
                                              const custom_text(text: "Attendance Sheet:", textStyles: blackText14, topValue: 0, maxLines: 2, bottomValue: 0, leftValue: 5),
                                              GestureDetector(
                                                  onTap: () async {
                                                    await launchUrl(Uri.parse(placementData?[index].fields?.attendance_form?.last.url ?? ""), mode: LaunchMode.externalApplication);
                                                  },
                                                  child: custom_text(text: "Show", textStyles: primaryTextSemiBold14, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 0)),
                                            ]),
                                            placementData?[index].fields?.placement_attendance_status != strings_name.str_approve &&
                                                    placementData?[index].fields?.placement_attendance_status != strings_name.str_reject
                                                ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          rejectionConfirmationDialog(placementData![index], 1);
                                                        },
                                                        child: const custom_text(
                                                          text: strings_name.str_reject,
                                                          textStyles: primaryTextSemiBold14,
                                                          alignment: Alignment.centerRight,
                                                          topValue: 5,
                                                          bottomValue: 0,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      GestureDetector(
                                                        onTap: () {
                                                          approveConfirmationDialog(placementData![index], 1);
                                                        },
                                                        child: const custom_text(
                                                          text: strings_name.str_approve,
                                                          textStyles: greenTextSemiBold14,
                                                          alignment: Alignment.centerRight,
                                                          topValue: 5,
                                                          bottomValue: 0,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      custom_text(
                                                        text: "${strings_name.str_status} ${placementData?[index].fields?.placement_attendance_status ?? ""}",
                                                        textStyles: blackTextSemiBold14,
                                                        topValue: 0,
                                                        maxLines: 2,
                                                        bottomValue: 0,
                                                        leftValue: 5,
                                                      ),
                                                      placementData?[index].fields?.attendance_rejection_reason?.isNotEmpty == true
                                                          ? custom_text(
                                                              text: "${strings_name.str_rejection_reason}: ${placementData?[index].fields?.attendance_rejection_reason}",
                                                              textStyles: blackText14,
                                                              topValue: 5,
                                                              maxLines: 100,
                                                              bottomValue: 0,
                                                              leftValue: 5,
                                                            )
                                                          : custom_text(
                                                              text: "Attendance Hour: ${placementData?[index].fields?.attendance_hours ?? ""}",
                                                              textStyles: blackTextSemiBold14,
                                                              topValue: 5,
                                                              maxLines: 2,
                                                              bottomValue: 5,
                                                              leftValue: 5,
                                                            ),
                                                    ],
                                                  )
                                          ],
                                        )
                                      : Container(),
                                  placementData?[index].fields?.company_loc?.isNotEmpty == true
                                      ? Column(
                                          children: [
                                            const custom_text(
                                              text: "Company Detail",
                                              textStyles: blackTextSemiBold15,
                                              topValue: 0,
                                              bottomValue: 5,
                                              leftValue: 5,
                                            ),
                                            Container(height: 1.h, color: colors_name.darkGrayColor),
                                            Row(children: [
                                              const custom_text(text: "${strings_name.str_letter_of_consent}:", textStyles: blackText14, topValue: 0, maxLines: 2, bottomValue: 0, leftValue: 5),
                                              GestureDetector(
                                                  onTap: () async {
                                                    await launchUrl(Uri.parse(placementData?[index].fields?.company_loc?.last.url ?? ""), mode: LaunchMode.externalApplication);
                                                  },
                                                  child: custom_text(text: "Show", textStyles: primaryTextSemiBold14, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 0)),
                                            ]),
                                            placementData?[index].fields?.placement_company_loc_status != strings_name.str_approve &&
                                                    placementData?[index].fields?.placement_company_loc_status != strings_name.str_reject
                                                ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          rejectionConfirmationDialog(placementData![index], 2);
                                                        },
                                                        child: const custom_text(
                                                          text: strings_name.str_reject,
                                                          textStyles: primaryTextSemiBold14,
                                                          alignment: Alignment.centerRight,
                                                          topValue: 5,
                                                          bottomValue: 0,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      GestureDetector(
                                                        onTap: () {
                                                          approveConfirmationDialog(placementData![index], 2);
                                                        },
                                                        child: const custom_text(
                                                          text: strings_name.str_approve,
                                                          textStyles: greenTextSemiBold14,
                                                          alignment: Alignment.centerRight,
                                                          topValue: 5,
                                                          bottomValue: 0,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      custom_text(
                                                        text: "${strings_name.str_status} ${placementData?[index].fields?.placement_company_loc_status ?? ""}",
                                                        textStyles: blackTextSemiBold14,
                                                        topValue: 0,
                                                        maxLines: 2,
                                                        bottomValue: 0,
                                                        leftValue: 5,
                                                      ),
                                                      placementData?[index].fields?.company_loc_rejection_reason?.isNotEmpty == true
                                                          ? custom_text(
                                                              text: "${strings_name.str_rejection_reason}: ${placementData?[index].fields?.company_loc_rejection_reason}",
                                                              textStyles: blackText14,
                                                              topValue: 5,
                                                              maxLines: 100,
                                                              bottomValue: 0,
                                                              leftValue: 5,
                                                            )
                                                          : Container(),
                                                    ],
                                                  )
                                          ],
                                        )
                                      : Container(),
                                  placementData?[index].fields?.workbook?.isNotEmpty == true
                                      ? Column(
                                          children: [
                                            const custom_text(
                                              text: "WorkBook Detail",
                                              textStyles: blackTextSemiBold15,
                                              topValue: 0,
                                              bottomValue: 5,
                                              leftValue: 5,
                                            ),
                                            Container(height: 1.h, color: colors_name.darkGrayColor),
                                            Row(children: [
                                              const custom_text(text: "${strings_name.str_workbook}:", textStyles: blackText14, topValue: 0, maxLines: 2, bottomValue: 0, leftValue: 5),
                                              GestureDetector(
                                                  onTap: () async {
                                                    await launchUrl(Uri.parse(placementData?[index].fields?.workbook?.last.url ?? ""), mode: LaunchMode.externalApplication);
                                                  },
                                                  child: custom_text(text: "Show", textStyles: primaryTextSemiBold14, topValue: 5, maxLines: 2, bottomValue: 5, leftValue: 0)),
                                            ]),
                                            placementData?[index].fields?.placement_workbook_status != strings_name.str_approve &&
                                                    placementData?[index].fields?.placement_workbook_status != strings_name.str_reject
                                                ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          rejectionConfirmationDialog(placementData![index], 3);
                                                        },
                                                        child: const custom_text(
                                                          text: strings_name.str_reject,
                                                          textStyles: primaryTextSemiBold14,
                                                          alignment: Alignment.centerRight,
                                                          topValue: 5,
                                                          bottomValue: 0,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      GestureDetector(
                                                        onTap: () {
                                                          approveConfirmationDialog(placementData![index], 3);
                                                        },
                                                        child: const custom_text(
                                                          text: strings_name.str_approve,
                                                          textStyles: greenTextSemiBold14,
                                                          alignment: Alignment.centerRight,
                                                          topValue: 5,
                                                          bottomValue: 0,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      custom_text(
                                                        text: "${strings_name.str_status} ${placementData?[index].fields?.placement_workbook_status ?? ""}",
                                                        textStyles: blackTextSemiBold14,
                                                        topValue: 0,
                                                        maxLines: 2,
                                                        bottomValue: 0,
                                                        leftValue: 5,
                                                      ),
                                                      placementData?[index].fields?.workbook_rejection_reason?.isNotEmpty == true
                                                          ? custom_text(
                                                              text: "${strings_name.str_rejection_reason}: ${placementData?[index].fields?.workbook_rejection_reason}",
                                                              textStyles: blackText14,
                                                              topValue: 5,
                                                              maxLines: 100,
                                                              bottomValue: 0,
                                                              leftValue: 5,
                                                            )
                                                          : Column(
                                                        children: [
                                                          custom_text(
                                                            text: "SKP Hours: ${placementData?[index].fields?.skp_hours ?? ""}",
                                                            textStyles: blackTextSemiBold14,
                                                            topValue: 5,
                                                            maxLines: 2,
                                                            bottomValue: 0,
                                                            leftValue: 5,
                                                          ),
                                                          custom_text(
                                                            text: "SKP Marks: ${placementData?[index].fields?.skp_marks ?? ""}",
                                                            textStyles: blackTextSemiBold14,
                                                            topValue: 5,
                                                            maxLines: 2,
                                                            bottomValue: 5,
                                                            leftValue: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          );
                        })
                    : Container(margin: const EdgeInsets.only(top: 50), child: custom_text(text: strings_name.str_no_doc, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
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

  Future<void> rejectionConfirmationDialog(BaseApiResponseWithSerializable<AddPlacementAttendanceResponse> placementData, int type) async {
    rejectionReasonController.text = "";
    attendanceHourController.text = "";
    skpMarksController.text = "";
    skpHourController.text = "";

    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          custom_text(text: 'Please confirm the rejection', textStyles: boldTitlePrimaryColorStyle),
          SizedBox(height: 5.h),
          custom_text(
            text: 'Company Name : ${placementData.fields?.company_name?.first.toString()}',
            textStyles: blackTextSemiBold14,
            maxLines: 2,
            bottomValue: 0,
          ),
          custom_text(
            text: 'Position : ${placementData.fields?.job_title}',
            textStyles: blackTextSemiBold14,
            maxLines: 2,
            bottomValue: 0,
          ),
          SizedBox(height: 5.h),
          const custom_text(
            text: strings_name.str_provide_rejection_reason,
            alignment: Alignment.topLeft,
            textStyles: blackTextSemiBold16,
            bottomValue: 5,
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
          CustomButton(
              text: strings_name.str_submit,
              click: () {
                if (rejectionReasonController.text.trim().isEmpty) {
                  Utils.showSnackBar(context, strings_name.str_rejection_reason);
                } else {
                  Get.back(closeOverlays: true);
                  updateJobStatus(placementData, type, false);
                }
              })
        ],
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  Future<void> approveConfirmationDialog(BaseApiResponseWithSerializable<AddPlacementAttendanceResponse> placementData, int type) async {
    rejectionReasonController.text = "";
    attendanceHourController.text = "";
    skpMarksController.text = "";
    skpHourController.text = "";

    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          custom_text(text: 'Please confirm the approval', textStyles: boldTitlePrimaryColorStyle),
          SizedBox(height: 5.h),
          custom_text(
            text: 'Company Name : ${placementData.fields?.company_name?.last.toString()}',
            textStyles: blackTextSemiBold14,
            maxLines: 2,
            bottomValue: 0,
          ),
          custom_text(
            text: 'Position : ${placementData.fields?.job_title?.last.toString()}',
            textStyles: blackTextSemiBold14,
            maxLines: 2,
            bottomValue: 0,
          ),
          type == 1
              ? Column(
                  children: [
                    SizedBox(height: 5.h),
                    const custom_text(
                      text: "Attendance Hours",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      bottomValue: 5,
                    ),
                    custom_edittext(
                      type: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: attendanceHourController,
                      topValue: 0,
                    ),
                  ],
                )
              : Container(),
          type == 3
              ? Column(
                  children: [
                    SizedBox(height: 5.h),
                    const custom_text(
                      text: "SKP Hours",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      bottomValue: 5,
                    ),
                    custom_edittext(
                      type: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: skpHourController,
                      topValue: 0,
                    ),
                    SizedBox(height: 5.h),
                    const custom_text(
                      text: "SKP Marks",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      bottomValue: 5,
                    ),
                    custom_edittext(
                      type: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: skpMarksController,
                      topValue: 0,
                    ),
                  ],
                )
              : Container(),
          CustomButton(
              text: strings_name.str_submit,
              click: () {
                if (type == 1 && attendanceHourController.text.trim().isEmpty) {
                  Utils.showSnackBar(context, strings_name.str_empty_attendance_hour);
                } else if (type == 3 && skpHourController.text.trim().isEmpty) {
                  Utils.showSnackBar(context, strings_name.str_empty_skp_hour);
                } else if (type == 3 && skpMarksController.text.trim().isEmpty) {
                  Utils.showSnackBar(context, strings_name.str_empty_skp_marks);
                } else {
                  Get.back(closeOverlays: true);
                  updateJobStatus(placementData, type, true);
                }
              })
        ],
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  void updateJobStatus(BaseApiResponseWithSerializable<AddPlacementAttendanceResponse> placementData, int type, bool isApproved) async {
    setState(() {
      isVisible = true;
    });

    AddPlacementAttendanceResponse request = AddPlacementAttendanceResponse();
    if (isApproved) {
      if (type == 1) {
        request.placement_attendance_status = strings_name.str_approve;
        request.attendance_hours = attendanceHourController.text.trim().toString();
      }
      if (type == 2) {
        request.placement_company_loc_status = strings_name.str_approve;
      }
      if (type == 3) {
        request.placement_workbook_status = strings_name.str_approve;
        request.skp_hours = skpHourController.text.trim().toString();
        request.skp_marks = skpMarksController.text.trim().toString();
      }
    } else {
      if (type == 1) {
        request.placement_attendance_status = strings_name.str_reject;
        request.attendance_rejection_reason = rejectionReasonController.text.trim().toString();
      } else if (type == 2) {
        request.placement_company_loc_status = strings_name.str_reject;
        request.company_loc_rejection_reason = rejectionReasonController.text.trim().toString();
      } else if (type == 3) {
        request.placement_workbook_status = strings_name.str_reject;
        request.workbook_rejection_reason = rejectionReasonController.text.trim().toString();
      }
    }

    var json = request.toJson();
    json.removeWhere((key, value) => value == null);
    try {
      var resp = await apiRepository.updatePlacementInfoDataApi(json, placementData.id.toString());
      if (resp.id != null) {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_placement_status_updated);
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
}
