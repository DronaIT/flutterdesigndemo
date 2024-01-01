import 'dart:convert';

import 'package:flutterdesigndemo/models/company_detail_response.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/login_employee_response.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/role_response.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/typeofsectoreresponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static late SharedPreferences _preferences;

  static const _keyUsername = 'username';
  static const _keyEmail = 'email';

  static const _keyisLogin = 'isLogin';
  static const _keyEnablePush = 'enablePushNotification';
  static const _keyisOtpVerify = 'isOtpVerify';
  static const _keyLoginData = 'isLoginData';
  static const _keyRoleList = 'roleList';
  static const _keyHubList = 'hubList';
  static const _keySpecializationList = 'specializationList';
  static const _keySectoreList = 'sectoreList';

  static const _keyLoginRecordId = 'loginRecordId';

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String username) async => await _preferences.setString(_keyUsername, username);

  static String getUsername() => _preferences.getString(_keyUsername) ?? " ";

  static Future setEmail(String email) async => await _preferences.setString(_keyEmail, email);

  static String getEmail() => _preferences.getString(_keyEmail) ?? " ";

  //0 = not login
  //1 = student
  //2 = employee
  //3 = organization

  static Future setIsLogin(int amount) async => await _preferences.setInt(_keyisLogin, amount);

  static int getIsLogin() => _preferences.getInt(_keyisLogin) ?? 0;

  static Future setEnablePush(String push) async => await _preferences.setString(_keyEnablePush, push);

  static String getIsPushEnabled() => _preferences.getString(_keyEnablePush) ?? "0";

  static Future setisOtpVerify(bool amount) async => await _preferences.setBool(_keyisOtpVerify, amount);

  static bool getisOtpVerify() => _preferences.getBool(_keyisOtpVerify) ?? false;

  static Future setLoginData(LoginFieldsResponse user) async => await _preferences.setString(_keyLoginData, jsonEncode(user));

  static LoginFieldsResponse getLoginData() => LoginFieldsResponse.fromJson(jsonDecode(_preferences.getString(_keyLoginData)!));

  static Future setRoleList(BaseLoginResponse<RoleResponse> roleResponse) async => await _preferences.setString(_keyRoleList, jsonEncode(roleResponse));

  static BaseLoginResponse<RoleResponse> getRoleList() {
    return BaseLoginResponse<RoleResponse>.fromJson(jsonDecode(_preferences.getString(_keyRoleList)!), (response) => RoleResponse.fromJson(response));
  }

  static Future setHubList(BaseLoginResponse<HubResponse> hubResponse) async => await _preferences.setString(_keyHubList, jsonEncode(hubResponse));

  static BaseLoginResponse<HubResponse> getHubList() {
    return BaseLoginResponse<HubResponse>.fromJson(jsonDecode(_preferences.getString(_keyHubList)!), (response) => HubResponse.fromJson(response));
  }

  static Future setLoginDataEmployee(LoginEmployeResponse user) async => await _preferences.setString(_keyLoginData, jsonEncode(user));

  static LoginEmployeResponse getLoginDataEmployee() => LoginEmployeResponse.fromJson(jsonDecode(_preferences.getString(_keyLoginData)!));

  static Future setLoginDataOrganization(CompanyDetailResponse user) async => await _preferences.setString(_keyLoginData, jsonEncode(user));

  static CompanyDetailResponse getLoginDataOrganization() => CompanyDetailResponse.fromJson(jsonDecode(_preferences.getString(_keyLoginData)!));

  static Future setSpecializationList(BaseLoginResponse<SpecializationResponse> specializationResponse) async => await _preferences.setString(_keySpecializationList, jsonEncode(specializationResponse));

  static BaseLoginResponse<SpecializationResponse> getSpecializationList() {
    return BaseLoginResponse<SpecializationResponse>.fromJson(jsonDecode(_preferences.getString(_keySpecializationList)!), (response) => SpecializationResponse.fromJson(response));
  }

  static Future setTypeofList(BaseLoginResponse<TypeOfsectoreResponse> typeofResponse) async => await _preferences.setString(_keySectoreList, jsonEncode(typeofResponse));

  static BaseLoginResponse<TypeOfsectoreResponse> getTypeOFSectoreList() {
    return BaseLoginResponse<TypeOfsectoreResponse>.fromJson(jsonDecode(_preferences.getString(_keySectoreList)!), (response) => TypeOfsectoreResponse.fromJson(response));
  }

  static Future setLoginRecordId(String recordId) async => await _preferences.setString(_keyLoginRecordId, recordId);

  static String getLoginRecordId() => _preferences.getString(_keyLoginRecordId) ?? " ";

  static clearPreference() {
    var roleList = getRoleList();
    var hubList = getHubList();
    var specializationList = getSpecializationList();

    _preferences.clear();

    setRoleList(roleList);
    setHubList(hubList);
    setSpecializationList(specializationList);
  }
}
