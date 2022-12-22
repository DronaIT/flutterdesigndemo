import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/dio_client.dart';
import 'package:flutterdesigndemo/models/permission_response.dart';
import 'package:flutterdesigndemo/models/request/add_employee_request.dart';
import 'package:flutterdesigndemo/models/login_employee_response.dart';
import 'package:flutterdesigndemo/models/request/add_hub_request.dart';
import 'package:flutterdesigndemo/models/request/create_student_request.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/role_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/createpassword.dart';
import 'package:flutterdesigndemo/models/createpasswordemployee.dart';

import 'package:flutterdesigndemo/models/home_module_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/models/updatehub.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';

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

  Future<BaseLoginResponse<SubjectResponse>> getSubjectsForSpecializationApi(String detailFormula) async {
    try {
      Map<String, dynamic> someMap = {"filterByFormula": detailFormula};
      Map<String, String> header = {"Content-Type": "application/json", "Authorization": "Bearer ${TableNames.APIKEY}"};

      final Response response = await dioClient.get(TableNames.TBL_SUBJECT, queryParameters: someMap, options: Options(headers: header));
      return BaseLoginResponse<SubjectResponse>.fromJson(response.data, (response) => SubjectResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }
}
