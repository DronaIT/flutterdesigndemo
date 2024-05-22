import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/request/student_referral_request.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';

class AddStudentReferral extends StatefulWidget {
  const AddStudentReferral({Key? key}) : super(key: key);

  @override
  State<AddStudentReferral> createState() => _AddStudentReferralState();
}

class _AddStudentReferralState extends State<AddStudentReferral> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  String? statesValue = "Select State", cityValue = "Select City";
  List<String>? statesArray = [];
  List<String>? cityArray = [];
  List<Map<String, StudentReferralRequest>> list = [];
  bool value = false;

  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  String _otp = "";

  @override
  void initState() {
    super.initState();
    hubResponseArray = PreferenceUtils.getHubList().records;
    if (hubResponseArray!.isNotEmpty) {
      for (int i = 0; i < hubResponseArray!.length; i++) {
        if (hubResponseArray![i].fields?.hubId == TableNames.CANCELLED_HUB_ID) {
          hubResponseArray?.removeAt(i);
          i--;
        } else if (hubResponseArray![i].fields?.hubId == TableNames.SUSPENDED_HUB_ID) {
          hubResponseArray?.removeAt(i);
          i--;
        }
      }
    }
    getStates();
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_student_referral),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                const custom_text(
                  text: strings_name.str_referral_name,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: nameController,
                  topValue: 0,
                ),
                SizedBox(height: 5.h),
                const custom_text(
                  text: strings_name.str_email,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: emailController,
                  topValue: 0,
                ),
                SizedBox(height: 5.h),
                const custom_text(
                  text: strings_name.str_phone,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  bottomValue: 0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: custom_edittext(
                          type: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          controller: TextEditingController(),
                          readOnly: true,
                          hintText: "+91",
                          textalign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: custom_edittext(
                        type: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        controller: mobileController,
                        maxLength: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                const custom_text(
                  text: strings_name.str_select_state,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  bottomValue: 0,
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
                          value: statesValue,
                          focusColor: Colors.white,
                          onChanged: (String? newValue) {
                            statesValue = newValue!;
                            getCities();
                          },
                          items: statesArray?.map<DropdownMenuItem<String>>((String value) {
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
                const custom_text(
                  text: strings_name.str_select_city,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  bottomValue: 0,
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
                          value: cityValue,
                          focusColor: Colors.white,
                          onChanged: (String? newValue) {
                            setState(() {
                              cityValue = newValue!;
                            });
                          },
                          items: cityArray?.map<DropdownMenuItem<String>>((String? value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value ?? ""),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                const custom_text(
                  text: strings_name.str_select_hub,
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
                    style: blackText16,
                    focusColor: Colors.white,
                    onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                      hubValue = newValue!.fields!.id!.toString();
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
                    items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
                      return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                        value: value,
                        child: Text(value.fields!.hubName!.toString()),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 5.h),
                const custom_text(
                  text: strings_name.str_select_specialization,
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
                    style: blackText16,
                    focusColor: Colors.white,
                    onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                      setState(() {
                        speValue = newValue!.fields!.id.toString();
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
                SizedBox(height: 15.h),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: value,
                      activeColor: colors_name.colorPrimary,
                      onChanged: (bool? value) {
                        setState(() {
                          this.value = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'I hereby accept the ',
                              style: primaryTextSemiBold14,
                            ),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: primaryTextSemiBold14,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await launchUrl(Uri.parse("https://pastebin.com/raw/k1GDRjm9"), mode: LaunchMode.inAppWebView, webViewConfiguration: const WebViewConfiguration(enableJavaScript: true));
                                },
                            ),
                            const TextSpan(
                              text: ' of Drona Foundation.',
                              style: primaryTextSemiBold14,
                            ),
                          ],
                        ),
                      ), //Text
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                CustomButton(
                    text: strings_name.str_submit,
                    click: () async {
                      var phone = FormValidator.validatePhone(mobileController.text.toString().trim());
                      if (nameController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_referral_name);
                      } else if (emailController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_email);
                      } else if (phone.isNotEmpty) {
                        Utils.showSnackBar(context, phone);
                      } else if (statesValue.toString().trim() == "Select State") {
                        Utils.showSnackBar(context, strings_name.str_empty_select_state);
                      } else if (cityValue.toString().trim() == "Select City") {
                        Utils.showSnackBar(context, strings_name.str_empty_select_city);
                      } else if (hubValue.isEmpty == true) {
                        Utils.showSnackBar(context, strings_name.str_empty_hub);
                      } else if (speValue.isEmpty == true) {
                        Utils.showSnackBar(context, strings_name.str_empty_spe);
                      } else if (!value) {
                        Utils.showSnackBar(context, strings_name.str_accept_terms_only);
                      } else {
                        sendOTP();
                      }
                    })
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
        ],
      ),
    ));
  }

  Future<void> verifyOTP(int validOtp) async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const custom_text(
            text: 'OTP Verification',
            textStyles: primaryTextSemiBold16,
            maxLines: 3,
          ),
          SizedBox(height: 5.h),
          custom_text(
            text: 'We have sent an OTP to your provided mobile number +91${mobileController.text.trim().toString()}',
            textStyles: blackTextSemiBold14,
            maxLines: 3,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: PinCodeTextField(
              textStyle: centerTextStyleBlack18,
              keyboardType: TextInputType.number,
              backgroundColor: Colors.transparent,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                activeFillColor: Colors.transparent,
                inactiveColor: colors_name.colorgraylight,
                selectedColor: colors_name.colorPrimary,
                activeColor: colors_name.colorPrimary,
                selectedFillColor: Colors.transparent,
                inactiveFillColor: Colors.transparent,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
              ),
              cursorColor: Colors.black,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              onCompleted: (v) {
                _otp = v;
              },
              onChanged: (value) {},
              beforeTextPaste: (text) {
                debugPrint("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
              appContext: context,
            ),
          ),
          CustomButton(
              text: strings_name.str_confirm,
              click: () {
                //debugPrint("otp=>${_otp}");
                if (_otp.isEmpty) {
                  Utils.showSnackBar(context, strings_name.str_enter_otp);
                } else if (_otp.toString() == validOtp.toString()) {
                  Get.back(closeOverlays: true);
                  addInquiry();
                } else {
                  Utils.showSnackBar(context, strings_name.str_enter_otp);
                }
              }),
        ],
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  Future<void> getStates() async {
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.get(Uri.parse('https://countriesnow.space/api/v0.1/countries/states/q?country=India'));

      if (response.statusCode == 200 || response.statusCode == 202) {
        var res = json.decode(response.body.toString());

        statesArray?.clear();
        statesArray?.add("Select State");

        cityValue = "Select City";
        cityArray?.clear();
        cityArray?.add(cityValue!);

        for (int i = 0; i < res['data']['states'].length; i++) {
          statesArray?.add(res['data']['states'][i]['name']);
        }
        setState(() {
          isVisible = false;
        });
      } else {
        Utils.showSnackBar(context, response.reasonPhrase.toString());
      }
    } on SocketException catch (e) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBarUsingGet("No Internet");
    }
  }

  Future<void> getCities() async {
    try {
      setState(() {
        isVisible = true;
      });
      cityValue = "Select City";
      cityArray = [];

      var response = await http.get(Uri.parse('https://countriesnow.space/api/v0.1/countries/state/cities/q?country=India&state=${statesValue?.trim().replaceAll(" ", '%20')}'));

      if (response.statusCode == 200 || response.statusCode == 202) {
        var res = json.decode(response.body.toString());
        cityArray?.add(cityValue!);
        if (res['data'] != null && res['data'].length > 0) {
          for (int i = 0; i < res['data'].length; i++) {
            cityArray?.add(res['data'][i]);
          }
        }
        setState(() {
          isVisible = false;
        });
      } else {
        Utils.showSnackBar(context, response.reasonPhrase.toString());
      }
    } on SocketException catch (e) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBarUsingGet("No Internet");
    }
  }

  Future<void> sendOTP() async {
    try {
      setState(() {
        isVisible = true;
      });
      var otp = Random().nextInt(900000) + 100000;
      var headers = {'Content-Type': 'application/json', 'api-key': TableNames.KALEYRA_APIKEY};
      var request = http.MultipartRequest('POST', Uri.parse('https://api.kaleyra.io/v1/HXIN1756562868IN/messages'));
      request.fields.addAll({
        'to': '+91${mobileController.text.trim()}',
        'type': 'OTP',
        'sender': TableNames.KALEYRA_SENDER,
        'template': TableNames.TEMPLATE_ID_VERIFICATION,
        'body': 'Your OTP for Drona Foundation Mobile App login is $otp. The OTP is valid for 5 minutes.'
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 202) {
        setState(() {
          isVisible = false;
        });
        verifyOTP(otp);
      } else {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, response.reasonPhrase.toString());
      }
    } on SocketException catch (_) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBarUsingGet("No Internet");
    }
  }

  addInquiry() async {
    setState(() {
      isVisible = true;
    });
    StudentReferralRequest response = StudentReferralRequest();
    response.name = nameController.text.trim().toString();
    response.state = statesValue;
    response.city = cityValue;
    response.mobile_number = mobileController.text.trim().toString();
    response.email = emailController.text.trim().toString();
    response.hub_id = hubResponse?.id?.split(",");
    response.specialization_id = speResponse?.id?.split(",");
    response.student_id = PreferenceUtils.getLoginRecordId().split(",");
    response.status = strings_name.str_referral_status_pending;

    try {
      var query = "AND(mobile_number='${mobileController.text.trim().toString()}')";

      var res = await apiRepository.getStudentReferralDataApi(query);
      if (res.records?.isEmpty == true) {
        var resp = await apiRepository.addStudentReferralApi(response);
        if (resp.id != null) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_student_referral_added);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(closeOverlays: true, result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_student_referral_already_exist);
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
