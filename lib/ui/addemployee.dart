import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/HubResponse.dart';
import 'package:flutterdesigndemo/models/RoleResponse.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/utils/prefrence.dart';
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
  List<BaseApiResponseWithSerializable<RoleResponse>>? roleResponseArray = [] ;
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];


  @override
  void initState() {
    super.initState();
    hubResponseArray =  PreferenceUtils.getHubList().records;
    roleResponseArray = PreferenceUtils.getRoleList().records ;

  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
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
                          value: "male",
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
                          value: "female",
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
                          margin: EdgeInsets.only(left: 10,right: 5,top: 5,bottom: 5),
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
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 2,
                        child: const Icon(
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
                          margin: EdgeInsets.only(left: 10,right: 5,top: 5,bottom: 5),
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
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 2,
                        child: const Icon(
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

                        if(nameController.text.isEmpty){

                        }else if(cityController.text.isEmpty){

                        }else if(phoneController.text.isEmpty){

                        }else if(gender.isEmpty){

                        }else{

                        }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
