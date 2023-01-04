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
  TextEditingController joingYearController = TextEditingController();
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
  int semesterValue = -1;

  List<String> divisionResponseArray = <String>[TableNames.DIVISION_A, TableNames.DIVISION_B, TableNames.DIVISION_C, TableNames.DIVISION_D];
  String divisionValue = "";

  @override
  void initState() {
    super.initState();
    hubResponseArray = PreferenceUtils.getHubList().records;
    speResponseArray = PreferenceUtils.getSpecializationList().records;
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_add_student),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
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
                    textInputAction: TextInputAction.next,
                    controller: nameController,
                    topValue: 2,
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_email,
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
                    text: strings_name.str_phone,
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
                    text: strings_name.str_address,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 5,
                  ),
                  custom_edittext(
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: addressController,
                    topValue: 2,
                  ),
                  SizedBox(height: 3.h),
                  custom_text(
                    text: strings_name.str_city,
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
                    controller: joingYearController,
                    topValue: 2,
                    maxLength: 4,
                  ),
                  SizedBox(height: 5.h),
                  custom_text(
                    text: strings_name.str_select_hub,
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
                            focusColor: colors_name.colorPrimary,
                            onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                              setState(() {
                                hubValue = newValue!.fields!.hubId!.toString();
                                hubResponse = newValue;
                              });
                            },
                            items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
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
                    text: strings_name.str_select_spelization,
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
                            focusColor: colors_name.colorPrimary,
                            onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                              setState(() {
                                speValue = newValue!.fields!.specializationId.toString();
                                speResponse = newValue;
                              });
                            },
                            items: speResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>((BaseApiResponseWithSerializable<SpecializationResponse> value) {
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
                            elevation: 16,
                            style: blackText16,
                            focusColor: colors_name.colorPrimary,
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
                            style: blackText16,
                            focusColor: colors_name.colorPrimary,
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
                      } else if (addressController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_address);
                      } else if (cityController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_city);
                      } else if (gender.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_gender);
                      } else if (joingYearController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_joing_year);
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
                        response.joiningYear = joingYearController.text.trim().toString();
                        response.hubIds = Utils.getHubId(hubValue)!.split(",");
                        response.semester = semesterValue.toString();
                        response.division = divisionValue;

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
                        } else {
                          setState(() {
                            isVisible = false;
                          });
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
