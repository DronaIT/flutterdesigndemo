import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/ui/placement/company_detail.dart';
import 'package:flutterdesigndemo/ui/placement/job_opportunity_form.dart';
import 'package:flutterdesigndemo/ui/placement/job_opportunity_list.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/custom_edittext_search.dart';
import '../../customwidget/custom_text.dart';
import '../../models/base_api_response.dart';
import '../../models/company_detail_response.dart';
import '../../models/hub_response.dart';
import '../../values/text_styles.dart';

class GetCompanyDetail extends StatefulWidget {
  const GetCompanyDetail({Key? key}) : super(key: key);

  @override
  State<GetCompanyDetail> createState() => _GetCompanyDetailState();
}

class _GetCompanyDetailState extends State<GetCompanyDetail> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  List<BaseApiResponseWithSerializable<CompanyDetailResponse>>? companyList = [];
  List<BaseApiResponseWithSerializable<CompanyDetailResponse>>? companyListMain = [];
  var update = false;
  bool createJobsAlerts = false, viewJobAlerts = false, updateJobAlerts = false;
  var controllerSearch = TextEditingController();
  String offset = "";
  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  @override
  void initState() {
    super.initState();
    update = Get.arguments;

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
    if(hubResponseArray != null ){
      hubResponse = hubResponseArray?.first;
      hubValue = hubResponseArray!.first.fields!.id!.toString();
      setState(() {

      });
    }
    getPermission();


  }

  Future<void> getRecords() async {
    setState(() {
      isVisible = true;
    });
    try {
      var query = "SEARCH('${hubValue}',${TableNames.CLM_HUB_ID},0)";
      var data = await apiRepository.getCompanyDetailApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          companyList?.clear();
          companyListMain?.clear();
        }
        companyListMain?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<CompanyDetailResponse>>);
        companyList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<CompanyDetailResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          setState(() {
            companyList?.sort((a, b) => a.fields!.companyName!.trim().compareTo(b.fields!.companyName!.trim()));
            companyListMain?.sort((a, b) => a.fields!.companyName!.trim().compareTo(b.fields!.companyName!.trim()));
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            companyList = [];
            companyListMain = [];
          }
        });
        offset = "";
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  Future<void> getPermission() async {
    setState(() {
      isVisible = true;
    });

    var query = "";
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      query = "AND(FIND('${TableNames.STUDENT_ROLE_ID}',role_ids)>0,module_ids='${TableNames.MODULE_PLACEMENT}')";
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      query = "AND(FIND('${loginData.roleIdFromRoleIds!.join(',')}',role_ids)>0,module_ids='${TableNames.MODULE_PLACEMENT}')";
    }
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_JOBALERTS) {
            setState(() {
              createJobsAlerts = true;
            });
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEWJOBS) {
            setState(() {
              viewJobAlerts = true;
            });
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_EDITJOBS) {
            setState(() {
              updateJobAlerts = true;
            });
          }
        }
        getRecords();
      } else {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_create_company),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                custom_text(
                  text: strings_name.str_select_hub,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  bottomValue: 0,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                        getRecords();

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
                SizedBox(
                  height: 4,
                ),
                CustomEditTextSearch(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: controllerSearch,
                  onChanges: (value) {
                    if (value.isEmpty) {
                      companyList = [];
                      companyList = companyListMain;
                      setState(() {});
                    } else {
                      companyList = [];
                      for (var i = 0; i < companyListMain!.length; i++) {
                        if (companyListMain![i].fields!.companyName!.toLowerCase().contains(value.toLowerCase())) {
                          companyList?.add(companyListMain![i]);
                          //data.add(test[i]);
                        }
                      }
                      setState(() {});
                    }
                  },
                ),
                SizedBox(height: 5),
                Container(
                    margin: const EdgeInsets.all(10),
                    child: companyList != null && companyList!.isNotEmpty
                        ? ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                            itemCount: companyList?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  elevation: 5,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Column(
                                              children: [
                                                custom_text(text: "${companyList?[index].fields?.companyName?.trim()}", textStyles: centerTextStylePrimary18, topValue: 10, maxLines: 2),
                                                custom_text(text: "Name: ${companyList?[index].fields?.contactName}", textStyles: blackTextSemiBold12, bottomValue: 5, topValue: 0),
                                                custom_text(text: "Contact no.: ${companyList?[index].fields?.contactNumber}", textStyles: blackTextSemiBold12, bottomValue: 5, topValue: 0),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: update,
                                            child: GestureDetector(
                                                onTap: () {
                                                  Get.to(const CompanyDetail(), arguments: companyList?[index].fields?.company_code)?.then((result) {
                                                    if (result != null && result) {
                                                      getRecords();
                                                    }
                                                  });
                                                },
                                                child: Container(margin: const EdgeInsets.only(right: 10), child: const Icon(Icons.edit))),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            visible: createJobsAlerts,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Get.to(() => const JobOpportunityForm(), arguments: [
                                                  {"company_id": companyList?[index].id},
                                                  {"job_code": ""},
                                                ]);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: colors_name.presentColor,
                                                padding: const EdgeInsets.all(10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                elevation: 7.0,
                                              ),
                                              child: Text(
                                                strings_name.str_create_job_opp_detail,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Visibility(
                                            visible: viewJobAlerts,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Get.to(() => const JobOpportunityList(), arguments: [
                                                  {"updateJobOppList": updateJobAlerts},
                                                  {"companyId": companyList?[index].fields?.id},
                                                  {"companyName": companyList?[index].fields?.companyName}
                                                ]);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: colors_name.presentColor,
                                                padding: const EdgeInsets.all(10),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                elevation: 7.0,
                                              ),
                                              child: const Text(
                                                strings_name.str_list_job_opp_detail,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ));
                            })
                        : Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: custom_text(text: strings_name.str_no_company, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
                          )),
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
