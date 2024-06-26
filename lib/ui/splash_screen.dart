import 'dart:async';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/models/app_version_response.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';

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
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  var isLogin = 0;

  /*
    0 = No update
    1 = Normal update
    2 = Force update
  */
  var updateType = 0;
  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<RoleResponse> roleResponse = BaseLoginResponse();
  BaseLoginResponse<HubResponse> hubResponse = BaseLoginResponse();
  BaseLoginResponse<SpecializationResponse> specializationResponse = BaseLoginResponse();
  BaseLoginResponse<AppVersionResponse> appVersionResponse = BaseLoginResponse();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return initScreen(context);
  }

  @override
  void initState() {
    isLogin = PreferenceUtils.getIsLogin();
    WidgetsFlutterBinding.ensureInitialized();
    initialization();
    super.initState();
  }

  //isLogin=1 student login
  //isLogin=2 employee login
  //isLogin=3 organization login
  void initialization() async {
    if (!kIsWeb) {
      await checkAppUpdate();
      if (updateType == 1) {
        showAlertDialog(context, "New update available.", false);
      } else if (updateType == 2) {
        showAlertDialog(context, "Please update app to latest version.", true);
      } else {
        await getRecords();
        Future.delayed(const Duration(seconds: 2), () async {
          if (isLogin == 1 || isLogin == 2 || isLogin == 3) {
            doLogin();
          } else {
            Get.to(const Welcome());
          }
        });
      }
    } else {
      await getRecords();
      Future.delayed(const Duration(seconds: 2), () async {
        if (isLogin == 1 || isLogin == 2 || isLogin == 3) {
          doLogin();
        } else {
          Get.to(const Welcome());
        }
      });
    }
  }

  Future<void> doLogin() async {
    if (isLogin == 1) {
      var loginData = PreferenceUtils.getLoginData();
      var query = "FIND('${loginData.mobileNumber.toString()}', ${TableNames.TB_USERS_PHONE}, 0)";
      try {
        var data = await apiRepository.loginApi(query);
        if (data.records!.isNotEmpty) {
          String? deviceId = await Utils.getId();
          if (data.records!.first.fields!.token == null) {
            redirectToLogin();
          } else if (data.records!.first.fields!.token == deviceId) {
            await PreferenceUtils.setLoginData(data.records!.first.fields!);
            await PreferenceUtils.setLoginRecordId(data.records!.first.id!);
            Get.offAll(const Home());
          } else {
            redirectToLogin();
          }
        } else {
          redirectToLogin();
        }
      } on DioError catch (e) {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        Utils.showSnackBarUsingGet(errorMessage);
      }
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      var query = "SEARCH('${loginData.mobileNumber.toString()}', ${TableNames.TB_USERS_PHONE})";
      try {
        var dataEmployee = await apiRepository.loginEmployeeApi(query);
        if (dataEmployee.records!.isNotEmpty) {
          String? deviceId = await Utils.getId();
          if (dataEmployee.records!.first.fields!.token == null) {
            redirectToLogin();
          } else if (dataEmployee.records!.first.fields!.token == deviceId) {
            await PreferenceUtils.setLoginDataEmployee(dataEmployee.records!.first.fields!);
            await PreferenceUtils.setLoginRecordId(dataEmployee.records!.first.id!);
            Get.offAll(const Home());
          } else {
            redirectToLogin();
          }
        } else {
          redirectToLogin();
        }
      } on DioError catch (e) {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        Utils.showSnackBarUsingGet(errorMessage);
      }
    } else if (isLogin == 3) {
      var loginData = PreferenceUtils.getLoginDataOrganization();
      var query = "AND(${TableNames.TB_CONTACT_NUMBER}='${loginData.contactNumber.toString()}')";
      try {
        var dataOrganization = await apiRepository.getCompanyDetailApi(query);
        if (dataOrganization.records!.isNotEmpty) {
          String? deviceId = await Utils.getId();
          if (dataOrganization.records!.first.fields!.token == null) {
            redirectToLogin();
          } else if (dataOrganization.records!.first.fields!.token == deviceId) {
            await PreferenceUtils.setLoginDataOrganization(dataOrganization.records!.first.fields!);
            await PreferenceUtils.setLoginRecordId(dataOrganization.records!.first.id!);
            Get.offAll(const Home());
          } else {
            redirectToLogin();
          }
        } else {
          redirectToLogin();
        }
      } on DioError catch (e) {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        Utils.showSnackBarUsingGet(errorMessage);
      }
    }
  }

  redirectToLogin() {
    PreferenceUtils.clearPreference();
    Get.offAll(const Login());
  }

  initScreen(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: AppImage.load(AppImage.ic_launcher, width: 220.w, height: 220.h),
          ),
        ),
      ),
    );
  }

  Future<void> getRecords() async {
    try {
      roleResponse = await apiRepository.getRolesApi();
      if (roleResponse.records!.isNotEmpty) {
        PreferenceUtils.setRoleList(roleResponse);
        debugPrint("Role ${PreferenceUtils.getRoleList().records!.length}");
      }
      hubResponse = await apiRepository.getHubApi();
      if (hubResponse.records!.isNotEmpty) {
        PreferenceUtils.setHubList(hubResponse);
        debugPrint("Hub ${PreferenceUtils.getHubList().records!.length}");
      }
      specializationResponse = await apiRepository.getSpecializationApi();
      if (specializationResponse.records!.isNotEmpty) {
        PreferenceUtils.setSpecializationList(specializationResponse);
        debugPrint("Specialization ${PreferenceUtils.getSpecializationList().records!.length}");
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  Future<int> checkAppUpdate() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.buildNumber;

      appVersionResponse = await apiRepository.getAppVersions();
      if (appVersionResponse.records?.isNotEmpty == true) {
        for (int i = appVersionResponse.records!.length - 1; i >= 0; i--) {
          if (Platform.isAndroid && appVersionResponse.records![i].fields?.androidVersion?.isNotEmpty == true) {
            var androidVer = appVersionResponse.records![i].fields?.androidVersion;
            String enablePushNotification = appVersionResponse.records![i].fields?.enablePushNotifications ?? "0";
            PreferenceUtils.setEnablePush(enablePushNotification);
            if (int.parse(androidVer!) > int.parse(version)) {
              updateType = appVersionResponse.records![i].fields!.updateType!;
            }
            break;
          } else if (Platform.isIOS && appVersionResponse.records![i].fields?.iosVersion?.isNotEmpty == true) {
            var iosVer = appVersionResponse.records![i].fields?.iosVersion;
            String enablePushNotification = appVersionResponse.records![i].fields?.enablePushNotifications ?? "0";
            PreferenceUtils.setEnablePush(enablePushNotification);
            if (int.parse(iosVer!) > int.parse(version)) {
              updateType = appVersionResponse.records![i].fields!.updateType!;
            }
            break;
          }
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    } finally {
      return updateType;
    }
  }

  void showAlertDialog(BuildContext context, String message, bool isForced) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "",
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Text(message, style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal, fontFamily: 'Roboto')),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            actions: <Widget>[
              Visibility(
                  visible: !isForced,
                  child: TextButton(
                    child: const Text(strings_name.str_cancle, style: blackTextSemiBold14),
                    onPressed: () async {
                      Navigator.pop(context);
                      await getRecords();
                      if (isLogin == 1 || isLogin == 2 || isLogin == 3) {
                        doLogin();
                      } else {
                        Get.to(const Welcome());
                      }
                    },
                  )),
              TextButton(
                child: const Text(
                  strings_name.str_update,
                  style: primryTextSemiBold14,
                ),
                onPressed: () {
                  // Navigator.pop(context);
                  StoreRedirect.redirect(androidAppId: "com.dronafoundations", iOSAppId: "6446907709");
                },
              )
            ],
          ),
        );
      },
    );
  }
}
