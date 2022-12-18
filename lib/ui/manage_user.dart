import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/ui/addemployee.dart';
import 'package:flutterdesigndemo/ui/addsinglestudent.dart';
import 'package:flutterdesigndemo/ui/create_students.dart';
import 'package:flutterdesigndemo/ui/update_employee.dart';
import 'package:flutterdesigndemo/ui/view_employee.dart';
import 'package:flutterdesigndemo/ui/view_student.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class ManageUser extends StatefulWidget {
  const ManageUser({Key? key}) : super(key: key);

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  bool isVisible = false;
  bool canAddEmployee = false, canUpdateEmployee = false, canViewEmployee = false;
  bool canAddStudent = false, canViewStudent = false;

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
    print(query);
    var data = await apiRepository.getPermissionsApi(query);
    if (data.records!.isNotEmpty) {
      for (var i = 0; i < data.records!.length; i++) {
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_EMPLOYEE) {
          setState(() {
            canAddEmployee = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_STUDENT) {
          setState(() {
            canAddStudent = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_EMPLOYEE) {
          setState(() {
            canViewEmployee = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_EMPLOYEE) {
          setState(() {
            canUpdateEmployee = true;
          });
        }
        if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_STUDENT) {
          setState(() {
            canViewStudent = true;
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
      appBar: AppBar(
        title: const Text(strings_name.str_manage_users),
        backgroundColor: colors_name.colorPrimary,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(14),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(children: [
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            children: [
              Visibility(
                visible: canAddEmployee,
                child: GestureDetector(
                  child: Card(
                    elevation: 5,
                      child: Container(
                      color: colors_name.colorWhite,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [Text(strings_name.str_add_employee, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(() => AddEmployee());
                  },
                ),
              ),
              SizedBox(height: 5.h),
              Visibility(
                visible: canAddStudent,
                child: GestureDetector(
                  child: Card(
                    elevation: 5,
                    child: Container(
                      color: colors_name.colorWhite,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [Text(strings_name.str_add_students, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
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
              SizedBox(height: 5.h),
              Visibility(
                visible: canViewEmployee,
                child: GestureDetector(
                  child: Card(
                    elevation: 5,
                    child: Container(
                      color: colors_name.colorWhite,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [Text(strings_name.str_view_employee, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(const ViewEmployee(), arguments: canUpdateEmployee);
                  },
                ),
              ),
              // SizedBox(height: 5.h),
              Visibility(
                visible: false,
                child: GestureDetector(
                  child: Card(
                    elevation: 5,
                    child: Container(
                      color: colors_name.colorWhite,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [Text(strings_name.str_update_employee, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(const UpdateEmployee());
                  },
                ),
              ),
              SizedBox(height: 5.h),
              Visibility(
                visible: canViewStudent,
                child: GestureDetector(
                  child: Card(
                    elevation: 5,
                    child: Container(
                      color: colors_name.colorWhite,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [Text(strings_name.str_view_students, textAlign: TextAlign.center, style: blackTextSemiBold16), Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(const ViewStudent());
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
