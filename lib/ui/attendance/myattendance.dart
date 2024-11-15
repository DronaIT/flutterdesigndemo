import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/student_attendance_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/models/view_student_attendance.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/dio_exception.dart';
import '../../utils/utils.dart';

class MyAttendance extends StatefulWidget {
  const MyAttendance({Key? key}) : super(key: key);

  @override
  State<MyAttendance> createState() => _MyAttendanceState();
}

class _MyAttendanceState extends State<MyAttendance> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  String myEnrollmentNo = "", mySemester = "";

  BaseLoginResponse<LoginFieldsResponse> dataByDate = BaseLoginResponse();
  BaseLoginResponse<StudentAttendanceResponse> dataBySubject = BaseLoginResponse();

  List<ViewStudentAttendance>? studentAttendanceArray = [];
  List<ViewStudentAttendance>? studentAttendanceBySubjectArray = [];
  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectData = [];

  var formatterShow = DateFormat('dd MMM, yyyy');

  String formattedDate = "";
  String enrollmentNo = "", name = "";

  int totalLectures = 0, totalPresentLectures = 0;
  double totalPresentPercentage = 0;

  @override
  void initState() {
    super.initState();
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      var loginData = PreferenceUtils.getLoginData();
      myEnrollmentNo = loginData.enrollmentNumber.toString();
      mySemester = loginData.semester.toString();
    }
    checkCurrentData();

    if (Get.arguments != null) {
      enrollmentNo = Get.arguments[0]["studentEnrollmentNo"];
      formattedDate = Get.arguments[1]["date"];
      name = Get.arguments[2]["name"];
    }
    viewAttendanceByDate();
  }

  void checkCurrentData() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
  }

  void viewAttendanceByDate() async {
    setState(() {
      isVisible = true;
    });
    var query = "";
    if (enrollmentNo.isNotEmpty) {
      query = "(${TableNames.TB_USERS_ENROLLMENT}='$enrollmentNo')";
    } else {
      query = "(${TableNames.TB_USERS_ENROLLMENT}='$myEnrollmentNo')";
    }
    try {
      dataByDate = await apiRepository.loginApi(query);
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }

    if (dataByDate.records?.isNotEmpty == true) {
      setState(() {
        isVisible = false;
      });
      studentAttendanceArray?.clear();
      studentAttendanceBySubjectArray?.clear();
      checkPresentAbsentDetailByDate();
      checkTotalPercentage();
    } else {
      setState(() {
        isVisible = false;
      });
      studentAttendanceArray?.clear();
      studentAttendanceBySubjectArray?.clear();
    }
  }

  void viewAttendanceBySubjects() async {
    setState(() {
      isVisible = true;
    });
    var query = "";
    if (enrollmentNo.isNotEmpty) {
      query = "SEARCH('${enrollmentNo.toUpperCase()}', ARRAYJOIN(${TableNames.CLM_ENROLLMENT_NUMBERS}), 0)";
    } else {
      query = "SEARCH('${myEnrollmentNo.toUpperCase()}', ARRAYJOIN(${TableNames.CLM_ENROLLMENT_NUMBERS}), 0)";
    }
    try {
      dataBySubject = await apiRepository.getStudentAttendanceApi(query);
      if (dataBySubject.records?.isNotEmpty == true) {
        setState(() {
          isVisible = false;
        });
        studentAttendanceArray?.clear();
        studentAttendanceBySubjectArray?.clear();
        checkPresentAbsentDetailBySubject();
      } else {
        setState(() {
          isVisible = false;
        });
        studentAttendanceArray?.clear();
        studentAttendanceBySubjectArray?.clear();
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  String _isDate = "";

  String getFormattedDate(String date) {
    /// Convert into local date format.
    var localDate = DateTime.parse(date).toLocal();

    /// inputFormat - format getting from api or other func.
    /// e.g If 2021-05-27 9:34:12.781341 then format must be yyyy-MM-dd HH:mm
    /// If 27/05/2021 9:34:12.781341 then format must be dd/MM/yyyy HH:mm
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(localDate.toString());

    /// outputFormat - convert into format you want to show.
    var outputFormat = DateFormat('dd/MM/yyyy HH:mm');
    var outputDate = outputFormat.format(inputDate);

    return outputDate.toString();
  }

  void checkPresentAbsentDetailByDate() {
    if (dataByDate.records!.isNotEmpty) {
      if (dataByDate.records != null && dataByDate.records!.first.fields != null && dataByDate.records!.first.fields!.presentLectureDate != null) {
        for (int i = 0; i < dataByDate.records!.first.fields!.presentLectureDate!.length; i++) {
          DateTime fudgeThis = DateTime.parse(formattedDate);
          if (false && DateFormat("yyyy-dd-MM").format(fudgeThis) == dataByDate.records!.first.fields!.presentLectureDate![i]) {
            studentAttendanceArray?.add(ViewStudentAttendance(
                subject_id: dataByDate.records!.first.fields!.presentSubjectId![i],
                subject_title: dataByDate.records!.first.fields!.presentSubjectTitle![i],
                lecture_date: dataByDate.records!.first.fields!.presentLectureDate![i],
                status: 1));
          } else if (DateFormat("yyyy-MM-dd").format(fudgeThis) == dataByDate.records!.first.fields!.presentLectureDate![i]) {
            studentAttendanceArray?.add(ViewStudentAttendance(
                subject_id: dataByDate.records!.first.fields!.presentSubjectId![i],
                subject_title: dataByDate.records!.first.fields!.presentSubjectTitle![i],
                lecture_date: dataByDate.records!.first.fields!.presentLectureDate![i],
                status: 1));
          }
        }
      }
      if (dataByDate.records != null && dataByDate.records!.first.fields != null && dataByDate.records!.first.fields!.absentLectureDate != null) {
        for (int i = 0; i < dataByDate.records!.first.fields!.absentLectureDate!.length; i++) {
          DateTime fudgeThis = DateTime.parse(formattedDate);
          if (false && DateFormat("yyyy-dd-MM").format(fudgeThis) == dataByDate.records!.first.fields!.absentLectureDate![i]) {
            studentAttendanceArray?.add(ViewStudentAttendance(
                subject_id: dataByDate.records!.first.fields!.absentSubjectId![i],
                subject_title: dataByDate.records!.first.fields!.absentSubjectTitle![i],
                lecture_date: dataByDate.records!.first.fields!.absentLectureDate![i],
                status: 0));
          } else if (DateFormat("yyyy-MM-dd").format(fudgeThis) == dataByDate.records!.first.fields!.absentLectureDate![i]) {
            studentAttendanceArray?.add(ViewStudentAttendance(
                subject_id: dataByDate.records!.first.fields!.absentSubjectId![i],
                subject_title: dataByDate.records!.first.fields!.absentSubjectTitle![i],
                lecture_date: dataByDate.records!.first.fields!.absentLectureDate![i],
                status: 0));
          }
        }
      }
    }
  }

  void checkPresentAbsentDetailBySubject() {
    var total_lecture = 0, present_lecture = 0, absent_lecture = 0;
    if (dataByDate.records!.isNotEmpty) {
      var records = dataByDate.records?.first.fields;
      if (records != null && records.presentSubjectId != null) {
        for (int i = 0; i < records.presentSubjectId!.length; i++) {
          if (records.presentSemesterByStudent![i] == records.semester && records.present_specialization_id![i] == records.specializationIds!.last) {
            var isAdded = false;
            for (int j = 0; j < studentAttendanceBySubjectArray!.length; j++) {
              if (studentAttendanceBySubjectArray![j].subject_id == records.presentSubjectId![i]) {
                isAdded = true;
                studentAttendanceBySubjectArray![j].total_lectures += 1;
                studentAttendanceBySubjectArray![j].present_lectures += 1;
                break;
              }
            }
            if (!isAdded) {
              var attendanceData = ViewStudentAttendance(
                  subject_id: records.presentSubjectId![i],
                  subject_title: records.presentSubjectTitle![i],
                  lecture_date: records.presentLectureDate![i],
                  status: 1);
              attendanceData.total_lectures += 1;
              attendanceData.present_lectures += 1;
              studentAttendanceBySubjectArray!.add(attendanceData);
            }
          }
        }
      }
      if (records != null && records.absentSubjectId != null) {
        for (int i = 0; i < records.absentSubjectId!.length; i++) {
          if (records.absentSemesterByStudent![i] == records.semester && records.absent_specialization_id![i] == records.specializationIds!.last) {
            var isAdded = false;
            for (int j = 0; j < studentAttendanceBySubjectArray!.length; j++) {
              if (studentAttendanceBySubjectArray![j].subject_id == records.absentSubjectId![i]) {
                isAdded = true;
                studentAttendanceBySubjectArray![j].total_lectures += 1;
                studentAttendanceBySubjectArray![j].absent_lectures += 1;
                break;
              }
            }
            if (!isAdded) {
              var attendanceData = ViewStudentAttendance(
                  subject_id: records.absentSubjectId![i],
                  subject_title: records.absentSubjectTitle![i],
                  lecture_date: records.absentLectureDate![i],
                  status: 0);
              attendanceData.total_lectures += 1;
              attendanceData.absent_lectures += 1;
              studentAttendanceBySubjectArray!.add(attendanceData);
            }
          }
        }
      }
    }
    for (int i = 0; i < studentAttendanceBySubjectArray!.length; i++) {
      total_lecture += studentAttendanceBySubjectArray![i].total_lectures;
      present_lecture += studentAttendanceBySubjectArray![i].present_lectures;
      absent_lecture += studentAttendanceBySubjectArray![i].absent_lectures;
    }

    setState(() {
      totalLectures = total_lecture;
      totalPresentLectures = present_lecture;
      totalPresentPercentage = ((present_lecture * 100) / total_lecture);
    });
  }

  void checkTotalPercentage() {
    var total_lecture = 0, present_lecture = 0, absent_lecture = 0;
    List<ViewStudentAttendance>? studentAttendanceBySubjectArray = [];

    if (dataByDate.records!.isNotEmpty) {
      var records = dataByDate.records?.first.fields;
      if (records != null && records.presentSubjectId != null) {
        for (int i = 0; i < records.presentSubjectId!.length; i++) {
          if (records.presentSemesterByStudent![i] == records.semester && records.present_specialization_id![i] == records.specializationIds!.last) {
            var isAdded = false;
            for (int j = 0; j < studentAttendanceBySubjectArray.length; j++) {
              if (studentAttendanceBySubjectArray[j].subject_id == records.presentSubjectId![i]) {
                isAdded = true;
                studentAttendanceBySubjectArray[j].total_lectures += 1;
                studentAttendanceBySubjectArray[j].present_lectures += 1;
                break;
              }
            }
            if (!isAdded) {
              var attendanceData = ViewStudentAttendance(
                  subject_id: records.presentSubjectId![i],
                  subject_title: records.presentSubjectTitle![i],
                  lecture_date: records.presentLectureDate![i],
                  status: 1);
              attendanceData.total_lectures += 1;
              attendanceData.present_lectures += 1;
              studentAttendanceBySubjectArray.add(attendanceData);
            }
          }
        }
      }
      if (records != null && records.absentSubjectId != null) {
        for (int i = 0; i < records.absentSubjectId!.length; i++) {
          if (records.absentSemesterByStudent![i] == records.semester && records.absent_specialization_id![i] == records.specializationIds!.last) {
            var isAdded = false;
            for (int j = 0; j < studentAttendanceBySubjectArray.length; j++) {
              if (studentAttendanceBySubjectArray[j].subject_id == records.absentSubjectId![i]) {
                isAdded = true;
                studentAttendanceBySubjectArray[j].total_lectures += 1;
                studentAttendanceBySubjectArray[j].absent_lectures += 1;
                break;
              }
            }
            if (!isAdded) {
              var attendanceData = ViewStudentAttendance(
                  subject_id: records.absentSubjectId![i],
                  subject_title: records.absentSubjectTitle![i],
                  lecture_date: records.absentLectureDate![i],
                  status: 0);
              attendanceData.total_lectures += 1;
              attendanceData.absent_lectures += 1;
              studentAttendanceBySubjectArray.add(attendanceData);
            }
          }
        }
      }
    }
    for (int i = 0; i < studentAttendanceBySubjectArray.length; i++) {
      total_lecture += studentAttendanceBySubjectArray[i].total_lectures;
      present_lecture += studentAttendanceBySubjectArray[i].present_lectures;
      absent_lecture += studentAttendanceBySubjectArray[i].absent_lectures;
    }

    setState(() {
      totalLectures = total_lecture;
      totalPresentLectures = present_lecture;
      totalPresentPercentage = ((present_lecture * 100) / total_lecture);
    });
  }

  void checkPresentAbsentDetailBySemester() {
    if (dataByDate.records != null && dataByDate.records!.first.fields != null) {
      for (int i = 0; i < dataByDate.records!.length; i++) {
        if (mySemester == dataByDate.records![i].fields!.semester!) {}
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
          title: Text(enrollmentNo.isNotEmpty ? strings_name.str_attendance : strings_name.str_viewself_attendance, style: whiteTextSemiBold20),
          iconTheme: const IconThemeData(color: colors_name.colorWhite),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10.w),
              child: IconButton(
                  icon: const Icon(Icons.filter_alt_outlined),
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    createBottomFilterNew();
                  }),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Visibility(
                visible: name.isNotEmpty, child: custom_text(text: name, alignment: Alignment.topLeft, textStyles: blackTextbold14, bottomValue: 5)),
            Visibility(
              visible: PreferenceUtils.getIsLogin() == 2,
              child: custom_text(text: "Total Lectures : $totalLectures", alignment: Alignment.topLeft, textStyles: blackTextbold14, bottomValue: 5),
            ),
            Visibility(
              visible: PreferenceUtils.getIsLogin() == 2,
              child: custom_text(
                  text: "Total Present Lectures : $totalPresentLectures", alignment: Alignment.topLeft, textStyles: blackTextbold14, bottomValue: 5),
            ),
            Row(
              children: [
                Visibility(
                  visible: PreferenceUtils.getIsLogin() == 2,
                  child: custom_text(
                      text: "Total Present : ${totalPresentPercentage.toStringAsFixed(2)}%",
                      alignment: Alignment.topLeft,
                      textStyles: blackTextbold14,
                      bottomValue: 5),
                ),
                Visibility(
                  visible: PreferenceUtils.getIsLogin() == 2,
                  child: Expanded(
                    child: Container(
                      width: 300,
                      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: totalPresentPercentage >= 75 ? colors_name.presentColor : colors_name.errorColor,
                          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          totalPresentPercentage >= 75 ? "Eligible for exam" : "Not eligible for exam",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  child: studentAttendanceArray!.isNotEmpty
                      ? ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: studentAttendanceArray?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                elevation: 5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          custom_text(
                                            text: studentAttendanceArray![index].subject_title!,
                                            alignment: Alignment.topLeft,
                                            textStyles: blackTextSemiBold12,
                                            bottomValue: 5,
                                            maxLines: 3,
                                          ),
                                          custom_text(
                                            text: formatterShow.format(DateTime.parse(studentAttendanceArray![index].lecture_date!)),
                                            alignment: Alignment.topLeft,
                                            textStyles: blackTextSemiBold12,
                                            topValue: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: studentAttendanceArray![index].status == 1 ? colors_name.presentColor : colors_name.errorColor,
                                          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          elevation: 7.0,
                                        ),
                                        child: Text(
                                          studentAttendanceArray![index].status == 1 ? strings_name.str_present : strings_name.str_absent,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          })
                      : Container(),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  child: studentAttendanceBySubjectArray!.isNotEmpty
                      ? ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: studentAttendanceBySubjectArray?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                elevation: 5,
                                child: Column(children: [
                                  custom_text(
                                    text: studentAttendanceBySubjectArray![index].subject_title!,
                                    alignment: Alignment.topLeft,
                                    textStyles: blackTextSemiBold16,
                                    bottomValue: 0,
                                    maxLines: 3,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Visibility(
                                            visible: PreferenceUtils.getIsLogin() == 2,
                                            child: custom_text(
                                              text: "Total Lectures : ${studentAttendanceBySubjectArray![index].total_lectures}",
                                              alignment: Alignment.topLeft,
                                              textStyles: blackTextSemiBold12,
                                              bottomValue: 0,
                                            ),
                                          ),
                                          Visibility(
                                            visible: PreferenceUtils.getIsLogin() == 2,
                                            child: custom_text(
                                              text: "Present Lectures : ${studentAttendanceBySubjectArray![index].present_lectures}",
                                              alignment: Alignment.topLeft,
                                              textStyles: blackTextSemiBold12,
                                              bottomValue: 0,
                                            ),
                                          ),
                                          Visibility(
                                            visible: true,
                                            child: custom_text(
                                              text:
                                                  "Present : ${((studentAttendanceBySubjectArray![index].present_lectures * 100) / studentAttendanceBySubjectArray![index].total_lectures).toStringAsFixed(2)}%",
                                              alignment: Alignment.topLeft,
                                              textStyles: blackTextSemiBold12,
                                              bottomValue: 10,
                                            ),
                                          ),
                                          SizedBox(height: 5.h)
                                        ],
                                      )),
                                      Expanded(
                                        child: Container(
                                          width: 100,
                                          margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: ((studentAttendanceBySubjectArray![index].present_lectures * 100) /
                                                          studentAttendanceBySubjectArray![index].total_lectures) >=
                                                      75
                                                  ? colors_name.presentColor
                                                  : colors_name.errorColor,
                                              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              ((studentAttendanceBySubjectArray![index].present_lectures * 100) /
                                                          studentAttendanceBySubjectArray![index].total_lectures) >=
                                                      75
                                                  ? "Eligible for exam"
                                                  : "Not eligible for exam",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ]));
                          })
                      : Container(),
                ),
                (studentAttendanceArray.isBlank == true && studentAttendanceBySubjectArray.isBlank == true)
                    ? Container(
                        margin: EdgeInsets.only(top: 100.h),
                        child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center))
                    : Container(),
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
          ]),
        ),
      ),
    );
  }

  createBottomFilterNew() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => Container(
                height: MediaQuery.of(context).size.height * 0.25,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: custom_text(
                              text: strings_name.str_filter_by,
                              alignment: Alignment.topLeft,
                              textStyles: centerTextStylblack20,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          RadioListTile(
                            dense: true,
                            activeColor: colors_name.colorPrimary,
                            title: custom_text(
                              text: strings_name.str_by_date,
                              textStyles: blackTextSemiBold16,
                              bottomValue: 0,
                              topValue: 0,
                              leftValue: 0,
                              rightValue: 5,
                            ),
                            contentPadding: const EdgeInsets.all(0),
                            value: strings_name.str_by_date,
                            groupValue: "",
                            onChanged: (value) {
                              _isDate = value.toString();
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.parse(formattedDate),
                                      firstDate: DateTime(2005),
                                      lastDate: DateTime.now())
                                  .then((pickedDate) {
                                if (pickedDate == null) {
                                  return;
                                }
                                setState(() {
                                  var formatter = DateFormat('yyyy-MM-dd');
                                  formattedDate = formatter.format(pickedDate);
                                  viewAttendanceByDate();
                                });
                                Navigator.pop(context);
                              });
                            },
                          ),
                          /*RadioListTile(
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
                                debugPrint("isSemester==> ${_isDate}");
                              });
                            },
                          ),*/
                          RadioListTile(
                            dense: true,
                            activeColor: colors_name.colorPrimary,
                            title: custom_text(
                              text: strings_name.str_by_subject,
                              textStyles: blackTextSemiBold16,
                              bottomValue: 0,
                              topValue: 0,
                              leftValue: 0,
                              rightValue: 5,
                            ),
                            value: strings_name.str_by_subject,
                            contentPadding: const EdgeInsets.all(0),
                            groupValue: "",
                            onChanged: (value) {
                              _isDate = value.toString();
                              viewAttendanceBySubjects();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ))
                    ],
                  ),
                )),
          );
        });
  }

/*
  createSubjectList(){
    Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: DropdownButtonFormField<BaseApiResponseWithSerializable<SubjectResponse>>(
        value: subjectResponse,
        isExpanded: true,
        elevation: 16,
        style: blackText16,
        focusColor: colors_name.colorPrimary,
        onChanged: (BaseApiResponseWithSerializable<SubjectResponse>? newValue) {
          setState(() {
            subjValue = newValue!.fields!.subjectId!.toString();
            subjectResponse = newValue;
          });
        },
        items: subjResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SubjectResponse>>>((BaseApiResponseWithSerializable<SubjectResponse> value) {
          return DropdownMenuItem<BaseApiResponseWithSerializable<SubjectResponse>>(
            value: value,
            child: Text(value.fields!.subjectTitle!),
          );
        }).toList(),
      ),
    );
  }
*/
}
