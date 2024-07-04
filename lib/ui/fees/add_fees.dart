import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
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
import 'package:flutterdesigndemo/models/fees_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/request/fees_request.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/ui/fees/single_student_selection.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class AddFees extends StatefulWidget {
  const AddFees({super.key});

  @override
  State<AddFees> createState() => _AddFeesState();
}

class _AddFeesState extends State<AddFees> {
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  List<int> semesterResponseArray = <int>[-1, 1, 2, 3, 4, 5, 6];
  int semesterValue = -1;

  List<String> divisionResponseArray = <String>[TableNames.DIVISION_A, TableNames.DIVISION_B, TableNames.DIVISION_C, TableNames.DIVISION_D];
  String divisionValue = "";

  var fromUpdate = false;
  String offset = "";

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? viewStudent = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? studentList = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? selectedStudentData = [];

  TextEditingController feesPaymentController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  String popPath = "", popTitle = "";
  var popData;
  var cloudinary;

  FeesResponse? feesResponse;
  String? feesResponseId;

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    hubResponseArray = PreferenceUtils.getHubList().records;

    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      if ((loginData.accessible_hub_ids?.length ?? 0) > 0) {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          var isAccessible = false;
          for (var j = 0; j < loginData.accessible_hub_ids!.length; j++) {
            if (loginData.accessible_hub_ids![j] == hubResponseArray![i].id) {
              isAccessible = true;
              break;
            }
            if (loginData.hubIdFromHubIds?.first == hubResponseArray![i].fields?.hubId) {
              isAccessible = true;
              break;
            }
          }
          if (!isAccessible) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      } else {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          if (loginData.hubIdFromHubIds?.first != hubResponseArray![i].fields?.hubId) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      }
    }
  }

  getSpecializations() {
    speResponseArray = [];
    speResponseArray?.addAll(PreferenceUtils.getSpecializationList().records!);
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(fromUpdate ? strings_name.str_update_fees_record : strings_name.str_add_fees_record),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              custom_text(
                text: strings_name.str_select_hub_r,
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
                bottomValue: 0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                width: viewWidth,
                child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                  value: hubResponse,
                  elevation: 16,
                  isExpanded: true,
                  style: blackText16,
                  focusColor: Colors.white,
                  onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                    hubValue = newValue!.fields!.id!.toString();
                    hubResponse = newValue;
                    studentList = [];
                    feesPaymentController.text = "";
                    popTitle = "";

                    getSpecializations();
                    if (hubValue.trim().isNotEmpty) {
                      for (int i = 0; i < speResponseArray!.length; i++) {
                        if (speResponseArray![i].fields?.hubIdFromHubIds?.contains(hubResponse?.fields?.hubId) != true) {
                          speResponseArray!.removeAt(i);
                          i--;
                        }
                      }
                    }
                    speValue = "";
                    speResponse = null;
                    if (speResponseArray?.isEmpty == true) {
                      Utils.showSnackBar(context, strings_name.str_no_specialization_linked);
                    }
                    setState(() {});
                  },
                  items: hubResponseArray
                      ?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
                    return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                      value: value,
                      child: Text(value.fields!.hubName!.toString()),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 5.h),
              custom_text(
                text: strings_name.str_select_specialization_r,
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
                topValue: 0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                width: viewWidth,
                child: DropdownButtonFormField<BaseApiResponseWithSerializable<SpecializationResponse>>(
                  value: speResponse,
                  elevation: 16,
                  isExpanded: true,
                  style: blackText16,
                  focusColor: Colors.white,
                  onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                    setState(() {
                      speValue = newValue!.fields!.id.toString();
                      speResponse = newValue;
                      studentList = [];
                      feesPaymentController.text = "";
                      popTitle = "";
                    });
                  },
                  items: speResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>(
                      (BaseApiResponseWithSerializable<SpecializationResponse> value) {
                    return DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>(
                      value: value,
                      child: Text(value.fields!.specializationName.toString()),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 5.h),
              custom_text(
                text: strings_name.str_semester_r,
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
                topValue: 0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                width: viewWidth,
                child: DropdownButtonFormField<int>(
                  value: semesterValue,
                  elevation: 16,
                  style: blackText16,
                  focusColor: Colors.white,
                  onChanged: (int? newValue) {
                    setState(() {
                      semesterValue = newValue!;
                      studentList = [];
                      feesPaymentController.text = "";
                      popTitle = "";
                    });
                  },
                  items: semesterResponseArray.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value == -1 ? "Select semester" : "Semester $value"),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 5.h),
              custom_text(
                text: strings_name.str_division_r,
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
                        style: blackText16,
                        focusColor: Colors.white,
                        onChanged: (String? newValue) {
                          setState(() {
                            divisionValue = newValue!;
                            studentList = [];
                            feesPaymentController.text = "";
                            popTitle = "";
                          });
                        },
                        items: divisionResponseArray.map<DropdownMenuItem<String>>((String value) {
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
              Card(
                elevation: 5,
                child: Container(
                  color: colors_name.colorWhite,
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.h),
                  child: selectedStudentData?.isNotEmpty == true
                      ? Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                performClick();
                              },
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(selectedStudentData?.last.fields?.name ?? "", textAlign: TextAlign.center, style: blackTextSemiBold16),
                                Icon(Icons.edit_outlined, size: 25.h, color: colors_name.colorPrimary),
                              ]),
                            ),
                            GestureDetector(
                              onTap: () {
                                Utils.launchCaller(selectedStudentData?.last.fields?.mobileNumber ?? "");
                              },
                              child: custom_text(
                                text: selectedStudentData?.last.fields?.mobileNumber ?? "",
                                textStyles: linkTextSemiBold16,
                                topValue: 5,
                                leftValue: 0,
                                bottomValue: 0,
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            performClick();
                          },
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            const Text(strings_name.str_select_student, textAlign: TextAlign.center, style: blackTextSemiBold16),
                            Icon(Icons.keyboard_arrow_right, size: 25.h, color: colors_name.colorPrimary),
                          ]),
                        ),
                ),
              ),
              selectedStudentData?.isNotEmpty == true
                  ? Column(
                      children: [
                        custom_text(
                          text: "${strings_name.str_enter_fees_paid}*",
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                        ),
                        custom_edittext(
                          type: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: feesPaymentController,
                          maxLength: 6,
                          topValue: 2,
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            custom_text(
                              text: strings_name.str_proof_of_payment,
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                              leftValue: 10,
                            ),
                            GestureDetector(
                              child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black)),
                              onTap: () {
                                picPOPFile();
                              },
                            ),
                          ],
                        ),
                        Visibility(
                          visible: popPath.isNotEmpty,
                          child: Column(
                            children: [
                              SizedBox(height: 3.h),
                              custom_text(text: popTitle, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0),
                            ],
                          ),
                        ),
                        custom_text(
                          text: strings_name.str_file_size_limit,
                          alignment: Alignment.topLeft,
                          maxLines: 3,
                          textStyles: primaryTextSemiBold14,
                          leftValue: 10,
                        ),
                        custom_text(
                          text: strings_name.str_remarks,
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold16,
                        ),
                        custom_edittext(
                          type: TextInputType.multiline,
                          topValue: 2,
                          maxLines: 5,
                          minLines: 4,
                          maxLength: 5000,
                          textInputAction: TextInputAction.next,
                          controller: remarksController,
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height: 5.h),
              CustomButton(
                text: strings_name.str_submit,
                click: () {
                  if (hubValue.trim().isEmpty) {
                    Utils.showSnackBar(context, strings_name.str_empty_hub);
                  } else if (speValue.trim().isEmpty) {
                    Utils.showSnackBar(context, strings_name.str_empty_spe);
                  } else if (semesterValue == -1) {
                    Utils.showSnackBar(context, strings_name.str_empty_semester);
                  } else if (divisionValue.trim().isEmpty) {
                    Utils.showSnackBar(context, strings_name.str_empty_division);
                  } else if (studentList?.isEmpty == true) {
                    Utils.showSnackBar(context, strings_name.str_empty_select_student);
                  } else if (feesPaymentController.text.trim().isEmpty) {
                    Utils.showSnackBar(context, strings_name.str_empty_fees_paid);
                  } else if (popTitle.trim().isEmpty) {
                    Utils.showSnackBar(context, strings_name.str_empty_proof_of_payment);
                  } else {
                    submitData();
                  }
                },
              ),
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
        )
      ]),
    ));
  }

  performClick() {
    if (hubValue.isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_hub);
    } else if (speValue.isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_spe);
    } else if (semesterValue == -1) {
      Utils.showSnackBar(context, strings_name.str_empty_semester);
    } else if (divisionValue.isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_division);
    } else {
      viewStudent = [];
      studentList = [];

      fetchStudents();
    }
  }

  Future<void> fetchStudents() async {
    var query = "AND(${TableNames.CLM_HUB_IDS}='$hubValue'";

    if (speValue.isNotEmpty) {
      query += ",${TableNames.CLM_SPE_IDS}='$speValue'";
    }
    if (semesterValue != -1) {
      query += ",${TableNames.CLM_SEMESTER}='${semesterValue.toString()}'";
    }
    if (divisionValue.isNotEmpty) {
      query += ",${TableNames.CLM_DIVISION}='${divisionValue.toString()}'";
    }

    query += ")";
    debugPrint(query);

    setState(() {
      isVisible = true;
    });
    try {
      var data = await apiRepository.loginApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          viewStudent?.clear();
        }
        viewStudent?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchStudents();
        } else {
          viewStudent?.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
          filterData();

          setState(() {
            isVisible = false;
          });
        }
      } else {
        if (offset.isEmpty) {
          viewStudent = [];
        }
        offset = "";
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBarUsingGet(strings_name.str_no_students);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  void filterData() {
    if (viewStudent != null && viewStudent?.isNotEmpty == true) {
      studentList?.addAll(viewStudent!);

      if (studentList?.isNotEmpty == true) {
        studentList?.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
        Get.to(const SingleStudentSelection(), arguments: [
          {"studentList": studentList},
          {"selectedStudentData": selectedStudentData},
        ])?.then((result) {
          if (result != null) {
            selectedStudentData = result;
            setState(() {});
          }
        });
      } else {
        Utils.showSnackBarUsingGet(strings_name.str_no_students);
      }
    }
  }

  picPOPFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      if (result.files.single.size / (1024 * 1024) < 2) {
        popTitle = result.files.single.name;
        if (kIsWeb) {
          setState(() {
            popData = result.files.single;
            popPath = result.files.single.bytes.toString();
          });
        } else {
          setState(() {
            popPath = result.files.single.path!;
          });
        }
      } else {
        Utils.showSnackBar(context, strings_name.str_file_size_limit);
      }
    }
  }

  submitData() async {
    setState(() {
      isVisible = true;
    });

    try {
      var updatedPath = "";
      if (popTitle.isNotEmpty) {
        if (kIsWeb) {
          CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromByteData(Utils.uint8ListToByteData(popData.bytes!),
                resourceType: CloudinaryResourceType.Image, folder: TableNames.CLOUDARY_FOLDER_PROOF_OF_FEES, identifier: popData.name),
          );
          updatedPath = response.secureUrl;
        } else {
          CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(popPath, resourceType: CloudinaryResourceType.Image, folder: TableNames.CLOUDARY_FOLDER_PROOF_OF_FEES),
          );
          updatedPath = response.secureUrl;
        }
      }

      FeesRequest request = FeesRequest();
      request.studentId = selectedStudentData?.last.id?.split(",");
      request.feesPaid = int.tryParse(feesPaymentController.text.trim());
      request.feesBySemester = selectedStudentData?.last.fields?.semester;
      request.remarks = remarksController.text.trim();

      if (updatedPath.isNotEmpty) {
        Map<String, dynamic> map = Map();
        map["url"] = updatedPath;
        List<Map<String, dynamic>> listData = [];
        listData.add(map);
        request.proofOfPayment = listData;
      }

      var json = request.toJson();
      json.removeWhere((key, value) => value == null);

      if (fromUpdate) {
        var resp = await apiRepository.updateFeesRecord(json, feesResponseId!);
        if (resp.id != null) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_updated_fees_record);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      } else {
        var resp = await apiRepository.addFeesRecordApi(request);
        if (resp.id != null) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_added_fees_record);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      }
    } on Exception catch (e) {
      Utils.showSnackBar(context, strings_name.str_invalid_data);
      setState(() {
        isVisible = false;
      });
    }
  }
}
