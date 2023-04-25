import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/add_subject.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class ViewSubjects extends StatefulWidget {
  const ViewSubjects({Key? key}) : super(key: key);

  @override
  State<ViewSubjects> createState() => _ViewSubjectsState();
}

class _ViewSubjectsState extends State<ViewSubjects> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  bool canUpdateSubject = false, canViewSubject = false, canAddSubject = false;

  BaseLoginResponse<SubjectResponse> subjectData = BaseLoginResponse();

  Future<void> viewSubjects() async {
    try {
      subjectData = await apiRepository.getSubjectsApi("");
      if (subjectData.records!.isNotEmpty) {
        setState(() {
          canViewSubject = true;
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

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  getPermission() async {
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

    var query = "AND(FIND('${roleId}',role_ids)>0,module_ids='${TableNames.MODULE_ACADEMIC_DETAIL}')";
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_SUBJECT) {
            setState(() {
              canUpdateSubject = true;
            });
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_SUBJECT) {
            setState(() {
              canViewSubject = true;
            });
            viewSubjects();
          }
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_SUBJECT) {
            setState(() {
              canAddSubject = true;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_subject),
      body: Stack(
        children: [
          Column(children: [
            canViewSubject && subjectData.records?.isNotEmpty == true
                ? Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ListView.builder(
                          itemCount: subjectData.records?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: custom_text(text: "${subjectData.records![index].fields!.subjectTitle}", textStyles: blackTextSemiBold16, topValue: 10, maxLines: 2)),
                                  canUpdateSubject
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.to(const AddSubject(), arguments: [
                                              {"subjectId": subjectData.records?[index].fields?.ids}
                                            ])?.then((result) {
                                              if (result != null && result) {
                                                getPermission();
                                              }
                                            });
                                          },
                                          child: Container(alignment: Alignment.centerRight, margin: EdgeInsets.all(10), child: Icon(Icons.edit)))
                                      : Container(),
                                ],
                              ),
                            );
                          }),
                    ),
                  )
                : canViewSubject
                    ? Container(margin: EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_subjects, textStyles: centerTextStyleBlack18, alignment: Alignment.center))
                    : Container(),
            canAddSubject
                ? Container(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                        text: strings_name.str_add_subjects,
                        click: () async {
                          Get.to(const AddSubject())?.then((result) {
                            if (result != null && result) {
                              getPermission();
                            }
                          });
                        }))
                : Container(),
          ]),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
