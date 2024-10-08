import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/ui/manage_user/addemployee.dart';
import 'package:flutterdesigndemo/ui/manage_user/addsinglestudent.dart';
import 'package:flutterdesigndemo/ui/manage_user/assign_mentor.dart';
import 'package:flutterdesigndemo/ui/manage_user/create_students.dart';
import 'package:flutterdesigndemo/ui/manage_user/update_employee.dart';
import 'package:flutterdesigndemo/ui/manage_user/view_employee.dart';
import 'package:flutterdesigndemo/ui/manage_user/view_student.dart';

import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({Key? key}) : super(key: key);

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  bool isVisible = false;
  bool canAddEmployee = false, canUpdateEmployee = false, canViewEmployee = false;
  bool canAddStudent = false, canViewStudent = false, canUpdateStudent = false;
  bool canAssignMentor = false;

  final apiRepository = getIt.get<ApiRepository>();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    setState(() {
      isVisible = true;
    });
    var loginData = PreferenceUtils.getLoginDataEmployee();
    var query = "AND(FIND('${loginData.roleIdFromRoleIds!.join(',')}',role_ids)>0,module_ids='${TableNames.MODULE_MANAGE_USER}')";
    debugPrint(query);
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_EMPLOYEE) {
            canAddEmployee = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_STUDENT) {
            canAddStudent = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_EMPLOYEE) {
            canViewEmployee = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_EMPLOYEE) {
            canUpdateEmployee = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_STUDENT) {
            canViewStudent = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_STUDENT) {
            canUpdateStudent = true;
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ASSIGN_MENTOR) {
            canAssignMentor = true;
          }
        }
        setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_manage_users),
      body: Stack(children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              Visibility(
                visible: canAddEmployee,
                child: GestureDetector(
                  child: Card(
                    margin: EdgeInsets.only(top: 5.h),
                    elevation: 5,
                    child: Container(
                      color: colors_name.colorWhite,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(strings_name.str_add_employee, textAlign: TextAlign.center, style: blackTextSemiBold16),
                          Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(() => AddEmployee());
                  },
                ),
              ),
              Visibility(
                visible: canAddStudent,
                child: GestureDetector(
                  child: Card(
                    margin: EdgeInsets.only(top: 5.h),
                    elevation: 5,
                    child: Container(
                      color: colors_name.colorWhite,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(strings_name.str_add_students, textAlign: TextAlign.center, style: blackTextSemiBold16),
                          Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(strings_name.str_add_student, style: centerTextStyle20),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                strings_name.str_add_multiple_student,
                                style: whiteText13,
                              ),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colors_name.colorPrimary)),
                              onPressed: () {
                                Navigator.pop(context);
                                Get.to(const CreateStudent());
                              },
                            ),
                            TextButton(
                              child: const Text(strings_name.str_add_single_student, style: whiteText13),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(colors_name.colorPrimary)),
                              onPressed: () {
                                Navigator.pop(context);
                                Get.to(const AddSingleStudent());
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Visibility(
                visible: canViewEmployee,
                child: GestureDetector(
                  child: Card(
                    margin: EdgeInsets.only(top: 5.h),
                    elevation: 5,
                    child: Container(
                      color: colors_name.colorWhite,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(strings_name.str_view_employee, textAlign: TextAlign.center, style: blackTextSemiBold16),
                          Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(const ViewEmployee(), arguments: canUpdateEmployee);
                  },
                ),
              ),
              Visibility(
                visible: false,
                child: GestureDetector(
                  child: Card(
                    margin: EdgeInsets.only(top: 5.h),
                    elevation: 5,
                    child: Container(
                      color: colors_name.colorWhite,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(strings_name.str_update_employee, textAlign: TextAlign.center, style: blackTextSemiBold16),
                          Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(const UpdateEmployee());
                  },
                ),
              ),
              Visibility(
                visible: canViewStudent,
                child: GestureDetector(
                  child: Card(
                    margin: EdgeInsets.only(top: 5.h),
                    elevation: 5,
                    child: Container(
                      color: colors_name.colorWhite,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(strings_name.str_view_students, textAlign: TextAlign.center, style: blackTextSemiBold16),
                          Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(const ViewStudent(), arguments: canUpdateStudent);
                  },
                ),
              ),
              Visibility(
                visible: canAssignMentor,
                child: GestureDetector(
                  child: Card(
                    margin: EdgeInsets.only(top: 5.h),
                    elevation: 5,
                    child: Container(
                      color: colors_name.colorWhite,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(strings_name.str_assign_mentor, textAlign: TextAlign.center, style: blackTextSemiBold16),
                          Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(const AssignMentor(), arguments: canUpdateStudent);
                  },
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
