import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/request/add_hub_request.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class AddHub extends StatefulWidget {
  const AddHub({Key? key}) : super(key: key);

  @override
  State<AddHub> createState() => _AddHubState();
}

class _AddHubState extends State<AddHub> {
  TextEditingController hubController = TextEditingController();
  bool isVisible = false;
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];
  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  final apiRepository = getIt.get<ApiRepository>();

  @override
  void initState() {
    super.initState();
    speResponseArray = PreferenceUtils.getSpecializationList().records;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_add_hub),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 10.h),
                custom_text(
                  text: strings_name.str_hub_name,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: hubController,
                  topValue: 5,
                ),
                SizedBox(height: 3.h),
                custom_text(
                  text: strings_name.str_address,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  topValue: 5,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: addressController,
                  topValue: 2,
                ),
                SizedBox(height: 3.h),
                custom_text(
                  text: strings_name.str_city,
                  alignment: Alignment.topLeft,
                  textStyles: blackTextSemiBold16,
                  topValue: 5,
                ),
                custom_edittext(
                  type: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: cityController,
                  topValue: 2,
                ),
                // SizedBox(height: 3.h),
                // custom_text(
                //   text: strings_name.str_select_spelization,
                //   alignment: Alignment.topLeft,
                //   textStyles: blackTextSemiBold16,
                // ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Flexible(
                //       fit: FlexFit.loose,
                //       child: Container(
                //         margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                //         width: MediaQuery.of(context).size.width,
                //         child: DropdownButtonFormField<BaseApiResponseWithSerializable<SpecializationResponse>>(
                //           value: speResponse,
                //           elevation: 16,
                //           style: blackText16,
                //           focusColor: colors_name.colorPrimary,
                //           onChanged: (BaseApiResponseWithSerializable<SpecializationResponse>? newValue) {
                //             setState(() {
                //               speValue = newValue!.fields!.specializationId.toString();
                //               speResponse = newValue;
                //             });
                //           },
                //           items: speResponseArray?.map<DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>>((BaseApiResponseWithSerializable<SpecializationResponse> value) {
                //             return DropdownMenuItem<BaseApiResponseWithSerializable<SpecializationResponse>>(
                //               value: value,
                //               child: Text(value.fields!.specializationName.toString()),
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 20.h),
                CustomButton(
                    text: strings_name.str_submit,
                    click: () {
                      if (hubController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_hubname);
                      } else if (addressController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_address);
                      } else if (cityController.text.trim().isEmpty) {
                        Utils.showSnackBar(context, strings_name.str_empty_city);
                      } else {

                        addRecord();
                      }
                    })
              ],
            ),
            Center(
              child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addRecord() async {
    setState(() {
      isVisible = true;
    });
    AddHubRequest request = AddHubRequest();
    request.hub_name = hubController.text.toString();
    request.city = cityController.text.toString();
    request.address = addressController.text.toString();
    var resp = await apiRepository.addHubApi(request);
    if (resp.id!.isNotEmpty) {
      setState(() {
        isVisible = false;
      });
      Utils.showSnackBar(context, strings_name.str_hub_added);
      await Future.delayed(const Duration(milliseconds: 2000));
      Get.back(closeOverlays: true,result: true);
    } else {
      setState(() {
        isVisible = false;
      });
    }
  }
}
