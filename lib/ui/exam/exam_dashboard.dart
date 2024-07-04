import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/ui/exam/add_update_exam.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

class ExamDashboard extends StatefulWidget {
  const ExamDashboard({super.key});

  @override
  State<ExamDashboard> createState() => _ExamDashboardState();
}

class _ExamDashboardState extends State<ExamDashboard> {
  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  bool isVisible = false;

  bool createExamSchedule = false, updateExamSchedule = false, updateAccessibleExamData = false, updateMyExamData = false;
  String loginId = "";
  var isLogin = 0;

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  Future<void> getPermission() async {
    setState(() {
      isVisible = true;
    });
    var roleId = "";
    isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      roleId = TableNames.STUDENT_ROLE_ID;
      loginId = PreferenceUtils.getLoginData().studentId.toString();
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      roleId = loginData.roleIdFromRoleIds!.join(',');
      loginId = loginData.employeeId.toString();
    } else if (isLogin == 3) {
      roleId = TableNames.ORGANIZATION_ROLE_ID;
      loginId = PreferenceUtils.getLoginDataOrganization().id.toString();
    }

    var query = "AND(FIND('$roleId',role_ids)>0,module_ids='${TableNames.MODULE_EXAM_MODULE}')";
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_CREATE_EXAM_SCHEDULE) {
            createExamSchedule = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_EXAM_SCHEDULE) {
            updateExamSchedule = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_ACCESSIBLE_EXAM_DATA) {
            updateAccessibleExamData = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_MY_EXAM_DATA) {
            updateMyExamData = true;
          }
        }
      } else {
        setState(() {
          isVisible = false;
        });
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    } finally {
      setState(() {
        isVisible = false;
      });
      // getRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          appBar: AppWidgets.appBarWithoutBack(strings_name.str_exam_schedule),
          body: Stack(
            children: [
              const SingleChildScrollView(
                child: Column(
                  children: [],
                ),
              ),
              Visibility(
                visible: isVisible,
                child: Container(
                  color: colors_name.colorWhite,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary),
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              backgroundColor: colors_name.colorPrimary,
              onPressed: () {
                Get.to(const AddUpdateExam())?.then((result) {
                  if (result != null && result) {
                    // getRecords();
                  }
                });
              },
              child: const Icon(
                Icons.upload,
                color: Colors.white,
              ))),
    );
  }
}
