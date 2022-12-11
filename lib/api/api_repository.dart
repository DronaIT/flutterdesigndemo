import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/api_request.dart';
import 'package:flutterdesigndemo/models/CreateStudentRequest.dart';
import 'package:flutterdesigndemo/models/HubResponse.dart';
import 'package:flutterdesigndemo/models/RoleResponse.dart';
import 'package:flutterdesigndemo/models/SpecializationResponse.dart';
import 'package:flutterdesigndemo/models/LoginEmployeResponse.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/createpassword.dart';
import 'package:flutterdesigndemo/models/homeModuleResponse.dart';
import 'package:flutterdesigndemo/models/createpasswordemployee.dart';
import 'package:flutterdesigndemo/models/loginFiledsResponse.dart';

class ApiRepository {
  final ApiRequest userApi;

  ApiRepository(this.userApi);

  Future<BaseLoginResponse<LoginFieldsResponse>> loginApi(String query) async {
    try {
      final response = await userApi.loginRegisterApi(query);
      // final users = (response.data['records'] as List)
      //     .map((e) => Records.fromJson(e))
      //     .toList();
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<BaseLoginResponse<LoginEmployeResponse>> loginEmployeeApi(String query) async {
    try {
      final response = await userApi.loginRegisterEmployeeApi(query);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<BaseLoginResponse<LoginFieldsResponse>> registerApi(String query) async {
    try {
      final response = await userApi.loginRegisterApi(query);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<BaseLoginResponse<LoginEmployeResponse>> registerEmployeeApi(String query) async {
    try {
      final response = await userApi.loginRegisterEmployeeApi(query);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<CreatePasswordResponse> createPasswordApi(Map<String, String> loginFormula, String recordId) async {
    try {
      final response = await userApi.createPasswordApi(loginFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<CreatePasswordEmployeeResponse> createPasswordEmpApi(Map<String, String> loginFormula, String recordId) async {
    try {
      final response = await userApi.createPasswordEmployeeApi(loginFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<BaseLoginResponse<homeModuleResponse>> getHomeModulesApi(String homeModuleFormula) async {
    try {
      final response = await userApi.getHomeModulesApi(homeModuleFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<BaseLoginResponse<CreatePasswordResponse>> createStudentApi(List<Map<String, CreateStudentRequest>> createStudentFormula) async {
    try {
      final response = await userApi.createStudentApi(createStudentFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<BaseLoginResponse<RoleResponse>> getRolesApi() async {
    try {
      final response = await userApi.getRolesApi();
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<BaseLoginResponse<HubResponse>> getHubApi() async {
    try {
      final response = await userApi.getHubApi();
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<BaseLoginResponse<SpecializationResponse>> getSpecializationApi() async {
    try {
      final response = await userApi.getSpecializationApi();
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
