import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/view_student_attendence.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:intl/intl.dart';

//https://www.kindacode.com/article/flutter-date-picker/
class MyAttendence extends StatefulWidget {
  const MyAttendence({Key? key}) : super(key: key);

  @override
  State<MyAttendence> createState() => _MyAttendenceState();
}

class _MyAttendenceState extends State<MyAttendence> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  String phone = "";

  BaseLoginResponse<LoginFieldsResponse> data = BaseLoginResponse();
  List<ViewStudentAttendence>? viewStudentArray = [];
  var formatterShow = DateFormat('dd-MM-yyyy');

  String formattedDate = "";
  String semester = "";

  @override
  void initState() {
    super.initState();
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      var loginData = PreferenceUtils.getLoginData();
      phone = loginData.mobileNumber.toString();
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      phone = loginData.mobileNumber.toString();
    }
    checkCurrentData();
    viewAttendance();
  }

  void checkCurrentData() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    print(formattedDate);


  }

  void viewAttendance() async {
    setState(() {
      isVisible = true;
    });
    var query = "(${TableNames.TB_USERS_PHONE}='${phone}')";
    data = await apiRepository.loginApi(query);
    if (data != null) {
      setState(() {
        isVisible = false;
      });
      viewStudentArray?.clear();
      checkPre_AbsentDetailByDate();
    }else{
      viewStudentArray?.clear();
    }
  }

  bool _isTap = false;
  String _isDate = "";

  void checkPre_AbsentDetailByDate() {
    if (data.records != null && data.records!.first.fields != null && data.records!.first.fields!.presentLectureDate != null) {
      for (int i = 0; i < data.records!.first.fields!.presentLectureDate!.length; i++) {
        if (formattedDate == data.records!.first.fields!.presentLectureDate![i]) {
          viewStudentArray?.add(ViewStudentAttendence(subject_title: data.records!.first.fields!.presentSubjectTitle![i], lecture_date: data.records!.first.fields!.presentLectureDate![i], status: 1));
        }
      }
    }
    if (data.records != null && data.records!.first.fields != null && data.records!.first.fields!.absentLectureDate != null) {
      for (int i = 0; i < data.records!.first.fields!.absentLectureDate!.length; i++) {
        if (formattedDate == data.records!.first.fields!.absentLectureDate![i]) {
          viewStudentArray?.add(ViewStudentAttendence(subject_title: data.records!.first.fields!.absentSubjectTitle![i], lecture_date: data.records!.first.fields!.absentLectureDate![i], status: 0));
        }
      }
    }
  }

  void checkPre_AbsentDetailBySemester() {
    if (data.records != null && data.records!.first.fields != null) {
      for (int i = 0; i < data.records!.length; i++) {
        if (semester == data.records![i].fields!.semester!) {

        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: colors_name.colorPrimary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(14),
            ),
          ),
          title: const Text(strings_name.str_viewself_attendence),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                  //  icon:  Icon(_isTap ?Icons.filter_alt:Icons.filter_alt_outlined),
                  icon: const Icon(Icons.filter_alt_outlined),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(formattedDate), firstDate: DateTime(2005), lastDate: DateTime.now()).then((pickedDate) {
                      if (pickedDate == null) {
                        return;
                      }
                      setState(() {
                        var formatter = DateFormat('yyyy-MM-dd');
                        formattedDate = formatter.format(pickedDate);

                        viewAttendance();
                      });
                    });

                  }),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: viewStudentArray!.isNotEmpty
                  ? ListView.builder(
                      itemCount: viewStudentArray?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    custom_text(
                                      text: viewStudentArray![index].subject_title!,
                                      alignment: Alignment.topLeft,
                                      textStyles: blackTextSemiBold12,
                                      bottomValue: 5,
                                    ),
                                    custom_text(
                                      text: formatterShow.format(DateTime.parse(viewStudentArray![index].lecture_date!)),
                                      alignment: Alignment.topLeft,
                                      textStyles: blackTextSemiBold12,
                                      topValue: 5,
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      primary: viewStudentArray![index].status == 1 ? colors_name.presentColor : colors_name.errorColor,
                                      padding: const EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 7.0,
                                    ),
                                    child: Text(
                                      viewStudentArray![index].status == 1 ? strings_name.str_present : strings_name.str_absent,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      })
                  : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
            ),
            Center(
              child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
            )
          ],
        ),
      ),
    );
  }

  _CreateBottomFilterNew() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: custom_text(
                              text: strings_name.str_filter,
                              alignment: Alignment.topLeft,
                              textStyles: centerTextStylblack20,
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isDate = "Date";
                                  });
                                },
                                child: custom_text(
                                  text: strings_name.str_reset,
                                  alignment: Alignment.topLeft,
                                  textStyles: centerTextStyl20,
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          RadioListTile(
                            activeColor: colors_name.colorPrimary,
                            title: custom_text(
                              text: strings_name.str_by_date,
                              textStyles: blackTextSemiBold16,
                              bottomValue: 0,
                              topValue: 0,
                              leftValue: 0,
                              rightValue: 5,
                            ),
                            value: strings_name.str_by_date,
                            groupValue: _isDate,
                            onChanged: (value) {
                              showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(), firstDate: DateTime(2005), lastDate: DateTime.now()).then((pickedDate) {
                                if (pickedDate == null) {
                                  return;
                                }
                                setState(() {

                                  var formatter = DateFormat('yyyy-MM-dd');
                                  formattedDate = formatter.format(pickedDate);

                                  print("test===> ${formattedDate}");
                                });
                              });
                            },
                          ),
                          RadioListTile(
                            activeColor: colors_name.colorPrimary,
                            title: custom_text(
                              text: strings_name.str_by_semester,
                              textStyles: blackTextSemiBold16,
                              bottomValue: 0,
                              topValue: 0,
                              leftValue: 0,
                              rightValue: 5,
                            ),
                            value: strings_name.str_by_semester,
                            groupValue: _isDate,
                            onChanged: (value) {
                              setState(() {
                                _isDate = value.toString();
                                print("isSemester==> ${_isDate}");
                              });
                            },
                          ),
                          // RadioListTile(
                          //
                          //   activeColor: colors_name.colorPrimary,
                          //   title: custom_text(
                          //     text: strings_name.str_by_subject,
                          //     textStyles: blackTextSemiBold16,
                          //     bottomValue: 0,
                          //     topValue: 0,
                          //     leftValue: 3,
                          //     rightValue: 5,
                          //   ),
                          //   value: strings_name.str_by_subject,
                          //   groupValue: _isDate,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _isDate = value.toString();
                          //       print("isSubject==> ${_isDate}");
                          //     });
                          //   },
                          // ),
                        ],
                      ))
                    ],
                  ),
                )),
          );
        });
  }
}
