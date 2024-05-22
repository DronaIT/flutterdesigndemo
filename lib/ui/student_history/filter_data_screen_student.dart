import 'dart:io';

import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/request/add_placement_attendance_response.dart';
import 'package:flutterdesigndemo/ui/student_history/student_history.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../values/text_styles.dart';

class FilterDataStudent extends StatefulWidget {
  const FilterDataStudent({Key? key}) : super(key: key);

  @override
  State<FilterDataStudent> createState() => _FilterDataStudentState();
}

class _FilterDataStudentState extends State<FilterDataStudent> {
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> studentList = [];

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>> test = [];

  bool isVisible = false;
  var subjectName;

  var subjectId;

  var isFromEligible;
  var speName;
  var hubName;
  var mentorName;
  var controllerSearch = TextEditingController();

  List<BaseApiResponseWithSerializable<AddPlacementAttendanceResponse>>? placementData = [];
  String offset = "";

  final apiRepository = getIt.get<ApiRepository>();
  int part = 0;

  @override
  void initState() {
    super.initState();
    if (Get.arguments[0]["studentList"] != null) {
      test = Get.arguments[0]["studentList"];
      studentList = Get.arguments[0]["studentList"];
      subjectName = Get.arguments[1]["subject"];
      subjectId = Get.arguments[4]["subjectid"];
      speName = Get.arguments[2]["specialization"];
      hubName = Get.arguments[3]["hub"];
      mentorName = Get.arguments[5]["mentor"];
    }

    if (mentorName?.toString().trim().isNotEmpty == true) {
      getPlacementData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_students),
      body: Stack(children: [
        Column(
          children: [
            custom_text(
              text: "Total Students: ${test.length}",
              textStyles: primaryTextSemiBold16,
            ),
            CustomEditTextSearch(
              type: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: controllerSearch,
              onChanges: (value) {
                if (value.isEmpty) {
                  studentList = [];
                  studentList = List.from(test);
                  setState(() {});
                } else {
                  studentList = [];
                  for (var i = 0; i < test.length; i++) {
                    if (test[i].fields!.name!.toLowerCase().contains(value.toLowerCase())) {
                      studentList.add(test[i]);
                    }
                  }
                  setState(() {});
                }
              },
            ),
            studentList.isNotEmpty
                ? Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      child: ListView.builder(
                          itemCount: studentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(const StudentHistory(), arguments: studentList[index].fields?.mobileNumber);
                              },
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 3.h),
                                  decoration: BoxDecoration(color: colors_name.colorWhite, borderRadius: BorderRadius.circular(10.r)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      custom_text(text: "${studentList[index].fields?.name}", textStyles: linkTextSemiBold16),
                                      custom_text(topValue: 0, bottomValue: 5, text: "Enrollment No: ${studentList[index].fields?.enrollmentNumber}", textStyles: blackTextSemiBold14),
                                      custom_text(
                                          topValue: 0,
                                          bottomValue: 5,
                                          maxLines: 2,
                                          text: "Specialization: ${Utils.getSpecializationName(studentList[index].fields?.specializationIds![0])}",
                                          textStyles: blackTextSemiBold14),
                                      custom_text(topValue: 0, bottomValue: 5, text: "Mobile No: ${studentList[index].fields?.mobileNumber}", textStyles: blackTextSemiBold14),
                                      custom_text(topValue: 0, bottomValue: 5, text: "Semester: ${studentList[index].fields?.semester}", textStyles: blackTextSemiBold14),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                : Container(margin: EdgeInsets.only(top: 100.h), child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
            CustomButton(
              fontSize: 15,
              text: strings_name.str_export_student_data,
              click: () async {
                if (studentList.isNotEmpty) {
                  exportStudentData();
                } else {
                  Utils.showSnackBar(context, strings_name.str_please_select_one_student);
                }
              },
            ),
          ],
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
      ]),
    ));
  }

  getPlacementData() async {
    if (!isVisible) {
      setState(() {
        isVisible = true;
      });
    }

    var query = "OR(";
    int endPos = (part + 50 > studentList.length) ? studentList.length : part + 50;
    for (int i = part; i < endPos; i++) {
      if (studentList[i].fields?.placedJob?.isNotEmpty == true) {
        if (query.length > 3) {
          query += ",";
        }
        query += "AND("
            "SEARCH('${studentList[i].fields?.mobileNumber}',ARRAYJOIN(${TableNames.CLM_STUDENT_MOBILE_NUMBER})),"
            "SEARCH('${studentList[i].fields?.placed_job_code?.last}',ARRAYJOIN(${TableNames.CLM_JOB_CODE}))"
            ")";
      }
    }
    query += ")";
    debugPrint("Part: $part\n$query");

    try {
      var data = await apiRepository.getPlacementInfoApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty && part == 0) {
          placementData?.clear();
        }
        placementData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<AddPlacementAttendanceResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getPlacementData();
        } else {
          if (endPos < studentList.length) {
            part = endPos;
            getPlacementData();
          } else {
            part = 0;
          }

          placementData?.sort((b, a) {
            var adate = a.fields!.uploadedOn;
            var bdate = b.fields!.uploadedOn;
            return adate!.compareTo(bdate!);
          });

          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            placementData = [];
          }
        });
        offset = "";
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  Future<void> exportStudentData() async {
    setState(() {
      isVisible = true;
    });
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];
    var title = mentorName.toString().trim().isNotEmpty ? mentorName :Utils.getHubName(studentList[0].fields?.hubIdFromHubIds?.first);
    sheet.appendRow([title]);
    sheet.appendRow([
      'Name',
      'Enrollment Number',
      'Mobile Number',
      'Email',
      'Specialization',
      'Semester',
      'Division',
      'Total Attendance',
      'Attendance Percentage',
      'Placement Status',
      'Company Name',
      'Job Title',
      mentorName.toString().trim().isNotEmpty ? 'Placement Attendance Data' : ' '
    ]);

    studentList.forEach((row) {
      String placementStatus = "Not Placed", companyName = "", jobTitle = "";
      if ((row.fields?.placedJob?.length ?? 0) > 0) {
        placementStatus = "Placed";
        companyName = row.fields?.company_name_from_placed_job?.last ?? "";
        jobTitle = row.fields?.job_title_from_placed_job?.last ?? "";
      }
      var total_lecture = 0, total_present = 0, totalPresentPercentage, total_absent = 0;
      if (row.fields?.lectureSubjectId?.isNotEmpty == true) {
        if (row.fields?.presentLectureIds != null && row.fields?.presentLectureIds?.isNotEmpty == true) {
          for (var i = 0; i < row.fields!.presentLectureIds!.length; i++) {
            if (row.fields?.presentSemesterByStudent![i] == row.fields?.semester) {
              total_present += 1;
              total_lecture += 1;
            }
          }
        }
        if (row.fields?.absentLectureIds != null && row.fields?.absentLectureIds?.isNotEmpty == true) {
          for (var i = 0; i < row.fields!.absentLectureIds!.length; i++) {
            if (row.fields?.absentSemesterByStudent![i] == row.fields?.semester) {
              total_absent += 1;
              total_lecture += 1;
            }
          }
        }
      }
      totalPresentPercentage = ((total_present * 100) / total_lecture).toStringAsFixed(2);

      List<dynamic> studentDetail = [];
      studentDetail.add(row.fields?.name);
      studentDetail.add(row.fields?.enrollmentNumber);
      studentDetail.add(row.fields?.mobileNumber);
      studentDetail.add(row.fields?.email);
      studentDetail.add(Utils.getSpecializationName(row.fields?.specializationIds?.first));
      studentDetail.add(row.fields?.semester);
      studentDetail.add(row.fields?.division);
      studentDetail.add("$total_present/$total_lecture");
      studentDetail.add("$totalPresentPercentage%");
      studentDetail.add(placementStatus);
      studentDetail.add(companyName);
      studentDetail.add(jobTitle);

      if (mentorName.toString().trim().isNotEmpty) {
        if (row.fields?.job_title_from_placed_job?.last.isNotEmpty == true) {
          for (int i = 0; i < (placementData?.length ?? 0); i++) {
            if (placementData![i].fields?.job_id?.last == row.fields?.placedJob?.last && placementData![i].fields?.student_name?.last == row.fields?.name) {
              if (placementData![i].fields?.attendance_form?.isNotEmpty == true) {
                String title = "Attendance Form";
                String path = placementData![i].fields?.attendance_form?.last.url ?? "";
                String uploadedOn = placementData![i].fields?.uploadedOn ?? "";

                if (path.isNotEmpty) {
                  studentDetail.add("Type: $title \nPath: $path\nUploaded On: $uploadedOn");
                }
              }
              if (placementData![i].fields?.company_loc?.isNotEmpty == true) {
                String title = "Company LOC";
                String path = placementData![i].fields?.company_loc?.last.url ?? "";
                String uploadedOn = placementData![i].fields?.uploadedOn ?? "";

                if (path.isNotEmpty) {
                  studentDetail.add("Type: $title \nPath: $path\nUploaded On: $uploadedOn");
                }
              }
              if (placementData![i].fields?.workbook?.isNotEmpty == true) {
                String title = "Workbook";
                String path = placementData![i].fields?.workbook?.last.url ?? "";
                String uploadedOn = placementData![i].fields?.uploadedOn ?? "";

                if (path.isNotEmpty) {
                  studentDetail.add("Type: $title \nPath: $path\nUploaded On: $uploadedOn");
                }
              }
            }
          }
        }
      }

      sheet.appendRow(studentDetail);
    });

    var appDocumentsDirectory = await getApplicationDocumentsDirectory();
    var file = File("${appDocumentsDirectory.path}/${title?.replaceAll(" ", "").replaceAll("/", "")}_StudentsData.xlsx");
    await file.writeAsBytes(excel.encode()!);
    try {
      await OpenFilex.open(file.path);
      setState(() {
        isVisible = false;
      });
    } catch (e) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBarUsingGet("No Application found to open this file");
    }
  }
}
