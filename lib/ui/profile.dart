import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool showMentor = false;
  bool showSupportTeam = false;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Image.asset(
              AppImage.ic_launcher,
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 10),
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
            isLogin == 1
                ? Column(
                    children: [
                      PreferenceUtils.getLoginData().assigned_to?.isNotEmpty == true
                          ? Column(
                              children: [
                                GestureDetector(
                                  child: Card(
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    elevation: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const custom_text(
                                          text: strings_name.str_mentor_detail,
                                          alignment: Alignment.topLeft,
                                          textStyles: primaryTextSemiBold16,
                                          leftValue: 20,
                                        ),
                                        Icon(showMentor ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    showSupportTeam = false;
                                    showMentor = !showMentor;
                                    setState(() {});
                                  },
                                ),
                                showMentor
                                    ? Container(
                                        color: colors_name.subItemColor,
                                        child: Column(children: [
                                          custom_text(
                                            text: PreferenceUtils.getLoginData().assigned_to_employee_name?.last ?? '',
                                            alignment: Alignment.topLeft,
                                            textStyles: blackTextSemiBold16,
                                            topValue: 10,
                                            bottomValue: 10,
                                            leftValue: 20,
                                          ),
                                          Visibility(
                                            visible: false,
                                            child: GestureDetector(
                                              child: custom_text(
                                                text: PreferenceUtils.getLoginData().assigned_employee_mobile_number?.last ?? '',
                                                alignment: Alignment.topLeft,
                                                textStyles: linkTextSemiBold16,
                                                topValue: 5,
                                                bottomValue: 10,
                                                leftValue: 20,
                                              ),
                                              onTap: () {
                                                _launchCaller(PreferenceUtils.getLoginData().assigned_employee_mobile_number?.last ?? "");
                                              },
                                            ),
                                          ),
                                        ]),
                                      )
                                    : Container(),
                              ],
                            )
                          : Container(),
                      PreferenceUtils.getLoginData().assigned_counsellor?.isNotEmpty == true
                          ? Column(
                              children: [
                                GestureDetector(
                                  child: Card(
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                    elevation: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const custom_text(
                                          text: strings_name.str_student_support,
                                          alignment: Alignment.topLeft,
                                          textStyles: primaryTextSemiBold16,
                                          leftValue: 20,
                                        ),
                                        Icon(showSupportTeam ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    showMentor = false;
                                    showSupportTeam = !showSupportTeam;
                                    setState(() {});
                                  },
                                ),
                                showSupportTeam
                                    ? ListView.builder(
                                        primary: false,
                                        shrinkWrap: true,
                                        itemCount: PreferenceUtils.getLoginData().assigned_counsellor!.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                            color: colors_name.subItemColor,
                                            child: Column(children: [
                                              Container(
                                                color: colors_name.colorWhite,
                                                height: index != 0 ? 1 : 0,
                                              ),
                                              custom_text(
                                                text: PreferenceUtils.getLoginData().assigned_counsellor_name![index] ?? '',
                                                alignment: Alignment.topLeft,
                                                textStyles: blackTextSemiBold16,
                                                topValue: 10,
                                                bottomValue: 10,
                                                leftValue: 20,
                                              ),
                                              Visibility(
                                                visible: false,
                                                child: GestureDetector(
                                                  child: custom_text(
                                                    text: PreferenceUtils.getLoginData().assigned_counsellor_mobile_number![index] ?? '',
                                                    alignment: Alignment.topLeft,
                                                    textStyles: linkTextSemiBold16,
                                                    topValue: 5,
                                                    bottomValue: 10,
                                                    leftValue: 20,
                                                  ),
                                                  onTap: () {
                                                    _launchCaller(PreferenceUtils.getLoginData().assigned_counsellor_mobile_number![index] ?? "");
                                                  },
                                                ),
                                              ),
                                            ]),
                                          );
                                        })
                                    : Container(),
                              ],
                            )
                          : Container(),
                      SizedBox(height: 15.h),
                      Text.rich(TextSpan(children: [
                        const TextSpan(
                          text: 'For more help or assistance reach out to\n',
                          style: primaryTextSemiBold14,
                        ),
                        TextSpan(
                          text: '+91-9909990741',
                          style: linkTextSemiBold14,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              _launchCaller("9909990741");
                            },
                        ),
                      ]), textAlign: TextAlign.center,),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    ));
  }

  _launchCaller(String mobile) async {
    try {
      await launchUrl(Uri.parse("tel:$mobile"), mode: LaunchMode.externalApplication);
    } catch (e) {
      Utils.showSnackBarUsingGet(strings_name.str_invalid_mobile);
    }
  }
}
