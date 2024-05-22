import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/company_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

import '../../api/dio_exception.dart';
import '../../customwidget/custom_edittext_search.dart';

class CompanySelectionLocal extends StatefulWidget {
  const CompanySelectionLocal({Key? key}) : super(key: key);

  @override
  State<CompanySelectionLocal> createState() => _CompanySelectionLocalState();
}

class _CompanySelectionLocalState extends State<CompanySelectionLocal> {
  bool isVisible = false;
  List<CompanyResponse>? companyData = [];
  List<CompanyResponse>? mainCompanyData = [];

  List<CompanyResponse> selectedData = [];

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  final apiRepository = getIt.get<ApiRepository>();
  var controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    getHubs();
  }

  Future<void> getHubs() async {
    try {
      setState(() {
        isVisible = true;
      });
      var hubResponse = await apiRepository.getHubApi();
      if (hubResponse.records!.isNotEmpty) {
        PreferenceUtils.setHubList(hubResponse);
        debugPrint("Hubs ${PreferenceUtils.getHubList().records!.length}");

        for (int i = 0; i < hubResponse.records!.length; i++) {
          if (hubResponse.records![i].fields?.hubId == TableNames.CANCELLED_HUB_ID) {
            hubResponse.records?.removeAt(i);
            i--;
          } else if (hubResponse.records![i].fields?.hubId == TableNames.SUSPENDED_HUB_ID) {
            hubResponse.records?.removeAt(i);
            i--;
          }
        }

        hubResponseArray = hubResponse.records;
        this.hubResponse = hubResponseArray![0];
        hubValue = hubResponseArray![0].id!;

        getCompanyRecords();
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = true;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  getCompanyRecords() {
    mainCompanyData = [];
    companyData = [];
    for (int i = 0; i < (hubResponse?.fields?.tblCompany?.length ?? 0); i++) {
      if (hubResponse!.fields!.isCompanyAssigned![i] == 0) {
        CompanyResponse data = CompanyResponse();
        data.companyId = hubResponse!.fields!.tblCompany![i];
        data.companyName = hubResponse!.fields!.companyName![i];
        data.companyCity = hubResponse!.fields!.companyCity![i];
        data.companyContactPerson = hubResponse!.fields!.companyContactName![i];

        mainCompanyData?.add(data);
      }
    }

    if (mainCompanyData?.isNotEmpty == true) {
      mainCompanyData?.sort((a, b) {
        var adate = a.companyName?.trim();
        var bdate = b.companyName?.trim();
        return adate!.compareTo(bdate!);
      });
    }

    companyData = List.from(mainCompanyData!);
    isVisible = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_select_company),
      body: Stack(children: [
        SingleChildScrollView(
            child: Column(
          children: [
            custom_text(
              text: strings_name.str_select_hub,
              alignment: Alignment.topLeft,
              textStyles: blackTextSemiBold16,
              bottomValue: 0,
            ),
            Container(
              margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
              width: MediaQuery.of(context).size.width,
              child: DropdownButtonFormField<BaseApiResponseWithSerializable<HubResponse>>(
                value: hubResponse,
                elevation: 16,
                style: blackText16,
                focusColor: Colors.white,
                onChanged: (BaseApiResponseWithSerializable<HubResponse>? newValue) {
                  setState(() {
                    hubValue = newValue!.id!.toString();
                    hubResponse = newValue;
                    getCompanyRecords();
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
            SizedBox(height: 10.h),
            Visibility(
              visible: mainCompanyData?.isNotEmpty == true,
              child: Column(children: [
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
                          if (mainCompanyData![i].companyName!.toLowerCase().contains(value.toLowerCase())) {
                            companyData?.add(mainCompanyData![i]);
                          }
                        }
                      }
                      setState(() {});
                    }
                  },
                ),
                SizedBox(height: 5.h),
                Visibility(
                    visible: companyData?.isNotEmpty == true,
                    child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: companyData?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5,
                            margin: EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.h),
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
                                          custom_text(
                                            text: "${companyData![index].companyName}",
                                            textAlign: TextAlign.start,
                                            textStyles: blackTextSemiBold16,
                                            topValue: 5,
                                            bottomValue: 5,
                                          ),
                                          custom_text(
                                            text: "City: ${companyData![index].companyCity}",
                                            textAlign: TextAlign.start,
                                            textStyles: blackText14,
                                            topValue: 0,
                                            bottomValue: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (companyData![index].selected) const Icon(Icons.check, size: 20, color: colors_name.colorPrimary),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  companyData![index].selected = !companyData![index].selected;
                                  for (int i = 0; i < mainCompanyData!.length; i++) {
                                    if (companyData![index].companyId == mainCompanyData![i].companyId) {
                                      mainCompanyData![i].selected = companyData![index].selected;
                                    }
                                  }
                                  setState(() {});
                                });
                              },
                            ),
                          );
                        })),
                SizedBox(height: 20.h),
                CustomButton(
                  text: strings_name.str_submit,
                  click: () {
                    List<CompanyResponse>? selectedData = [];
                    for (var i = 0; i < mainCompanyData!.length; i++) {
                      if (mainCompanyData![i].selected) {
                        selectedData.add(mainCompanyData![i]);
                      }
                    }

                    if (selectedData.isNotEmpty == true) {
                      Get.back(result: selectedData);
                    } else {
                      Utils.showSnackBar(context, strings_name.str_empty_company);
                    }
                  },
                )
              ]),
            ),
          ],
        )),
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
}
