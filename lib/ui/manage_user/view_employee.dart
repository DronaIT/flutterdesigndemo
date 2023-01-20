import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/ui/manage_user/update_employee.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class ViewEmployee extends StatefulWidget {
  const ViewEmployee({Key? key}) : super(key: key);

  @override
  State<ViewEmployee> createState() => _ViewEmployeeState();
}

class _ViewEmployeeState extends State<ViewEmployee> {
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? viewEmployee = [];

  @override
  void initState() {
    super.initState();
    hubResponseArray = PreferenceUtils.getHubList().records;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_employee),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                custom_text(
                  text: strings_name.str_select_hub,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                    value: hubResponse,
                    elevation: 16,
                    style: blackText16,
                    focusColor: Colors.white,
                    onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                      setState(() {
                        hubValue = newValue!.fields!.id!.toString();
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
                CustomButton(
                  click: () async {
                    if (hubValue.isEmpty) {
                      Utils.showSnackBar(context, strings_name.str_empty_hub);
                    } else {
                      var query = "SEARCH('${hubValue}',${TableNames.CLM_HUB_IDS},0)";
                      setState(() {
                        isVisible = true;
                      });
                      var data = await apiRepository.viewEmployeeApi(query);
                      if (data.records!.isNotEmpty) {
                        setState(() {
                          isVisible = false;
                          viewEmployee = data.records;
                        });
                      } else {
                        setState(() {
                          isVisible = false;
                          viewEmployee = [];
                        });
                      }
                    }
                  },
                  text: strings_name.str_submit,
                ),
                viewEmployee!.length > 0
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: viewEmployee?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 5,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Column(
                                        children: [
                                          custom_text(text: viewEmployee![index].fields!.employeeName! + " (" + viewEmployee![index].fields!.employeeCode! + ")", textStyles: blackTextSemiBold16, topValue: 10, maxLines: 2),
                                          Visibility(visible: viewEmployee![index].fields!.email != null ,
                                              child: custom_text(text: viewEmployee![index].fields!.email != null ? viewEmployee![index].fields!.email! : "",
                                                  textStyles: blackTextSemiBold14, bottomValue: 5, topValue: 0)),
                                          custom_text(text: viewEmployee![index].fields!.mobileNumber!, textStyles: blackTextSemiBold14, bottomValue: 10, topValue: 0)
                                        ],
                                      ),
                                    ),
                                    Get.arguments != null
                                        ? GestureDetector(
                                            onTap: () async {
                                              var response = await Get.to(const UpdateEmployee(), arguments: viewEmployee![index]);
                                              if (response) {
                                                setState(() async {
                                                  var query = "SEARCH('${hubValue}',${TableNames.CLM_HUB_IDS},0)";
                                                  setState(() {
                                                    isVisible = true;
                                                  });
                                                  var data = await apiRepository.viewEmployeeApi(query);
                                                  if (data.records!.isNotEmpty) {
                                                    setState(() {
                                                      isVisible = false;
                                                      viewEmployee = data.records;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isVisible = false;
                                                      viewEmployee = [];
                                                    });
                                                    Utils.showSnackBar(context, strings_name.str_something_wrong);
                                                  }
                                                });
                                              }
                                            },
                                            child: Container(margin: EdgeInsets.all(10), child: Icon(Icons.edit)))
                                        : Container(),
                                  ],
                                ),
                              );
                            }),
                      )
                    : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_employee, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
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
}
