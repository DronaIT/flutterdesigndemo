import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/dio_client.dart';
import 'package:flutterdesigndemo/models/login.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';

class UserApi {
  final DioClient dioClient;

  UserApi({required this.dioClient});

  Future<Response> getUsersApi(String loginFormula) async {
    try {
      Map<String, String> someMap = {
        "filterByFormula": loginFormula,
      };
      Map<String, String> header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${TableNames.APIKEY}"
      };
      final Response response = await dioClient.get(TableNames.TB_STUDENT,
          queryParameters: someMap, options: Options(headers: header));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateUsersApi(Map<String, String> loginFormula , String recordId) async {
    try {
      Map<String, dynamic> someMap = {
        "fields": loginFormula,
      };
      Map<String, String> header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${TableNames.APIKEY}"
      };
      final Response response = await dioClient.patch(TableNames.TB_STUDENT+"/"+recordId, options: Options(headers: header) , data: jsonEncode(someMap));
      return response;
    } catch (e) {
      rethrow;
    }
  }

}
