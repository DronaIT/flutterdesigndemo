import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/CreateStudentRequest.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/createpassword.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';

class CreateStudent extends StatefulWidget {
  const CreateStudent({Key? key}) : super(key: key);

  @override
  State<CreateStudent> createState() => _AddStudent();
}

class _AddStudent extends State<CreateStudent> {
  bool isVisible = false;

  final createStudentRepository = getIt.get<ApiRepository>();
  late BaseLoginResponse<CreatePasswordResponse> resp;
  List<Map<String, CreateStudentRequest>> list = [];

  Future<void> createStudents() async {
    setState(() {
      isVisible = true;
    });
    resp = await createStudentRepository.createStudentApi(list);
    if (resp.records!.isNotEmpty) {
      setState(() {
        isVisible = false;
      });
    } else {
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(strings_name.str_add_students),
        backgroundColor: colors_name.colorPrimary,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(14),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
          child: custom_text(
            text: "Click me",
            alignment: Alignment.center,
            textStyles: blackTextSemiBold14,
          ),
          onTap: () {
            _importFromExcel();
          }),
    ));
  }

  _importFromExcel() async {
    var file = "assets/res/tables_data.xlsx";
    // var bytes = File(file).readAsBytesSync();
    var data = await rootBundle.load(file);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      for (var row = 1; row < excel.tables[table]!.maxRows; row++) {
        CreateStudentRequest response = CreateStudentRequest();
        response.name = excel.tables[table]?.rows[row][0]?.value.toString();
        response.mobileNumber = excel.tables[table]?.rows[row][1]?.value.toString();
        response.gender = excel.tables[table]?.rows[row][2]?.value;
        response.city = excel.tables[table]?.rows[row][3]?.value.toString();
        response.address = excel.tables[table]?.rows[row][4]?.value.toString();
        response.password = excel.tables[table]?.rows[row][5]?.value.toString();
        response.hubIds = Utils.getHubId(excel.tables[table]?.rows[row][6]?.value.toString())!.split(",");
        response.specializationIds = Utils.getSpecializationId(excel.tables[table]?.rows[row][7]?.value.toString())!.split(",");
        response.joiningYear = excel.tables[table]?.rows[row][8]?.value.toString();

        Map<String, CreateStudentRequest> map = Map();
        map["fields"] = response;

        list.add(map);
      }
    }
    if (list.length > 0) {
      print(jsonEncode(list));
      createStudents();
    }
  }
}
