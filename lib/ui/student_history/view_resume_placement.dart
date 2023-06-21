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

class ViewResumePlacement extends StatefulWidget {
  const ViewResumePlacement({Key? key}) : super(key: key);

  @override
  State<ViewResumePlacement> createState() => _ViewResumePlacementState();
}

class _ViewResumePlacementState extends State<ViewResumePlacement> {
  bool isVisible = false;
  // final createStudentRepository = getIt.get<ApiRepository>();
  // LoginFieldsResponse appData = LoginFieldsResponse();

  var titleController = TextEditingController();
  var desController = TextEditingController();
  var cloudinary;

  String docPath = "";
  String docName = "";
  LoginFieldsResponse? appData;

  @override
  void initState() {
    super.initState();
    appData = Get.arguments;
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
    //getSampleFile();
  }

  // Future<void> getSampleFile() async {
  //   setState(() {
  //     isVisible = true;
  //   });
  //   try {
  //     var query = "(${TableNames.TB_USERS_PHONE}='${PreferenceUtils.getLoginData().mobileNumber}')";
  //     var data = await createStudentRepository.registerApi(query);
  //     if (data != null) {
  //       appData = data.records!.first.fields!;
  //     }
  //     setState(() {
  //       isVisible = false;
  //     });
  //   } on DioError catch (e) {
  //     setState(() {
  //       isVisible = false;
  //     });
  //     final errorMessage = DioExceptions.fromDioError(e).toString();
  //     Utils.showSnackBarUsingGet(errorMessage);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_view_resume),
        body: Stack(
          children: [
            Center(
              child: Visibility(visible: isVisible, child: const CircularProgressIndicator(strokeWidth: 5.0, color: colors_name.colorPrimary)),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: appData?.resume?.isNotEmpty == true
                  ? Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: appData?.resume?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 5,
                              child: Container(
                                color: colors_name.colorWhite,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text("${appData?.resume?[index].filename}", textAlign: TextAlign.start, style: blackTextSemiBold16)),
                                    GestureDetector(
                                        onTap: () async {
                                          await launchUrl(Uri.parse(appData!.resume![index].url!), mode: LaunchMode.externalApplication);
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
      ),
    );
  }
}
