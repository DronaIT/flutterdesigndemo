import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/dio_client.dart';
import 'package:flutterdesigndemo/models/LoginEmployeResponse.dart';
import 'package:flutterdesigndemo/models/CreateStudentRequest.dart';
import 'package:flutterdesigndemo/models/HubResponse.dart';
import 'package:flutterdesigndemo/models/RoleResponse.dart';
import 'package:flutterdesigndemo/models/SpecializationResponse.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/createpassword.dart';
import 'package:flutterdesigndemo/models/createpasswordemployee.dart';

import 'package:flutterdesigndemo/models/homeModuleResponse.dart';
import 'package:flutterdesigndemo/models/loginFiledsResponse.dart';
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
}
