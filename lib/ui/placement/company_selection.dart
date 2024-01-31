import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/company_detail_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../customwidget/custom_edittext_search.dart';

class CompanySelection extends StatefulWidget {
  const CompanySelection({Key? key}) : super(key: key);

  @override
  State<CompanySelection> createState() => _CompanySelectionState();
}

class _CompanySelectionState extends State<CompanySelection> {
  bool isVisible = false;
  List<BaseApiResponseWithSerializable<CompanyDetailResponse>>? companyData = [];
  List<BaseApiResponseWithSerializable<CompanyDetailResponse>>? mainCompanyData = [];

  BaseApiResponseWithSerializable<CompanyDetailResponse> selectedData = BaseApiResponseWithSerializable();

  final apiRepository = getIt.get<ApiRepository>();
  String offset = "";
  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    getRecords();
  }

  getRecords() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });

    var query = "";
    if (PreferenceUtils.getIsLogin() == 2) {
      query = "OR(FIND('${PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
      if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code != null && PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code?.isNotEmpty == true) {
        for (int i = 0; i < PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code!.length; i++) {
          if (PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i] != PreferenceUtils.getLoginDataEmployee().hubIdFromHubIds![0]) {
            query += ",FIND('${PreferenceUtils.getLoginDataEmployee().accessible_hub_ids_code![i]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
          }
        }
      }
      query += ")";
    } else {
      query = "OR(FIND('${PreferenceUtils.getLoginData().hubIdFromHubIds![0]}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}))";
      query += ")";
    }
    debugPrint(query);

    try {
      var data = await apiRepository.getCompanyDetailApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mainCompanyData?.clear();
        }
        mainCompanyData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<CompanyDetailResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          mainCompanyData?.sort((a, b) {
            var adate = a.fields!.companyName?.trim();
            var bdate = b.fields!.companyName?.trim();
            return adate!.compareTo(bdate!);
          });

          companyData = [];
          companyData = List.from(mainCompanyData!);

          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            companyData = [];
            mainCompanyData = [];
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_select_company),
      body: Stack(children: [
        mainCompanyData?.isNotEmpty == true
            ? Column(children: [
                SizedBox(height: 10.h),
                CustomEditTextSearch(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: controllerSearch,
                  onChanges: (value) {
                    if (value.isEmpty) {
                      companyData = [];
                      companyData = List.from(mainCompanyData as Iterable);
                      setState(() {});
                    } else {
                      companyData = [];
                      if (mainCompanyData != null && mainCompanyData?.isNotEmpty == true) {
                        for (var i = 0; i < mainCompanyData!.length; i++) {
                          if (mainCompanyData![i].fields!.companyName!.toLowerCase().contains(value.toLowerCase())) {
                            companyData?.add(mainCompanyData![i]);
                          }
                        }
                      }
                      setState(() {});
                    }
                  },
                ),
                companyData?.isNotEmpty == true
                    ? Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: ListView.builder(
                              itemCount: companyData?.length,
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
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                custom_text(text: "${companyData![index].fields!.companyName}", textAlign: TextAlign.start, textStyles: blackTextSemiBold16, topValue:5, bottomValue: 5,),
                                                custom_text(text: "City: ${companyData![index].fields!.city}", textAlign: TextAlign.start, textStyles: blackText14, topValue: 0, bottomValue: 5,),
                                              ],
                                            ),
                                          ),
                                          if (companyData![index].fields!.selected) const Icon(Icons.check, size: 20, color: colors_name.colorPrimary),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedData = companyData![index];
                                        companyData![index].fields!.selected = !companyData![index].fields!.selected;
                                        for (int i = 0; i < mainCompanyData!.length; i++) {
                                          if (companyData![index].fields!.company_code == mainCompanyData![i].fields!.company_code) {
                                            mainCompanyData![i].fields!.selected = companyData![index].fields!.selected;
                                          } else {
                                            mainCompanyData![i].fields!.selected = false;
                                          }
                                        }
                                        setState(() {});
                                      });
                                    },
                                  ),
                                );
                              }),
                        ),
                      )
                    : Container(),
                SizedBox(height: 20.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    if (selectedData.id?.isNotEmpty == true) {
                      Get.back(result: selectedData);
                    } else {
                      Utils.showSnackBar(context, strings_name.str_empty_company);
                    }
                  },
                )
              ])
            : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_students, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
        Center(
          child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
        )
      ]),
    ));
  }
}
