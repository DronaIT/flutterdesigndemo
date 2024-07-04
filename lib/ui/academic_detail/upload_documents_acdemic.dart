import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';

import '../../api/api_repository.dart';
import '../../api/dio_exception.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_text.dart';
import '../../models/base_api_response.dart';
import '../../models/login_fields_response.dart';
import '../../models/subject_response.dart';
import '../../utils/preference.dart';
import '../../utils/tablenames.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class UploadDocumentsAcademic extends StatefulWidget {
  const UploadDocumentsAcademic({Key? key}) : super(key: key);

  @override
  State<UploadDocumentsAcademic> createState() => _UploadDocumentsAcademicState();
}

class _UploadDocumentsAcademicState extends State<UploadDocumentsAcademic> {
  bool isVisible = false;
  final apiRepository = getIt.get<ApiRepository>();
  LoginFieldsResponse appData = LoginFieldsResponse();

  var titleController = TextEditingController();
  var desController = TextEditingController();
  var cloudinary;

  String docPath = "";
  String docName = "";
  List<BaseApiResponseWithSerializable<SubjectResponse>>? subjectData = [];

  @override
  void initState() {
    super.initState();
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    callSubjectData();
  }

  callSubjectData() async {
    setState(() {
      isVisible = true;
    });
    try {
      //var query = "AND(FIND('${Get.arguments}', ${TableNames.CLM_SPE_ID}, 0),FIND('${semesterValue}',${TableNames.CLM_SEMESTER}, 0))";

      // var data = await apiRepository.getSubjectsApi(query);
      // if (data.records?.isNotEmpty == true) {
      //   data.records?.sort((a, b) => a.fields!.subjectTitle!.toLowerCase().compareTo(b.fields!.subjectTitle!.toLowerCase()));
      //   subjectData = data.records;
      // }
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
            ],
          ),
          floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              backgroundColor: colors_name.colorPrimary,
              onPressed: () {
                uploadDocument();
              },
              child: const Icon(
                Icons.upload,
                color: Colors.white,
              ))),
    );
  }

  Future<void> uploadDocument() async {
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
                              CloudinaryFile.fromFile(docPath, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_ACADEMIC_MATERIAL),
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
      List<Map<String, dynamic>> listData = [];
      // for(int i = 0 ;i <appData.resume!.length ; i++){
      //   Map<String, dynamic> map = Map();
      //   map["url"] = appData.resume?[i].url;
      //   listData.add(map);
      // }
      if (path.isNotEmpty) {
        Map<String, dynamic> map = Map();
        map["url"] = path;
        listData.add(map);
        Map<String, dynamic> query = {"resume": listData};
        var resp = await apiRepository.updateStudentDataApi(query, PreferenceUtils.getLoginRecordId());
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
