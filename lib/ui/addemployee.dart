import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/request/add_employee_request.dart';
import 'package:flutterdesigndemo/models/role_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String gender = "Male";
  String roleValue = "";
  BaseApiResponseWithSerializable<RoleResponse>? roleResponse;
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<RoleResponse>>? roleResponseArray = [];
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();

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
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
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
                      text: strings_name.str_employee_name,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(
                      type: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: nameController,
                    ),
                    SizedBox(height: 8.h),
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
                    ),
                    SizedBox(height: 8.h),
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
                    ),
                    SizedBox(height: 8.h),
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
                            title: custom_text(
                              text: "Male",
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                              topValue: 0,
                              leftValue: 5,
                              rightValue: 5,
                            ),
                            value: "Male",
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
                            title: custom_text(
                              text: "Female",
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                              topValue: 0,
                              leftValue: 5,
                              rightValue: 5,
                            ),
                            value: "Female",
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
                    SizedBox(height: 8.h),
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
                          flex: 8,
                          child: Container(
                            width: viewWidth,
                            margin: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                            child: DropdownButtonFormField<BaseApiResponseWithSerializable<RoleResponse>>(
                              value: roleResponse,
                              iconSize: 0,
                              elevation: 16,
                              style: blackText16,
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
                        const Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
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
                          flex: 8,
                          child: Container(
                            margin: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                            width: viewWidth,
                            child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                              value: hubResponse,
                              iconSize: 0,
                              elevation: 16,
                              style: blackText16,
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
                        const Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: strings_name.str_add_employee,
                      click: () {
                        print("test=>${hubValue}");
                        print("test=>${roleValue}");

                        var phone = FormValidator.validatePhone(phoneController.text.toString().trim());

                        if (nameController.text.isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_name);
                        } else if (cityController.text.isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_city);
                        } else if (phone.isNotEmpty) {
                          Utils.showSnackBar(context, phone);
                        } else if (gender.isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_gender);
                        } else if (roleValue.isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_role);
                        } else if (hubValue.isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_hub);
                        } else {
                          addRecord();
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
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, backgroundColor: colors_name.colorPrimary)),
        )
      ]),
    ));
  }

  Future<void> addRecord() async {
    setState(() {
      isVisible = true;
    });
    var query = "FIND('${phoneController.text.toString()}', ${TableNames.TB_USERS_PHONE}, 0)";
    var checkMobile = await apiRepository.loginEmployeeApi(query);
    if (checkMobile.records?.isEmpty == true) {
      AddEmployeeRequest request = AddEmployeeRequest();
      request.employee_name = nameController.text.toString();
      request.mobileNumber = phoneController.text.toString().replaceAll(" ", "").replaceAll("-", "");
      request.city = cityController.text.toString();
      request.gender = gender;
      request.hubIds = Utils.getHubId(hubValue)!.split(",");
      request.roleIds = Utils.getRoleId(roleValue)!.split(",");

      var resp = await apiRepository.addEmployeeApi(request);
      if (resp.id!.isNotEmpty) {
        setState(() {
          isVisible = false;
        });
      } else {
        setState(() {
          isVisible = false;
        });
      }
    } else {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBar(context, strings_name.str_employee_exists);
    }
  }
}
