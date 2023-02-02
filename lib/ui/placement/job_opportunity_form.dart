import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/request/create_job_opportunity_request.dart';
import 'package:flutterdesigndemo/models/semester_data.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/semester_selection.dart';
import 'package:flutterdesigndemo/ui/academic_detail/specialization_selection.dart';
import 'package:flutterdesigndemo/ui/manage_user/hub_selection.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../customwidget/app_widgets.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

class JobOpportunityForm extends StatefulWidget {
  const JobOpportunityForm({Key? key}) : super(key: key);

  @override
  State<JobOpportunityForm> createState() => _JobOpportunityFormState();
}

class _JobOpportunityFormState extends State<JobOpportunityForm> {
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController jobDescController = TextEditingController();
  TextEditingController jobSpecificReqController = TextEditingController();
  TextEditingController vacancyController = TextEditingController();
  TextEditingController minRangeController = TextEditingController();
  TextEditingController maxRangeController = TextEditingController();
  TextEditingController minAgeLimitController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  String stipendType = "";

  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];
  List<BaseApiResponseWithSerializable<HubResponse>>? hubsData = [];
  List<SemesterData>? semesterData = [];

  String bondFilePath = "", incentiveStructureFilePath = "";

  List<String> preferredGenderArr = <String>[strings_name.str_both, strings_name.str_male, strings_name.str_female];
  String preferredGenderValue = strings_name.str_both;

  List<String> internshipDurationArr = <String>[strings_name.str_month_6, strings_name.str_month_12, strings_name.str_month_18, strings_name.str_month_24, strings_name.str_month_30, strings_name.str_month_36];
  String internshipDurationValue = strings_name.str_month_6;

  List<String> internshipModeArr = <String>[strings_name.str_mode_work_from_office, strings_name.str_mode_work_from_home, strings_name.str_mode_remote_work, strings_name.str_mode_project_based_work];
  String internshipModeValue = strings_name.str_mode_work_from_office;

  bool isVisible = false;
  var cloudinary;
  final apiRepository = getIt.get<ApiRepository>();

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
  }

  void createJobAlert() async {
    setState(() {
      isVisible = true;
    });

    var bondPath = "", incentivePath = "";
    if (bondFilePath.isNotEmpty) {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(bondFilePath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_BONDS),
      );
      bondPath = response.secureUrl;
    }
    if (incentiveStructureFilePath.isNotEmpty) {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(incentiveStructureFilePath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_COMPANY_INCENTIVE_STRUCTURE),
      );
      incentivePath = response.secureUrl;
    }

    CreateJobOpportunityRequest request = CreateJobOpportunityRequest();
    request.companyId = Get.arguments;
    request.jobTitle = jobTitleController.text.trim().toString();
    request.jobDescription = jobDescController.text.trim().toString();
    request.specificRequirements = jobSpecificReqController.text.trim().toString();
    request.stipendType = stipendType.trim().toString();
    if (stipendType == strings_name.str_amount_type_range) {
      request.stipendRangeMin = minRangeController.text.trim().toString();
      request.stipendRangeMax = maxRangeController.text.trim().toString();
    }
    request.vacancies = vacancyController.text.trim().toString();
    request.gender = preferredGenderValue.trim().toString();
    request.minimumAge = minAgeLimitController.text.trim().toString();
    request.timingStart = startTimeController.text.trim().toString();
    request.timingEnd = endTimeController.text.trim().toString();
    request.internshipModes = internshipModeValue.trim().toString();
    request.internshipDuration = internshipDurationValue.trim().toString();
    if (bondPath.isNotEmpty) {
      Map<String, dynamic> map = Map();
      map["url"] = bondPath;
      List<Map<String, dynamic>> listData = [];
      listData.add(map);

      request.bondStructure = listData;
    }
    if (incentivePath.isNotEmpty) {
      Map<String, dynamic> map = Map();
      map["url"] = incentivePath;
      List<Map<String, dynamic>> listData = [];
      listData.add(map);

      request.incentiveStructure = listData;
    }

    List<String> selectedHubData = [];
    for (var i = 0; i < hubsData!.length; i++) {
      selectedHubData.add(hubsData![i].id.toString());
    }
    request.hubIds = selectedHubData;

    List<String> selectedSpecializationData = [];
    for (var i = 0; i < specializationData!.length; i++) {
      selectedSpecializationData.add(specializationData![i].id.toString());
    }
    request.specializationIds = selectedSpecializationData;

    List<String> selectedSemesterData = [];
    for (var i = 0; i < semesterData!.length; i++) {
      selectedSemesterData.add(semesterData![i].semester.toString());
    }
    request.semester = selectedSemesterData;

    var resp = await apiRepository.createJobOpportunityApi(request);
    if (resp.id!.isNotEmpty) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBar(context, strings_name.str_job_added);
      await Future.delayed(const Duration(milliseconds: 2000));
      Get.back(closeOverlays: true, result: true);
    } else {
      setState(() {
        isVisible = false;
      });
    }
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
                  text: strings_name.str_job_title,
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
                  text: strings_name.str_job_desc,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: jobDescController,
                  minLines: 3,
                  maxLines: 3,
                  topValue: 0,
                ),
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
                  topValue: 0,
                ),
                SizedBox(height: 5.h),
                custom_text(
                  text: strings_name.str_stipend_amount,
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
                SizedBox(height: 5.h),
                custom_text(
                  text: strings_name.str_vacancy,
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
                      text: strings_name.str_select_hub,
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
                SizedBox(height: 5.h),
                custom_text(
                  text: strings_name.str_internship_timing,
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
                        showTimePicker(context: context, initialTime: TimeOfDay.now()).then((pickedTime) {
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
                          hintText: strings_name.str_end_time,
                          type: TextInputType.none,
                          textInputAction: TextInputAction.next,
                          controller: endTimeController,
                          topValue: 0,
                        ),
                      ),
                      onTap: () {
                        showTimePicker(context: context, initialTime: TimeOfDay.now()).then((pickedTime) {
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
                Visibility(visible: incentiveStructureFilePath.isNotEmpty, child: custom_text(text: incentiveStructureFilePath, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0)),
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
                    } else {
                      createJobAlert();
                    }
                  },
                )
              ],
            ),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }

  picBondFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      bondFilePath = result.files.single.path!;
    }
  }

  picIncentiveFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      incentiveStructureFilePath = result.files.single.path!;
    }
  }
}
