import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/app_version_response.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/ui/student_referral/add_student_referral.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../values/text_styles.dart';

class ReferralTerms extends StatefulWidget {
  const ReferralTerms({Key? key}) : super(key: key);

  @override
  State<ReferralTerms> createState() => _ReferralTermsState();
}

class _ReferralTermsState extends State<ReferralTerms> {
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<AppVersionResponse> appVersionResponse = BaseLoginResponse();

  bool value = false, isVisible = false, proceedAllowed = false;
  String ttd = "";

  @override
  void initState() {
    super.initState();
    proceedAllowed = Get.arguments;
    fetchTnc();
  }

  void fetchTnc() async {
    try {
      setState(() {
        isVisible = true;
      });
      appVersionResponse = await apiRepository.getAppVersions();
      if (appVersionResponse.records?.isNotEmpty == true) {
        for (int i = appVersionResponse.records!.length - 1; i >= 0; i--) {
          if (appVersionResponse.records![i].fields?.type == "Referral TNC") {
            ttd = appVersionResponse.records![i].fields?.text_to_display ?? "";
            break;
          }
        }
      }
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_student_referral_tnc),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              custom_text(
                text: ttd,
                textStyles: blackText15,
                maxLines: 50000,
              ),
              proceedAllowed
                  ? Row(
                      children: <Widget>[
                        Checkbox(
                          value: value,
                          activeColor: colors_name.colorPrimary,
                          onChanged: (bool? value) {
                            setState(() {
                              this.value = value!;
                            });
                          },
                        ),
                        const SizedBox(width: 5),
                        const Expanded(
                          child: custom_text(
                            text: 'I hereby accept the above Terms & Conditions of Drona Foundation.',
                            textStyles: primaryTextSemiBold14,
                            leftValue: 0,
                            maxLines: 3,
                          ), //Text
                        )
                      ],
                    )
                  : Container(),
              proceedAllowed
                  ? CustomButton(
                      text: strings_name.str_submit,
                      click: () async {
                        if (value) {
                          Get.off(const AddStudentReferral());
                        } else {
                          Utils.showSnackBar(context, strings_name.str_accept_terms_only);
                        }
                      })
                  : Container(),
            ],
          ),
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
        ),
      ]),
    ));
  }
}
