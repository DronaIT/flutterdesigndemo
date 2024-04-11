import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/student_response.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/ui/manage_user/student_selection_local.dart';
import 'package:flutterdesigndemo/ui/placement/company_selection_local.dart';
import 'package:flutterdesigndemo/ui/punch_leaves/single_employee_selection.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class AssignMentor extends StatefulWidget {
  const AssignMentor({super.key});

  @override
  State<AssignMentor> createState() => _AssignMentorState();
}

class _AssignMentorState extends State<AssignMentor> {
  bool isVisible = false;

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";

  List<StudentResponse>? selectedStudentResponse = [];
  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? employeeData = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_assign_mentor),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    GestureDetector(
                      child: Card(
                        elevation: 5,
                        color: colors_name.colorWhite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            custom_text(
                              text: selectedStudentResponse != null && selectedStudentResponse?.isNotEmpty == true ? strings_name.str_selected_student : strings_name.str_select_student,
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Icon(selectedStudentResponse != null && selectedStudentResponse?.isNotEmpty == true ? Icons.edit : Icons.arrow_forward_ios_rounded, size: 22, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.to(const StudentSelectionLocal(), arguments: selectedStudentResponse)?.then((result) {
                          if (result != null) {
                            setState(() {
                              selectedStudentResponse = result;
                            });
                          }
                        });
                      },
                    ),
                    selectedStudentResponse != null && selectedStudentResponse?.isNotEmpty == true
                        ? Card(
                            elevation: 1,
                            child: Column(
                              children: [
                                custom_text(
                                  text: "New Selected : ${selectedStudentResponse?.length} Students",
                                  alignment: Alignment.topLeft,
                                  textStyles: blackTextSemiBold16,
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(height: 5.h),
                    GestureDetector(
                      child: Card(
                        elevation: 5,
                        color: colors_name.colorWhite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const custom_text(
                              text: strings_name.str_assign_to,
                              alignment: Alignment.topLeft,
                              textStyles: blackTextSemiBold16,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Icon(employeeData != null && employeeData?.isNotEmpty == true ? Icons.edit : Icons.arrow_forward_ios_rounded, size: 22, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.to(const SingleEmployeeSelection(), arguments: employeeData)?.then((result) {
                          if (result != null) {
                            setState(() {
                              employeeData = result;
                            });
                          }
                        });
                      },
                    ),
                    employeeData != null && employeeData?.isNotEmpty == true
                        ? Card(
                            elevation: 5,
                            child: Column(
                              children: [
                                custom_text(
                                  text: "${employeeData?.last.fields?.employeeName}",
                                  alignment: Alignment.topLeft,
                                  textStyles: blackTextSemiBold16,
                                  bottomValue: 0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Utils.launchCaller(employeeData?.last.fields?.mobileNumber ?? "");
                                  },
                                  child: custom_text(
                                    text: "${employeeData?.last.fields?.mobileNumber}",
                                    textStyles: linkTextSemiBold16,
                                    topValue: 5,
                                    bottomValue: 0,
                                  ),
                                ),
                                custom_text(
                                  text: "Role: ${employeeData?.last.fields?.roleTitleFromRoleIds?.last}",
                                  alignment: Alignment.topLeft,
                                  topValue: 5,
                                  bottomValue: 0,
                                  textStyles: blackTextSemiBold16,
                                ),
                                custom_text(
                                  text: "Currently Managing: ${employeeData?.last.fields?.assigned_students?.length ?? 0} Students",
                                  alignment: Alignment.topLeft,
                                  textStyles: blackTextSemiBold16,
                                  topValue: 5,
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(height: 10.h),
                    CustomButton(
                      text: strings_name.str_submit,
                      click: () {
                        if (selectedStudentResponse == null || selectedStudentResponse?.isEmpty == true) {
                          Utils.showSnackBar(context, strings_name.str_empty_select_student);
                        } else if (employeeData == null || employeeData?.isEmpty == true) {
                          Utils.showSnackBar(context, strings_name.str_empty_select_employee);
                        } else {
                          submitData();
                        }
                      },
                    )
                  ],
                ),
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
      ),
    );
  }

  submitData() async {
    try {
      setState(() {
        isVisible = true;
      });

      List<String> studentData = [];
      studentData.addAll(employeeData?.last.fields?.assigned_students ?? []);
      for (int i = 0; i < (selectedStudentResponse?.length ?? 0); i++) {
        if (!studentData.contains(selectedStudentResponse![i].studentId)) {
          studentData.add(selectedStudentResponse![i].studentId!);
        }
      }

      Map<String, dynamic> updateEmployee = {
        "assigned_students": studentData,
      };
      var resp = await apiRepository.updateEmployeeApi(updateEmployee, employeeData?.last.id.toString() ?? "");
      if (resp.id!.isNotEmpty) {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_mentor_assigned);
        await Future.delayed(const Duration(milliseconds: 2000));
        Get.back(closeOverlays: true, result: true);
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
    }
  }
}
