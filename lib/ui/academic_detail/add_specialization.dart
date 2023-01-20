import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/request/add_specialization_request.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/subject_detail.dart';
import 'package:flutterdesigndemo/ui/academic_detail/subject_selection.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class AddSpecialization extends StatefulWidget {
  const AddSpecialization({Key? key}) : super(key: key);

  @override
  State<AddSpecialization> createState() => _AddSpecializationState();
}

class _AddSpecializationState extends State<AddSpecialization> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  bool isVisible = false;
  bool fromEdit = false;
  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectData = [];

  final apiRepository = getIt.get<ApiRepository>();
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    if (Get.arguments != null) {
      setState(() {
        isVisible = true;
      });
      var query = "FIND('${Get.arguments}', ${TableNames.CLM_SPE_ID}, 0)";
      var data = await apiRepository.getSpecializationDetailApi(query);
      if (data.records?.isNotEmpty == true) {
        setState(() {
          fromEdit = true;
        });

        specializationData = data.records;
        if (specializationData?.isNotEmpty == true) {
          titleController.text = specializationData![0].fields!.specializationName.toString();
          descController.text = specializationData![0].fields!.specializationDesc.toString();

          var query = "FIND('${specializationData![0].fields!.id}', ${TableNames.CLM_SPE_IDS}, 0)";
          var data = await apiRepository.getSubjectsApi(query);
          if (data.records?.isNotEmpty == true) {
            subjectData = data.records;
          }
        }
      } else {
        Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppWidgets.appBarWithoutBack(fromEdit ? strings_name.str_update_specilization : strings_name.str_add_specilization),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    custom_text(
                      text: strings_name.str_specialization_title,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(
                      type: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      controller: titleController,
                      topValue: 2,
                      maxLength: 200,
                    ),
                    SizedBox(height: 10.h),
                    custom_text(
                      text: strings_name.str_specialization_desc,
                      alignment: Alignment.topLeft,
                      textStyles: blackTextSemiBold16,
                    ),
                    custom_edittext(
                      type: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: 3,
                      minLines: 3,
                      controller: descController,
                      topValue: 2,
                      maxLength: 5000,
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          custom_text(
                            text: strings_name.str_subjects,
                            alignment: Alignment.topLeft,
                            textStyles: blackTextSemiBold16,
                          ),
                          GestureDetector(
                            child: custom_text(
                              text: subjectData?.isEmpty == true ? strings_name.str_add : strings_name.str_update,
                              alignment: Alignment.topLeft,
                              textStyles: primaryTextSemiBold16,
                            ),
                            onTap: () {
                              Get.to(const SubjectSelection(), arguments: subjectData)?.then((result) {
                                if (result != null) {
                                  setState(() {
                                    subjectData = result;
                                  });
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    subjectData!.isNotEmpty
                        ? ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: subjectData?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                child: Card(
                                  elevation: 5,
                                  child: GestureDetector(
                                    child: Container(
                                      color: colors_name.colorWhite,
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [Expanded(child: Text("${subjectData![index].fields!.subjectTitle}", textAlign: TextAlign.start, style: blackText16)), const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                                      ),
                                    ),
                                    onTap: () {
                                      Get.to(const SubjectDetail(), arguments: subjectData![index].fields?.ids);
                                    },
                                  ),
                                ),
                              );
                            })
                        : Container(),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: strings_name.str_submit,
                      click: () {
                        if (titleController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_specialization_title);
                        } else if (descController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_empty_specialization_desc);
/*
                        } else if (subjectData!.isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_select_subject);
*/
                        } else {
                          addRecord();
                        }
                      },
                    )
                  ],
                ),
              ),
              Center(
                child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
              )
            ],
          )),
    );
  }

  Future<void> addRecord() async {
    setState(() {
      isVisible = true;
    });
    AddSpecializationRequest request = AddSpecializationRequest();
    request.specializationName = titleController.text.toString();
    request.specializationDesc = descController.text.toString();

    List<String> selectedSubjectData = [];
    for (var i = 0; i < subjectData!.length; i++) {
      selectedSubjectData.add(subjectData![i].id.toString());
    }
    request.tBLSUBJECT = selectedSubjectData;

    if (!fromEdit) {
      var resp = await apiRepository.addSpecializationApi(request);
      if (resp.id!.isNotEmpty) {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_specialization_added);
        await Future.delayed(const Duration(milliseconds: 2000));
        Get.back(closeOverlays: true, result: true);
      } else {
        setState(() {
          isVisible = false;
        });
      }
    } else {
      var resp = await apiRepository.updateSpecializationApi(request.toJson(), specializationData![0].id.toString());
      if (resp.id!.isNotEmpty) {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_specialization_updated);
        await Future.delayed(const Duration(milliseconds: 2000));
        Get.back(closeOverlays: true, result: true);
      } else {
        setState(() {
          isVisible = false;
        });
      }
    }
  }
}
