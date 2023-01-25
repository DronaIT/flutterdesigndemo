import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/ui/placement/company_detail.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/service_locator.dart';
import '../../customwidget/custom_text.dart';
import '../../models/base_api_response.dart';
import '../../models/company_detail_response.dart';
import '../../values/text_styles.dart';

class GetCompanyDetail extends StatefulWidget {
  const GetCompanyDetail({Key? key}) : super(key: key);

  @override
  State<GetCompanyDetail> createState() => _GetCompanyDetailState();
}

class _GetCompanyDetailState extends State<GetCompanyDetail> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<CompanyDetailResponse> companyDetailResponse = BaseLoginResponse();
  var update = false;

  @override
  void initState() {
    super.initState();
    update = Get.arguments;
    getRecords();
  }

  Future<void> getRecords() async {
    setState(() {
      isVisible = true;
    });
    companyDetailResponse = await apiRepository.getCompanyDetailApi("");
    if (companyDetailResponse.records!.isNotEmpty) {
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_create_company),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: companyDetailResponse.records != null ?companyDetailResponse.records?.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      elevation: 5,
                      child: Row(
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                custom_text(text: "${companyDetailResponse.records?[index].fields?.companyName}", textStyles: centerTextStylePrimary18, topValue: 10, maxLines: 2),
                                custom_text(text: "Name: ${companyDetailResponse.records?[index].fields?.contactName}", textStyles: blackTextSemiBold12, bottomValue: 5, topValue: 0),
                                custom_text(text: "Contact no.: ${companyDetailResponse.records?[index].fields?.contactNumber}", textStyles: blackTextSemiBold12, bottomValue: 5, topValue: 0),
                              ],
                            ),
                          ),
                          Visibility(
                              visible: update,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(const CompanyDetail(), arguments: companyDetailResponse.records?[index].fields?.company_code)?.then((result) {
                                    if (result != null && result) {
                                      getRecords();
                                    }
                                  });
                                },
                                child:  Container(margin: const EdgeInsets.all(10), child: const Icon(Icons.edit))),
                              )
                        ],
                      ));
                }),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }
}
