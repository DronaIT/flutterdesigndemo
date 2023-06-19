import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_text.dart';
import '../../models/App_data_response.dart';
import '../../models/base_api_response.dart';
import '../../models/login_fields_response.dart';
import '../../utils/preference.dart';
import '../../utils/tablenames.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class UploadDocumentsPlacement extends StatefulWidget {
  const UploadDocumentsPlacement({Key? key}) : super(key: key);

  @override
  State<UploadDocumentsPlacement> createState() => _UploadDocumentsPlacementState();
}

class _UploadDocumentsPlacementState extends State<UploadDocumentsPlacement> {
  bool isVisible = false;
  final createStudentRepository = getIt.get<ApiRepository>();
 LoginFieldsResponse appData = LoginFieldsResponse();

  var titleController = TextEditingController();
  var desController = TextEditingController();
  var cloudinary;

  String docPath = "";
  String docName = "";

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    getSampleFile();
  }

  Future<void> getSampleFile() async {
    setState(() {
      isVisible = true;
    });
    try {
      var query = "(${TableNames.TB_USERS_PHONE}='${PreferenceUtils.getLoginData().mobileNumber}')";
      var data = await createStudentRepository.registerApi(query);
      if(data != null){
        appData = data.records!.first.fields!;
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
          appBar: AppWidgets.appBarWithoutBack(strings_name.str_uplaod_resume),
          body: Stack(
            children: [
              Center(
                child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: appData.resume?.isNotEmpty == true
                    ? Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: appData.resume?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 5,
                                child: Container(
                                  color: colors_name.colorWhite,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text("${appData.resume?[index].filename}", textAlign: TextAlign.start, style: blackTextSemiBold16)),
                                      GestureDetector(
                                          onTap: () async {
                                           await launchUrl(Uri.parse(appData.resume![index].url!), mode: LaunchMode.externalApplication);
                                          },
                                          child: const Icon(Icons.download, size: 30, color: colors_name.colorPrimary))
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              backgroundColor: colors_name.colorPrimary,
              onPressed: () {
                uplaodDocument();
              },
              child: const Icon(
                Icons.upload,
                color: Colors.white,
              ))),
    );
  }

  Future<void> uplaodDocument() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, right: 10),
                      alignment: Alignment.topRight,
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  custom_text(
                    text: strings_name.str_uplaod_resume,
                    textStyles: boldTitlePrimaryColorStyle,
                    topValue: 0,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      custom_text(
                        text: strings_name.str_document,
                        leftValue: 10,
                        alignment: Alignment.topLeft,
                        textStyles: blackTextSemiBold16,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Row(children: [
                          GestureDetector(
                            child: const Icon(Icons.upload_file_rounded, size: 30, color: Colors.black),
                            onTap: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);
                              if (result != null) {
                                setState(() {
                                  docPath = result.files.single.path!;
                                  docName = result.files.single.name;
                                });
                              }
                            },
                          ),
                          custom_text(
                            text: strings_name.str_upload_file,
                            textStyles: blackTextSemiBold14,
                            leftValue: 5,
                          ),
                        ]),
                      ),
                    ],
                  ),
                  custom_text(
                    text: docName,
                    alignment: Alignment.topLeft,
                    textStyles: blackTextSemiBold14,
                    maxLines: 1,
                    topValue: 0,
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                      text: strings_name.str_submit,
                      click: () async {
                        if (docPath.isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_uplaod_err);
                        } else {
                          var docMainPath = " ";
                          if (docPath.isNotEmpty) {
                            CloudinaryResponse response = await cloudinary.uploadFile(
                              CloudinaryFile.fromFile(docPath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_STUDENT_RESUME),
                            );
                            docMainPath = response.secureUrl;
                          }
                          addRecord(docMainPath);
                          Get.back();
                        }
                      })
                ],
              ),
            );
          });
        });
  }

  Future<void> addRecord(String path) async {
    setState(() {
      isVisible = true;
    });
    try {
      if (path.isNotEmpty) {
        Map<String, dynamic> map = Map();
        map["url"] = path;
        List<Map<String, dynamic>> listData = [];
        listData.add(map);
        Map<String, dynamic> query = {"resume": listData};
        print("etstst=>${query}=>${PreferenceUtils.getLoginRecordId()}");
        var resp = await createStudentRepository.addToken(query, PreferenceUtils.getLoginRecordId());
        if (resp != null) {
          setState(() {
            isVisible = false;
          });
          Utils.showSnackBar(context, strings_name.str_resume_added);
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
}
