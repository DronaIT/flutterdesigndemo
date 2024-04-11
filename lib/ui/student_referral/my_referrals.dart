import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_pageIndicator.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/app_version_response.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/student_referral_response.dart';
import 'package:flutterdesigndemo/ui/student_referral/referral_terms.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class MyReferrals extends StatefulWidget {
  const MyReferrals({super.key});

  @override
  State<MyReferrals> createState() => _MyReferralsState();
}

class _MyReferralsState extends State<MyReferrals> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();

  String offset = "";
  List<BaseApiResponseWithSerializable<StudentReferralResponse>>? mainList = [];

  PageController pageController = PageController();
  int currentPageValue = 0;
  Timer? _timer;

  List<BaseApiResponseWithSerializable<AppVersionResponse>> announcement = [];
  var sliderHeight = 1.5.sw - 20;

  @override
  void initState() {
    super.initState();
    fetchSlider();
    getRecords();
  }

  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (currentPageValue < announcement.length) {
        currentPageValue += 1;
      } else {
        currentPageValue = 0;
      }
      pageController.animateToPage(
        currentPageValue.toInt(),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  fetchSlider() async {
    try {
      setState(() {
        isVisible = true;
      });
      var appVersionResponse = await apiRepository.getAppVersions();
      if (appVersionResponse.records?.isNotEmpty == true) {
        for (int i = appVersionResponse.records!.length - 1; i >= 0; i--) {
          if (appVersionResponse.records![i].fields?.type == "Referral Slider") {
            announcement.add(appVersionResponse.records![i]);
          }
        }
      }
      setState(() {
        isVisible = false;
      });
      if (_timer == null) {
        _startTimer();
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  getRecords() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });
    var query = "AND(student_mobile_number='${PreferenceUtils.getLoginData().mobileNumber}')";

    try {
      var data = await apiRepository.getStudentReferralDataApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mainList?.clear();
        }
        mainList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<StudentReferralResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          mainList?.sort((a, b) {
            var adate = a.fields!.created_on;
            var bdate = b.fields!.created_on;
            return bdate!.compareTo(adate!);
          });
          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            mainList = [];
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
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_student_referral),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: sliderHeight,
                  child: PageView.builder(
                      controller: pageController,
                      scrollDirection: Axis.horizontal,
                      itemCount: announcement.length,
                      onPageChanged: (int page) {
                        currentPageValue = page;
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            if (announcement[index].fields?.is_clickable == "1") {
                              await Get.to(const ReferralTerms(), arguments: false);
                            }
                          },
                          child: SizedBox(
                            height: sliderHeight,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Image.network(announcement[index].fields?.image_to_display ?? '',
                                      width: 1.sw,
                                      height: sliderHeight,
                                      fit: BoxFit.fill,
                                      errorBuilder: (context, url, error) => const Center(child: Icon(Icons.error))),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: colors_name.colorBlack.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: CustomPageIndicatorScrolling(
                  totalItems: announcement.length,
                  controller: pageController,
                ),
              ),
              Visibility(
                visible: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: custom_text(
                        text: strings_name.str_student_referral_tnc_agreed,
                        textStyles: primaryTextSemiBold15,
                        maxLines: 3,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.error_outline_sharp, color: colors_name.colorPrimary),
                      label: const Text("View", style: primaryTextSemiBold15),
                      onPressed: () async {
                        Get.to(const ReferralTerms(), arguments: false);
                      },
                    ),
                  ],
                ),
              ),
              mainList?.isNotEmpty == true
                  ? Card(
                      elevation: 2,
                      child: Container(
                        color: colors_name.lightGrayColor,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${strings_name.str_my_referrals}(${mainList?.length ?? 0})", textAlign: TextAlign.center, style: blackTextSemiBold16),
                            const Icon(Icons.keyboard_arrow_down, size: 30, color: colors_name.colorPrimary)
                          ],
                        ),
                      ),
                    )
                  : Container(),
              mainList?.isNotEmpty == true
                  ? ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: mainList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Column(children: [
                            Container(
                              color: colors_name.colorWhite,
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              child: Column(
                                children: [
                                  custom_text(
                                    text: "Referral Name: ${mainList![index].fields?.name}",
                                    maxLines: 2,
                                    bottomValue: 0,
                                    textStyles: primaryTextSemiBold14,
                                  ),
                                  custom_text(
                                    text: "Email: ${mainList![index].fields?.email}",
                                    maxLines: 2,
                                    topValue: 5,
                                    bottomValue: 0,
                                    textStyles: blackTextSemiBold14,
                                  ),
                                  custom_text(
                                    text: "Mobile: ${mainList![index].fields?.mobile_number}",
                                    maxLines: 2,
                                    topValue: 5,
                                    bottomValue: 0,
                                    textStyles: blackTextSemiBold14,
                                  ),
                                  custom_text(
                                    text: "State : ${mainList![index].fields?.state}",
                                    topValue: 5,
                                    bottomValue: 0,
                                    textStyles: blackTextSemiBold14,
                                  ),
                                  custom_text(
                                    text: "City : ${mainList![index].fields?.city}",
                                    topValue: 5,
                                    bottomValue: 0,
                                    textStyles: blackTextSemiBold14,
                                  ),
                                  custom_text(
                                    text: "Added on : ${formatDate(mainList![index].fields?.created_on ?? "")}",
                                    topValue: 5,
                                    bottomValue: 0,
                                    textStyles: primaryTextSemiBold14,
                                  ),
                                  custom_text(
                                    text: "Status : ${mainList![index].fields?.status}",
                                    topValue: 5,
                                    bottomValue: 0,
                                    textStyles: primaryTextSemiBold14,
                                  ),
                                  mainList![index].fields?.status_updated_name?.isNotEmpty == true
                                      ? custom_text(
                                          text: "Status Updated By: ${mainList![index].fields?.status_updated_name?.last}",
                                          topValue: 5,
                                          bottomValue: 0,
                                          textStyles: primaryTextSemiBold14,
                                        )
                                      : Container(),
                                  mainList![index].fields?.remarks?.trim().isNotEmpty == true
                                      ? custom_text(
                                          text: "Remarks : ${mainList![index].fields?.status}",
                                          topValue: 5,
                                          textStyles: blackTextSemiBold14,
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 0), color: colors_name.lightGreyColor, padding: const EdgeInsets.all(0.5)),
                          ]),
                        );
                      })
                  : custom_text(text: strings_name.str_no_referrals, textStyles: centerTextStyleBlack18, alignment: Alignment.center, topValue: 30),
            ]),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: colors_name.colorPrimary,
          onPressed: () {
            Get.to(const ReferralTerms(), arguments: true)?.then((value) {
              if (value != null && value) {
                mainList?.clear();
                getRecords();
              }
            });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    ));
  }

  String formatDate(String date){
    var createdDateTime = DateTime.parse(date.trim()).toLocal();
    return DateFormat("yyyy-MM-dd hh:mm aa").format(createdDateTime);
  }
}
