import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/user_api.dart';
import 'package:flutterdesigndemo/models/login.dart';

class UserRepository {
  final UserApi userApi;

  UserRepository(this.userApi);

  Future<List<Records>> getUsersRequested(String query) async {
    try {
      final response = await userApi.getUsersApi(query);
      final users = (response.data['records'] as List)
          .map((e) => Records.fromJson(e))
          .toList();
      return users;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<List<Records>> getUsersRegister(String query) async {
    try {
      final response = await userApi.getUsersApi(query);
      print("user => ${response.data}");
      final users = (response.data['records'] as List)
          .map((e) => Records.fromJson(e))
          .toList();
      return users;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  Future<List<Records>> getUsersCreatePassword( Map<String, String> loginFormula , String recordId) async {
    try {
      final response = await userApi.updateUsersApi(loginFormula,recordId);
      print("userre => ${response.data}");
      final users = (response.data['records'] as List)
          .map((e) => Records.fromJson(e))
          .toList();
      return users;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }
}
