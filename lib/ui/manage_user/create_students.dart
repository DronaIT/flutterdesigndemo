import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/createpassword.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/request/create_student_request.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/dio_exception.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({Key? key}) : super(key: key);

  @override
  State<CreateStudent> createState() => _AddStudent();
}

class _AddStudent extends State<CreateStudent> {
  bool isVisible = false;
  bool showError = false;

  final createStudentRepository = getIt.get<ApiRepository>();
  late BaseLoginResponse<CreatePasswordResponse> resp;
  List<Map<String, CreateStudentRequest>> list = [];

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];
  String hubValue = "", fileName = "";

  @override
  void initState() {
    super.initState();

    hubResponseArray = PreferenceUtils.getHubList().records;
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      if ((loginData.accessible_hub_ids?.length ?? 0) > 0) {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          var isAccessible = false;
          for (var j = 0; j < loginData.accessible_hub_ids!.length; j++) {
            if (loginData.accessible_hub_ids![j] == hubResponseArray![i].id) {
              isAccessible = true;
              break;
            }
            if (loginData.hubIdFromHubIds?.first == hubResponseArray![i].fields?.hubId) {
              isAccessible = true;
              break;
            }
          }
          if (!isAccessible) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      } else {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          if (loginData.hubIdFromHubIds?.first != hubResponseArray![i].fields?.hubId) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      }
    }
  }

  Future<void> getSampleFile() async {
    setState(() {
      isVisible = true;
    });
    try {
      var url;
      var data = await createStudentRepository.getAppData();
      for (var i = 0; i < data.records!.length; i++) {
        if (data.records?[i].fields?.title == TableNames.APPDATA_TITLE) {
          url = data.records?[i].fields?.url;
          break;
        }
      }
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      setState(() {
        isVisible = false;
      });
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  Future<void> createStudents(List<Map<String, CreateStudentRequest>> list, bool canClose) async {
    setState(() {
      isVisible = true;
    });
    try {
      resp = await createStudentRepository.createStudentApi(list);
      if (resp.records!.isNotEmpty && canClose) {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_students_added);
        await Future.delayed(const Duration(milliseconds: 2000));
        Get.back(closeOverlays: true);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_add_students),
      body: Stack(children: [
        Column(children: [
          SizedBox(height: 8.h),
          custom_text(
            text: strings_name.str_add_student_desc,
            alignment: Alignment.topLeft,
            textStyles: blackText16,
            maxLines: 5,
          ),
          ElevatedButton.icon(
            onPressed: () {
              getSampleFile();
            },
            icon: Icon(Icons.remove_red_eye),
            label: Text("View sample file"),
          ),
/*
          SizedBox(height: 8.h),
          custom_text(
            text: strings_name.str_select_hub,
            alignment: Alignment.topLeft,
            textStyles: blackTextSemiBold16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  width: viewWidth,
                  child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                    value: hubResponse,
                    elevation: 16,
                    style: blackText16,
                    focusColor: colors_name.colorPrimary,
                    onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                      setState(() {
                        hubValue = newValue!.fields!.hubId!.toString();
                        hubResponse = newValue;
                      });
                    },
                    items: hubResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>>((BaseApiResponseWithSerializable<HubResponse> value) {
                      return DropdownMenuItem<BaseApiResponseWithSerializable<HubResponse>>(
                        value: value,
                        child: Text(value.fields!.hubName!.toString()),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
*/
          SizedBox(height: 10.h),
          Visibility(
            visible: fileName.isNotEmpty,
            child: custom_text(
              text: fileName,
              alignment: Alignment.center,
              textStyles: blackTextSemiBold14,
            ),
          ),
          GestureDetector(
              child: custom_text(
                text: strings_name.str_select_upload_file,
                alignment: Alignment.center,
                textStyles: blackTextSemiBold16,
              ),
              onTap: () {
                _importFromExcel();
              }),
          SizedBox(height: 25.h),
          CustomButton(
            text: strings_name.str_submit,
            click: () {
              // if (hubValue.isEmpty) {
              //   Utils.showSnackBar(context, strings_name.str_empty_hub);
              // } else
              if (list.isEmpty) {
                if (fileName.isNotEmpty && !showError) {
                  Utils.showSnackBarDuration(context, strings_name.str_student_exists, 5);
                } else if (showError) {
                  Utils.showSnackBarDuration(context, strings_name.str_empty_mobile_sheet, 5);
                } else {
                  Utils.showSnackBar(context, strings_name.str_empty_file);
                }
              } else {
                if (list.length <= 10) {
                  createStudents(list, true);
                } else {
                  List<Map<String, CreateStudentRequest>> tempList = [];
                  for (var i = 0; i < list.length; i++) {
                    if (tempList.length < 10) {
                      tempList.add(list[i]);
                    }

                    if (tempList.length == 10) {
                      createStudents(tempList, i == list.length - 1);
                      tempList.clear();
                    } else if (i == list.length - 1) {
                      print("New students added");
                      // createStudents(tempList, true);
                    }
                  }
                }
              }
            },
          )
        ]),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, backgroundColor: colors_name.colorPrimary)),
        )
      ]),
    ));
  }

  openFile() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}/tables_data.xlsx";
    print(path);

    ByteData data = await rootBundle.load("assets/res/tables_data.xlsx");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var file = await File(path).writeAsBytes(bytes);

    OpenFilex.open(file.path);
  }

  _importFromExcel() async {
    // var file = "assets/res/tables_data.xlsx";
    // var data = await rootBundle.load(file);
    // var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    showError = false;
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

    if (result != null) {
      var bytes;

      if (kIsWeb) {
        bytes = result.files.single.bytes;
      } else {
        bytes = File(result.files.single.path!).readAsBytesSync();
      }

      var excel = Excel.decodeBytes(bytes);

      setState(() {
        isVisible = true;
        fileName = result.files.single.name;
      });
      for (var table in excel.tables.keys) {
        for (var row = 1; row < excel.tables[table]!.maxRows; row++) {
          CreateStudentRequest request = CreateStudentRequest();
          for (var col = 0; col < excel.tables[table]!.maxColumns; col++) {
            switch (excel.tables[table]?.rows[0][col]?.value.toString()) {
              case TableNames.EXCEL_COL_NAME:
                request.name = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_MOBILE_NUMBER:
                request.mobileNumber = excel.tables[table]?.rows[row][col]?.value.toString().replaceAll(" ", "").replaceAll("-", "");
                break;
              case TableNames.EXCEL_COL_GENDER:
                request.gender = capitalize(excel.tables[table]?.rows[row][col]?.value.toString());
                break;
              case TableNames.EXCEL_COL_CITY:
                request.city = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_ADDRESS:
                request.address = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_PIN_CODE:
                request.pinCode = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_HUB_IDS:
                request.hubIds = Utils.getHubIds(excel.tables[table]?.rows[row][col]?.value.toString())!.split(",");
                break;
              case TableNames.EXCEL_COL_SPECIALIZATION_IDS:
                request.specializationIds = Utils.getSpecializationId(excel.tables[table]?.rows[row][col]?.value.toString())!.split(",");
                break;
              case TableNames.EXCEL_COL_JOINING_YEAR:
                request.joiningYear = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_EMAIL:
                request.email = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_SEMESTER:
                request.semester = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_DIVISION:
                request.division = capitalizeFL(excel.tables[table]?.rows[row][col]?.value.toString());
                break;
              case TableNames.EXCEL_COL_SR_NUMBER:
                request.srNumber = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_BIRTHDATE:
                request.birthdate = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_AADHAR_CARD_NUMBER:
                request.aadharCardNumber = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_CASTE:
                request.caste = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_HSC_SCHOOL:
                request.hscSchool = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_HSC_SCHOOL_CITY:
                request.hscSchoolCity = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_HSC_PERCENTAGE:
                request.hscPercentage = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_MOTHER_NAME:
                request.motherName = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_MOTHER_NUMBER:
                request.motherNumber = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_FATHER_NUMBER:
                request.fatherNumber = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
              case TableNames.EXCEL_COL_BATCH:
                request.batch = excel.tables[table]?.rows[row][col]?.value.toString();
                break;
            }
          }
          // var query = "OR(${TableNames.TB_USERS_PHONE}='${response.mobileNumber.toString()}',${TableNames.CLM_MOTHER_NUMBER}='${response.motherNumber.toString()}',${TableNames.CLM_FATHER_NUMBERS}='${response.fatherNumber.toString()}')";
          if (request.mobileNumber != null) {
            var query = "FIND('${request.mobileNumber.toString()}',${TableNames.TB_USERS_PHONE},0)";
            try {
              var checkMobile = await createStudentRepository.loginApi(query);
              if (checkMobile.records?.isEmpty == true) {
                Map<String, CreateStudentRequest> map = Map();
                map["fields"] = request;
                list.add(map);
              }
            } on DioError catch (e) {
              setState(() {
                isVisible = false;
              });
              final errorMessage = DioExceptions.fromDioError(e).toString();
              Utils.showSnackBarUsingGet(errorMessage);
            }
          } else {
            list = [];
            showError = true;
            Utils.showSnackBarDuration(context, strings_name.str_empty_mobile_sheet, 5);
          }
        }
      }
      if (list.isNotEmpty) {
        setState(() {
          isVisible = false;
        });
        print(jsonEncode(list));
        // createStudents();
      } else {
        setState(() {
          isVisible = false;
        });
        if (!showError) {
          Utils.showSnackBarDuration(context, strings_name.str_student_exists, 5);
        }
      }
      FilePicker.platform.clearTemporaryFiles();
    }
  }

  String capitalize(String? s) => s![0].toUpperCase() + s.substring(1).toLowerCase();

  String capitalizeFL(String? s) {
    if (equalsIgnoreCase(s, TableNames.DIVISION_A)) {
      return TableNames.DIVISION_A;
    } else if (equalsIgnoreCase(s, TableNames.DIVISION_B)) {
      return TableNames.DIVISION_B;
    } else if (equalsIgnoreCase(s, TableNames.DIVISION_C)) {
      return TableNames.DIVISION_C;
    } else if (equalsIgnoreCase(s, TableNames.DIVISION_D)) {
      return TableNames.DIVISION_D;
    }
    return s.toString();
  }

  bool equalsIgnoreCase(String? a, String? b) => (a == null && b == null) || (a != null && b != null && a.toLowerCase() == b.toLowerCase());
}
