import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/dio_client.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/createpassword.dart';

import 'package:flutterdesigndemo/models/loginFiledsResponse.dart';
import 'package:flutterdesigndemo/ui/createpassword.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';

class ApiRequest {
  final DioClient dioClient;

  ApiRequest({required this.dioClient});

  Future<BaseLoginResponse<LoginFieldsResponse>> loginRegisterApi(String loginFormula) async {
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
      return BaseLoginResponse<LoginFieldsResponse>.fromJson(response.data, (response) => LoginFieldsResponse.fromJson(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<CreatePasswordResponse>createPasswordApi(Map<String, String> loginFormula ,String recordId) async {
    try {
      Map<String, dynamic> someMap = {
        "fields": loginFormula,
      };
      Map<String, String> header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${TableNames.APIKEY}"
      };

      Map<String, dynamic> response = await dioClient.patch(TableNames.TB_STUDENT+"/"+recordId, options: Options(headers: header) , data: jsonEncode(someMap));
      return  CreatePasswordResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

}
