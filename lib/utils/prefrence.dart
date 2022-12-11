import 'dart:convert';
import 'dart:ffi';

import 'package:flutterdesigndemo/models/LoginEmployeResponse.dart';
import 'package:flutterdesigndemo/models/loginFiledsResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static late SharedPreferences _preferences;

  static const _keyUsername = 'username';
  static const _keyEmail = 'email';

  static const _keyisLogin = 'isLogin';
  static const _keyisOtpVerify = 'isOtpVerify';
  static const _keyLoginData = 'isLoginData';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUsername(String username) async =>
      await _preferences.setString(_keyUsername, username);

  static String getUsername() => _preferences.getString(_keyUsername) ?? " ";

  static Future setEmail(String email) async =>
      await _preferences.setString(_keyEmail, email);

  static String getEmail() => _preferences.getString(_keyEmail) ?? " ";




  //0 = not login
  //1 = student
  //2 = employee

  static Future setIsLogin(int amount) async =>
      await _preferences.setInt(_keyisLogin, amount);

  static int getIsLogin() => _preferences.getInt(_keyisLogin) ?? 0;



  static Future setisOtpVerify(bool amount) async =>
      await _preferences.setBool(_keyisOtpVerify, amount);

  static bool getisOtpVerify() => _preferences.getBool(_keyisOtpVerify) ?? false;


  static Future setLoginData(LoginFieldsResponse user) async =>
      await _preferences.setString(_keyLoginData, jsonEncode(user));

  static String? getLoginData() => _preferences.getString(_keyLoginData);


  static Future setLoginDataEmployee(LoginEmployeResponse user) async =>
      await _preferences.setString(_keyLoginData, jsonEncode(user));

  static String? getLoginDataEmployee() => _preferences.getString(_keyLoginData);

}
