import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/dio_client.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/models/permission_response.dart';
import 'package:flutterdesigndemo/models/request/add_student_attendance_request.dart';
import 'package:flutterdesigndemo/models/request/add_employee_request.dart';
import 'package:flutterdesigndemo/models/login_employee_response.dart';
import 'package:flutterdesigndemo/models/request/add_hub_request.dart';
import 'package:flutterdesigndemo/models/request/add_specialization_request.dart';
import 'package:flutterdesigndemo/models/request/add_subject_request.dart';
import 'package:flutterdesigndemo/models/request/add_topics_request.dart';
import 'package:flutterdesigndemo/models/request/add_units_request.dart';
import 'package:flutterdesigndemo/models/request/create_job_opportunity_request.dart';
import 'package:flutterdesigndemo/models/request/create_student_request.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/role_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/createpassword.dart';
import 'package:flutterdesigndemo/models/createpasswordemployee.dart';

import 'package:flutterdesigndemo/models/home_module_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/student_attendance_response.dart';
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
import 'package:flutterdesigndemo/utils/tablenames.dart';

import '../models/company_approch_response.dart';
import '../models/company_detail_response.dart';
import '../models/request/create_company_appr_req.dart';
import '../models/request/create_company_det_req.dart';

class ApiRequest {
  final DioClient dioClient;

  ApiRequest({required this.dioClient});

  Future<BaseLoginResponse<LoginFieldsResponse>> loginRegisterApi(String loginFormula) async {
    try {
      Map<String, String> someMap = {"filterByFormula": loginFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TB_STUDENT, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<LoginFieldsResponse>.fromJson(response.data, (response) => LoginFieldsResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<LoginEmployeResponse>> loginRegisterEmployeeApi(String loginFormula) async {
    try {
      Map<String, String> someMap = {
        "filterByFormula": loginFormula,
      };
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.get(TableNames.TBL_EMPLOYEE, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<LoginEmployeResponse>.fromJson(response.data, (response) => LoginEmployeResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<CreatePasswordResponse> createPasswordApi(Map<String, String> loginFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": loginFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch(TableNames.TB_STUDENT + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
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

      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_EMPLOYEE + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
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

      final Response response = await dioClient.post(TableNames.TB_STUDENT, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseLoginResponse<CreatePasswordResponse>.fromJson(response.data, (response) => CreatePasswordResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyApprochResponse>> createCopmanyApprochApi(List<Map<String, CreateCompanyaRequest>> createCompanyFormula) async {
    try {
      Map<String, dynamic> someMap = {"records": createCompanyFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.post(TableNames.TBL_COMPANY_APPROACH, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseLoginResponse<CompanyApprochResponse>.fromJson(response.data, (response) => CompanyApprochResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyDetailResponse>> createCopmanyDetailApi(List<Map<String, CreateCompanyDetailRequest>> createCompanydFormula) async {
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

      Map<String, dynamic> response = await dioClient.patch(TableNames.TB_STUDENT + "/" + recordId, options: Options(headers: header), data: jsonEncode(updateFormula));
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

  Future<BaseLoginResponse<CompanyDetailResponse>> getCompanyDetailApi(String updateFormula) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.get(TableNames.TBL_COMPANY_DETAIL, options: Options(headers: header), queryParameters: someMap);
      return BaseLoginResponse<CompanyDetailResponse>.fromJson(response.data, (response) => CompanyDetailResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<TypeOfsectoreResponse>> getSectorsApi() async {
    try {
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_SECTOR, options: Options(headers: header));
      return BaseLoginResponse<TypeOfsectoreResponse>.fromJson(response.data, (response) => TypeOfsectoreResponse.fromJson(response));
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

  Future<BaseApiResponseWithSerializable<LoginEmployeResponse>> addEmployeeApi(AddEmployeeRequest addEmployeeFormula) async {
    try {
      Map<String, dynamic> someMap = {"fields": addEmployeeFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.post(TableNames.TBL_EMPLOYEE, options: Options(headers: header), data: jsonEncode(someMap));
      return BaseApiResponseWithSerializable<LoginEmployeResponse>.fromJson(response.data, (response) => LoginEmployeResponse.fromJson(response));
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

      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_EMPLOYEE + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
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

      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_HUB + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
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

      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_SPECIALIZATION + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
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

      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_SUBJECT + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateSubject.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateSubject> updateCompanyDetailApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_COMPANY_DETAIL + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
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

      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_UNITS + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
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

      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_UNITS + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
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
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};
      final Response response = await dioClient.get(TableNames.TBL_STUDENT_ATTENDANCE + "/" + recordId, options: Options(headers: header));
      return BaseApiResponseWithSerializable<StudentAttendanceResponse>.fromJson(response.data, (response) => StudentAttendanceResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseLoginResponse<StudentAttendanceResponse>> getStudentAttendanceApi(String attendanceFormula) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": attendanceFormula};
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

      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_STUDENT_ATTENDANCE + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
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

  Future<BaseLoginResponse<JobOpportunityResponse>> getJoboppoApi(String JoboppoFormula) async {
    try {
      Map<String, String> someMap = {"filterByFormula": JoboppoFormula};
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

      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_JOBS + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
      return UpdateJobOpportunity.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateJobOpportunity> updateJobSortListedApi(Map<String, dynamic> updateSortList, String recordId) async {
    try {
      Map<String, dynamic> someMap = {"fields": updateSortList};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      Map<String, dynamic> response = await dioClient.patch(TableNames.TBL_JOBS + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
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

      Map<String, dynamic> response = await dioClient.patch(TableNames.TB_STUDENT + "/" + recordId, options: Options(headers: header), data: jsonEncode(someMap));
      return CreatePasswordResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateJobOpportunity> getJobOpportunityWithRecordIdApi(String recordId) async {
    try {
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_JOBS + "/" + recordId, options: Options(headers: header));
      return UpdateJobOpportunity.fromJson(response.extra);
    } catch (e) {
      rethrow;
    }
  }
}
