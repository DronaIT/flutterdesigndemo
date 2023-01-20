import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/customwidget/custom_button.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/role_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/ui/home.dart';
import 'package:flutterdesigndemo/ui/authentucation/login.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/app_images.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await PreferenceUtils.init();
  setup();
  runApp(const GetMaterialApp(debugShowCheckedModeBanner: false, home: WelcomeScreen()));
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var isLogin = 0;

  final apiRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<RoleResponse> roleResponse = BaseLoginResponse();
  BaseLoginResponse<HubResponse> hubResponse = BaseLoginResponse();
  BaseLoginResponse<SpecializationResponse> specializationResponse = BaseLoginResponse();

  @override
  void initState() {
    super.initState();
    isLogin = PreferenceUtils.getIsLogin();
    initialization();
  }

  void initialization() async {
    getRecords();
    if (isLogin == 1 || isLogin == 2) {
      doLogin();
    }
    await Future.delayed(const Duration(seconds: 5));
    FlutterNativeSplash.remove();
  }

  Future<void> getRecords() async {
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
  }

  Future<void> doLogin() async {
    if (isLogin == 1) {
      var loginData = PreferenceUtils.getLoginData();
      var query = "FIND('${loginData.mobileNumber.toString()}', ${TableNames.TB_USERS_PHONE}, 0)";
      var data = await apiRepository.loginApi(query);
      if (data.records!.isNotEmpty) {
        await PreferenceUtils.setLoginData(data.records!.first.fields!);
        await PreferenceUtils.setLoginRecordId(data.records!.first.id!);
        Get.offAll(const Home());
      } else {
        Get.offAll(const Login());
      }
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      var query = "FIND('${loginData.mobileNumber.toString()}', ${TableNames.TB_USERS_PHONE}, 0)";
      var dataEmployee = await apiRepository.loginEmployeeApi(query);
      if (dataEmployee.records!.isNotEmpty) {
        await PreferenceUtils.setLoginDataEmployee(dataEmployee.records!.first.fields!);
        await PreferenceUtils.setLoginRecordId(dataEmployee.records!.first.id!);
        Get.offAll(const Home());
      } else {
        Get.offAll(const Login());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                SizedBox(height: 60.h),
                Container(alignment: Alignment.topLeft, child: AppImage.load(AppImage.ic_launcher, width: 80.w, height: 80.h)),
                custom_text(
                  text: strings_name.str_welcome,
                  alignment: Alignment.topLeft,
                  textStyles: centerTextStyle30,
                ),
                SizedBox(height: 5.h),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: AppWidgets.spannableText(strings_name.str_welcome_detail, strings_name.str_drona, primaryTextSemiBold16),
                ),
                SizedBox(height: 40.h),
                Lottie.asset(AppImage.ic_welcome),
                SizedBox(height: 40.h),
                CustomButton(
                    text: strings_name.str_get_started,
                    click: () {
                      Get.offAll(const Login());
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
