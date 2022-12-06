import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';

import 'CustomException.dart';

class DioProvider {
  final Dio _dio = Dio();

  Future<dynamic> get(String url, String loginFormula) async {
    var responseJson;
    try {
      Map<String, String> someMap = {
        "filterByFormula": loginFormula,
      };

      Map<String, String> header = {
        'Authorization': 'Bearer ${TableNames.APIKEY}',
        'Content-Type': 'application/json',
      };

      final response = await _dio.get(TableNames.APIENDPOINTS + url,
          queryParameters: someMap, options: Options(headers: header));
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url) async {
    var responseJson;
    try {
      final response = await _dio.post(TableNames.APIENDPOINTS + url);
      responseJson = _response(response);
    } on SocketException {
      // ScaffoldMessenger.of(App.materialKey.currentContext).showSnackBar(const SnackBar(
      //   content: Text("Sending Message"),
      // ));
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
