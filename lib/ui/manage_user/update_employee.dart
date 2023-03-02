import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
import 'package:flutterdesigndemo/models/role_response.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/ui/manage_user/hub_selection.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class UpdateEmployee extends StatefulWidget {
  const UpdateEmployee({Key? key}) : super(key: key);

  @override
  State<UpdateEmployee> createState() => _UpdateEmployeeState();
}

class _UpdateEmployeeState extends State<UpdateEmployee> {
  bool isVisible = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String gender = "Male";
  String employeeCode = " ";
  String roleValue = "";
  BaseApiResponseWithSerializable<RoleResponse>? roleResponse;
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<RoleResponse>>? roleResponseArray = [];
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];
  final apiRepository = getIt.get<ApiRepository>();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  TextEditingController parentController = TextEditingController();
  TextEditingController spouseController = TextEditingController();

  List<BaseApiResponseWithSerializable<HubResponse>>? accessibleHubsData = [];

  @override
  void initState() {
    super.initState();
    hubResponseArray = PreferenceUtils.getHubList().records;
    roleResponseArray = PreferenceUtils.getRoleList().records;
    var loginData = PreferenceUtils.getLoginDataEmployee();

    var authority = -1;
    for (var i = 0; i < roleResponseArray!.length; i++) {
      if (roleResponseArray![i].fields!.roleId! == loginData.roleIdFromRoleIds![0]) {
        authority = roleResponseArray![i].fields!.roleAuthority!;
        break;
      }
    }
    if (authority != -1) {
      for (var i = 0; i < roleResponseArray!.length; i++) {
        if (authority > roleResponseArray![i].fields!.roleAuthority! || roleResponseArray![i].fields?.roleId == TableNames.STUDENT_ROLE_ID) {
          roleResponseArray!.removeAt(i);
          i--;
        }
      }
    }

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

    BaseApiResponseWithSerializable<ViewEmployeeResponse> data = Get.arguments;
    nameController.text = data.fields!.employeeName!;
    phoneController.text = data.fields!.mobileNumber!;
    emailController.text = data.fields!.email!;
    addressController.text = data.fields!.address ?? "";
    cityController.text = data.fields!.city ?? "";
    gender = data.fields!.gender ?? "";
    employeeCode = data.fields!.employeeCode!;
    cityController.text = data.fields!.city ?? "";

    pinCodeController.text = data.fields!.pin_code ?? "";
    spouseController.text = data.fields!.spouse_mobile_number ?? "";
    parentController.text = data.fields!.parents_mobile_number ?? "";

    for (var i = 0; i < roleResponseArray!.length; i++) {
      if (data.fields!.roleIdFromRoleIds![0] == roleResponseArray![i].fields!.roleId) {
        setState(() {
          roleResponse = roleResponseArray![i];
          roleValue = roleResponseArray![i].fields!.roleId!.toString();
        });
        break;
      }
    }
    for (var i = 0; i < hubResponseArray!.length; i++) {
      if (data.fields!.hubIdFromHubIds![0] == hubResponseArray![i].fields!.hubId) {
        setState(() {
          hubResponse = hubResponseArray![i];
          hubValue = hubResponseArray![i].fields!.hubId!.toString();
        });
        break;
      }
    }
    if ((data.fields!.accessible_hub_ids?.length ?? 0) > 0) {
      for (var i = 0; i < data.fields!.accessible_hub_ids!.length; i++) {
        for (var j = 0; j < hubResponseArray!.length; j++) {
          if (data.fields!.accessible_hub_ids![i] == hubResponseArray![j].id) {
            accessibleHubsData?.add(hubResponseArray![j]);
            break;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_update_employee),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: 10.h),
                    custom_text(
                      text: strings_name.str_employee_name + " (" + employeeCode + ")",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(
                      type: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: nameController,
                      topValue: 5,
                    ),
                    SizedBox(height: 5.h),
                    custom_text(
                      text: strings_name.str_phone,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(
                      type: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      controller: phoneController,
                      maxLength: 10,
                      topValue: 5,
                      readOnly: true,
                      enabled: false,
                    ),
                    SizedBox(height: 5.h),
                    custom_text(
                      text: strings_name.str_email,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                      topValue: 2,
                    ),
                    custom_edittext(
                      type: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      topValue: 2,
                    ),
                    SizedBox(height: 5.h),
                    custom_text(
                      text: strings_name.str_address,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(
                      type: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: addressController,
                      topValue: 2,
                    ),
                    SizedBox(height: 5.h),
                    custom_text(
                      text: strings_name.str_city,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(
                      type: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: cityController,
                      maxLength: 30,
                      topValue: 5,
                    ),
                    SizedBox(height: 5.h),
                    custom_text(
                      text: strings_name.str_pincode,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(
                      type: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: pinCodeController,
                      maxLength: 6,
                      topValue: 2,
                    ),
                    SizedBox(height: 5.h),
                    custom_text(
                      text: strings_name.str_parent_number,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(
                      type: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: parentController,
                      maxLength: 10,
                      topValue: 2,
                    ),
                    SizedBox(height: 5.h),
                    custom_text(
                      text: strings_name.str_spouse_number,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(
                      type: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: spouseController,
                      maxLength: 10,
                      topValue: 2,
                    ),
                    SizedBox(height: 5.h),
                    custom_text(
                      text: strings_name.str_select_gender,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
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
                    SizedBox(height: 5.h),
                    custom_text(
                      text: strings_name.str_select_role,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Container(
                            width: viewWidth,
                            margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                            child: DropdownButtonFormField<BaseApiResponseWithSerializable<RoleResponse>>(
                              value: roleResponse,
                              elevation: 16,
                              style: blackText16,
                              focusColor: Colors.white,
                              onChanged: (BaseApiResponseWithSerializable<RoleResponse>? newValue) {
                                setState(() {
                                  roleValue = newValue!.fields!.roleId!.toString();
                                  roleResponse = newValue;
                                });
                              },
                              items: roleResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<RoleResponse>>>((BaseApiResponseWithSerializable<RoleResponse> value) {
                                return DropdownMenuItem<BaseApiResponseWithSerializable<RoleResponse>>(
                                  value: value,
                                  child: Text(value.fields!.roleTitle!),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
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
                            margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          custom_text(
                            text: strings_name.str_select_accessible_hub,
                            alignment: Alignment.topLeft,
                            textStyles: blackTextSemiBold16,
                          ),
                          GestureDetector(
                            child: custom_text(
                              text: accessibleHubsData?.isEmpty == true ? strings_name.str_add : strings_name.str_update,
                              alignment: Alignment.topLeft,
                              textStyles: primaryTextSemiBold16,
                            ),
                            onTap: () {
                              Get.to(const HubSelection(), arguments: accessibleHubsData)?.then((result) {
                                if (result != null) {
                                  setState(() {
                                    accessibleHubsData = result;
                                  });
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    accessibleHubsData!.isNotEmpty
                        ? ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: accessibleHubsData?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 5,
                                child: GestureDetector(
                                  child: Container(
                                    color: colors_name.colorWhite,
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [Expanded(child: Text("${accessibleHubsData![index].fields!.hubName}", textAlign: TextAlign.start, style: blackText16)), const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                                    ),
                                  ),
                                  onTap: () {
                                    // Get.to(const (), arguments: unitsData![index].fields?.ids);
                                  },
                                ),
                              );
                            })
                        : Container(),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: strings_name.str_submit,
                      click: () async {
                        var email = FormValidator.validateEmail(emailController.text.toString().trim());
                        if (nameController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_name);
                        } else if (!email) {
                          Utils.showSnackBar(context, strings_name.str_empty_city);
                        } else if (addressController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_address);
                        } else if (cityController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_city);
                        } else if (pinCodeController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_pincode);
                        } else if (gender.isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_gender);
                        } else if (roleValue.isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_role);
                        } else if (hubValue.isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_hub);
                        } else {
                          List<String> accessibleHubList = [];
                          for (var i = 0; i < accessibleHubsData!.length; i++) {
                            accessibleHubList.add(accessibleHubsData![i].id.toString());
                          }

                          Map<String, dynamic> updateEmployee = {
                            "employee_name": nameController.text.toString(),
                            "address": addressController.text.toString(),
                            "email": emailController.text.toString(),
                            "gender": gender,
                            "city": cityController.text.toString(),
                            "role_ids": Utils.getRoleId(roleValue)!.split(","),
                            "hub_ids": Utils.getHubId(hubValue)!.split(","),
                            "pin_code": pinCodeController.text.toString(),
                            "parents_mobile_number": parentController.text.toString(),
                            "spouse_mobile_number": spouseController.text.toString(),
                            "accessible_hub_ids": accessibleHubList,
                          };
                          setState(() {
                            isVisible = true;
                          });
                          try{
                            var updateEmployees = await apiRepository.updateEmployeeApi(updateEmployee, Get.arguments.id);
                            if (updateEmployees != null) {
                              setState(() {
                                isVisible = false;
                              });
                              Utils.showSnackBar(context, strings_name.str_employee_update);
                              await Future.delayed(const Duration(milliseconds: 2000));
                              Get.back(closeOverlays: true, result: true);
                            } else {
                              setState(() {
                                isVisible = false;
                              });
                              Utils.showSnackBar(context, strings_name.str_something_wrong);
                            }
                          }on DioError catch (e) {
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
              ],
            ),
          ),
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
