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

  @override
  void initState() {
    super.initState();
    hubResponseArray = PreferenceUtils.getHubList().records;
    speResponseArray = PreferenceUtils.getSpecializationList().records;
    initialization();
  }

  Future<void> initialization() async {
    if (Get.arguments != null) {
      setState(() {
        isVisible = true;
      });
      var query = "FIND('${Get.arguments}', ${TableNames.TB_USERS_PHONE}, 0)";
      var data = await apiRepository.loginApi(query);
      if (data.records?.isNotEmpty == true) {
        setState(() {
          fromEdit = true;
          if( data.records?.first.fields != null){
            addStudentId = data.records?.first.id;
            nameController.text = data.records!.first.fields!.name.toString() ;
            emailController.text = data.records!.first.fields!.email.toString() ;
            phoneController.text = data.records!.first.fields!.mobileNumber.toString() ;
            cityController.text = data.records!.first.fields!.city.toString() ;
            addressController.text = data.records!.first.fields!.address.toString() ;
            pincodeController.text = data.records!.first.fields!.pin_code.toString() ;
            joingYearController.text = data.records!.first.fields!.joiningYear.toString() ;
            srnumberController.text = data.records!.first.fields!.sr_number.toString() ;
            birthdateController.text = data.records!.first.fields!.birthdate.toString() ;
            aadharcardnumberController.text = data.records!.first.fields!.aadhar_card_number.toString() ;
            casteController.text = data.records!.first.fields!.caste.toString() ;
            hscpercentageController.text = data.records!.first.fields!.hsc_percentage.toString() ;
            hscschoolcityController.text = data.records!.first.fields!.hsc_school_city.toString() ;
            hscschoolController.text = data.records!.first.fields!.hsc_school.toString() ;
            mothernumberController.text = data.records!.first.fields!.mother_number.toString() ;
            fathernumberController.text = data.records!.first.fields!.father_number.toString() ;
            mothernameController.text = data.records!.first.fields!.mother_name.toString() ;
            for( var i = 0 ; i < speResponseArray!.length; i++){
              if(data.records!.first.fields!.specializationIdFromSpecializationIds?[0] == speResponseArray![i].fields!.specializationId){
                setState(() {
                  speResponse = speResponseArray![i];
                  speValue =speResponseArray![i].fields!.specializationId!.toString();
                });
                break;
              }
            }
            for( var i = 0 ; i < hubResponseArray!.length; i++){
              if(data.records!.first.fields!.hubIdFromHubIds?[0] == hubResponseArray![i].fields!.hubId){
                setState(() {
                  hubResponse = hubResponseArray![i];
                  hubValue =hubResponseArray![i].fields!.hubId!.toString();
                });
                break;
              }
            }

            for( var i = 0 ; i < semesterResponseArray.length; i++){
              if(data.records!.first.fields!.semester == semesterResponseArray[i].toString()){
                setState(() {
                  semesterValue =semesterResponseArray[i];
                });
                break;
              }
            }
            for( var i = 0 ; i < divisionResponseArray.length; i++){
              if(data.records!.first.fields!.division == divisionResponseArray[i].toString()){
                setState(() {
                  divisionValue =divisionResponseArray[i];
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
    }

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
                    text: strings_name.str_brithday,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                    topValue: 5,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: custom_edittext(
                      type: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: birthdateController,
                      maxLength: 10,
                      topValue: 2,
                    ),
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
                  Row(
                    children: [
                      Expanded(
                          flex: 6,
                          child: Column(
                            children: [
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
                    controller: joingYearController,
                    topValue: 2,
                    maxLength: 4,
                  ),
                  SizedBox(height: 2.h),
                  custom_text(
                    text: strings_name.str_serial_number,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold16,
                  ),
                  custom_edittext(
                    type: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: srnumberController,
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
                            focusColor: Colors.white,
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
                            focusColor: Colors.white,
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
                            value:  semesterValue,
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
                            value:  divisionValue,
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
                      } else if (birthdateController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_brithdate);
                      } else if (addressController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_address);
                      } else if (cityController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_city);
                      } else if (pincodeController.text.trim().isEmpty) {
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
                        response.pinCode = pincodeController.text.trim().toString();
                        response.birthdate = birthdateController.text.trim().toString();
                        response.motherName = mothernameController.text.trim().toString();
                        response.motherNumber = mothernumberController.text.trim().toString();
                        response.fatherNumber = fathernumberController.text.trim().toString();
                        response.aadharCardNumber = aadharcardnumberController.text.trim().toString();
                        response.caste = casteController.text.trim().toString();
                        response.hscSchool = hscschoolController.text.trim().toString();
                        response.hscSchoolCity = hscschoolcityController.text.trim().toString();
                        response.hscPercentage = hscpercentageController.text.trim().toString();
                        response.srNumber = srnumberController.text.trim().toString();
                        if(!fromEdit){
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
                        }else{
                          Map<String, CreateStudentRequest> map = Map();
                          map["fields"] = response;
                          var updateStudent = await apiRepository.updateStudentApi(map,addStudentId);
                          if(updateStudent != null){
                            setState(() {
                              isVisible = false;
                            });
                            Utils.showSnackBar(context, strings_name.str_student_update);
                            await Future.delayed(const Duration(milliseconds: 2000));
                            Get.back(closeOverlays: true, result: true);
                          }else{
                            setState(() {
                              isVisible = false;
                            });
                            Utils.showSnackBar(context, strings_name.str_something_wrong);
                          }
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
