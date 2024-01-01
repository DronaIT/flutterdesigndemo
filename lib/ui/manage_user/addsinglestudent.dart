import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/request/create_student_request.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/dio_exception.dart';

class AddSingleStudent extends StatefulWidget {
  const AddSingleStudent({Key? key}) : super(key: key);

  @override
  State<AddSingleStudent> createState() => _AddSingleStudentState();
}

class _AddSingleStudentState extends State<AddSingleStudent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isVisible = false;
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController joiningYearController = TextEditingController();
  TextEditingController batchController = TextEditingController();

  TextEditingController pincodeController = TextEditingController();
  TextEditingController srnumberController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController aadharcardnumberController = TextEditingController();
  TextEditingController casteController = TextEditingController();
  TextEditingController hscschoolController = TextEditingController();

  TextEditingController hscschoolcityController = TextEditingController();
  TextEditingController hscpercentageController = TextEditingController();
  TextEditingController mothernameController = TextEditingController();
  TextEditingController fathernumberController = TextEditingController();
  TextEditingController mothernumberController = TextEditingController();

  String gender = "Male";
  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  List<Map<String, CreateStudentRequest>> list = [];
  final addStudentRepository = getIt.get<ApiRepository>();

  List<int> semesterResponseArray = <int>[1, 2, 3, 4, 5, 6];
  int semesterValue = 1;
  List<String> divisionResponseArray = <String>[TableNames.DIVISION_A, TableNames.DIVISION_B, TableNames.DIVISION_C, TableNames.DIVISION_D];
  String divisionValue = TableNames.DIVISION_A;
  bool fromEdit = false;
  final apiRepository = getIt.get<ApiRepository>();
  var addStudentId;

  String formattedDate = "";

  @override
  void initState() {
    super.initState();
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

    checkCurrentData();
    initialization();
  }

  getSpecializations() {
    speResponseArray = [];
    speResponseArray?.addAll(PreferenceUtils.getSpecializationList().records!);
  }

  void checkCurrentData() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
  }

  Future<void> initialization() async {
    if (Get.arguments != null) {
      setState(() {
        isVisible = true;
      });
      var query = "FIND('${Get.arguments}', ${TableNames.TB_USERS_PHONE}, 0)";
      var data = await apiRepository.loginApi(query);
      try {
        if (data.records?.isNotEmpty == true) {
          getSpecializations();

          for (int i = 0; i < (speResponseArray?.length ?? 0); i++) {
            bool contains = false;
            for (int j = 0; j < (hubResponseArray?.length ?? 0); j++) {
              if (speResponseArray![i].fields!.hubIdFromHubIds?.contains(hubResponseArray![j].fields?.hubId) == true) {
                contains = true;
                break;
              }
            }
            if (!contains) {
              speResponseArray?.removeAt(i);
              i--;
            }
          }

          setState(() {
            fromEdit = true;
            if (data.records?.first.fields != null) {
              addStudentId = data.records?.first.id;
              nameController.text = data.records!.first.fields!.name ?? "";
              emailController.text = data.records!.first.fields!.email ?? "";
              phoneController.text = data.records!.first.fields!.mobileNumber ?? "";
              cityController.text = data.records!.first.fields!.city ?? "";
              addressController.text = data.records!.first.fields!.address ?? "";
              pincodeController.text = data.records!.first.fields!.pin_code ?? "";
              joiningYearController.text = data.records!.first.fields!.joiningYear ?? "";
              srnumberController.text = data.records!.first.fields!.sr_number ?? "";
              birthdateController.text = data.records!.first.fields!.birthdate ?? "";
              batchController.text = data.records!.first.fields!.batch ?? "";
              if (data.records!.first.fields!.birthdate?.isNotEmpty == true) {
                formattedDate = data.records!.first.fields!.birthdate ?? "";
              }
              aadharcardnumberController.text = data.records!.first.fields!.aadhar_card_number ?? "";
              casteController.text = data.records!.first.fields!.caste ?? "";
              hscpercentageController.text = data.records!.first.fields!.hsc_percentage ?? "";
              hscschoolcityController.text = data.records!.first.fields!.hsc_school_city ?? "";
              hscschoolController.text = data.records!.first.fields!.hsc_school ?? "";
              mothernumberController.text = data.records!.first.fields!.mother_number ?? "";
              fathernumberController.text = data.records!.first.fields!.father_number ?? "";
              mothernameController.text = data.records!.first.fields!.mother_name ?? "";
              gender = data.records!.first.fields!.gender ?? strings_name.str_male;
              for (var i = 0; i < speResponseArray!.length; i++) {
                if (data.records!.first.fields!.specializationIdFromSpecializationIds?[0] == speResponseArray![i].fields!.specializationId) {
                  setState(() {
                    speResponse = speResponseArray![i];
                    speValue = speResponseArray![i].fields!.specializationId!.toString();
                  });
                  break;
                }
              }
              for (var i = 0; i < hubResponseArray!.length; i++) {
                if (data.records!.first.fields!.hubIdFromHubIds?[0] == hubResponseArray![i].fields!.hubId) {
                  setState(() {
                    hubResponse = hubResponseArray![i];
                    hubValue = hubResponseArray![i].fields!.hubId!.toString();
                  });
                  break;
                }
              }

              for (var i = 0; i < semesterResponseArray.length; i++) {
                if (data.records!.first.fields!.semester == semesterResponseArray[i].toString()) {
                  setState(() {
                    semesterValue = semesterResponseArray[i];
                  });
                  break;
                }
              }
              for (var i = 0; i < divisionResponseArray.length; i++) {
                if (data.records!.first.fields!.division == divisionResponseArray[i].toString()) {
                  setState(() {
                    divisionValue = divisionResponseArray[i];
                  });
                  break;
                }
              }
            }
          });
        } else {
          Utils.showSnackBar(context, strings_name.str_something_wrong);
        }
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
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(fromEdit ? strings_name.str_update_student_details : strings_name.str_add_student),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  custom_text(
                    text: strings_name.str_student_name,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 5,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    capitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    controller: nameController,
                    topValue: 2,
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_email_add,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 5,
                  ),
                  custom_edittext(
                    type: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    topValue: 2,
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_phone_number,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 5,
                  ),
                  custom_edittext(
                    type: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    controller: phoneController,
                    maxLength: 10,
                    topValue: 2,
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_birthday,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 5,
                  ),
                  InkWell(
                    child: IgnorePointer(
                      child: custom_edittext(
                        type: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: birthdateController,
                        maxLength: 10,
                        topValue: 2,
                      ),
                    ),
                    onTap: () {
                      showDatePicker(
                              context: context, initialDate: DateTime.parse(formattedDate), firstDate: DateTime(1950), lastDate: DateTime.now())
                          .then((pickedDate) {
                        if (pickedDate == null) {
                          return;
                        }
                        setState(() {
                          var formatter = DateFormat('yyyy-MM-dd');
                          formattedDate = formatter.format(pickedDate);
                          birthdateController.text = formattedDate;
                        });
                      });
                    },
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_mother_name,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 5,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: mothernameController,
                    maxLength: 10,
                    topValue: 2,
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              custom_text(
                                text: strings_name.str_father_number,
                                alignment: Alignment.topLeft,
                                textStyles: blackTextSemiBold16,
                                topValue: 5,
                              ),
                              custom_edittext(
                                type: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                controller: fathernumberController,
                                maxLength: 10,
                                topValue: 2,
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              custom_text(
                                text: strings_name.str_mother_number,
                                alignment: Alignment.topLeft,
                                textStyles: blackTextSemiBold16,
                                topValue: 5,
                              ),
                              custom_edittext(
                                type: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                controller: mothernumberController,
                                maxLength: 10,
                                topValue: 2,
                              ),
                            ],
                          ))
                    ],
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_address_r,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 5,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: addressController,
                    topValue: 2,
                    maxLines: 3,
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              custom_text(
                                text: strings_name.str_city_r,
                                alignment: Alignment.topLeft,
                                textStyles: blackTextSemiBold16,
                                topValue: 5,
                              ),
                              custom_edittext(
                                type: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: cityController,
                                topValue: 2,
                              ),
                            ],
                          )),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            custom_text(
                              text: strings_name.str_pincode,
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                              topValue: 5,
                            ),
                            custom_edittext(
                              type: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              controller: pincodeController,
                              topValue: 2,
                              maxLength: 6,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_select_gender,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: RadioListTile(
                          activeColor: colors_name.colorPrimary,
                          title: custom_text(
                            text: strings_name.str_male,
                            textStyles: blackTextSemiBold16,
                            bottomValue: 0,
                            topValue: 0,
                            leftValue: 5,
                            rightValue: 5,
                          ),
                          value: strings_name.str_male,
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value.toString();
                            });
                          },
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: RadioListTile(
                          activeColor: colors_name.colorPrimary,
                          title: custom_text(
                            text: strings_name.str_female,
                            textStyles: blackTextSemiBold16,
                            bottomValue: 0,
                            topValue: 0,
                            leftValue: 5,
                            rightValue: 5,
                          ),
                          value: strings_name.str_female,
                          groupValue: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  custom_text(
                    text: strings_name.str_joining_year,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: joiningYearController,
                    topValue: 2,
                    maxLength: 4,
                  ),
                  SizedBox(height: 2.h),
                  custom_text(
                    text: strings_name.str_batch,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: batchController,
                    topValue: 2,
                    maxLength: 10,
                  ),
                  SizedBox(height: 2.h),
                  custom_text(
                    text: strings_name.str_serial_number,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    capitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.next,
                    controller: srnumberController,
                    topValue: 2,
                  ),
                  SizedBox(height: 5.h),
                  custom_text(
                    text: strings_name.str_select_hub_r,
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
                          child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                            value: hubResponse,
                            elevation: 16,
                            style: blackText16,
                            focusColor: Colors.white,
                            onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                              hubValue = newValue!.fields!.hubId!.toString();
                              hubResponse = newValue;

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
                            items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>(
                                (BaseApiResponseWithSerializable<HubResponse> value) {
                              return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                                value: value,
                                child: Text(value.fields!.hubName!.toString()),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  custom_text(
                    text: strings_name.str_select_specialization,
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
                          child: DropdownButtonFormField<BaseApiResponseWithSerializable<SpecializationResponse>>(
                            value: speResponse,
                            elevation: 16,
                            style: blackText16,
                            focusColor: Colors.white,
                            onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                              setState(() {
                                speValue = newValue!.fields!.specializationId.toString();
                                speResponse = newValue;
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
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  custom_text(
                    text: strings_name.str_semester,
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
                          child: DropdownButtonFormField<int>(
                            value: semesterValue,
                            elevation: 16,
                            style: blackText16,
                            focusColor: Colors.white,
                            onChanged: (int? newValue) {
                              setState(() {
                                semesterValue = newValue!;
                              });
                            },
                            items: semesterResponseArray.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text("Semester $value"),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  custom_text(
                    text: strings_name.str_division,
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
                            value: divisionValue,
                            style: blackText16,
                            focusColor: Colors.white,
                            onChanged: (String? newValue) {
                              setState(() {
                                divisionValue = newValue!;
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
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_adharcard_number,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 5,
                  ),
                  custom_edittext(
                    type: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: aadharcardnumberController,
                    maxLength: 12,
                    topValue: 2,
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_caste,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 5,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: casteController,
                    topValue: 2,
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_hsc_school,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 5,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: hscschoolController,
                    topValue: 2,
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                          flex: 7,
                          child: Column(
                            children: [
                              custom_text(
                                text: strings_name.str_hsc_school_city,
                                alignment: Alignment.topLeft,
                                textStyles: blackTextSemiBold16,
                                topValue: 5,
                              ),
                              custom_edittext(
                                type: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                controller: hscschoolcityController,
                                topValue: 2,
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              custom_text(
                                text: strings_name.str_hsc_percentage,
                                alignment: Alignment.topLeft,
                                textStyles: blackTextSemiBold16,
                                topValue: 5,
                              ),
                              custom_edittext(
                                type: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                controller: hscpercentageController,
                                topValue: 2,
                              ),
                            ],
                          ))
                    ],
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    text: strings_name.str_submit,
                    click: () async {
                      var phone = FormValidator.validatePhone(phoneController.text.toString().trim());
                      var email = FormValidator.validateEmail(emailController.text.toString().trim());
                      if (nameController.text.isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_sname);
                      } else if (!email) {
                        Utils.showSnackBar(context, strings_name.str_empty_email);
                      } else if (phone.isNotEmpty) {
                        Utils.showSnackBar(context, phone);
                        // } else if (birthdateController.text.trim().isEmpty) {
                        //   Utils.showSnackBar(context, strings_name.str_empty_brithdate);
                      } else if (addressController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_address);
                      } else if (cityController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_city);
                        // } else if (pincodeController.text.trim().isEmpty) {
                        //   Utils.showSnackBar(context, strings_name.str_empty_pincode);
                      } else if (gender.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_gender);
                      } else if (joiningYearController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_joing_year);
                      } else if (batchController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_batch);
                      } else if (speValue.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_spe);
                      } else if (hubValue.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_hub);
                      } else if (semesterValue == -1) {
                        Utils.showSnackBar(context, strings_name.str_empty_semester);
                      } else if (divisionValue.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_division);
                      } else {
                        setState(() {
                          isVisible = true;
                        });
                        CreateStudentRequest response = CreateStudentRequest();
                        response.name = nameController.text.trim().toString();
                        response.mobileNumber = phoneController.text.trim().toString();
                        response.email = emailController.text.trim().toString();
                        response.gender = gender.trim().toString();
                        response.city = cityController.text.trim().toString();
                        response.address = addressController.text.trim().toString();
                        response.specializationIds = Utils.getSpecializationId(speValue)!.split(",");
                        response.joiningYear = joiningYearController.text.trim().toString();
                        response.batch = batchController.text.trim().toString();
                        response.hubIds = Utils.getHubId(hubValue)!.split(",");
                        response.semester = semesterValue.toString();
                        response.division = divisionValue;
                        response.pinCode = pincodeController.text.trim().toString();
                        if (birthdateController.text.trim().isNotEmpty) response.birthdate = birthdateController.text.trim().toString();
                        response.motherName = mothernameController.text.trim().toString();
                        response.motherNumber = mothernumberController.text.trim().toString();
                        response.fatherNumber = fathernumberController.text.trim().toString();
                        response.aadharCardNumber = aadharcardnumberController.text.trim().toString();
                        response.caste = casteController.text.trim().toString();
                        response.hscSchool = hscschoolController.text.trim().toString();
                        response.hscSchoolCity = hscschoolcityController.text.trim().toString();
                        response.hscPercentage = hscpercentageController.text.trim().toString();
                        response.srNumber = srnumberController.text.trim().toString();
                        try {
                          if (!fromEdit) {
                            var query = "FIND('${response.mobileNumber.toString()}', ${TableNames.TB_USERS_PHONE}, 0)";
                            var checkMobile = await addStudentRepository.loginApi(query);
                            if (checkMobile.records?.isEmpty == true) {
                              Map<String, CreateStudentRequest> map = Map();
                              map["fields"] = response;
                              list.add(map);
                            } else {
                              setState(() {
                                isVisible = false;
                              });
                              Utils.showSnackBarDuration(context, strings_name.str_student_exists, 5);
                            }
                            if (list.isNotEmpty) {
                              try {
                                var resp = await addStudentRepository.createStudentApi(list);
                                if (resp.records!.isNotEmpty) {
                                  setState(() {
                                    isVisible = false;
                                  });
                                  Utils.showSnackBar(context, strings_name.str_student_added);
                                  await Future.delayed(const Duration(milliseconds: 2000));
                                  Get.back(closeOverlays: true);
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
                            } else {
                              setState(() {
                                isVisible = false;
                              });
                            }
                          } else {
                            var json = response.toJson();
                            json.removeWhere((key, value) => value == null);

                            Map<String, dynamic> map = Map();
                            map["fields"] = json;
                            var updateStudent = await apiRepository.updateStudentApi(map, addStudentId);
                            if (updateStudent != null) {
                              setState(() {
                                isVisible = false;
                              });
                              Utils.showSnackBar(context, strings_name.str_student_update);
                              await Future.delayed(const Duration(milliseconds: 2000));
                              Get.back(closeOverlays: true, result: true);
                            } else {
                              setState(() {
                                isVisible = false;
                              });
                              Utils.showSnackBar(context, strings_name.str_something_wrong);
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
                    },
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
