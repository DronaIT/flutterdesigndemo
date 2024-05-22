import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/dio_client.dart';
import 'package:flutterdesigndemo/models/App_data_response.dart';
import 'package:flutterdesigndemo/models/add_timetable_model.dart';
import 'package:flutterdesigndemo/models/app_version_response.dart';
import 'package:flutterdesigndemo/models/ask_evaluation_response.dart';
import 'package:flutterdesigndemo/models/ask_level_response.dart';
import 'package:flutterdesigndemo/models/ask_parameter_response.dart';
import 'package:flutterdesigndemo/models/fees_response.dart';
import 'package:flutterdesigndemo/models/helpdesk_responses.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/models/marketing_response.dart';
import 'package:flutterdesigndemo/models/marks_response.dart';
import 'package:flutterdesigndemo/models/permission_response.dart';
import 'package:flutterdesigndemo/models/punch_data_response.dart';
import 'package:flutterdesigndemo/models/request/add_placement_attendance_data.dart';
import 'package:flutterdesigndemo/models/request/add_placement_attendance_response.dart';
import 'package:flutterdesigndemo/models/request/add_placement_marks_request.dart';
import 'package:flutterdesigndemo/models/request/add_punch_request.dart';
import 'package:flutterdesigndemo/models/request/add_student_attendance_request.dart';
import 'package:flutterdesigndemo/models/request/add_employee_request.dart';
import 'package:flutterdesigndemo/models/login_employee_response.dart';
import 'package:flutterdesigndemo/models/request/add_hub_request.dart';
import 'package:flutterdesigndemo/models/request/add_specialization_request.dart';
import 'package:flutterdesigndemo/models/request/add_subject_request.dart';
import 'package:flutterdesigndemo/models/request/add_topics_request.dart';
import 'package:flutterdesigndemo/models/request/add_units_request.dart';
import 'package:flutterdesigndemo/models/request/ask_parameter_request.dart';
import 'package:flutterdesigndemo/models/request/create_job_opportunity_request.dart';
import 'package:flutterdesigndemo/models/request/create_student_request.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/request/evaluation_request.dart';
import 'package:flutterdesigndemo/models/request/fees_request.dart';
import 'package:flutterdesigndemo/models/request/marketing_request.dart';
import 'package:flutterdesigndemo/models/request/student_referral_request.dart';
import 'package:flutterdesigndemo/models/role_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/createpassword.dart';
import 'package:flutterdesigndemo/models/createpasswordemployee.dart';

import 'package:flutterdesigndemo/models/home_module_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/student_attendance_response.dart';
import 'package:flutterdesigndemo/models/student_referral_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/models/typeofsectoreresponse.dart';
import 'package:flutterdesigndemo/models/units_response.dart';
import 'package:flutterdesigndemo/models/update_job_opportunity.dart';
import 'package:flutterdesigndemo/models/update_specialization.dart';
import 'package:flutterdesigndemo/models/update_student_attendance.dart';
import 'package:flutterdesigndemo/models/update_subject.dart';
import 'package:flutterdesigndemo/models/update_topics.dart';
import 'package:flutterdesigndemo/models/update_units.dart';
import 'package:flutterdesigndemo/models/updatehub.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/ui/ask/ask_evaluation.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';

import '../models/add_announcement_response.dart';
import '../models/add_time_table_response.dart';
import '../models/announcement_response.dart';
import '../models/company_approch_response.dart';
import '../models/company_detail_response.dart';
import '../models/help_desk_response.dart';
import '../models/help_desk_type_response.dart';
import '../models/request/add_time_table_response.dart';
import '../models/request/create_company_appr_req.dart';
import '../models/request/create_company_det_req.dart';
import '../models/request/help_desk_req.dart';

class ApiRequest {
  final DioClient dioClient;

  ApiRequest({required this.dioClient});

  Future<BaseLoginResponse<LoginFieldsResponse>> studentListApi(String loginFormula, [String offset = ""]) async {
    try {
      Map<String, String> someMap = {"filterByFormula": loginFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get("${TableNames.TBL_STUDENT}/listRecords", queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<LoginFieldsResponse>.fromJson(response.data, (response) => LoginFieldsResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<LoginFieldsResponse>> loginRegisterApi(String loginFormula, [String offset = ""]) async {
    try {
      Map<String, String> someMap = {"filterByFormula": loginFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_STUDENT, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<LoginFieldsResponse>.fromJson(response.data, (response) => LoginFieldsResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponse<AnnouncementResponse>> fetchAnnouncementApi(String formula, [String offset = ""]) async {
    try {
      Map<dynamic, dynamic> someMap = {
        "filterByFormula": formula,
        "sort": [
          {'field': 'id', 'direction': 'desc'}
        ],
        if (offset.isNotEmpty) "offset": offset
      };
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post('${TableNames.TBL_ANNOUNCEMENT}/listRecords', data: jsonEncode(someMap), options: Options(headers: header));
      return BaseResponse<AnnouncementResponse>.fromJson(response.data, (response) => AnnouncementResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponse<TimeTableResponseClass>> fetchTimeTablesApi(String formula, [String offset = "", int? pageSize]) async {
    try {
      // Map<dynamic, dynamic> someMap = {"filterByFormula": formula,"sort": [{'field': 'id', 'direction': 'asc'}], if (offset.isNotEmpty) "offset": offset,if (pageSize!=null) "pageSize": pageSize};
      Map<dynamic, dynamic> someMap = {
        "filterByFormula": formula,
        "sort": [
          {'field': 'date', 'direction': 'asc'}
        ],
        if (offset.isNotEmpty) "offset": offset,
        if (pageSize != null) "pageSize": pageSize
      };
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post('${TableNames.TBL_TIMETABLE}/listRecords', data: jsonEncode(someMap), options: Options(headers: header));
      return BaseResponse<TimeTableResponseClass>.fromJson(response.data, (response) => TimeTableResponseClass.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<LoginEmployeeResponse>> loginRegisterEmployeeApi(String loginFormula) async {
    try {
      Map<String, String> someMap = {
        "filterByFormula": loginFormula,
      };
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.get(TableNames.TBL_EMPLOYEE, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<LoginEmployeeResponse>.fromJson(response.data, (response) => LoginEmployeeResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<CreatePasswordResponse> createPasswordApi(Map<String, String> loginFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": loginFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_STUDENT}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return CreatePasswordResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<CreatePasswordEmployeeResponse> createPasswordEmployeeApi(Map<String, String> loginFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {
        "fields": loginFormula,
      };
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_EMPLOYEE}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return CreatePasswordEmployeeResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<homeModuleResponse>> getHomeModulesApi(String homeModuleFormula) async {
    try {
      Map<String, String> someMap = {"filterByFormula": homeModuleFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_MODULE, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<homeModuleResponse>.fromJson(response.data, (response) => homeModuleResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<CreatePasswordResponse>> createStudentApi(List<Map<String, CreateStudentRequest>> createStudentFormula) async {
    try {
      Map<String, dynamic> someMap = {"records": createStudentFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.post(TableNames.TBL_STUDENT, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseLoginResponse<CreatePasswordResponse>.fromJson(response.data, (response) => CreatePasswordResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyApproachResponse>> createCompanyApproachApi(List<Map<String, CreateCompanyApproveRequest>> createCompanyFormula) async {
    try {
      Map<String, dynamic> someMap = {"records": createCompanyFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.post(TableNames.TBL_COMPANY_APPROACH, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseLoginResponse<CompanyApproachResponse>.fromJson(response.data, (response) => CompanyApproachResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyDetailResponse>> createCompanyDetailApi(List<Map<String, CreateCompanyDetailRequest>> createCompanydFormula) async {
    try {
      Map<String, dynamic> someMap = {"records": createCompanydFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.post(TableNames.TBL_COMPANY_DETAIL, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseLoginResponse<CompanyDetailResponse>.fromJson(response.data, (response) => CompanyDetailResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<CreatePasswordResponse> updateStudentApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      // Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_STUDENT}/$recordId", options: Options(headers: header), data: jsonEncode(updateFormula));
      return CreatePasswordResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<RoleResponse>> getRolesApi() async {
    try {
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_ROLE, options: Options(headers: header));
      return BaseLoginResponse<RoleResponse>.fromJson(response.data, (response) => RoleResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<HubResponse>> getHubApi() async {
    try {
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_HUB, options: Options(headers: header));
      return BaseLoginResponse<HubResponse>.fromJson(response.data, (response) => HubResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyApproachResponse>> getCompanyApproachApi(String updateFormula, [String offset = ""]) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": updateFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_COMPANY_APPROACH, options: Options(headers: header), queryParameters: someMap);
      return BaseLoginResponse<CompanyApproachResponse>.fromJson(response.data, (response) => CompanyApproachResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyDetailResponse>> getCompanyDetailApi(String updateFormula, [String offset = ""]) async {
    try {
      Map<String, String> someMap = {"filterByFormula": updateFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_COMPANY_DETAIL, options: Options(headers: header), queryParameters: someMap);
      return BaseLoginResponse<CompanyDetailResponse>.fromJson(response.data, (response) => CompanyDetailResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<TypeOfSectorResponse>> getSectorsApi() async {
    try {
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_SECTOR, options: Options(headers: header));
      return BaseLoginResponse<TypeOfSectorResponse>.fromJson(response.data, (response) => TypeOfSectorResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<SpecializationResponse>> getSpecializationApi() async {
    try {
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_SPECIALIZATION, options: Options(headers: header));
      return BaseLoginResponse<SpecializationResponse>.fromJson(response.data, (response) => SpecializationResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<LoginEmployeeResponse>> addEmployeeApi(AddEmployeeRequest addEmployeeFormula) async {
    try {
      Map<String, dynamic> someMap = {"fields": addEmployeeFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.post(TableNames.TBL_EMPLOYEE, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<LoginEmployeeResponse>.fromJson(response.data, (response) => LoginEmployeeResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<PermissionResponse>> getPermissionsApi(String permissionFormula) async {
    try {
      Map<String, String> someMap = {"filterByFormula": permissionFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_PERMISSION, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<PermissionResponse>.fromJson(response.data, (response) => PermissionResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<ViewEmployeeResponse>> viewEmployeeApi(String viewEmpFormula) async {
    try {
      Map<String, String> someMap = {"filterByFormula": viewEmpFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_EMPLOYEE, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<ViewEmployeeResponse>.fromJson(response.data, (response) => ViewEmployeeResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<CreatePasswordEmployeeResponse> updateEmployeeApi(Map<String, dynamic> loginFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": loginFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_EMPLOYEE}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return CreatePasswordEmployeeResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<SpecializationResponse>> getSpecializationDetailApi(String detailFormula) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": detailFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_SPECIALIZATION, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<SpecializationResponse>.fromJson(response.data, (response) => SpecializationResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<HubResponse>> addHubApi(AddHubRequest addHubRequest) async {
    try {
      Map<String, dynamic> someMap = {"fields": addHubRequest};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_HUB, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<HubResponse>.fromJson(response.data, (response) => HubResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateHub> updateHubApi(Map<String, dynamic> loginFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": loginFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_HUB}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateHub.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<SubjectResponse>> getSubjectsApi(String detailFormula) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": detailFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_SUBJECT, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<SubjectResponse>.fromJson(response.data, (response) => SubjectResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<UnitsResponse>> getUnitsApi(String unitsFormula) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": unitsFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_UNITS, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<UnitsResponse>.fromJson(response.data, (response) => UnitsResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<TopicsResponse>> getTopicsApi(String topicsFormula) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": topicsFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_TOPICS, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<TopicsResponse>.fromJson(response.data, (response) => TopicsResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<SpecializationResponse>> addSpecializationApi(AddSpecializationRequest addSpecializationRequest) async {
    try {
      Map<String, dynamic> someMap = {"fields": addSpecializationRequest};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_SPECIALIZATION, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<SpecializationResponse>.fromJson(response.data, (response) => SpecializationResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateSpecialization> updateSpecializationApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_SPECIALIZATION}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateSpecialization.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<SubjectResponse>> addSubjectApi(AddSubjectRequest addSubjectRequest) async {
    try {
      Map<String, dynamic> someMap = {"fields": addSubjectRequest};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_SUBJECT, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<SubjectResponse>.fromJson(response.data, (response) => SubjectResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateSubject> updateSubjectApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_SUBJECT}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateSubject.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateSubject> updateCompanyDetailApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_COMPANY_DETAIL}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateSubject.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<UnitsResponse>> addUnitsApi(AddUnitsRequest addUnitsRequest) async {
    try {
      Map<String, dynamic> someMap = {"fields": addUnitsRequest};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_UNITS, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<UnitsResponse>.fromJson(response.data, (response) => UnitsResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateUnits> updateUnitsApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_UNITS}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateUnits.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<TopicsResponse>> addTopicApi(AddTopicsRequest addTopicsRequest) async {
    try {
      Map<String, dynamic> someMap = {"fields": addTopicsRequest};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_TOPICS, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<TopicsResponse>.fromJson(response.data, (response) => TopicsResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateTopics> updateTopicsApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_UNITS}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateTopics.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<StudentAttendanceResponse>> addStudentAttendanceApi(AddStudentAttendanceRequest request) async {
    try {
      Map<String, dynamic> someMap = {"fields": request};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_STUDENT_ATTENDANCE, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<StudentAttendanceResponse>.fromJson(response.data, (response) => StudentAttendanceResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<StudentAttendanceResponse>> studentAttendanceApi(String recordId) async {
    try {
      //Map<String, dynamic> someMap = {"fields": "name", "direction": "desc"};
      //"?field=name&direction=asc"
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.get("${TableNames.TBL_STUDENT_ATTENDANCE}/$recordId", options: Options(headers: header));
      return BaseApiResponseWithSerializable<StudentAttendanceResponse>.fromJson(response.data, (response) => StudentAttendanceResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<StudentAttendanceResponse>> getStudentAttendanceApi(String attendanceFormula, [String offset = ""]) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": attendanceFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_STUDENT_ATTENDANCE, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<StudentAttendanceResponse>.fromJson(response.data, (response) => StudentAttendanceResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateStudentAttendance> updateStudentAttendanceApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_STUDENT_ATTENDANCE}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateStudentAttendance.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<JobOpportunityResponse>> createJobOpportunityApi(CreateJobOpportunityRequest request) async {
    try {
      Map<String, dynamic> someMap = {"fields": request};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_JOBS, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<JobOpportunityResponse>.fromJson(response.data, (response) => JobOpportunityResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<JobOpportunityResponse>> getJobOppoApi(String jobOppoFormula, [String offset = ""]) async {
    try {
      Map<String, String> someMap = {"filterByFormula": jobOppoFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_JOBS, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<JobOpportunityResponse>.fromJson(response.data, (response) => JobOpportunityResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateJobOpportunity> updateJobOpportunityApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_JOBS}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateJobOpportunity.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateJobOpportunity> updateJobSortListedApi(Map<String, dynamic> updateSortList, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateSortList};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_JOBS}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateJobOpportunity.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<JobOpportunityResponse>> getJobOpportunityApi(String jobOpportunityFormula) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": jobOpportunityFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_JOBS, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<JobOpportunityResponse>.fromJson(response.data, (response) => JobOpportunityResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<CreatePasswordResponse> updateStudentDataApi(Map<String, dynamic> loginFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": loginFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_STUDENT}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return CreatePasswordResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AddAnnouncementResponse> updateAnnouncementApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_ANNOUNCEMENT, options: Options(headers: header), data: jsonEncode(updateFormula));
      return AddAnnouncementResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AddAnnouncementResponse> removeAnnouncementApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_ANNOUNCEMENT}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return AddAnnouncementResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<AddTimeTableResponse> updateTimeTableApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_TIMETABLE, options: Options(headers: header), data: jsonEncode(updateFormula));
      return AddTimeTableResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<AddTimeTable>> cancelTimeTableApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_TIMETABLE}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<AddTimeTable>.fromJson(response, (response) => AddTimeTable.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateJobOpportunity> getJobOpportunityWithRecordIdApi(String recordId) async {
    try {
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get("${TableNames.TBL_JOBS}/$recordId", options: Options(headers: header));
      return UpdateJobOpportunity.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<AddPlacementAttendanceResponse>> getPlacementInfoApi(String dataFormula, [String offset = ""]) async {
    try {
      Map<String, String> someMap = {"filterByFormula": dataFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_PLACEMENT_ATTENDANCE, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<AddPlacementAttendanceResponse>.fromJson(response.data, (response) => AddPlacementAttendanceResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<AddPlacementAttendanceData>> updatePlacementInfoApi(Map<String, dynamic> request) async {
    try {
      Map<String, dynamic> someMap = {"fields": request};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_PLACEMENT_ATTENDANCE, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<AddPlacementAttendanceData>.fromJson(response.data, (response) => AddPlacementAttendanceData.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<AddPlacementAttendanceData>> updatePlacementInfoDataApi(Map<String, dynamic> data, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": data};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_PLACEMENT_ATTENDANCE}/$recordId", data: jsonEncode(someMap), options: Options(headers: header));
      return BaseApiResponseWithSerializable<AddPlacementAttendanceData>.fromJson(response, (response) => AddPlacementAttendanceData.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<AppVersionResponse>> getAppVersions() async {
    try {
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_APP_TRACKING, options: Options(headers: header));
      return BaseLoginResponse<AppVersionResponse>.fromJson(response.data, (response) => AppVersionResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<App_data_response>> getAppData() async {
    try {
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_APP_DATA, options: Options(headers: header));
      return BaseLoginResponse<App_data_response>.fromJson(response.data, (response) => App_data_response.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<App_data_response>> addAppDataApi(Map<String, dynamic> data) async {
    try {
      Map<String, dynamic> someMap = {"fields": data};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_APP_DATA, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseLoginResponse<App_data_response>.fromJson(response.data, (response) => App_data_response.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponse<AddAnnouncementResponse>> addAnnouncementDataApi(Map<String, dynamic> data) async {
    try {
      Map<String, dynamic> someMap = data;
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_ANNOUNCEMENT, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseResponse<AddAnnouncementResponse>.fromJson(response.data, (response) => AddAnnouncementResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponse<AddTimeTableResponse>> addTimeTableDataApi(Map<String, dynamic> data) async {
    try {
      Map<String, dynamic> someMap = data;
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_TIMETABLE, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseResponse<AddTimeTableResponse>.fromJson(response.data, (response) => AddTimeTableResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<LoginFieldsResponse>> addToken(Map<String, dynamic> data, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": data};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_STUDENT}/$recordId", data: jsonEncode(someMap), options: Options(headers: header));
      return BaseLoginResponse<LoginFieldsResponse>.fromJson(response, (response) => LoginFieldsResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<LoginEmployeeResponse>> addTokenEmployee(Map<String, dynamic> data, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": data};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_EMPLOYEE}/$recordId", data: jsonEncode(someMap), options: Options(headers: header));
      return BaseLoginResponse<LoginEmployeeResponse>.fromJson(response, (response) => LoginEmployeeResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<HelpDeskTypeResponse>> getHelpdesk() async {
    try {
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.get(TableNames.TBL_HELPDESK_TYPE, options: Options(headers: header));
      return BaseLoginResponse<HelpDeskTypeResponse>.fromJson(response.data, (response) => HelpDeskTypeResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<HelpDeskResponse> addHelpDeskApi(HelpDeskRequest helpDeskReq) async {
    try {
      Map<String, dynamic> someMap = {"fields": helpDeskReq};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_HELPDESK, options: Options(headers: header), data: jsonEncode(someMap));
      return HelpDeskResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyDetailResponse>> addTokenOrganization(Map<String, dynamic> data, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": data};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_COMPANY_DETAIL}/$recordId", data: jsonEncode(someMap), options: Options(headers: header));
      return BaseLoginResponse<CompanyDetailResponse>.fromJson(response, (response) => CompanyDetailResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<HelpdeskResponses>> getTicketsApi(String ticketFormula, [String offset = ""]) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": ticketFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_HELPDESK, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<HelpdeskResponses>.fromJson(response.data, (response) => HelpdeskResponses.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<HelpDeskResponse> updateTicket(Map<String, dynamic> ticketFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": ticketFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_HELPDESK}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return HelpDeskResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<ViewEmployeeResponse>> getEmployeeListApi(String viewEmpFormula, [String offset = ""]) async {
    try {
      Map<String, String> someMap = {"filterByFormula": viewEmpFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_EMPLOYEE, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<ViewEmployeeResponse>.fromJson(response.data, (response) => ViewEmployeeResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyDetailResponse>> getSelfPlaceCompanyDetailApi(String updateFormula, [String offset = ""]) async {
    try {
      Map<String, String> someMap = {"filterByFormula": updateFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_SELF_COMPANY_DETAIL, options: Options(headers: header), queryParameters: someMap);
      return BaseLoginResponse<CompanyDetailResponse>.fromJson(response.data, (response) => CompanyDetailResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<JobOpportunityResponse>> getSelfPlaceJobDetailApi(String updateFormula, [String offset = ""]) async {
    try {
      Map<String, String> someMap = {"filterByFormula": updateFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_SELF_JOBS, options: Options(headers: header), queryParameters: someMap);
      return BaseLoginResponse<JobOpportunityResponse>.fromJson(response.data, (response) => JobOpportunityResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyDetailResponse>> createSelfPlaceCompanyApi(List<Map<String, CreateCompanyDetailRequest>> createCompanydFormula) async {
    try {
      Map<String, dynamic> someMap = {"records": createCompanydFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.post(TableNames.TBL_SELF_COMPANY_DETAIL, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseLoginResponse<CompanyDetailResponse>.fromJson(response.data, (response) => CompanyDetailResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateSubject> updateSelfPlaceCompanyApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_SELF_COMPANY_DETAIL}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateSubject.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<JobOpportunityResponse>> createSelfPlaceJobApi(Map<String, dynamic> request) async {
    try {
      Map<String, dynamic> someMap = {"fields": request};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_SELF_JOBS, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<JobOpportunityResponse>.fromJson(response.data, (response) => JobOpportunityResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateJobOpportunity> updateSelfPlaceJobApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_SELF_JOBS}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateJobOpportunity.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<MarketingResponse>> getMarketingRecordsApi(String marketingFormula, [String offset = ""]) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": marketingFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_MARKETING, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<MarketingResponse>.fromJson(response.data, (response) => MarketingResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<MarketingResponse>> addMarketingRecordApi(MarketingRequest marketingReq) async {
    try {
      Map<String, dynamic> someMap = {"fields": marketingReq};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_MARKETING, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<MarketingResponse>.fromJson(response.data, (response) => MarketingResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<MarketingResponse>> updateMarketingRecord(Map<String, dynamic> marketingFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": marketingFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_MARKETING}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<MarketingResponse>.fromJson(response, (response) => MarketingResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<FeesResponse>> getFeesRecordsApi(String feesFormula, [String offset = ""]) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": feesFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_FEES, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<FeesResponse>.fromJson(response.data, (response) => FeesResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<FeesResponse>> addFeesRecordApi(FeesRequest feesReq) async {
    try {
      Map<String, dynamic> someMap = {"fields": feesReq};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_FEES, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<FeesResponse>.fromJson(response.data, (response) => FeesResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<FeesResponse>> updateFeesRecord(Map<String, dynamic> feesFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": feesFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_FEES}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<FeesResponse>.fromJson(response, (response) => FeesResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<PunchDataResponse>> getPunchRecordsApi(String punchFormula, [String offset = ""]) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": punchFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_PUNCH_DATA, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<PunchDataResponse>.fromJson(response.data, (response) => PunchDataResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<PunchDataResponse>> addPunchRecordApi(AddPunchRequest punchReq) async {
    try {
      Map<String, dynamic> someMap = {"fields": punchReq};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_PUNCH_DATA, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<PunchDataResponse>.fromJson(response.data, (response) => PunchDataResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<PunchDataResponse>> updatePunchRecord(Map<String, dynamic> punchFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": punchFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_PUNCH_DATA}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<PunchDataResponse>.fromJson(response, (response) => PunchDataResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<MarksResponse>> getMarksApi(String updateFormula, [String offset = ""]) async {
    try {
      Map<String, String> someMap = {"filterByFormula": updateFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_PLACEMENT_MARKS, options: Options(headers: header), queryParameters: someMap);
      return BaseLoginResponse<MarksResponse>.fromJson(response.data, (response) => MarksResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<MarksResponse>> addPlacementMarksApi(AddPlacementMarksRequest marksReq) async {
    try {
      Map<String, dynamic> someMap = {"fields": marksReq};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_PLACEMENT_MARKS, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<MarksResponse>.fromJson(response.data, (response) => MarksResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<StudentReferralResponse>> addStudentReferralApi(StudentReferralRequest referralReq) async {
    try {
      Map<String, dynamic> someMap = {"fields": referralReq};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_STUDENT_REFERRALS, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<StudentReferralResponse>.fromJson(response.data, (response) => StudentReferralResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<StudentReferralResponse>> getStudentReferralDataApi(String updateFormula, [String offset = ""]) async {
    try {
      Map<String, String> someMap = {"filterByFormula": updateFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_STUDENT_REFERRALS, options: Options(headers: header), queryParameters: someMap);
      return BaseLoginResponse<StudentReferralResponse>.fromJson(response.data, (response) => StudentReferralResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<StudentReferralResponse>> updateStudentReferralStatusApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_STUDENT_REFERRALS}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<StudentReferralResponse>.fromJson(response, (response) => StudentReferralResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<ASKParameterResponse>> getAskParametersApi(String parameterFormula, [String offset = ""]) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": parameterFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_ASK_PARAMETERS, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<ASKParameterResponse>.fromJson(response.data, (response) => ASKParameterResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<ASKLevelResponse>> getAskLevelsApi(String askLevelFormula, [String offset = ""]) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": askLevelFormula, if (offset.isNotEmpty) "offset": offset};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_ASK_LEVEL, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<ASKLevelResponse>.fromJson(response.data, (response) => ASKLevelResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<ASKParameterResponse>> addAskParametersApi(ASKParameterRequest askParameterReq) async {
    try {
      Map<String, dynamic> someMap = {"fields": askParameterReq};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_ASK_PARAMETERS, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<ASKParameterResponse>.fromJson(response.data, (response) => ASKParameterResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<ASKParameterResponse>> updateAskParametersApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch("${TableNames.TBL_ASK_PARAMETERS}/$recordId", options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<ASKParameterResponse>.fromJson(response, (response) => ASKParameterResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<AskEvaluationResponse>> addAskEvaluationApi(EvaluationRequest evaluationReq) async {
    try {
      Map<String, dynamic> someMap = {"fields": evaluationReq, "typecast": true};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.post(TableNames.TBL_ASK_MANAGEMENT, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<AskEvaluationResponse>.fromJson(response.data, (response) => AskEvaluationResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }
}
