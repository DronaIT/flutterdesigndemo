import 'dart:convert';
import 'dart:ffi';

import 'package:flutterdesigndemo/models/HubResponse.dart';
import 'package:flutterdesigndemo/models/SpecializationResponse.dart';
import 'package:flutterdesigndemo/models/LoginEmployeResponse.dart';
import 'package:flutterdesigndemo/models/loginFiledsResponse.dart';
import 'package:flutterdesigndemo/models/RoleResponse.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static late SharedPreferences _preferences;

  static const _keyUsername = 'username';
  static const _keyEmail = 'email';

  static const _keyisLogin = 'isLogin';
  static const _keyisOtpVerify = 'isOtpVerify';
  static const _keyLoginData = 'isLoginData';
  static const _keyRoleList = 'roleList';
  static const _keyHubList = 'hubList';
  static const _keySpecializationList = 'specializationList';

  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String username) async => await _preferences.setString(_keyUsername, username);

  static String getUsername() => _preferences.getString(_keyUsername) ?? " ";

  static Future setEmail(String email) async => await _preferences.setString(_keyEmail, email);

  static String getEmail() => _preferences.getString(_keyEmail) ?? " ";

  //0 = not login
  //1 = student
  //2 = employee

  static Future setIsLogin(int amount) async => await _preferences.setInt(_keyisLogin, amount);

  static int getIsLogin() => _preferences.getInt(_keyisLogin) ?? 0;

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

  static Future setSpecializationList(BaseLoginResponse<SpecializationResponse> specializationResponse) async => await _preferences.setString(_keySpecializationList, jsonEncode(specializationResponse));

  static BaseLoginResponse<SpecializationResponse> getSpecializationList() {
    return BaseLoginResponse<SpecializationResponse>.fromJson(jsonDecode(_preferences.getString(_keySpecializationList)!), (response) => SpecializationResponse.fromJson(response));
  }
}
