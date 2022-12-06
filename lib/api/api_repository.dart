import 'dart:async';
import 'dart:collection';

import 'package:flutterdesigndemo/api/dioprovider.dart';
import 'package:flutterdesigndemo/models/login.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';



class ApiRepository {

  final DioProvider _providerDio = DioProvider();



  Future<List<login>> getLoginData(String formula) async {
    final response = await _providerDio.get(TableNames.TB_USERS, formula);
    print("REsponse => ${(response)}");
    print("REsponse => ${(response as List).map((postJson) => login.fromJson(postJson)).toList()}");
    return (response).map((postJson) => login.fromJson(postJson)).toList();
  }

}
