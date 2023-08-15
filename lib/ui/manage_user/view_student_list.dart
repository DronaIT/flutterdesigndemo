import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/ui/manage_user/addsinglestudent.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_edittext_search.dart';
import '../../customwidget/custom_text.dart';
import '../../models/base_api_response.dart';
import '../../models/login_fields_response.dart';
import '../../values/text_styles.dart';

class ViewStudentList extends StatefulWidget {
  const ViewStudentList({Key? key}) : super(key: key);

  @override
  State<ViewStudentList> createState() => _ViewStudentListState();
}

class _ViewStudentListState extends State<ViewStudentList> {
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? viewStudent = [];
  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? mainData = [];
  bool canUpdateStudent = false;
  String offset = "";
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;
  String hubValue = "";
  String speValue = "";
  int semesterValue = 1;
  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    canUpdateStudent = Get.arguments[0]["canUpdate"];
    hubValue = Get.arguments[1]["hubValue"];
    semesterValue = Get.arguments[2]["semValue"];
    speValue = Get.arguments[3]["speValue"];
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    var query = "AND(${TableNames.CLM_HUB_IDS}='$hubValue',${TableNames.CLM_SPE_IDS}='$speValue',${TableNames.CLM_SEMESTER}='${semesterValue.toString()}')";
    setState(() {
      isVisible = true;
    });
    try {
      var data = await apiRepository.loginApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mainData?.clear();
          viewStudent?.clear();
        }
        mainData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        viewStudent?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchRecords();
        } else {
          setState(() {
            mainData?.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
            viewStudent?.sort((a, b) => a.fields!.name!.compareTo(b.fields!.name!));
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            viewStudent = [];
            mainData = [];
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_students),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Visibility(
                    visible: mainData!.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 10),
                      child: CustomEditTextSearch(
                        type: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        controller: controllerSearch,
                        onChanges: (value) {
                          if (value.isEmpty) {
                            viewStudent = [];
                            viewStudent = List.from(mainData!);
                            setState(() {});
                          } else {
                            viewStudent = [];
                            for (var i = 0; i < mainData!.length; i++) {
                              if (mainData![i].fields!.name!.toLowerCase().contains(value.toLowerCase())) {
                                viewStudent?.add(mainData![i]);
                              }
                            }
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                      visible: viewStudent?.isNotEmpty == true,
                      child: custom_text(
                        text: "Total Students : ${viewStudent!.length}",
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                        topValue: 0,
                      )),
                  viewStudent!.isNotEmpty
                      ? ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: viewStudent?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 5,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Column(
                                      children: [
                                        custom_text(text: "${viewStudent![index].fields!.name!} (${viewStudent![index].fields!.enrollmentNumber!})", textStyles: blackTextSemiBold16, topValue: 10, maxLines: 2),
                                        Visibility(visible: viewStudent![index].fields!.email != null, child: custom_text(text: viewStudent![index].fields!.email != null ? viewStudent![index].fields!.email! : "", textStyles: blackTextSemiBold14, bottomValue: 5, topValue: 0)),
                                        custom_text(text: viewStudent![index].fields!.mobileNumber!, textStyles: blackTextSemiBold14, bottomValue: 10, topValue: 0)
                                      ],
                                    ),
                                  ),
                                  canUpdateStudent
                                      ? GestureDetector(
                                          onTap: () async {
                                            var response = await Get.to(const AddSingleStudent(), arguments: viewStudent![index].fields?.mobileNumber);
                                            if (response) {
                                              fetchRecords();
                                            }
                                          },
                                          child: Container(margin: const EdgeInsets.all(10), child: const Icon(Icons.edit)))
                                      : Container()
                                ],
                              ),
                            );
                          })
                      : Center(
                          child: Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
                        ),
                ],
              ),
            ),
            Center(
              child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
            )
          ],
        ),
      ),
    );
  }
}
