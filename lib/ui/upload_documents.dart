import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_edittext.dart';
import '../api/api_repository.dart';
import '../api/dio_exception.dart';
import '../api/service_locator.dart';
import '../customwidget/app_widgets.dart';
import '../customwidget/custom_text.dart';
import '../models/App_data_response.dart';
import '../models/base_api_response.dart';
import '../utils/preference.dart';
import '../utils/tablenames.dart';
import '../utils/utils.dart';
import '../values/text_styles.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({Key? key}) : super(key: key);

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
  bool isVisible = false;
  final createStudentRepository = getIt.get<ApiRepository>();
  List<BaseApiResponseWithSerializable<App_data_response>> appData = [];

  var titleController = TextEditingController();
  var desController = TextEditingController();
  var cloudinary;

  String docPath = "";
  String docName = "";
  var docFileData;
  bool canupload = false, canView = false;

  @override
  void initState() {
    super.initState();
    getPermission();
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    getSampleFile();
  }

  Future<void> getPermission() async {
    setState(() {
      isVisible = true;
    });
    var roleId = "";
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      roleId = TableNames.STUDENT_ROLE_ID;
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      roleId = loginData.roleIdFromRoleIds!.join(',');
    }
    var query = "AND(FIND('${roleId}',role_ids)>0,module_ids='${TableNames.MODULE_UPLOAD_DOCUMENT}')";
    try {
      var data = await createStudentRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPLOAD_DOCUMENTS) {
            setState(() {
              canupload = true;
            });
          }

          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_DOCUMENTS) {
            setState(() {
              canView = true;
            });
          }
        }
      } else {
        Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }

    setState(() {
      isVisible = false;
    });
  }

  Future<void> getSampleFile() async {
    setState(() {
      isVisible = true;
    });
    try {
      var data = await createStudentRepository.getAppData();
      if (data.records != null && data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (PreferenceUtils.getIsLogin() == 2) {
            if (data.records![i].fields!.isForStudent == 0.toString()) {
              appData.add(data.records![i]);
            }
          } else {
            if (data.records![i].fields!.isForStudent == 1.toString()) {
              appData.add(data.records![i]);
            }
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
          appBar: AppWidgets.appBarWithoutBack(strings_name.str_uplaod_doc),
          body: Stack(
            children: [
              Visibility(
                visible: canView,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: appData.isNotEmpty == true
                      ? Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: appData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  elevation: 5,
                                  child: Container(
                                    color: colors_name.colorWhite,
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(child: Text("${appData[index].fields?.title}", textAlign: TextAlign.start, style: blackTextSemiBold16)),
                                        GestureDetector(
                                            onTap: () async {
                                              await launchUrl(
                                                Uri.parse(appData[index].fields!.url!),
                                                mode: LaunchMode.externalApplication
                                              );
                                            },
                                            child: const Icon(Icons.download, size: 30, color: colors_name.colorPrimary))
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container(margin: const EdgeInsets.only(top: 100), child: custom_text(text: strings_name.str_no_data, textStyles: centerTextStyleBlack18, alignment: Alignment.center)),
                ),
              ),
              Center(
                child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
              )
            ],
          ),
          floatingActionButton: Visibility(
            visible: canupload,
            child: FloatingActionButton(
                elevation: 0.0,
                backgroundColor: colors_name.colorPrimary,
                onPressed: () {
                  uplaodDocument();
                },
                child: const Icon(
                  Icons.upload,
                  color: Colors.white,
                )),
          )),
    );
  }

  Future<void> uplaodDocument() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return  StatefulBuilder(builder: (context, StateSetter setState){
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
                      margin: EdgeInsets.only(top: 10, right: 10),
                      alignment: Alignment.topRight,
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  custom_text(
                    text: strings_name.str_title,
                    textStyles: boldTitlePrimaryColorStyle,
                    topValue: 0,
                  ),
                  custom_edittext(
                    hintText: strings_name.str_title,
                    type: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: titleController,
                    maxLines: 1,
                    topValue: 0,
                  ),
                  custom_text(
                    text: strings_name.str_description,
                    textStyles: boldTitlePrimaryColorStyle,
                    topValue: 3,
                  ),
                  custom_edittext(
                    hintText: strings_name.str_description,
                    type: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    controller: desController,
                    maxLines: 3,
                    topValue: 0,
                  ),
                  SizedBox(height: 5),
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
                              FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
                              if (result != null) {
                                // docFileData
                                docName = result.files.single.name;
                                if(kIsWeb){
                                  setState(() {
                                    docPath = result.files.single.bytes.toString();
                                    docFileData = result.files.single;
                                  });
                                }else {
                                  setState(() {
                                    docPath = result.files.single.path!;
                                  });
                                }
                              }
                              // documentfile();
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
                  SizedBox(height: 10),
                  CustomButton(
                      text: strings_name.str_submit,
                      click: () async {
                        if (titleController.text.trim().isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_title_err);
                        } else if (docPath.isEmpty) {
                          Utils.showSnackBar(context, strings_name.str_uplaod_err);
                        } else {
                          var docMainPath = " ";
                          if (docPath.isNotEmpty) {
                            if(kIsWeb) {
                              CloudinaryResponse response = await cloudinary
                                  .uploadFile(
                                CloudinaryFile.fromByteData(
                                    Utils.uint8ListToByteData(docFileData.bytes!),
                                    resourceType: CloudinaryResourceType.Auto,
                                    folder: TableNames.CLOUDARY_FOLDER_APP_ASSETS, identifier: docFileData.name),
                              );
                              docMainPath = response.secureUrl;
                            }else{
                              CloudinaryResponse response = await cloudinary
                                  .uploadFile(
                                CloudinaryFile.fromFile(docPath,
                                    resourceType: CloudinaryResourceType.Auto,
                                    folder: TableNames
                                        .CLOUDARY_FOLDER_APP_ASSETS),
                              );
                              docMainPath = response.secureUrl;
                            }
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
      //isForStudent = "0" - Employee , "1" - student
      Map<String, dynamic> docUplaod = {"title": titleController.text, "url": path, "description": desController.text , "isForStudent" : PreferenceUtils.getIsLogin() ==2 ? "0" : "1"};
      var resp = await createStudentRepository.addAppDataApi(docUplaod);
      if (resp != null) {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_doc_added);
        await Future.delayed(const Duration(milliseconds: 2000));
        Get.back(closeOverlays: true, result: true);
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
}
