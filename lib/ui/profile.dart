import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = "";
  String phone = "";
  String roleName = "";
  String hubName = "";
  String employeeCode = "";
  String? city;
  String email = "";
  String address = "";
  var isLogin = 0;

  @override
  void initState() {
    super.initState();
    isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      var loginData = PreferenceUtils.getLoginData();
      name = loginData.name.toString();
      email = loginData.email.toString();
      phone = loginData.mobileNumber.toString();
      roleName = strings_name.str_student;
      hubName = Utils.getHubName(loginData.hubIdFromHubIds![0]) ?? "";
      employeeCode = loginData.enrollmentNumber.toString();
      city = loginData.city;
      address = loginData.address.toString();
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      name = loginData.employeeName.toString();
      phone = loginData.mobileNumber.toString();
      email = loginData.email.toString();
      roleName = Utils.getRoleName(loginData.roleIdFromRoleIds![0])!;
      hubName = Utils.getHubName(loginData.hubIdFromHubIds![0]) ?? "";
      employeeCode = loginData.employeeCode.toString();
      address = loginData.address.toString();
      city = loginData.city;
    } else if (isLogin == 3) {
      var loginData = PreferenceUtils.getLoginDataOrganization();
      name = loginData.companyName.toString();
      phone = loginData.contactNumber.toString();
      email = loginData.contactEmail.toString();
      roleName = strings_name.str_organization;
      hubName = loginData.reporting_branch.toString();
      employeeCode = loginData.company_code.toString();
      address = loginData.reporting_address.toString();
      city = loginData.city;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_profile),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Image.asset(
            AppImage.ic_launcher,
            height: 120,
            width: 120,
          ),
          const SizedBox(height: 20),
          //  AppWidgets.spannableText(strings_name.str_name+ ": ", name, primaryTextSemiBold16),
          custom_text(
            text: "${strings_name.str_name}: $name",
            alignment: Alignment.topLeft,
            textStyles: blackTextSemiBold16,
            bottomValue: 0,
            leftValue: 20,
          ),
          custom_text(
            text: "${strings_name.str_phone}: $phone",
            alignment: Alignment.topLeft,
            textStyles: blackTextSemiBold16,
            topValue: 10,
            bottomValue: 0,
            leftValue: 20,
          ),
          custom_text(
            text: "${strings_name.str_email}: $email",
            alignment: Alignment.topLeft,
            textStyles: blackTextSemiBold16,
            topValue: 10,
            bottomValue: 0,
            leftValue: 20,
          ),
          custom_text(
            text: "${strings_name.str_code}: $employeeCode",
            alignment: Alignment.topLeft,
            textStyles: blackTextSemiBold16,
            topValue: 10,
            bottomValue: 0,
            leftValue: 20,
          ),
          custom_text(
            text: "${isLogin == 3 ? strings_name.str_reporting_branch : strings_name.str_hub_name} : $hubName",
            alignment: Alignment.topLeft,
            textStyles: blackTextSemiBold16,
            topValue: 10,
            bottomValue: 0,
            leftValue: 20,
          ),
          Visibility(
            visible: isLogin != 3,
            child: custom_text(
              text: "${strings_name.str_role}: $roleName",
              alignment: Alignment.topLeft,
              textStyles: blackTextSemiBold16,
              topValue: 10,
              bottomValue: 0,
              leftValue: 20,
            ),
          ),
          custom_text(
            text: "${strings_name.str_address}: $address",
            alignment: Alignment.topLeft,
            textStyles: blackTextSemiBold16,
            topValue: 10,
            bottomValue: 0,
            leftValue: 20,
            maxLines: 3,
          ),
          city != null
              ? custom_text(
                  text: "${strings_name.str_city}: ${city!}",
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  topValue: 10,
                  bottomValue: 0,
                  leftValue: 20,
                )
              : Container(),
        ],
      ),
    ));
  }
}
