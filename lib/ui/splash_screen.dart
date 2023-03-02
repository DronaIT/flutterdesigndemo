import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/main.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:get/get.dart';

import '../api/api_repository.dart';
import '../api/dio_exception.dart';
import '../api/service_locator.dart';
import '../models/base_api_response.dart';
import '../models/hub_response.dart';
import '../models/role_response.dart';
import '../models/specialization_response.dart';
import '../utils/preference.dart';
import '../utils/tablenames.dart';
import '../utils/utils.dart';
import 'authentication/login.dart';
import 'home.dart';
import 'welcome.dart';




class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  var isLogin = 0;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<RoleResponse> roleResponse = BaseLoginResponse();
  BaseLoginResponse<HubResponse> hubResponse = BaseLoginResponse();
  BaseLoginResponse<SpecializationResponse> specializationResponse = BaseLoginResponse();


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return initScreen(context);
  }

  @override
  void initState() {
    isLogin = PreferenceUtils.getIsLogin();
    initialization();
    super.initState();
  }
  //islogin= 1 student login
  //islogin=2 employee login
  void initialization() async {
    getRecords();
    Future.delayed(const Duration(seconds: 3), () async {
      if (isLogin == 1 || isLogin == 2) {
        doLogin();
      }else{
        Get.to(const Welcome());
      }
    });

  }

  Future<void> doLogin() async {
    if (isLogin == 1) {
      var loginData = PreferenceUtils.getLoginData();
      var query = "FIND('${loginData.mobileNumber.toString()}', ${TableNames.TB_USERS_PHONE}, 0)";
      try{
        var data = await apiRepository.loginApi(query);
        if (data.records!.isNotEmpty) {
          await PreferenceUtils.setLoginData(data.records!.first.fields!);
          await PreferenceUtils.setLoginRecordId(data.records!.first.id!);
          Get.offAll(const Home());
        } else {
          Get.offAll(const Login());
        }
      } on DioError catch (e) {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        Utils.showSnackBarUsingGet(errorMessage);
      }

    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      var query = "FIND('${loginData.mobileNumber.toString()}', ${TableNames.TB_USERS_PHONE}, 0)";
      try{
        var dataEmployee = await apiRepository.loginEmployeeApi(query);
        if (dataEmployee.records!.isNotEmpty) {
          await PreferenceUtils.setLoginDataEmployee(dataEmployee.records!.first.fields!);
          await PreferenceUtils.setLoginRecordId(dataEmployee.records!.first.id!);
          Get.offAll(const Home());
        } else {
          Get.offAll(const Login());
        }
      }on DioError catch (e) {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        Utils.showSnackBarUsingGet(errorMessage);
      }

    }
  }


  initScreen(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: AppImage.load(AppImage.ic_launcher, width: 220.w, height: 220.h),
        ),
      ),
    );
  }

  Future<void> getRecords() async {
    try{
      roleResponse = await apiRepository.getRolesApi();
      if (roleResponse.records!.isNotEmpty) {
        PreferenceUtils.setRoleList(roleResponse);
        print("Role ${PreferenceUtils.getRoleList().records!.length}");
      }
      hubResponse = await apiRepository.getHubApi();
      if (hubResponse.records!.isNotEmpty) {
        PreferenceUtils.setHubList(hubResponse);
        print("Hub ${PreferenceUtils.getHubList().records!.length}");
      }
      specializationResponse = await apiRepository.getSpecializationApi();
      if (specializationResponse.records!.isNotEmpty) {
        PreferenceUtils.setSpecializationList(specializationResponse);
        print("Specialization ${PreferenceUtils.getSpecializationList().records!.length}");
      }

    }on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

}
