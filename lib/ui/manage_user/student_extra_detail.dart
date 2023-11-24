import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_edittext.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StudentExtraDetail extends StatefulWidget {
  const StudentExtraDetail({super.key});

  @override
  State<StudentExtraDetail> createState() => _StudentExtraDetailState();
}

class _StudentExtraDetailState extends State<StudentExtraDetail> {
  bool canUpdateProfilePic = false;
  bool canUpdateDetails = false;
  bool isVisible = false;
  String helpPath = "", helpTitle = "";
  late PlatformFile helpAttechmentData;

  TextEditingController birthdateController = TextEditingController();
  TextEditingController fathernameController = TextEditingController();

  String formattedDate = "";
  var cloudinary;
  final apiRepository = getIt.get<ApiRepository>();

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    checkCurrentData();
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      var loginData = PreferenceUtils.getLoginData();
      canUpdateProfilePic = loginData.profile_pic?.isEmpty ?? true;
      canUpdateDetails = (loginData.father_full_name?.isEmpty ?? true) || (loginData.birthdate?.isEmpty ?? true);

      if (loginData.birthdate?.isNotEmpty == true) {
        formattedDate = loginData.birthdate ?? "";
      }
      if (loginData.father_full_name?.isNotEmpty == true) {
        fathernameController.text = loginData.father_full_name ?? "";
      }
    }
  }

  void checkCurrentData() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    var viewWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppWidgets.appBarWithoutBack(strings_name.str_update_details),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: canUpdateProfilePic || canUpdateDetails
                  ? Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(children: [
                        custom_text(
                          text: strings_name.str_nsdc_changes_warning,
                          alignment: Alignment.topLeft,
                          maxLines: 10,
                          textStyles: primaryTextSemiBold14,
                          leftValue: 10,
                        ),
                        canUpdateProfilePic
                            ? Column(children: [
                                SizedBox(height: 5.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    custom_text(
                                      text: strings_name.str_profile_pic,
                                      alignment: Alignment.topLeft,
                                      textStyles: blackTextSemiBold16,
                                      leftValue: 10,
                                    ),
                                    GestureDetector(
                                      child: Container(margin: const EdgeInsets.only(right: 10), child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black)),
                                      onTap: () {
                                        picLOIFile();
                                      },
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: helpPath.isNotEmpty,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 3.h),
                                      custom_text(text: helpTitle, alignment: Alignment.topLeft, textStyles: grayTextstyle, topValue: 0, bottomValue: 0),
                                    ],
                                  ),
                                ),
                              ])
                            : Container(),
                        canUpdateDetails
                            ? Column(
                                children: [
                                  SizedBox(height: 5.h),
                                  custom_text(
                                    text: strings_name.str_birthday,
                                    alignment: Alignment.topLeft,
                                    textStyles: blackTextSemiBold16,
                                    topValue: 5,
                                  ),
                                  InkWell(
                                    child: IgnorePointer(
                                      child: custom_edittext(
                                        type: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        controller: birthdateController,
                                        maxLength: 10,
                                        topValue: 2,
                                      ),
                                    ),
                                    onTap: () {
                                      showDatePicker(context: context, initialDate: DateTime.parse(formattedDate), firstDate: DateTime(1950), lastDate: DateTime.now()).then((pickedDate) {
                                        if (pickedDate == null) {
                                          return;
                                        }
                                        setState(() {
                                          var formatter = DateFormat('yyyy-MM-dd');
                                          formattedDate = formatter.format(pickedDate);
                                          birthdateController.text = formattedDate;
                                        });
                                      });
                                    },
                                  ),
                                  SizedBox(height: 3.h),
                                  custom_text(
                                    text: strings_name.str_father_name,
                                    alignment: Alignment.topLeft,
                                    textStyles: blackTextSemiBold16,
                                    topValue: 5,
                                  ),
                                  custom_edittext(
                                    type: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    controller: fathernameController,
                                    maxLength: 1000,
                                    topValue: 2,
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(height: 50.h),
                        CustomButton(
                          text: strings_name.str_submit,
                          click: () async {
                            if (canUpdateProfilePic && helpPath.isEmpty) {
                              Utils.showSnackBar(context, strings_name.str_empty_profile_pic);
                            } else if (canUpdateDetails && birthdateController.text.trim().toString().isEmpty) {
                              Utils.showSnackBar(context, strings_name.str_empty_brithdate);
                            } else if (canUpdateDetails && fathernameController.text.trim().toString().isEmpty) {
                              Utils.showSnackBar(context, strings_name.str_empty_father_name);
                            } else {
                              uploadData();
                            }
                          },
                        ),
                      ]),
                    )
                  : Container(margin: const EdgeInsets.only(top: 10), child: custom_text(text: strings_name.str_details_updated, textStyles: centerTextStyleBlack18, alignment: Alignment.center))),
          Center(
            child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
          )
        ],
      ),
    ));
  }

  picLOIFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        helpTitle = result.files.single.name;
        if (kIsWeb) {
          helpPath = result.files.single.bytes.toString();
          helpAttechmentData = result.files.single;
        } else {
          helpPath = result.files.single.path!;
        }
      });
    }
  }

  Future<void> uploadData() async {
    setState(() {
      isVisible = true;
    });

    var path = "";
    if (helpPath.isNotEmpty) {
      if (!kIsWeb) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(helpPath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_PROFILE_PIC),
        );
        path = response.secureUrl;
      } else {
        try {
          CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromByteData(uint8ListToByteData(helpAttechmentData.bytes!), resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_PROFILE_PIC, identifier: helpAttechmentData.name.toString()),
          );
          path = response.secureUrl;
        } catch (e) {
          debugPrint('../ error helpPath $e');
        }
      }
    }

    try {
      List<Map<String, dynamic>> listData = [];
      if (path.isNotEmpty) {
        Map<String, dynamic> map = Map();
        map["url"] = path;
        listData.add(map);
        Map<String, dynamic> query = {"profile_pic": listData};
        query.addIf(birthdateController.text.trim().isNotEmpty, "birthdate", birthdateController.text.trim());
        query.addIf(fathernameController.text.trim().isNotEmpty, "father_full_name", fathernameController.text.trim());

        var resp = await apiRepository.updateStudentDataApi(query, PreferenceUtils.getLoginRecordId());
        if (resp != null) {
          setState(() {
            isVisible = false;
          });
          await PreferenceUtils.setLoginData(resp.fields!);
          Utils.showSnackBar(context, strings_name.str_update_details_successfully);
          await Future.delayed(const Duration(milliseconds: 2000));
          Get.back(closeOverlays: true, result: true);
        } else {
          setState(() {
            isVisible = false;
          });
        }
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  ByteData uint8ListToByteData(Uint8List uint8List) {
    final buffer = uint8List.buffer;
    return ByteData.view(buffer);
  }
}
