import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/announcements_card.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_pageIndicator.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/app_version_response.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/request/student_referral_request.dart';
import 'package:flutterdesigndemo/models/student_referral_response.dart';
import 'package:flutterdesigndemo/ui/student_referral/referral_terms.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class StudentReferrals extends StatefulWidget {
  const StudentReferrals({super.key});

  @override
  State<StudentReferrals> createState() => _StudentReferralsState();
}

class _StudentReferralsState extends State<StudentReferrals> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();

  String offset = "";
  List<BaseApiResponseWithSerializable<StudentReferralResponse>>? mainList = [];
  List<BaseApiResponseWithSerializable<StudentReferralResponse>>? dataList = [];

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];
  var controllerSearch = TextEditingController();

  TextEditingController rejectionReasonController = TextEditingController();

  PageController pageController = PageController();
  int currentPageValue = 0;
  Timer? _timer;

  List<BaseApiResponseWithSerializable<AppVersionResponse>> announcement = [];
  var sliderHeight = 280.h;

  @override
  void initState() {
    super.initState();
    initData();
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

  initData() async {
    hubResponseArray = PreferenceUtils.getHubList().records;
    for (int i = 0; i < hubResponseArray!.length; i++) {
      if (hubResponseArray![i].fields?.hubId == TableNames.CANCELLED_HUB_ID) {
        hubResponseArray?.removeAt(i);
        i--;
      } else if (hubResponseArray![i].fields?.hubId == TableNames.SUSPENDED_HUB_ID) {
        hubResponseArray?.removeAt(i);
        i--;
      }
    }

    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      if ((loginData.accessible_hub_ids?.length ?? 0) > 0) {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          var isAccessible = false;
          for (var j = 0; j < loginData.accessible_hub_ids!.length; j++) {
            if (loginData.accessible_hub_ids![j] == hubResponseArray![i].id) {
              isAccessible = true;
              break;
            }
            if (loginData.hubIdFromHubIds?.first == hubResponseArray![i].fields?.hubId) {
              isAccessible = true;
              break;
            }
          }
          if (!isAccessible) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      } else {
        for (var i = 0; i < hubResponseArray!.length; i++) {
          if (loginData.hubIdFromHubIds?.first != hubResponseArray![i].fields?.hubId) {
            hubResponseArray?.removeAt(i);
            i--;
          }
        }
      }
    }
    if (hubResponseArray != null) {
      hubResponse = hubResponseArray?.first;
      hubValue = hubResponseArray!.first.fields!.id!.toString();
      setState(() {});
    }

    // await fetchSlider();
    await getRecords();
  }

  getRecords() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });
    try {
      var query = "AND(SEARCH('${hubResponse?.fields?.hubId}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0))";

      var data = await apiRepository.getStudentReferralDataApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          dataList?.clear();
          mainList?.clear();
        }
        dataList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<StudentReferralResponse>>);
        mainList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<StudentReferralResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          dataList?.sort((a, b) {
            var adate = a.fields!.created_on;
            var bdate = b.fields!.created_on;
            return bdate!.compareTo(adate!);
          });
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
            dataList = [];
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_student_referral),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              Visibility(
                visible: false,
                child: Padding(
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
              ),
              Visibility(
                visible: false,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: CustomPageIndicatorScrolling(
                    totalItems: announcement.length,
                    controller: pageController,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              const custom_text(
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
                      hubValue = newValue!.fields!.id!.toString();
                      hubResponse = newValue;
                      getRecords();
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
              SizedBox(height: 4.h),
              Visibility(
                visible: mainList != null && mainList!.isNotEmpty,
                child: CustomEditTextSearch(
                  type: TextInputType.text,
                  hintText: "Search by name...",
                  textInputAction: TextInputAction.done,
                  controller: controllerSearch,
                  onChanges: (value) {
                    if (value.isEmpty) {
                      dataList = [];
                      dataList = mainList;
                      setState(() {});
                    } else {
                      dataList = [];
                      for (var i = 0; i < mainList!.length; i++) {
                        if (mainList![i].fields!.name!.toLowerCase().contains(value.toLowerCase())) {
                          dataList?.add(mainList![i]);
                        }
                      }
                      setState(() {});
                    }
                  },
                ),
              ),
              dataList?.isNotEmpty == true
                  ? ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: dataList!.length,
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
                                    text: "Name: ${dataList![index].fields?.name}",
                                    maxLines: 2,
                                    bottomValue: 0,
                                    textStyles: primaryTextSemiBold14,
                                  ),
                                  custom_text(
                                    text: "Email: ${dataList![index].fields?.email}",
                                    maxLines: 2,
                                    topValue: 5,
                                    bottomValue: 0,
                                    textStyles: blackTextSemiBold14,
                                  ),
                                  Row(
                                    children: [
                                      const custom_text(
                                        text: "Mobile: ",
                                        alignment: Alignment.topLeft,
                                        textStyles: blackTextSemiBold14,
                                        topValue: 5,
                                        bottomValue: 0,
                                        rightValue: 0,
                                      ),
                                      GestureDetector(
                                        child: custom_text(
                                          text: "+91${dataList![index].fields?.mobile_number}",
                                          maxLines: 2,
                                          topValue: 5,
                                          leftValue: 5,
                                          bottomValue: 0,
                                          textStyles: linkTextSemiBold14,
                                        ),
                                        onTap: () {
                                          _launchCaller("+91${dataList![index].fields?.mobile_number}");
                                        },
                                      ),
                                    ],
                                  ),
                                  custom_text(
                                    text: "State : ${dataList![index].fields?.state}",
                                    topValue: 5,
                                    bottomValue: 0,
                                    textStyles: blackTextSemiBold14,
                                  ),
                                  custom_text(
                                    text: "City : ${dataList![index].fields?.city}",
                                    topValue: 5,
                                    bottomValue: 0,
                                    textStyles: blackTextSemiBold14,
                                  ),
                                  dataList![index].fields?.student_name?.isNotEmpty == true
                                      ? custom_text(
                                          text: "Referred By: ${dataList![index].fields?.student_name?.last}",
                                          bottomValue: 0,
                                          textStyles: primaryTextSemiBold14,
                                        )
                                      : Container(),
                                  custom_text(
                                    text: "Added on : ${formatDate(dataList![index].fields?.created_on ?? "")}",
                                    topValue: 5,
                                    bottomValue: 0,
                                    textStyles: primaryTextSemiBold14,
                                  ),
                                  custom_text(
                                    text: "Status : ${dataList![index].fields?.status}",
                                    topValue: 5,
                                    textStyles: primaryTextSemiBold14,
                                  ),
                                  dataList![index].fields?.status_updated_name?.isNotEmpty == true
                                      ? custom_text(
                                          text: "Status Updated By: ${dataList![index].fields?.status_updated_name?.last}",
                                          bottomValue: 0,
                                          textStyles: primaryTextSemiBold14,
                                        )
                                      : Container(),
                                  dataList![index].fields?.remarks?.trim().isNotEmpty == true
                                      ? custom_text(
                                          text: "Remarks : ${dataList![index].fields?.remarks}",
                                          topValue: 5,
                                          textStyles: blackTextSemiBold14,
                                        )
                                      : Container(),
                                  dataList![index].fields?.status == strings_name.str_referral_status_pending
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(right: 10),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  approveDialog(dataList![index]);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: colors_name.presentColor,
                                                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  elevation: 5.0,
                                                ),
                                                child: const Text(
                                                  strings_name.str_approve,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(right: 10),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  rejectionDialog(dataList?[index]);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: colors_name.errorColor,
                                                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  elevation: 5.0,
                                                ),
                                                child: const Text(
                                                  strings_name.str_reject,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 0), color: colors_name.lightGreyColor, padding: const EdgeInsets.all(0.5)),
                          ]),
                        );
                      })
                  : custom_text(text: strings_name.str_no_referrals_hub, textStyles: centerTextStyleBlack18, alignment: Alignment.center, topValue: 30),
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
    ));
  }

  _launchCaller(String mobile) async {
    try {
      await launchUrl(Uri.parse("tel:$mobile"), mode: LaunchMode.externalApplication);
    } catch (e) {
      Utils.showSnackBarUsingGet(strings_name.str_invalid_mobile);
    }
  }

  Future<void> rejectionDialog(BaseApiResponseWithSerializable<StudentReferralResponse>? referralData) async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          custom_text(
            text: 'Name: ${referralData?.fields?.name}',
            textStyles: primaryTextSemiBold15,
            maxLines: 3,
            bottomValue: 0,
          ),
          custom_text(
            text: 'Mobile No.: ${referralData?.fields?.mobile_number}',
            textStyles: blackTextSemiBold14,
            bottomValue: 0,
            maxLines: 3,
          ),
          custom_text(
            text: 'Referred By: ${referralData?.fields?.student_name?.last}',
            textStyles: blackTextSemiBold14,
            maxLines: 3,
          ),
          const custom_text(
            text: strings_name.str_provide_rejection_reason,
            textStyles: primaryTextSemiBold16,
            maxLines: 2,
          ),
          custom_edittext(
            type: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            controller: rejectionReasonController,
            minLines: 3,
            maxLines: 3,
            maxLength: 50000,
            topValue: 0,
          ),
          Row(
            children: [
              SizedBox(width: 5.h),
              Expanded(
                  child: CustomButton(
                      text: strings_name.str_reject,
                      click: () {
                        if (rejectionReasonController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_rejection_reason);
                        } else {
                          Get.back(closeOverlays: true);
                          updateStatus(referralData, false);
                        }
                      })),
              SizedBox(width: 10.h),
              Expanded(
                  child: CustomButton(
                      text: strings_name.str_cancle,
                      click: () {
                        Get.back(closeOverlays: true);
                      })),
              SizedBox(width: 5.h),
            ],
          )
        ],
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  Future<void> approveDialog(BaseApiResponseWithSerializable<StudentReferralResponse>? referralData) async {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          custom_text(
            text: 'Name: ${referralData?.fields?.name}',
            textStyles: primaryTextSemiBold15,
            maxLines: 3,
            bottomValue: 0,
          ),
          custom_text(
            text: 'Mobile No.: ${referralData?.fields?.mobile_number}',
            textStyles: blackTextSemiBold14,
            bottomValue: 0,
            maxLines: 3,
          ),
          custom_text(
            text: 'Referred By: ${referralData?.fields?.student_name?.last}',
            textStyles: blackTextSemiBold14,
            maxLines: 3,
          ),
          const custom_text(
            text: 'Are you sure you want to approve this referral?',
            textStyles: primaryTextSemiBold15,
            maxLines: 3,
          ),
          Row(
            children: [
              SizedBox(width: 5.h),
              Expanded(
                  child: CustomButton(
                      text: strings_name.str_yes,
                      click: () {
                        Get.back(closeOverlays: true);
                        updateStatus(referralData, true);
                      })),
              SizedBox(width: 10.h),
              Expanded(
                  child: CustomButton(
                      text: strings_name.str_cancle,
                      click: () {
                        Get.back(closeOverlays: true);
                      })),
              SizedBox(width: 5.h),
            ],
          )
        ],
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => errorDialog);
  }

  void updateStatus(BaseApiResponseWithSerializable<StudentReferralResponse>? jobData, bool isApproved) async {
    setState(() {
      isVisible = true;
    });

    StudentReferralRequest request = StudentReferralRequest();
    request.status_updated_by = PreferenceUtils.getLoginRecordId().split(",");
    if (isApproved) {
      request.status = strings_name.str_referral_status_approved;
      request.remarks = "";
    } else {
      request.status = strings_name.str_referral_status_rejected;
      request.remarks = rejectionReasonController.text.trim().toString();
    }

    var json = request.toJson();
    json.removeWhere((key, value) => value == null);
    try {
      var resp = await apiRepository.updateStudentReferralStatusApi(json, jobData!.id.toString());
      if (resp.id != null) {
        getRecords();

        Utils.showSnackBar(context, strings_name.str_referral_updated);
        await Future.delayed(const Duration(milliseconds: 2000));
      } else {
        setState(() {
          isVisible = false;
        });
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  String formatDate(String date) {
    var createdDateTime = DateTime.parse(date.trim()).toLocal();
    return DateFormat("yyyy-MM-dd hh:mm aa").format(createdDateTime);
  }
}
