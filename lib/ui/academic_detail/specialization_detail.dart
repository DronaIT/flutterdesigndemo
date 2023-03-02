import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/ui/academic_detail/subject_detail.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';

class SpecializationDetail extends StatefulWidget {
  const SpecializationDetail({Key? key}) : super(key: key);

  @override
  State<SpecializationDetail> createState() => _SpecializationDetailState();
}

class _SpecializationDetailState extends State<SpecializationDetail> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? specializationData = [];
  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectData = [];

  final apiRepository = getIt.get<ApiRepository>();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  Future<void> initialization() async {
    setState(() {
      isVisible = true;
    });
    var query = "FIND('${Get.arguments}', ${TableNames.CLM_SPE_ID}, 0)";
    try{
      var data = await apiRepository.getSpecializationDetailApi(query);
      if (data.records?.isNotEmpty == true) {
        specializationData = data.records;
        if (specializationData?.isNotEmpty == true) {
          var query = "FIND('${specializationData![0].fields!.id}', ${TableNames.CLM_SPE_IDS}, 0)";
          var data = await apiRepository.getSubjectsApi(query);
          if (data.records?.isNotEmpty == true) {
            subjectData = data.records;
          }
        }
      } else {
        Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
    }on DioError catch (e) {
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_spe_detail),
      body: Stack(children: [
        specializationData?.isNotEmpty == true
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    custom_text(text: specializationData![0].fields!.specializationName.toString(), maxLines: 5, textStyles: centerTextStyle24),
                    custom_text(text: "Code : ${specializationData![0].fields!.specializationId}", textStyles: blackTextSemiBold16),
                    custom_text(text: specializationData![0].fields!.specializationDesc.toString(), maxLines: 5000, textStyles: blackTextSemiBold14),
                    Visibility(visible: subjectData?.isNotEmpty == true, child: custom_text(text: "Subjects", textStyles: blackTextSemiBold16)),
                    subjectData?.isNotEmpty == true
                        ? Container(
                            margin: const EdgeInsets.all(10),
                            child: ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: subjectData?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 5,
                                    child: GestureDetector(
                                      child: Container(
                                        color: colors_name.colorWhite,
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [Expanded(child: Text("${subjectData![index].fields!.subjectTitle}", textAlign: TextAlign.start, style: blackTextSemiBold14)), const Icon(Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)],
                                        ),
                                      ),
                                      onTap: () {
                                        Get.to(const SubjectDetail(), arguments: subjectData![index].fields?.ids);
                                      },
                                    ),
                                  );
                                }),
                          )
                        : Container(),
                    // Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_employee, textStyles: centerTextStyleBlack18, alignment: Alignment.center))
                  ],
                ),
              )
            : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
