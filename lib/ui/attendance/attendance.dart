import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/ui/attendance/attendance_history.dart';
import 'package:flutterdesigndemo/ui/attendance/attendance_report_day.dart';
import 'package:flutterdesigndemo/ui/attendance/myattendance.dart';
import 'package:flutterdesigndemo/ui/attendance/take_attendance.dart';
import 'package:flutterdesigndemo/ui/attendance/filter_screen.dart';
import 'package:flutterdesigndemo/ui/attendance/take_attendance_for_predefined_lec.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../api/dio_exception.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key}) : super(key: key);

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool isVisible = false;
  bool canViewSelfAttendance = false, canViewOthersAttendance = false, canTakeAttendance = false, showReports = false;
  bool canViewAccessibleAttendance = false, canUpdateAccessibleAttendance = false;

  final apiRepository = getIt.get<ApiRepository>();

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
      query = "AND(FIND('${TableNames.STUDENT_ROLE_ID}',role_ids)>0,module_ids='${TableNames.MODULE_ATTENDANCE}')";
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      query = "AND(FIND('${loginData.roleIdFromRoleIds!.join(',')}',role_ids)>0,module_ids='${TableNames.MODULE_ATTENDANCE}')";
    }
    try{
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_TAKE_ATTENDANCE) {
            setState(() {
              canTakeAttendance = true;
            });
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ATTENDANCE_REPORTS) {
            setState(() {
              showReports = true;
            });
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEWSELF_ATTENDANCE && PreferenceUtils.getIsLogin() == 1) {
            setState(() {
              canViewSelfAttendance = true;
            });
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_OTHERS_ATTENDANCE) {
            setState(() {
              canViewOthersAttendance = true;
            });
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_ACCESSIBLE_ATTENDANCE) {
            setState(() {
              canViewAccessibleAttendance = true;
            });
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_ACCESSIBLE_ATTENDANCE) {
            setState(() {
              canUpdateAccessibleAttendance = true;
            });
          }
        }
      } else {
        Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
    setState(() {
      isVisible = false;
    });
  }

  selectAttendanceTypeDialog() {
    return Get.defaultDialog(
      title: strings_name.str_attendance_for,
      titlePadding: EdgeInsets.symmetric(vertical: 12.h),
      contentPadding: EdgeInsets.symmetric(horizontal: 30.w),
      content: Column(
        children: [
          CustomButton(
            text: strings_name.str_predefined_lectures,
            click: () {
              Get.off(() => const TakeAttendanceForPredefinedLec());
            },
          ),
          CustomButtonOutline(
            text: strings_name.str_new_lectures,
            click: () {
              Get.off(() => const TakeAttendance());
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_attendance),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                Visibility(
                  visible: canTakeAttendance,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_take_attendance, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      selectAttendanceTypeDialog();
                      // Get.to(() => const TakeAttendance());
                    },
                  ),
                ),
                Visibility(
                  visible: canViewSelfAttendance,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_viewself_attendance, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const MyAttendance());
                    },
                  ),
                ),
                Visibility(
                  visible: canViewOthersAttendance,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_viewothers_attendance, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const AttendanceHistory(), arguments: [
                        {"canViewAccessibleAttendance": canViewAccessibleAttendance},
                        {"canUpdateAccessibleAttendance": canUpdateAccessibleAttendance}
                      ]);
                    },
                  ),
                ),
                Visibility(
                  visible: showReports,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_attendance_reports, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const AttendanceReportDay());
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
