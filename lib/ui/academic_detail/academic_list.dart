import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/ui/academic_detail/academic_details.dart';
import 'package:flutterdesigndemo/ui/academic_detail/view_subject.dart';
import 'package:flutterdesigndemo/ui/academic_detail/viewtopics.dart';
import 'package:flutterdesigndemo/ui/academic_detail/viewunits.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class AcademicList extends StatefulWidget {
  const AcademicList({Key? key}) : super(key: key);

  @override
  State<AcademicList> createState() => _AcademicListState();
}

class _AcademicListState extends State<AcademicList> {
  bool isVisible = false;
  bool canViewSubject = false, canViewSpe = false;

  final apiRepository = getIt.get<ApiRepository>();

  Future<void> getPermission() async {
    setState(() {
      isVisible = true;
    });
    var roleId = "";
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      roleId = TableNames.STUDENT_ROLE_ID;
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      roleId = loginData.roleIdFromRoleIds!.join(',');
    }
    var query = "AND(FIND('$roleId',role_ids)>0,module_ids='${TableNames.MODULE_ACADEMIC_DETAIL}')";
    try{
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_SUBJECT) {
            setState(() {
              canViewSubject = true;
            });
          }

          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_SPECILIZATION) {
            setState(() {
              canViewSpe = true;
            });
          }
        }
      } else {
        Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
    }on DioError catch (e) {
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

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_academic_detail),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              children: [
                Visibility(
                  visible: canViewSpe,
                  child: GestureDetector(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        color: colors_name.colorWhite,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Text(strings_name.str_view_spe, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const AcademicDetails());
                    },
                  ),
                ),
                Visibility(
                  visible: canViewSubject,
                  child: Column(
                    children: [
                      GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            color: colors_name.colorWhite,
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [Text(strings_name.str_view_subject, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const ViewSubjects());
                        },
                      ),
                      GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            color: colors_name.colorWhite,
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [Text(strings_name.str_view_unit, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const ViewUnits());
                        },
                      ),
                      GestureDetector(
                        child: Card(
                          elevation: 5,
                          child: Container(
                            color: colors_name.colorWhite,
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [Text(strings_name.str_view_topic, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(() => const ViewTopics());
                        },
                      ),
                    ],
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
