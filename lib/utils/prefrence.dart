import 'dart:convert';
import 'dart:ffi';

import 'package:flutterdesigndemo/models/loginFiledsResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static late SharedPreferences _preferences;

  static const _keyUsername = 'username';
  static const _keyEmail = 'email';
  static const _keyAmount = 'amount';
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

  static Future setAmount(int amount) async =>
      await _preferences.setInt(_keyAmount, amount);

  static int getAmount() => _preferences.getInt(_keyAmount) ?? 0;



  static Future setIsLogin(bool amount) async =>
      await _preferences.setBool(_keyisLogin, amount);

  static bool getIsLogin() => _preferences.getBool(_keyisLogin) ?? false;


  static Future setisOtpVerify(bool amount) async =>
      await _preferences.setBool(_keyisOtpVerify, amount);

  static bool getisOtpVerify() => _preferences.getBool(_keyisOtpVerify) ?? false;


  static Future setLoginData(LoginFieldsResponse user) async =>
      await _preferences.setString(_keyLoginData, jsonEncode(user));

  static String? getLoginData() => _preferences.getString(_keyLoginData);


}
