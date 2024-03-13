import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/push_notification_service.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/api_repository.dart';
import '../../api/service_locator.dart';
import '../../customwidget/app_widgets.dart';
import '../../customwidget/custom_button.dart';
import '../../customwidget/custom_edittext.dart';
import '../../customwidget/custom_text.dart';
import '../../models/announcement_response.dart' hide Attachment, Fields;
import '../../models/base_api_response.dart';
import '../../models/hub_response.dart';
import '../../models/request/add_announcement_request.dart';
import '../../models/request/update_announcement_request.dart';
import '../../models/selected_module.dart';
import '../../models/specialization_response.dart';
import '../../utils/image_picker_dialog.dart';
import '../../utils/tablenames.dart';
import '../../utils/utils.dart';
import '../../values/text_styles.dart';

class AddAnnouncement extends StatefulWidget {
  final BaseApiResponseWithSerializable<AnnouncementResponse>? announcementData;
  final bool isFromDetailScreen;

  const AddAnnouncement({super.key, this.announcementData, this.isFromDetailScreen = false});

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> with SingleTickerProviderStateMixin {
  bool isLoading = false;
  bool isForEveryOne = false;
  bool isForAllStudent = false;
  bool isForAllEmployee = false;
  bool isForEmployee = false;

  TextEditingController announcementTitleController = TextEditingController();
  TextEditingController announcementDesController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();

  File? _image;

  TabController? tabController;

  List<PlatformFile> attachmentFiles = [];
  List<PlatformFile> files = [];

  BaseApiResponseWithSerializable<HubResponse>? hubResponse;
  String hubValue = "";
  List<BaseApiResponseWithSerializable<HubResponse>>? hubResponseArray = [];

  BaseApiResponseWithSerializable<SpecializationResponse>? speResponse;
  String speValue = "";
  List<BaseApiResponseWithSerializable<SpecializationResponse>>? speResponseArray = [];

  List<String> selectedHubIds = [];
  List<String> selectedSpecializationIds = [];
  List<String> selectedSemesters = [];
  List<String> selectedDivisions = [];

  final apiRepository = getIt.get<ApiRepository>();

  List<SelectedModule> semesterResponseArray = <SelectedModule>[
    SelectedModule(name: '1', isSelected: false),
    SelectedModule(name: '2', isSelected: false),
    SelectedModule(name: '3', isSelected: false),
    SelectedModule(name: '4', isSelected: false),
    SelectedModule(name: '5', isSelected: false),
    SelectedModule(name: '6', isSelected: false)
  ];

  List<SelectedModule> divisionResponseArray = <SelectedModule>[
    SelectedModule(name: TableNames.DIVISION_A, isSelected: false),
    SelectedModule(name: TableNames.DIVISION_B, isSelected: false),
    SelectedModule(name: TableNames.DIVISION_C, isSelected: false),
    SelectedModule(name: TableNames.DIVISION_D, isSelected: false),
  ];

  late CloudinaryPublic cloudinary;

  BaseApiResponseWithSerializable<AnnouncementResponse>? announcementData;

  bool isAnyOneExpanded = false;

  @override
  void initState() {
    init();
    super.initState();
    tabController?.addListener(addTabListener);
  }

  @override
  dispose() {
    tabController?.dispose();
    super.dispose();
  }

  init() {
    hubResponseArray = PreferenceUtils.getHubList().records;
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
    getSpecializations();

    announcementData = widget.announcementData;
    if (announcementData != null) {
      setData();
    }
    tabController = TabController(length: 2, vsync: this, initialIndex: isForEmployee ? 1 : 0);
    cloudinary = CloudinaryPublic(TableNames.CLOUDARY_CLOUD_NAME, TableNames.CLOUDARY_PRESET, cache: false);
  }

  getSpecializations() {
    speResponseArray = PreferenceUtils.getSpecializationList().records;
    for (int i = 0; i < (speResponseArray?.length ?? 0); i++) {
      bool contains = false;
      for (int j = 0; j < (hubResponseArray?.length ?? 0); j++) {
        if (speResponseArray![i].fields!.hubIdFromHubIds?.contains(hubResponseArray![j].fields?.hubId) == true) {
          contains = true;
          break;
        }
      }
      if (!contains) {
        speResponseArray?.removeAt(i);
        i--;
      }
    }
  }

  setData() {
    announcementTitleController.text = announcementData?.fields?.title ?? '';
    announcementDesController.text = announcementData?.fields?.description ?? '';
    var whoFor = announcementData?.fields?.announcementResponseFor;

    if (whoFor == 'everyone') {
      isForEveryOne = true;
    } else if (whoFor == 'employee') {
      isForEmployee = true;
      if ((announcementData?.fields?.isAll ?? false) == true) {
        isForAllEmployee = true;
      } else {
        for (var hub in hubResponseArray ?? []) {
          for (var data in announcementData?.fields?.hubIds ?? []) {
            if (hub.id == data) {
              hub.fields?.selected = true;
            }
          }
        }
        for (var spe in speResponseArray ?? []) {
          for (var data in announcementData?.fields?.specializationIds ?? []) {
            if (spe.id == data) {
              spe.fields?.selected = true;
            }
          }
        }
        for (var sem in semesterResponseArray) {
          for (var data in announcementData?.fields?.semesters ?? []) {
            if (sem.name == data.toString()) {
              sem.isSelected = true;
            }
          }
        }
        for (var div in divisionResponseArray) {
          for (var data in announcementData?.fields?.divisions ?? []) {
            if (div.name == data.toString()) {
              div.isSelected = true;
            }
          }
        }
      }
    } else if (whoFor == 'student') {
      if ((announcementData?.fields?.isAll ?? false) == true) {
        isForAllStudent = true;
      } else {
        for (var hub in hubResponseArray ?? []) {
          for (var data in announcementData?.fields?.hubIds ?? []) {
            if (hub.id == data) {
              hub.fields?.selected = true;
            }
          }
        }
        for (var spe in speResponseArray ?? []) {
          for (var data in announcementData?.fields?.specializationIds ?? []) {
            if (spe.id == data) {
              spe.fields?.selected = true;
            }
          }
        }
        for (var sem in semesterResponseArray) {
          for (var data in announcementData?.fields?.semesters ?? []) {
            if (sem.name == data.toString()) {
              sem.isSelected = true;
            }
          }
        }
        for (var div in divisionResponseArray) {
          for (var data in announcementData?.fields?.divisions ?? []) {
            if (div.name == data.toString()) {
              div.isSelected = true;
            }
          }
        }
      }
    }
    setState(() {});
  }

  addTabListener() {
    setState(() {
      selectedHubIds = [];
      selectedSpecializationIds = [];
      selectedSemesters = [];
      selectedDivisions = [];
      isForAllEmployee = false;
      isForAllStudent = false;
      for (var data in hubResponseArray ?? []) {
        data.fields?.selected = false;
      }
      for (var data in speResponseArray ?? []) {
        data.fields?.selected = false;
      }
      for (var data in semesterResponseArray) {
        data.isSelected = false;
      }
      for (var data in divisionResponseArray) {
        data.isSelected = false;
      }
    });
  }

  _pickAttachment() async {
    if (kIsWeb && false) {
/*
      final List<XFile> tmpFiles = await openFiles();
      if (tmpFiles.isNotEmpty) {
        setState(() {
          files.addAll(tmpFiles);
        });
      }
      debugPrint('../ files ${files[0].path}');
*/
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: true);
      setState(() {
        attachmentFiles.addAll(result?.files ?? []);
      });
    }
  }

  /*
  *   messageType :: 1 => Add, 2 => Update
  */
  fetchTokenDataAndSendPushNotification(int messageType) async {
    String pushMessage = strings_name.str_push_desc_new_announcement;
    if (messageType == 2) {
      pushMessage = strings_name.str_push_desc_update_announcement + announcementTitleController.text.trim();
    }
    if (isForEveryOne) {
      await fetchEmployeeData(pushMessage);
      await fetchStudentData(pushMessage);
    } else if (tabController!.index == 1) {
      await fetchEmployeeData(pushMessage);
    } else if (tabController!.index == 0) {
      await fetchStudentData(pushMessage);
    }
  }

  String offset = "";

  List<BaseApiResponseWithSerializable<ViewEmployeeResponse>>? mainEmployeeData = [];
  List<String> employeesToken = [];

  List<BaseApiResponseWithSerializable<LoginFieldsResponse>>? mainStudentData = [];
  List<String> studentToken = [];

  fetchEmployeeData(String pushMessage) async {
    var query = "AND(FIND(1,is_working,0)";
    if (!isForAllEmployee) {
      int hubSelected = 0;
      for (var data in hubResponseArray!) {
        if (data.fields!.selected) {
          if (hubSelected == 0) {
            query += ",OR(";
            hubSelected++;
          } else {
            query += ",";
          }
          query += "OR(SEARCH('${data.fields?.hubId}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0),SEARCH('${data.fields?.hubId}',ARRAYJOIN({accessible_hub_ids_code}),0))";
        }
      }
      if (hubSelected > 0) {
        query += ")";
      }
    }
    query += ")";
    debugPrint(query);

    try {
      var data = await apiRepository.getEmployeeListApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mainEmployeeData?.clear();
        }
        mainEmployeeData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<ViewEmployeeResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchEmployeeData(pushMessage);
        } else {
          mainEmployeeData?.sort((a, b) {
            var adate = a.fields!.employeeName;
            var bdate = b.fields!.employeeName;
            return adate!.compareTo(bdate!);
          });

          employeesToken.clear();
          for (var j = 0; j < mainEmployeeData!.length; j++) {
            if (mainEmployeeData![j].fields?.token?.trim().isNotEmpty == true) {
              employeesToken.add(mainEmployeeData![j].fields!.token!);
              if (employeesToken.length == 500) {
                PushNotificationService.sendNotificationToMultipleDevices(employeesToken, "", pushMessage);
                employeesToken.clear();
              }
            }
          }

          debugPrint(mainEmployeeData?.length.toString());
          debugPrint(employeesToken.length.toString());
          if (employeesToken.isNotEmpty) {
            PushNotificationService.sendNotificationToMultipleDevices(employeesToken, "", pushMessage);
            employeesToken.clear();
          }
        }
      } else {
        if (offset.isEmpty) {
          employeesToken = [];
          mainEmployeeData = [];
        }
        offset = "";
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  fetchStudentData(String pushMessage) async {
    var query = "";
    if (!isForAllStudent) {
      query += "AND(";
      int hubSelected = 0, speSelected = 0, semSelected = 0;

      for (var data in hubResponseArray!) {
        if (data.fields!.selected) {
          if (hubSelected == 0) {
            query += "OR(";
            hubSelected++;
          } else {
            query += ",";
          }
          query += "SEARCH('${data.fields?.hubId}',ARRAYJOIN({${TableNames.CLM_HUB_IDS_FROM_HUB_ID}}),0)";
        }
      }
      if (hubSelected > 0) {
        query += ")";
      }
      for (var data in speResponseArray!) {
        if (data.fields!.selected) {
          if (hubSelected > 0) {
            query += ",";
          }
          if (speSelected == 0) {
            query += "OR(";
            speSelected++;
          } else {
            query += ",";
          }
          query += "SEARCH('${data.fields?.specializationId}',ARRAYJOIN({${TableNames.CLM_SPE_ID_FROM_SPE_IDS}}),0)";
        }
      }
      if (speSelected > 0) {
        query += ")";
      }
      for (var data in semesterResponseArray) {
        if (data.isSelected) {
          if (hubSelected > 0 || speSelected > 0) {
            query += ",";
          }
          if (semSelected == 0) {
            query += "OR(";
            semSelected++;
          } else {
            query += ",";
          }
          query += "${TableNames.CLM_SEMESTER}='${data.name}'";
        }
      }
      if (semSelected > 0) {
        query += ")";
      }
      query += ")";
    }
    debugPrint(query);

    try {
      var data = await apiRepository.loginApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          mainStudentData?.clear();
        }
        mainStudentData?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<LoginFieldsResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          fetchStudentData(pushMessage);
        } else {
          mainStudentData?.sort((a, b) {
            var adate = a.fields!.name;
            var bdate = b.fields!.name;
            return adate!.compareTo(bdate!);
          });

          studentToken.clear();
          for (var j = 0; j < mainStudentData!.length; j++) {
            if (mainStudentData![j].fields?.token?.trim().isNotEmpty == true) {
              studentToken.add(mainStudentData![j].fields!.token!);
              if (studentToken.length == 500) {
                PushNotificationService.sendNotificationToMultipleDevices(studentToken, "", pushMessage);
                studentToken.clear();
              }
            }
          }

          debugPrint(mainStudentData?.length.toString());
          debugPrint(studentToken.length.toString());
          if (studentToken.isNotEmpty) {
            PushNotificationService.sendNotificationToMultipleDevices(studentToken, "", pushMessage);
            studentToken.clear();
          }
        }
      } else {
        if (offset.isEmpty) {
          mainStudentData = [];
          studentToken = [];
        }
        offset = "";
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  addAnnouncement() async {
    selectedHubIds.clear();
    selectedSpecializationIds.clear();
    selectedSemesters.clear();
    selectedDivisions.clear();
    if (_image == null) {
      Utils.showSnackBar(context, strings_name.str_empty_image);
    } else if (announcementTitleController.text.trim().isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_announcement_title);
    } else if (announcementDesController.text.trim().isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_announcement_desc);
    } else if (isForEveryOne || isForAllStudent || isForAllEmployee) {
      addAnnouncementApiCall();
    } else {
      for (var data in hubResponseArray!) {
        if (data.fields!.selected) {
          selectedHubIds.add(data.id.toString());
        }
      }
      for (var data in speResponseArray!) {
        if (data.fields!.selected) {
          selectedSpecializationIds.add(data.id.toString());
        }
      }
      for (var data in semesterResponseArray) {
        if (data.isSelected) {
          selectedSemesters.add(data.name.toString());
        }
      }
      for (var data in divisionResponseArray) {
        if (data.isSelected) {
          selectedDivisions.add(data.name.toString());
        }
      }
      if (selectedHubIds.isEmpty && selectedSpecializationIds.isEmpty && selectedSemesters.isEmpty && selectedDivisions.isEmpty) {
        Utils.showSnackBar(context, strings_name.str_empty_see_announcement);
      } else {
        addAnnouncementApiCall();
      }
    }
  }

  addAnnouncementApiCall() async {
    setState(() {
      isLoading = true;
    });

    try {
      bool isForStudent = false;
      bool isForAll = isForAllStudent || isForAllEmployee ? true : false;
      if (tabController!.index == 0) {
        isForStudent = true;
      } else {
        isForStudent = false;
      }

      CloudinaryResponse imageCloudinaryResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_image!.path, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_ANNOUNCEMENT),
      );

      List<CloudinaryResponse> attachmentResultCloudinaryResponse = [];
      List<Attachment>? attachmentResultCloudinary = [];

      if (!kIsWeb) {
        if (attachmentFiles.isNotEmpty ?? false) {
          attachmentResultCloudinaryResponse = await cloudinary.uploadFiles([
            for (var data in attachmentFiles)
              // CloudinaryFile.fromFile(data.path ?? '', resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_ANNOUNCEMENT)
              CloudinaryFile.fromFile(data.path ?? '', resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_ANNOUNCEMENT)
          ]);

          for (var data in attachmentResultCloudinaryResponse) {
            attachmentResultCloudinary.add(Attachment(url: data.secureUrl.toString()));
          }
        }
      } else {
        if (files.isNotEmpty ?? false) {
          debugPrint('../ files ${files[0].path}');
          attachmentResultCloudinaryResponse = await cloudinary
              .uploadFiles([for (var data in files) CloudinaryFile.fromFile(data.path ?? '', resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_ANNOUNCEMENT)]);

          for (var data in attachmentResultCloudinaryResponse) {
            attachmentResultCloudinary.add(Attachment(url: data.secureUrl.toString()));
          }
        }
      }
      String createdBy = PreferenceUtils.getLoginRecordId();
      AddAnnouncementRequest addAnnouncementRequest = AddAnnouncementRequest(
        records: [
          Record(
            fields: Fields(
              title: announcementTitleController.text,
              description: announcementDesController.text,
              image: imageCloudinaryResponse.secureUrl,
              fieldsFor: isForEveryOne
                  ? 'everyone'
                  : isForStudent
                      ? 'student'
                      : 'employee',
              isAll: isForAll ? true : false,
              isActive: 1,
              attachments: attachmentResultCloudinary,
              createdBy: [createdBy],
              hubIds: isForAll ? [] : selectedHubIds,
              specializationIds: isForAll ? [] : selectedSpecializationIds,
              semesters: isForAll ? [] : selectedSemesters,
              divisions: isForAll ? [] : selectedDivisions,
            ),
          )
        ],
      );

      var resp = await apiRepository.addAnnouncementDataApi(addAnnouncementRequest.toJson());

      if (resp.records?.isNotEmpty ?? false) {
        await fetchTokenDataAndSendPushNotification(1);
        Get.back(result: 'updateAnnouncement');
        setState(() {
          isLoading = false;
        });
        if (!widget.isFromDetailScreen) {
          Utils.showSnackBar(context, strings_name.str_announcement_added);
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Utils.showSnackBar(context, e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  updateAnnouncement() {
    selectedHubIds.clear();
    selectedSpecializationIds.clear();
    selectedSemesters.clear();
    selectedDivisions.clear();
    if (_image == null && ((announcementData?.fields?.image ?? '') == '')) {
      Utils.showSnackBar(context, strings_name.str_empty_image);
    } else if (announcementTitleController.text.trim().isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_announcement_title);
    } else if (announcementDesController.text.trim().isEmpty) {
      Utils.showSnackBar(context, strings_name.str_empty_announcement_desc);
    } else if (isForEveryOne || isForAllStudent || isForAllEmployee) {
      updateAnnouncementApiCall();
    } else {
      for (var data in hubResponseArray!) {
        if (data.fields!.selected) {
          selectedHubIds.add(data.id.toString());
        }
      }
      for (var data in speResponseArray!) {
        if (data.fields!.selected) {
          selectedSpecializationIds.add(data.id.toString());
        }
      }
      for (var data in semesterResponseArray) {
        if (data.isSelected) {
          selectedSemesters.add(data.name.toString());
        }
      }
      for (var data in divisionResponseArray) {
        if (data.isSelected) {
          selectedDivisions.add(data.name.toString());
        }
      }
      if (selectedHubIds.isEmpty && selectedSpecializationIds.isEmpty && selectedSemesters.isEmpty && selectedDivisions.isEmpty) {
        Utils.showSnackBar(context, strings_name.str_empty_see_announcement);
      } else {
        updateAnnouncementApiCall();
      }
    }
  }

  updateAnnouncementApiCall() async {
    setState(() {
      isLoading = true;
    });
    try {
      bool isForStudent = false;
      bool isForAll = isForAllStudent || isForAllEmployee ? true : false;
      if (tabController!.index == 0) {
        isForStudent = true;
      } else {
        isForStudent = false;
      }

      String image = announcementData?.fields?.image ?? '';
      if (_image?.path != null) {
        CloudinaryResponse imageCloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(_image!.path, resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_ANNOUNCEMENT),
        );
        image = imageCloudinaryResponse.secureUrl;
      }

      List<UpdateAttachment>? attachmentResultCloudinary = [];

      for (var data in announcementData?.fields?.attachments ?? []) {
        attachmentResultCloudinary.add(UpdateAttachment(url: data.url));
      }

      if (!kIsWeb) {
        if (attachmentFiles.isNotEmpty ?? false) {
          List<CloudinaryResponse> attachmentResultCloudinaryResponse = await cloudinary
              .uploadFiles([for (var data in attachmentFiles) CloudinaryFile.fromFile(data.path ?? '', resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_ANNOUNCEMENT)]);
          for (var data in attachmentResultCloudinaryResponse) {
            attachmentResultCloudinary.add(UpdateAttachment(url: data.secureUrl.toString()));
          }
        }
      } else {
        if (files.isNotEmpty ?? false) {
          debugPrint('../ files ${files[0].path}');
          List<CloudinaryResponse> attachmentResultCloudinaryResponse = await cloudinary
              .uploadFiles([for (var data in files) CloudinaryFile.fromFile(data.path ?? '', resourceType: CloudinaryResourceType.Auto, folder: TableNames.CLOUDARY_FOLDER_ANNOUNCEMENT)]);
          for (var data in attachmentResultCloudinaryResponse) {
            attachmentResultCloudinary.add(UpdateAttachment(url: data.secureUrl.toString()));
          }
        }
      }

      String updatedBy = PreferenceUtils.getLoginRecordId();
      UpdateAnnouncementRequest updateAnnouncementRequest = UpdateAnnouncementRequest(records: [
        UpdateRecord(
            id: announcementData?.id ?? '',
            fields: UpdateFields(
              title: announcementTitleController.text,
              description: announcementDesController.text,
              image: image,
              fieldsFor: isForEveryOne
                  ? 'everyone'
                  : isForStudent
                      ? 'student'
                      : 'employee',
              isAll: isForAll ? true : false,
              isActive: 1,
              attachments: attachmentResultCloudinary,
              createdBy: [announcementData?.fields?.createdBy.first ?? ''],
              updatedBy: [updatedBy],
              hubIds: isForAll ? [] : selectedHubIds,
              specializationIds: isForAll ? [] : selectedSpecializationIds,
              semesters: isForAll ? [] : selectedSemesters,
              divisions: isForAll ? [] : selectedDivisions,
              seenByStudents: announcementData?.fields?.seenByStudents ?? [],
              seenByEmployees: announcementData?.fields?.seenByEmployees ?? [],
            ))
      ]);
      var dataUpdate = await apiRepository.updateAnnouncementDataApi(updateAnnouncementRequest.toJson(), announcementData?.id ?? '');
      if (dataUpdate.records?.isNotEmpty ?? false) {
        await fetchTokenDataAndSendPushNotification(2);
        setState(() {
          isLoading = false;
        });
        Get.back(result: 'updateAnnouncement');
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  formReset() {
    setState(() {
      announcementTitleController.clear();
      announcementDesController.clear();
      _image = null;
      attachmentFiles.clear();
      isForEveryOne = false;
      isForAllStudent = false;
      isForAllEmployee = false;
      for (var data in hubResponseArray!) {
        data.fields?.selected = false;
      }
      for (var data in speResponseArray!) {
        data.fields?.selected = false;
      }
      for (var data in semesterResponseArray) {
        data.isSelected = false;
      }
      for (var data in divisionResponseArray) {
        data.isSelected = false;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppWidgets.appBarWithoutBack(widget.announcementData != null ? strings_name.edit_announcements : strings_name.add_announcements),
          floatingActionButton: isLoading
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: CircularProgressIndicator(
                    color: colors_name.colorPrimary,
                  ),
                )
              : CustomButton(
                  click: () async {
                    if (widget.announcementData != null) {
                      updateAnnouncement();
                    } else {
                      addAnnouncement();
                    }
                  },
                  text: widget.announcementData != null ? strings_name.update_announcements : strings_name.add_announcements,
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            children: [
              SizedBox(height: 15.h),
              _image != null
                  ? GestureDetector(
                      onTap: () {
                        ImagePickerDialog().openDialog(context, (file) async {
                          if (file != null) {
                            setState(() {
                              _image = file;
                            });
                          }
                        });
                      },
                      child: Container(
                        height: 100.h,
                        width: 1.sw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.w),
                          image: DecorationImage(
                              image: FileImage(
                                File(_image!.path),
                              ),
                              fit: BoxFit.cover,
                              opacity: 0.5),
                          color: Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            const Text(
                              strings_name.change_image,
                              style: whiteText16,
                            )
                          ],
                        ),
                      ),
                    )
                  : announcementData?.fields?.image != null
                      ? GestureDetector(
                          onTap: () {
                            ImagePickerDialog().openDialog(context, (file) async {
                              if (file != null) {
                                setState(() {
                                  _image = file;
                                });
                              }
                            });
                          },
                          child: Container(
                            height: 100.h,
                            width: 1.sw,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.w),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    widget.announcementData?.fields?.image ?? '',
                                  ),
                                  fit: BoxFit.cover,
                                  opacity: 0.5),
                              color: Colors.black,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                const Text(
                                  strings_name.change_image,
                                  style: whiteText16,
                                )
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            ImagePickerDialog().openDialog(context, (file) async {
                              if (file != null) {
                                setState(() {
                                  _image = file;
                                });
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            decoration: BoxDecoration(border: Border.all(color: colors_name.textColorGreyLight), borderRadius: BorderRadius.circular(15.w)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.image_outlined),
                                SizedBox(
                                  width: 5.w,
                                ),
                                const Text(strings_name.add_image)
                              ],
                            ),
                          ),
                        ),
              SizedBox(height: 24.h),
              custom_text(
                margin: EdgeInsets.zero,
                text: strings_name.announcement_title_asterisk,
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
              ),
              SizedBox(height: 10.h),
              custom_edittext(
                margin: EdgeInsets.zero,
                type: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                controller: announcementTitleController,
                // hintText: strings_name.announcement_title_asterisk,
              ),
              SizedBox(height: 20.h),
              custom_text(
                margin: EdgeInsets.zero,
                text: strings_name.announcement_des_asterisk,
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
              ),
              SizedBox(height: 10.h),
              custom_edittext(
                margin: EdgeInsets.zero,
                type: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                controller: announcementDesController,
                maxLines: 5,
                minLines: 4,
                maxLength: 5000,
              ),
              SizedBox(height: 20.h),
              custom_text(
                margin: EdgeInsets.zero,
                text: strings_name.announcement_end_date,
                alignment: Alignment.topLeft,
                textStyles: blackTextSemiBold16,
              ),
              SizedBox(height: 10.h),
              InkWell(
                child: IgnorePointer(
                  child: custom_edittext(
                    margin: EdgeInsets.zero,
                    hintText: strings_name.select_end_date,
                    type: TextInputType.none,
                    textInputAction: TextInputAction.next,
                    controller: deadlineController,
                    topValue: 0,
                  ),
                ),
                onTap: () {
                  DateTime dateSelected = DateTime.now();
                  TimeOfDay timeSelected = TimeOfDay.now();
                  if (deadlineController.text.isNotEmpty) {
                    dateSelected = DateFormat("yyyy-MM-dd").parse(deadlineController.text);
                    DateTime time = DateFormat("hh:mm aa").parse(deadlineController.text);
                    timeSelected = TimeOfDay.fromDateTime(time);
                  }
                  showDatePicker(context: context, initialDate: dateSelected, firstDate: DateTime.now(), lastDate: DateTime(2100))
                      .then((pickedDate) {
                    if (pickedDate == null) {
                      return;
                    }
                    setState(() {
                      showTimePicker(context: context, initialTime: timeSelected).then((pickedTime) {
                        if (pickedTime == null) {
                          return;
                        }
                        setState(() {
                          var dateTime = pickedDate;
                          var formatter = DateFormat('yyyy-MM-dd hh:mm aa');
                          var time = DateTime(dateTime.year, dateTime.month, dateTime.day, pickedTime.hour, pickedTime.minute);
                          deadlineController.text = formatter.format(time);
                        });
                      });
                    });
                  });
                },
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  _pickAttachment();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  decoration: BoxDecoration(border: Border.all(color: colors_name.textColorGreyLight), borderRadius: BorderRadius.circular(15.w)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.file_open_outlined),
                      SizedBox(
                        width: 5.w,
                      ),
                      const Text(strings_name.attach_files)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: announcementData?.fields?.attachments?.length ?? 0,
                itemBuilder: (context, index) {
                  var data = announcementData?.fields?.attachments?[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.0.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: custom_text(
                            margin: EdgeInsets.zero,
                            text: data?.filename ?? '',
                            alignment: Alignment.topLeft,
                            textStyles: blackTextSemiBold14,
                            maxLines: 1,
                            topValue: 0,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await launchUrl(Uri.parse(data?.url ?? ''), mode: LaunchMode.externalApplication);
                          },
                          child: const Icon(Icons.download, color: colors_name.colorPrimary),
                        )
                      ],
                    ),
                  );
                },
              ),
              Visibility(
                visible: !kIsWeb,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: attachmentFiles.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = attachmentFiles[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.0.h),
                        child: custom_text(
                          margin: EdgeInsets.zero,
                          text: data.name ?? '',
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold14,
                          maxLines: 1,
                          topValue: 0,
                        ),
                      );
                    }),
              ),
              Visibility(
                visible: kIsWeb,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: files.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var data = files[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.0.h),
                        child: custom_text(
                          margin: EdgeInsets.zero,
                          text: data.name ?? '',
                          alignment: Alignment.topLeft,
                          textStyles: blackTextSemiBold14,
                          maxLines: 1,
                          topValue: 0,
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 20.h,
              ),
              custom_text(text: strings_name.who_can_see, textStyles: greyDarkTextStyle12, topValue: 5, maxLines: 1000, bottomValue: 5, leftValue: 5), //Text
              Row(
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: isForEveryOne,
                    onChanged: (bool? value) {
                      setState(() {
                        isForEveryOne = value!;
                      });
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isForEveryOne = !isForEveryOne;
                      });
                    },
                    child: custom_text(text: strings_name.everyone, textStyles: blackTextSemiBold14, topValue: 5, maxLines: 1000, bottomValue: 5, leftValue: 5),
                  ), //Text
                ],
              ),
              Visibility(
                  visible: isForEveryOne,
                  child: SizedBox(
                    height: 70.h,
                  )),
              Visibility(
                visible: !isForEveryOne,
                child: TabBar(
                  controller: tabController,
                  labelStyle: blackTextBold14,
                  labelColor: colors_name.colorBlack,
                  unselectedLabelColor: colors_name.lightGreyColor,
                  indicatorColor: colors_name.colorPrimary,
                  tabs: const [
                    Tab(
                      text: strings_name.str_students,
                    ),
                    Tab(
                      text: strings_name.str_employee,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !isForEveryOne,
                child: SizedBox(
                  height: isAnyOneExpanded ? 550.h : 350.h,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      studentTab(),
                      employeesTab(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget employeesTab() {
    return Column(
      children: [
        SizedBox(height: 5.h),
        Row(
          children: <Widget>[
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: isForAllEmployee,
              onChanged: (bool? value) {
                setState(() {
                  isForAllEmployee = value!;
                });
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isForAllEmployee = !isForAllEmployee;
                });
              },
              child: custom_text(text: strings_name.all_employee, textStyles: blackTextSemiBold14, topValue: 5, maxLines: 1000, bottomValue: 5, leftValue: 5),
            ), //Text
          ],
        ),
        Visibility(
          visible: !isForAllEmployee,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h),
            child: ExpansionTileGroup(
              onExpansionItemChanged: (int index, bool isOpen) {},
              spaceBetweenItem: 10,
              toggleType: ToggleType.expandOnlyCurrent,
              children: [
                customExpansionTileItem(
                  title: strings_name.campus,
                  widget: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: hubResponseArray?.length ?? 0,
                      itemBuilder: (context, index) {
                        var data = hubResponseArray![index];
                        return CustomCheckListTile(
                          title: data.fields?.hubName ?? "",
                          onChanged: (bool? value) {
                            setState(() {
                              data.fields?.selected = value!;
                            });
                          },
                          isSelected: data.fields!.selected,
                        );
                      }),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget studentTab() {
    return Column(
      children: [
        SizedBox(height: 5.h),
        Row(
          children: <Widget>[
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: isForAllStudent,
              onChanged: (bool? value) {
                setState(() {
                  isForAllStudent = value!;
                });
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isForAllStudent = !isForAllStudent;
                });
              },
              child: custom_text(text: strings_name.all_students, textStyles: blackTextSemiBold14, topValue: 5, maxLines: 1000, bottomValue: 5, leftValue: 5),
            ), //Text
          ],
        ),
        SizedBox(height: 5.h),
        Visibility(
          visible: !isForAllStudent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h),
            child: ExpansionTileGroup(
              spaceBetweenItem: 10,
              toggleType: ToggleType.expandOnlyCurrent,
              children: [
                customExpansionTileItem(
                  title: strings_name.campus,
                  widget: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: hubResponseArray?.length ?? 0,
                      itemBuilder: (context, index) {
                        var data = hubResponseArray![index];
                        return CustomCheckListTile(
                          title: data.fields?.hubName ?? "",
                          onChanged: (bool? value) {
                            setState(() {
                              data.fields?.selected = value!;
                            });
                          },
                          isSelected: data.fields!.selected,
                        );
                      }),
                ),
                customExpansionTileItem(
                  title: strings_name.str_specializations,
                  widget: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: speResponseArray?.length ?? 0,
                      itemBuilder: (context, index) {
                        var data = speResponseArray![index];
                        return CustomCheckListTile(
                          title: data.fields?.specializationName ?? '',
                          onChanged: (bool? value) {
                            setState(() {
                              data.fields?.selected = value!;
                            });
                          },
                          isSelected: data.fields!.selected,
                        );
                      }),
                ),
                customExpansionTileItem(
                    title: strings_name.str_semester,
                    widget: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: semesterResponseArray.length,
                        itemBuilder: (context, index) {
                          var data = semesterResponseArray[index];
                          return CustomCheckListTile(
                            title: 'Semester ${data.name.toString()}',
                            onChanged: (bool? value) {
                              setState(() {
                                data.isSelected = value!;
                              });
                            },
                            isSelected: data.isSelected,
                          );
                        })),
                customExpansionTileItem(
                    title: strings_name.str_class,
                    listHeight: 160.h,
                    widget: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: divisionResponseArray.length,
                        itemBuilder: (context, index) {
                          var data = divisionResponseArray[index];
                          return CustomCheckListTile(
                            title: data.name.toString(),
                            onChanged: (bool? value) {
                              setState(() {
                                data.isSelected = value!;
                              });
                            },
                            isSelected: data.isSelected,
                          );
                        })),
              ],
            ),
          ),
        )
      ],
    );
  }

  ExpansionTileItem customExpansionTileItem({required String title, required Widget widget, double? listHeight}) {
    return ExpansionTileItem(
      childrenPadding: EdgeInsets.zero,
      onExpansionChanged: (bool isExpanded) {
        setState(() {
          isAnyOneExpanded = isExpanded;
        });
      },
      decoration: BoxDecoration(
        border: Border.all(
          color: colors_name.darkGrayColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(title),
      children: [
        SizedBox(
          height: listHeight ?? 200.h,
          child: widget,
        )
      ],
    );
  }
}

class CustomCheckListTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final void Function(bool?)? onChanged;

  const CustomCheckListTile({super.key, required this.title, required this.onChanged, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(visualDensity: VisualDensity.compact, value: isSelected, onChanged: onChanged),
        Expanded(
            child: GestureDetector(
          onTap: () {
            onChanged?.call(!isSelected);
          },
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )),
      ],
    );
  }
}
