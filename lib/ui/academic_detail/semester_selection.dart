import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/semester_data.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SemesterSelection extends StatefulWidget {
  const SemesterSelection({Key? key}) : super(key: key);

  @override
  State<SemesterSelection> createState() => _SemesterSelectionState();
}

class _SemesterSelectionState extends State<SemesterSelection> {
  bool isVisible = false;
  List<SemesterData>? semesterDataArray = [];

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    semesterDataArray?.clear();
    semesterDataArray?.add(SemesterData(semester: 1));
    semesterDataArray?.add(SemesterData(semester: 2));
    semesterDataArray?.add(SemesterData(semester: 3));
    semesterDataArray?.add(SemesterData(semester: 4));
    semesterDataArray?.add(SemesterData(semester: 5));
    semesterDataArray?.add(SemesterData(semester: 6));

    List<SemesterData>? selectedData = [];
    selectedData = Get.arguments;

    for (var i = 0; i < selectedData!.length; i++) {
      for (var j = 0; j < semesterDataArray!.length; j++) {
        if (semesterDataArray![j].semester == selectedData[i].semester) {
          semesterDataArray![j].selected = true;
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_semester),
      body: Stack(children: [
        semesterDataArray?.isNotEmpty == true
            ? Column(children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: ListView.builder(
                        itemCount: semesterDataArray?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.all(5),
                            child: GestureDetector(
                              child: Container(
                                color: colors_name.colorWhite,
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [Expanded(child: Text("Semester ${semesterDataArray![index].semester}", textAlign: TextAlign.start, style: blackTextSemiBold16)), if (semesterDataArray![index].selected) const Icon(Icons.check, size: 20, color: colors_name.colorPrimary)]),
                              ),
                              onTap: () {
                                setState(() {
                                  semesterDataArray![index].selected = !semesterDataArray![index].selected;
                                });
                              },
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    List<SemesterData>? selectedSemesterData = [];
                    for (var i = 0; i < semesterDataArray!.length; i++) {
                      if (semesterDataArray![i].selected) {
                        selectedSemesterData.add(semesterDataArray![i]);
                      }
                    }
                    Get.back(result: selectedSemesterData);
/*
                    if (selectedSemesterData.isNotEmpty) {
                      Get.back(result: selectedSemesterData);
                    } else {
                      Utils.showSnackBar(context, strings_name.str_select_spelization);
                    }
*/
                  },
                )
              ])
            : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_semester, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
