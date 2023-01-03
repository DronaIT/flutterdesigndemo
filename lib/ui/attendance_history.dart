import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/login_employee_response.dart';
import 'package:flutterdesigndemo/models/view_lecture_attendance.dart';
import 'package:flutterdesigndemo/ui/attendance_history_detail.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class AttendanceHistory extends StatefulWidget {
  const AttendanceHistory({Key? key}) : super(key: key);

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  BaseLoginResponse<LoginEmployeResponse> data = BaseLoginResponse();
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  String phone = "";
  String formattedDate = "";
  List<ViewLectureAttendance>? viewLectureArray = [];
  var formatterShow = DateFormat('dd-MM-yyyy');
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
    viewEmpLectures();
  }

  void viewEmpLectures() async {
    setState(() {
      isVisible = true;
    });
    var query = "(${TableNames.TB_USERS_PHONE}='$phone')";
    data = await apiRepository.loginEmployeeApi(query);
    if (data != null) {
      setState(() {
        isVisible = false;
      });
      viewLectureArray?.clear();
      lectureByDate();
    } else {
      setState(() {
        isVisible = false;
      });
      viewLectureArray?.clear();
    }
  }

  void checkCurrentData() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
  }

  void lectureByDate() {
    if (data.records != null && data.records!.first.fields != null) {
      for (int i = 0; i < data.records!.first.fields!.lectureDate!.length; i++) {
        if (formattedDate == data.records!.first.fields!.lectureDate![i]) {
          viewLectureArray?.add(ViewLectureAttendance(
              subject_title: data.records!.first.fields!.subjectTitle![i],
              lecture_date: data.records!.first.fields!.lectureDate![i],
              unit_title: data.records!.first.fields!.lectureDate![i],
              semester: data.records!.first.fields!.semester![i],
              division: data.records!.first.fields!.division![i],
              lecture_id: data.records!.first.fields!.lectureIds![i]));
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
        title: const Text(strings_name.str_viewothers_attendence),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                color: Colors.white,
                iconSize: 30,
                onPressed: () {
                  showDatePicker(context: context, initialDate: DateTime.parse(formattedDate), firstDate: DateTime(2005), lastDate: DateTime.now()).then((pickedDate) {
                    if (pickedDate == null) {
                      return;
                    }
                    setState(() {
                      var formatter = DateFormat('yyyy-MM-dd');
                      formattedDate = formatter.format(pickedDate);
                      viewEmpLectures();
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
            child: viewLectureArray!.isNotEmpty
                ? ListView.builder(
                    itemCount: viewLectureArray?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Card(
                            elevation: 5,
                            child: Column(
                              children: [
                                custom_text(
                                  text: viewLectureArray![index].subject_title!,
                                  alignment: Alignment.topLeft,
                                  textStyles: primaryTextSemiBold14,
                                  bottomValue: 5,
                                ),
                                custom_text(
                                  text: "${strings_name.str_by_date}: ${formatterShow.format(DateTime.parse(viewLectureArray![index].lecture_date!))}",
                                  alignment: Alignment.topLeft,
                                  textStyles: blackTextSemiBold12,
                                  topValue: 5,
                                  bottomValue: 0,
                                ),
                                custom_text(
                                  text: "${strings_name.str_semester}: ${viewLectureArray![index].semester!} ${" , "} ${strings_name.str_division}: ${viewLectureArray![index].division!}",
                                  alignment: Alignment.topLeft,
                                  textStyles: blackTextSemiBold12,
                                  topValue: 5,
                                ),
                              ],
                            )),
                        onTap: () {
                          Get.to(() => const AttendanceHistoryDetail(), arguments: viewLectureArray?[index].lecture_id);
                        },
                      );
                    })
                : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
