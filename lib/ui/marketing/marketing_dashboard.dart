import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext_search.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/marketing_response.dart';
import 'package:flutterdesigndemo/ui/marketing/add_marketing_record.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MarketingDashboard extends StatefulWidget {
  const MarketingDashboard({super.key});

  @override
  State<MarketingDashboard> createState() => _MarketingDashboardState();
}

class _MarketingDashboardState extends State<MarketingDashboard> {
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false, toggleMyList = true, toggleOtherList = true;

  bool canViewOthers = false, canAdd = false;
  var isLogin = 0;
  var loginId = "";

  var controllerSearch = TextEditingController();
  String offset = "";

  List<BaseApiResponseWithSerializable<MarketingResponse>>? mainList = [];
  List<BaseApiResponseWithSerializable<MarketingResponse>>? displayList = [];

  List<BaseApiResponseWithSerializable<MarketingResponse>>? myList = [];
  List<BaseApiResponseWithSerializable<MarketingResponse>>? othersList = [];

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  Future<void> getPermission() async {
    setState(() {
      isVisible = true;
    });
    var roleId = "";
    isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      roleId = TableNames.STUDENT_ROLE_ID;
      loginId = PreferenceUtils.getLoginData().studentId.toString();
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      roleId = loginData.roleIdFromRoleIds!.join(',');
      loginId = loginData.employeeId.toString();
    } else if (isLogin == 3) {
      roleId = TableNames.ORGANIZATION_ROLE_ID;
      loginId = PreferenceUtils.getLoginDataOrganization().id.toString();
    }

    var query = "AND(FIND('$roleId',role_ids)>0,module_ids='${TableNames.MODULE_MARKETING}')";
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_OTHERS_MARKETING_RECORD) {
            canViewOthers = true;
          } else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_ADD_MARKETING_RECORD) {
            canAdd = true;
          }
        }
      } else {
        setState(() {
          isVisible = false;
        });
        // Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    } finally {
      getRecords();
    }
  }

  getRecords() async {
    setState(() {
      if (!isVisible) isVisible = true;
    });
    var query = "";

    if (canViewOthers && isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      query = "OR(SEARCH('${loginData.hubIdFromHubIds?.last}', ARRAYJOIN(${TableNames.CLM_EMPLOYEE_HUB_ID}))";
      if (loginData.accessible_hub_ids_code?.isNotEmpty == true) {
        for (int i = 0; i < loginData.accessible_hub_ids_code!.length; i++) {
          query += ",SEARCH('${loginData.accessible_hub_ids_code![i]}', ARRAYJOIN(${TableNames.CLM_EMPLOYEE_HUB_ID}))";
        }
      }
      query += ")";
    } else {
      query = "AND(${TableNames.CLM_DETAILS_ADDED_BY}=$loginId)";
    }
    debugPrint(query);

    try {
      var data = await apiRepository.getMarketingRecordsApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mainList?.clear();
        }
        mainList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<MarketingResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          displayList = [];
          displayList = List.from(mainList!);

          if (canViewOthers && isLogin == 2) {
            differentiateData();
          } else {
            myList = [];
            myList = List.from(displayList!);
          }
          setState(() {
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            displayList = [];
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

  differentiateData() {
    myList?.clear();
    othersList?.clear();

    displayList?.sort((a, b) {
      var adate = a.fields!.entryDate;
      var bdate = b.fields!.entryDate;
      return bdate!.compareTo(adate!);
    });

    if (displayList?.isNotEmpty == true) {
      for (int i = 0; i < displayList!.length; i++) {
        if (displayList![i].fields!.detailsAddedBy?.contains(PreferenceUtils.getLoginRecordId()) == true) {
          myList?.add(displayList![i]);
        } else {
          othersList?.add(displayList![i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_marketing_records),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 5.h),
              CustomEditTextSearch(
                type: TextInputType.text,
                hintText: "Search by employee name..",
                textInputAction: TextInputAction.done,
                controller: controllerSearch,
                onChanges: (value) {
                  if (value.isEmpty) {
                    displayList = [];
                    displayList = List.from(mainList!);
                  } else {
                    displayList = [];
                    for (var i = 0; i < mainList!.length; i++) {
                      if (mainList![i].fields!.employeeName?.isNotEmpty == true) {
                        for (var j = 0; j < mainList![i].fields!.employeeName!.length; j++) {
                          if (mainList![i].fields!.employeeName![j].toLowerCase().contains(value.toLowerCase())) {
                            displayList?.add(mainList![i]);
                          }
                        }
                      }
                    }
                  }
                  differentiateData();
                  setState(() {});
                },
              ),
              SizedBox(height: 5.h),
              GestureDetector(
                child: Card(
                  elevation: 5,
                  child: Container(
                    color: colors_name.lightGrayColor,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${strings_name.str_my_records}(${myList?.length ?? 0})", textAlign: TextAlign.center, style: blackTextSemiBold16),
                        Icon(toggleMyList ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  if (myList?.isNotEmpty == true) {
                    toggleMyList = !toggleMyList;
                    setState(() {});
                  }
                },
              ),
              myList?.isNotEmpty == true
                  ? Visibility(
                      visible: toggleMyList,
                      child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: myList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_city}: ",
                                      textStyles: primaryTextSemiBold14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 10,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: myList![index].fields?.city ?? "",
                                      textStyles: blackTextSemiBold14,
                                      maxLines: 2,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 10,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_number_of_approach}: ",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: "${myList![index].fields?.numberOfApproach ?? 0}",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_number_of_meeting}: ",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: "${myList![index].fields?.numberOfMeetings ?? 0}",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_number_of_seminars_arranged}: ",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: "${myList![index].fields?.numberOfSeminarArranged ?? 0}",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_number_of_seminars_completed}: ",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: "${myList![index].fields?.numberOfSeminarsCompleted ?? 0}",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_created_on} ",
                                      textStyles: primaryTextSemiBold14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: DateFormat("yyyy-MM-dd hh:mm aa")
                                          .format(DateTime.parse(myList![index].fields?.entryDate?.trim() ?? "").toLocal()),
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Visibility(
                                  visible: myList![index].fields?.remarks?.isNotEmpty == true,
                                  child: Row(
                                    children: [
                                      custom_text(
                                        text: "${strings_name.str_remarks}: ",
                                        textStyles: primaryTextSemiBold14,
                                        bottomValue: 0,
                                        rightValue: 0,
                                        topValue: 0,
                                        maxLines: 2,
                                      ),
                                      custom_text(
                                        text: myList![index].fields?.remarks ?? "",
                                        textStyles: blackText14,
                                        bottomValue: 0,
                                        leftValue: 0,
                                        topValue: 0,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(const AddMarketingRecord(), arguments: [
                                      {"fields": myList?[index].fields},
                                      {"recordId": myList?[index].id}
                                    ])?.then((value) {
                                      if (value != null && value) {
                                        displayList?.clear();
                                        myList?.clear();
                                        othersList?.clear();

                                        getRecords();
                                      }
                                    });
                                  },
                                  child: custom_text(
                                    text: "${strings_name.str_update_details}",
                                    textStyles: primaryTextSemiBold16,
                                    alignment: Alignment.topRight,
                                    bottomValue: 0,
                                    rightValue: 10,
                                    topValue: 0,
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                index + 1 < myList!.length
                                    ? Container(
                                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        color: colors_name.lightGreyColor,
                                        padding: const EdgeInsets.all(0.5))
                                    : Container(),
                              ],
                            );
                          }),
                    )
                  : custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
              SizedBox(height: 5.h),
              GestureDetector(
                child: Card(
                  elevation: 5,
                  child: Container(
                    color: colors_name.lightGrayColor,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${strings_name.str_added_by_subordinates}(${othersList?.length ?? 0})",
                            textAlign: TextAlign.center, style: blackTextSemiBold16),
                        Icon(toggleOtherList ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 30, color: colors_name.colorPrimary)
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  if (othersList?.isNotEmpty == true) {
                    toggleOtherList = !toggleOtherList;
                    setState(() {});
                  }
                },
              ),
              othersList?.isNotEmpty == true
                  ? Visibility(
                      visible: toggleOtherList,
                      child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: othersList!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_added_by}: ",
                                      textStyles: primaryTextSemiBold14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 10,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: othersList![index].fields?.employeeName?.last ?? "",
                                      textStyles: blackTextSemiBold14,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 10,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_city}: ",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: othersList![index].fields?.city ?? "",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_number_of_approach}: ",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: "${othersList![index].fields?.numberOfApproach ?? 0}",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_number_of_meeting}: ",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: "${othersList![index].fields?.numberOfMeetings ?? 0}",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_number_of_seminars_arranged}: ",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: "${othersList![index].fields?.numberOfSeminarArranged ?? 0}",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_number_of_seminars_completed}: ",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: "${othersList![index].fields?.numberOfSeminarsCompleted ?? 0}",
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  children: [
                                    custom_text(
                                      text: "${strings_name.str_created_on} ",
                                      textStyles: primaryTextSemiBold14,
                                      bottomValue: 0,
                                      rightValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                    custom_text(
                                      text: DateFormat("yyyy-MM-dd hh:mm aa")
                                          .format(DateTime.parse(othersList![index].fields?.entryDate?.trim() ?? "").toLocal()),
                                      textStyles: blackText14,
                                      bottomValue: 0,
                                      leftValue: 0,
                                      topValue: 0,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Visibility(
                                  visible: othersList![index].fields?.remarks?.isNotEmpty == true,
                                  child: Row(
                                    children: [
                                      custom_text(
                                        text: "${strings_name.str_remarks}: ",
                                        textStyles: primaryTextSemiBold14,
                                        bottomValue: 0,
                                        rightValue: 0,
                                        topValue: 0,
                                        maxLines: 2,
                                      ),
                                      custom_text(
                                        text: othersList![index].fields?.remarks ?? "",
                                        textStyles: blackText14,
                                        bottomValue: 0,
                                        leftValue: 0,
                                        topValue: 0,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                index + 1 < othersList!.length
                                    ? Container(
                                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        color: colors_name.lightGreyColor,
                                        padding: const EdgeInsets.all(0.5))
                                    : Container(),
                              ],
                            );
                          }),
                    )
                  : custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center),
            ]),
          ),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          backgroundColor: colors_name.colorPrimary,
          onPressed: () {
            Get.to(const AddMarketingRecord())?.then((value) {
              if (value != null && value) {
                displayList?.clear();
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
}
