import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/ui/placement/company_approach.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class PlacementDashboard extends StatefulWidget {
  const PlacementDashboard({Key? key}) : super(key: key);

  @override
  State<PlacementDashboard> createState() => _PlacementDashboardState();
}

class _PlacementDashboardState extends State<PlacementDashboard> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  bool companyApproch = false, createCompany = false, createJobsAlerts = false;
  bool applyInternship = false, updateInternship = false;
  @override
  void initState() {
    super.initState();
    getPermission();
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
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_COMPANY_APPROCH) {
          setState(() {
            companyApproch = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_CREATE_COMPANY ) {
          setState(() {
            createCompany = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_JOBALERTS) {
          setState(() {
            createJobsAlerts = true;
          });
        }

        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_APPLY_INTERNSHIP) {
          setState(() {
            applyInternship = true;
          });
        }

        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_INTERNSHIP) {
          setState(() {
            updateInternship = true;
          });
        }

      }
    } else {
      Utils.showSnackBar(context, strings_name.str_something_wrong);
    }
    setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_dashboard),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [

                Visibility(
                  visible: companyApproch,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_company_approch, textAlign: TextAlign.center, style: blackTextSemiBold16),
                            Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const CompanyApproch());
                    },
                  ),
                ),
                SizedBox(height: 5.h),

                Visibility(
                  visible: createCompany,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_create_company, textAlign: TextAlign.center, style: blackTextSemiBold16),
                            Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {

                    },
                  ),
                ),
                SizedBox(height: 5.h),



                Visibility(
                  visible: createJobsAlerts,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_create_job_alert, textAlign: TextAlign.center, style: blackTextSemiBold16),
                            Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {

                    },
                  ),
                ),
                SizedBox(height: 5.h),



                Visibility(
                  visible: applyInternship,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_apply_internship, textAlign: TextAlign.center, style: blackTextSemiBold16),
                            Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {

                    },
                  ),
                ),
                SizedBox(height: 5.h),

                Visibility(
                  visible: updateInternship,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_update_internship, textAlign: TextAlign.center, style: blackTextSemiBold16),
                            Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {

                    },
                  ),
                ),
                SizedBox(height: 5.h),




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