import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/api_request.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/createpassword.dart';
import 'package:flutterdesigndemo/models/loginFiledsResponse.dart';


class ApiRepository {
  final ApiRequest userApi;

  ApiRepository(this.userApi);

  Future<BaseLoginResponse<LoginFieldsResponse>>loginApi(String query) async {
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

  Future<BaseLoginResponse<LoginFieldsResponse>> registerApi(String query) async {
    try {
      final response = await userApi.loginRegisterApi(query);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<CreatePasswordResponse>createPasswordApi(Map<String, String> loginFormula , String recordId) async {
    try {
      final response = await userApi.createPasswordApi(loginFormula,recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
