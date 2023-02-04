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
import '../../api/service_locator.dart';
import '../../customwidget/custom_text.dart';
import '../../models/base_api_response.dart';
import '../../models/company_detail_response.dart';
import '../../values/text_styles.dart';

class GetCompanyDetail extends StatefulWidget {
  const GetCompanyDetail({Key? key}) : super(key: key);

  @override
  State<GetCompanyDetail> createState() => _GetCompanyDetailState();
}

class _GetCompanyDetailState extends State<GetCompanyDetail> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<CompanyDetailResponse> companyDetailResponse = BaseLoginResponse();
  var update = false;
  bool createJobsAlerts = false, viewJobAlerts = false, updateJobAlerts = false;

  @override
  void initState() {
    super.initState();
    update = Get.arguments;
    // getRecords();
    getPermission();
  }

  Future<void> getRecords() async {
    setState(() {
      isVisible = true;
    });
    companyDetailResponse = await apiRepository.getCompanyDetailApi("");
    if (companyDetailResponse.records!.isNotEmpty) {
      setState(() {
        isVisible = false;
      });
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_create_company),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: companyDetailResponse.records != null ? companyDetailResponse.records?.length : 0,
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
                                    custom_text(text: "${companyDetailResponse.records?[index].fields?.companyName}", textStyles: centerTextStylePrimary18, topValue: 10, maxLines: 2),
                                    custom_text(text: "Name: ${companyDetailResponse.records?[index].fields?.contactName}", textStyles: blackTextSemiBold12, bottomValue: 5, topValue: 0),
                                    custom_text(text: "Contact no.: ${companyDetailResponse.records?[index].fields?.contactNumber}", textStyles: blackTextSemiBold12, bottomValue: 5, topValue: 0),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: update,
                                child: GestureDetector(
                                    onTap: () {
                                      Get.to(const CompanyDetail(), arguments: companyDetailResponse.records?[index].fields?.company_code)?.then((result) {
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
                                      {"company_id": companyDetailResponse.records?[index].id},
                                      {"job_code": "DF69941"},
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
                                    //  Get.to(() => const JobOpportunityList(), arguments: updateJobAlerts ,);

                                    Get.to(() => const JobOpportunityList(), arguments: [
                                      {"updateJobOppList": updateJobAlerts},
                                      {"companyId": companyDetailResponse.records?[index].fields?.id}
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
                                    strings_name.str_list_job_opp_detail,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ));
                }),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
