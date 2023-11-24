import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/document_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/models/semester_data.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/semester_selection.dart';
import 'package:flutterdesigndemo/ui/academic_detail/specialization_selection.dart';
import 'package:flutterdesigndemo/ui/manage_user/hub_selection.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../customwidget/app_widgets.dart';
import '../../utils/utils.dart';

class SelfPlaceJobOpportunityForm extends StatefulWidget {
  const SelfPlaceJobOpportunityForm({Key? key}) : super(key: key);

  @override
  State<SelfPlaceJobOpportunityForm> createState() => _SelfPlaceJobOpportunityFormState();
}

class _SelfPlaceJobOpportunityFormState extends State<SelfPlaceJobOpportunityForm> {
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController jobDescController = TextEditingController();
  TextEditingController jobSpecificReqController = TextEditingController();
  TextEditingController vacancyController = TextEditingController();
  TextEditingController minRangeController = TextEditingController();
  TextEditingController maxRangeController = TextEditingController();
  TextEditingController minAgeLimitController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  String stipendType = strings_name.str_amount_type_interview;

  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];
  List<BaseApiResponseWithSerializable<HubResponse>>? hubsData = [];
  List<SemesterData>? semesterData = [];

  String bondFilePath = "", incentiveStructureFilePath = "";
  String bondFileName = "", incentiveStructureFileName = "";
  var bondFileData, incentiveStructureData;

  List<String> preferredGenderArr = <String>[strings_name.str_both, strings_name.str_male, strings_name.str_female];
  String preferredGenderValue = strings_name.str_both;

  List<String> internshipDurationArr = <String>[strings_name.str_month_6, strings_name.str_month_12, strings_name.str_month_18, strings_name.str_month_24, strings_name.str_month_30, strings_name.str_month_36];
  String internshipDurationValue = strings_name.str_month_6;

  List<String> internshipModeArr = <String>[strings_name.str_mode_work_from_office, strings_name.str_mode_work_from_home, strings_name.str_mode_remote_work, strings_name.str_mode_project_based_work];
  String internshipModeValue = strings_name.str_mode_work_from_office;

  bool isVisible = false;
  var cloudinary;
  final apiRepository = getIt.get<ApiRepository>();

  String companyId = "", jobRecordId = "";
  bool fromEdit = false;

  BaseApiResponseWithSerializable<JobOpportunityResponse>? jobInfo;

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    initData();
  }

  void initData() async {
    if (Get.arguments != null) {
      jobInfo = Get.arguments;
    }
    if (PreferenceUtils.getIsLogin() == 1) {
      vacancyController.text = "1";

      var specializationArr = PreferenceUtils.getSpecializationList().records;
      for (int j = 0; j < specializationArr!.length; j++) {
        if (PreferenceUtils.getLoginData().specializationIds?.last == specializationArr[j].id) {
          specializationData?.add(specializationArr[j]);
          break;
        }
      }

      var hubArr = PreferenceUtils.getHubList().records;
      for (int j = 0; j < hubArr!.length; j++) {
        if (PreferenceUtils.getLoginData().hubIds?.last == hubArr[j].id) {
          hubsData?.add(hubArr[j]);
          break;
        }
      }

      SemesterData semData = SemesterData(semester: int.parse(PreferenceUtils.getLoginData().semester!));
      semData.selected = true;
      semesterData?.add(semData);
    }

    if (jobInfo != null) {
      fromEdit = true;
      jobRecordId = jobInfo?.id ?? "";
      var jobData = jobInfo?.fields;

      jobTitleController.text = jobData?.jobTitle ?? "";
      jobDescController.text = jobData?.jobDescription ?? "";
      jobSpecificReqController.text = jobData?.specificRequirements ?? "";
      vacancyController.text = "${jobData?.vacancies ?? ''}";
      minAgeLimitController.text = "${jobData?.minimumAge ?? ''}";
      startTimeController.text = jobData?.timingStart ?? "";
      endTimeController.text = jobData?.timingEnd ?? "";

      stipendType = jobData?.stipendType ?? "";
      minRangeController.text = "${jobData?.stipendRangeMin ?? ''}";
      maxRangeController.text = "${jobData?.stipendRangeMax ?? ''}";

      preferredGenderValue = jobData?.gender ?? strings_name.str_both;
      internshipModeValue = jobData?.internshipModes ?? strings_name.str_mode_work_from_office;
      internshipDurationValue = jobData?.internshipDuration ?? strings_name.str_month_6;

      companyId = jobData?.companyId?.first ?? "";

      if (jobData?.specializationIds?.isNotEmpty == true) {
        specializationData?.clear();
        var specializationArr = PreferenceUtils.getSpecializationList().records;
        for (int i = 0; i < jobData!.specializationIds!.length; i++) {
          for (int j = 0; j < specializationArr!.length; j++) {
            if (jobData.specializationIds![i] == specializationArr[j].id) {
              specializationData?.add(specializationArr[j]);
              break;
            }
          }
        }
      }

      if (jobData?.hubIds?.isNotEmpty == true) {
        hubsData?.clear();
        var hubArr = PreferenceUtils.getHubList().records;
        for (int i = 0; i < jobData!.hubIds!.length; i++) {
          for (int j = 0; j < hubArr!.length; j++) {
            if (jobData.hubIds![i] == hubArr[j].id) {
              hubsData?.add(hubArr[j]);
              break;
            }
          }
        }
      }

      if (jobData?.semester?.isNotEmpty == true) {
        semesterData?.clear();
        for (int i = 0; i < jobData!.semester!.length; i++) {
          SemesterData semData = SemesterData(semester: int.parse(jobData.semester![i]));
          semData.selected = true;

          semesterData?.add(semData);
        }
      }

      if (jobData?.bond_structure != null && (jobData?.bond_structure?.length ?? 0) > 0) {
        bondFilePath = jobData!.bond_structure!.first.url!;
        bondFileName = jobData.bond_structure!.first.filename!;
      }
      if (jobData?.incentive_structure != null && (jobData?.incentive_structure?.length ?? 0) > 0) {
        bondFilePath = jobData!.incentive_structure!.first.url!;
        bondFileName = jobData.incentive_structure!.first.filename!;
      }
    }

    setState(() {});
  }

  void submitData() async {
    setState(() {
      isVisible = true;
    });

    var bondPath = "", incentivePath = "";
    if (bondFilePath.isNotEmpty) {
      if (kIsWeb) {
        // bondFileData
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromByteData(Utils.uint8ListToByteData(bondFileData.bytes!), resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_BONDS, identifier: bondFileData.name),
        );
        bondPath = response.secureUrl;
      } else {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(bondFilePath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_BONDS),
        );
        bondPath = response.secureUrl;
      }
    }
    if (incentiveStructureFilePath.isNotEmpty) {
      if (kIsWeb) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromByteData(Utils.uint8ListToByteData(incentiveStructureData.bytes!), resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_INCENTIVE_STRUCTURE, identifier: incentiveStructureData.name),
        );
        incentivePath = response.secureUrl;
      } else {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(incentiveStructureFilePath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_INCENTIVE_STRUCTURE),
        );
        incentivePath = response.secureUrl;
      }
    }

    BaseApiResponseWithSerializable<JobOpportunityResponse>? data = BaseApiResponseWithSerializable<JobOpportunityResponse>();
    if (fromEdit) {
      data = jobInfo;
    }
    JobOpportunityResponse response = JobOpportunityResponse();
    response.jobTitle = jobTitleController.text.trim().toString();
    response.jobDescription = jobDescController.text.trim().toString();
    response.specificRequirements = jobSpecificReqController.text.trim().toString();
    response.stipendType = stipendType.trim().toString();
    if (stipendType == strings_name.str_amount_type_range) {
      if (minRangeController.text.toString().trim().isNotEmpty) {
        response.stipendRangeMin = int.parse(minRangeController.text.trim().toString());
      }
      if (maxRangeController.text.toString().trim().isNotEmpty) {
        response.stipendRangeMax = int.parse(maxRangeController.text.trim().toString());
      }
    }
    response.vacancies = int.tryParse(vacancyController.text.trim().toString()) ?? 1;
    response.gender = preferredGenderValue.trim().toString();
    if (minAgeLimitController.text.toString().trim().isNotEmpty) {
      if (int.tryParse(minAgeLimitController.text.trim().toString()) != null) {
        response.minimumAge = int.tryParse(minAgeLimitController.text.trim().toString());
      }
    }
    response.timingStart = startTimeController.text.trim().toString();
    response.timingEnd = endTimeController.text.trim().toString();
    response.internshipModes = internshipModeValue.trim().toString();
    response.internshipDuration = internshipDurationValue.trim().toString();
    response.status = strings_name.str_job_status_pending;

    if (bondPath.isNotEmpty) {
      DocumentResponse attachment = DocumentResponse();
      attachment.url = bondPath;
      attachment.filename = bondFileName;
      List<DocumentResponse> listData = [];
      listData.add(attachment);
      response.bond_structure = listData;
    }
    if (incentivePath.isNotEmpty) {
      DocumentResponse attachment = DocumentResponse();
      attachment.url = incentivePath;
      attachment.filename = incentiveStructureFileName;
      List<DocumentResponse> listData = [];
      listData.add(attachment);
      response.incentive_structure = listData;
    }

    List<String> selectedHubData = [];
    for (var i = 0; i < hubsData!.length; i++) {
      selectedHubData.add(hubsData![i].id.toString());
    }
    response.hubIds = selectedHubData;

    List<String> selectedSpecializationData = [];
    for (var i = 0; i < specializationData!.length; i++) {
      selectedSpecializationData.add(specializationData![i].id.toString());
    }
    response.specializationIds = selectedSpecializationData;

    List<String> selectedSemesterData = [];
    for (var i = 0; i < semesterData!.length; i++) {
      selectedSemesterData.add(semesterData![i].semester.toString());
    }
    response.semester = selectedSemesterData;

    setState(() {
      isVisible = false;
    });

    data?.fields = response;
    Get.back(closeOverlays: true, result: data);
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_job_opp_detail),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                custom_text(
                  text: "${strings_name.str_job_title}*",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: jobTitleController,
                  topValue: 0,
                ),
                SizedBox(height: 5.h),
                custom_text(
                  text: "${strings_name.str_job_desc}*",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: jobDescController,
                  minLines: 3,
                  maxLines: 3,
                  maxLength: 50000,
                  topValue: 0,
                ),
                PreferenceUtils.getIsLogin() == 2
                    ? Column(
                        children: [
                          SizedBox(height: 5.h),
                          custom_text(
                            text: strings_name.str_job_specific_req,
                            alignment: Alignment.topLeft,
                            textStyles: blackTextSemiBold16,
                          ),
                          custom_edittext(
                            type: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            controller: jobSpecificReqController,
                            maxLines: 3,
                            minLines: 3,
                            maxLength: 50000,
                            topValue: 0,
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 5.h),
                custom_text(
                  text: "${strings_name.str_stipend_amount}*",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                Column(
                  children: [
                    ListTileTheme(
                      horizontalTitleGap: 2,
                      child: RadioListTile(
                        contentPadding: const EdgeInsets.all(0),
                        activeColor: colors_name.colorPrimary,
                        dense: true,
                        title: Text(
                          strings_name.str_amount_type_interview,
                          style: blackTextSemiBold16,
                        ),
                        value: strings_name.str_amount_type_interview,
                        groupValue: stipendType,
                        onChanged: (value) {
                          setState(() {
                            stipendType = value.toString();
                          });
                        },
                      ),
                    ),
                    ListTileTheme(
                      horizontalTitleGap: 2,
                      child: RadioListTile(
                        contentPadding: const EdgeInsets.all(0),
                        activeColor: colors_name.colorPrimary,
                        dense: true,
                        title: Text(
                          strings_name.str_amount_type_range,
                          style: blackTextSemiBold16,
                        ),
                        value: strings_name.str_amount_type_range,
                        groupValue: stipendType,
                        onChanged: (value) {
                          setState(() {
                            stipendType = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Visibility(
                    visible: stipendType == strings_name.str_amount_type_range,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: custom_edittext(
                            type: TextInputType.number,
                            hintText: strings_name.str_range_min,
                            textInputAction: TextInputAction.next,
                            controller: minRangeController,
                            topValue: 5,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: custom_edittext(
                            type: TextInputType.number,
                            hintText: strings_name.str_range_max,
                            textInputAction: TextInputAction.next,
                            controller: maxRangeController,
                            topValue: 5,
                          ),
                        ),
                      ],
                    )),
                PreferenceUtils.getIsLogin() == 2
                    ? Column(children: [
                        SizedBox(height: 5.h),
                        custom_text(
                          text: "${strings_name.str_vacancy}*",
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                        ),
                        custom_edittext(
                          type: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: vacancyController,
                          maxLines: 3,
                          topValue: 5,
                        ),
                      ])
                    : Container(),
                PreferenceUtils.getIsLogin() == 2
                    ? Column(children: [
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            custom_text(
                              text: strings_name.str_specializations,
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                            ),
                            GestureDetector(
                              child: custom_text(
                                text: specializationData?.isEmpty == true ? strings_name.str_add : strings_name.str_update,
                                alignment: Alignment.topLeft,
                                textStyles: primaryTextSemiBold16,
                              ),
                              onTap: () {
                                Get.to(const SpecializationSelection(), arguments: specializationData)?.then((result) {
                                  if (result != null) {
                                    setState(() {
                                      specializationData = result;
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        specializationData!.isNotEmpty
                            ? ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: specializationData?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 5,
                                    child: Container(
                                      color: colors_name.colorWhite,
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [Expanded(child: Text("${specializationData![index].fields!.specializationName}", textAlign: TextAlign.start, style: blackText16)), const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                                      ),
                                    ),
                                  );
                                })
                            : Container(),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            custom_text(
                              text: strings_name.str_semester,
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                            ),
                            GestureDetector(
                              child: custom_text(
                                text: semesterData?.isEmpty == true ? strings_name.str_add : strings_name.str_update,
                                alignment: Alignment.topLeft,
                                textStyles: primaryTextSemiBold16,
                              ),
                              onTap: () {
                                Get.to(const SemesterSelection(), arguments: semesterData)?.then((result) {
                                  if (result != null) {
                                    setState(() {
                                      semesterData = result;
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        semesterData!.isNotEmpty
                            ? ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: semesterData?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 5,
                                    child: Container(
                                      color: colors_name.colorWhite,
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [Expanded(child: Text("Semester ${semesterData![index].semester}", textAlign: TextAlign.start, style: blackText16)), const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                                      ),
                                    ),
                                  );
                                })
                            : Container(),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            custom_text(
                              text: "${strings_name.str_select_hub}*",
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                            ),
                            GestureDetector(
                              child: custom_text(
                                text: hubsData?.isEmpty == true ? strings_name.str_add : strings_name.str_update,
                                alignment: Alignment.topLeft,
                                textStyles: primaryTextSemiBold16,
                              ),
                              onTap: () {
                                Get.to(const HubSelection(), arguments: hubsData)?.then((result) {
                                  if (result != null) {
                                    setState(() {
                                      hubsData = result;
                                    });
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        hubsData!.isNotEmpty
                            ? ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: hubsData?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 5,
                                    child: GestureDetector(
                                      child: Container(
                                        color: colors_name.colorWhite,
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [Expanded(child: Text("${hubsData![index].fields!.hubName}", textAlign: TextAlign.start, style: blackText16)), const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                                        ),
                                      ),
                                      onTap: () {
                                        // Get.to(const (), arguments: unitsData![index].fields?.ids);
                                      },
                                    ),
                                  );
                                })
                            : Container(),
                      ])
                    : Container(),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    custom_text(
                      text: strings_name.str_bond_contract,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      leftValue: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(children: [
                        GestureDetector(
                          child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black),
                          onTap: () {
                            picBondFile();
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
                Visibility(visible: bondFilePath.isNotEmpty, child: custom_text(text: bondFilePath, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0)),
                PreferenceUtils.getIsLogin() == 2
                    ? Column(children: [
                        SizedBox(height: 5.h),
                        custom_text(
                          text: strings_name.str_preferred_gender,
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Container(
                                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                                width: viewWidth,
                                child: DropdownButtonFormField<String>(
                                  elevation: 16,
                                  value: preferredGenderValue,
                                  style: blackText16,
                                  focusColor: Colors.white,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      preferredGenderValue = newValue!;
                                    });
                                  },
                                  items: preferredGenderArr.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        custom_text(
                          text: strings_name.str_min_age_limit,
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                        ),
                        custom_edittext(
                          type: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: minAgeLimitController,
                          maxLines: 3,
                          topValue: 5,
                        ),
                      ])
                    : Container(),
                SizedBox(height: 5.h),
                custom_text(
                  text: "${strings_name.str_internship_timing}*",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                Row(children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: InkWell(
                      child: IgnorePointer(
                        child: custom_edittext(
                          hintText: strings_name.str_start_time,
                          type: TextInputType.none,
                          textInputAction: TextInputAction.next,
                          controller: startTimeController,
                          topValue: 0,
                        ),
                      ),
                      onTap: () {
                        TimeOfDay timeOfDay = TimeOfDay.now();
                        if (startTimeController.text.isNotEmpty) {
                          DateTime dateTime = DateFormat("hh:mm aa").parse(startTimeController.text);
                          timeOfDay = TimeOfDay.fromDateTime(dateTime);
                        }

                        showTimePicker(context: context, initialTime: timeOfDay).then((pickedTime) {
                          if (pickedTime == null) {
                            return;
                          }
                          setState(() {
                            var formatter = DateFormat('hh:mm aa');
                            var dateTime = DateTime.now();
                            var time = DateTime(dateTime.year, dateTime.month, dateTime.day, pickedTime.hour, pickedTime.minute);
                            startTimeController.text = formatter.format(time);
                          });
                        });
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: InkWell(
                      child: IgnorePointer(
                        child: custom_edittext(
                          hintText: "${strings_name.str_end_time}*",
                          type: TextInputType.none,
                          textInputAction: TextInputAction.next,
                          controller: endTimeController,
                          topValue: 0,
                        ),
                      ),
                      onTap: () {
                        TimeOfDay timeOfDay = TimeOfDay.now();
                        if (endTimeController.text.isNotEmpty) {
                          DateTime dateTime = DateFormat("hh:mm aa").parse(endTimeController.text);
                          timeOfDay = TimeOfDay.fromDateTime(dateTime);
                        }

                        showTimePicker(context: context, initialTime: timeOfDay).then((pickedTime) {
                          if (pickedTime == null) {
                            return;
                          }
                          setState(() {
                            var formatter = DateFormat('hh:mm aa');
                            var dateTime = DateTime.now();
                            var time = DateTime(dateTime.year, dateTime.month, dateTime.day, pickedTime.hour, pickedTime.minute);
                            endTimeController.text = formatter.format(time);
                          });
                        });
                      },
                    ),
                  ),
                ]),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    custom_text(
                      text: strings_name.str_incentive_structure,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      leftValue: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(children: [
                        GestureDetector(
                          child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black),
                          onTap: () {
                            picIncentiveFile();
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
                // Visibility(visible: incentiveStructureFilePath.isNotEmpty, child: custom_text(text: incentiveStructureFilePath, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0)),
                incentiveStructureData == null ? SizedBox() : Visibility(visible: incentiveStructureData != null, child: custom_text(text: incentiveStructureData.name, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0)),
                SizedBox(height: 5.h),
                custom_text(
                  text: strings_name.str_internship_mode,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<String>(
                          elevation: 16,
                          value: internshipModeValue,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              internshipModeValue = newValue!;
                            });
                          },
                          items: internshipModeArr.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                custom_text(
                  text: strings_name.str_internship_min_duration,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        width: viewWidth,
                        child: DropdownButtonFormField<String>(
                          elevation: 16,
                          value: internshipDurationValue,
                          style: blackText16,
                          focusColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              internshipDurationValue = newValue!;
                            });
                          },
                          items: internshipDurationArr.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    if (jobTitleController.text.trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_job_title);
                    } else if (jobDescController.text.toString().trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_job_desc);
                    } else if (stipendType.isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_stipend_amount);
                    } else if (stipendType == strings_name.str_amount_type_range && minRangeController.text.toString().trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_min_range);
                    } else if (vacancyController.text.toString().trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_vacancies);
                    } else if (startTimeController.text.toString().trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_start_time);
                    } else if (endTimeController.text.toString().trim().isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_end_time);
                    } else if (hubsData?.isEmpty == true) {
                      Utils.showSnackBar(context, strings_name.str_empty_hub_data);
                    } else {
                      submitData();
                    }
                  },
                )
              ],
            ),
          ),
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
          ),
        ],
      ),
    ));
  }

  picBondFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        if (kIsWeb) {
          bondFileData = result.files.single;
          bondFilePath = result.files.single.bytes.toString();
          bondFileName = result.files.single.name;
        } else {
          bondFilePath = result.files.single.path!;
          bondFileName = result.files.single.name;
        }
      });
    }
  }

  picIncentiveFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        if (kIsWeb) {
          incentiveStructureData = result.files.single;
          incentiveStructureFilePath = result.files.single.bytes.toString();
          incentiveStructureFileName = result.files.single.name;
        } else {
          incentiveStructureFilePath = result.files.single.path!;
          incentiveStructureFileName = result.files.single.name;
        }
      });
    }
  }
}
