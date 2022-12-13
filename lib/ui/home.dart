import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/custom_text.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/homeModuleResponse.dart';
import 'package:flutterdesigndemo/ui/addemployee.dart';
import 'package:flutterdesigndemo/ui/create_students.dart';
import 'package:flutterdesigndemo/utils/prefrence.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/values/colors_name.dart';
import 'package:flutterdesigndemo/values/text_styles.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isVisible = false;

  final homeRepository = getIt.get<ApiRepository>();
  BaseLoginResponse<homeModuleResponse> homeModule = BaseLoginResponse();

  Future<void> getRecords(String roleId) async {
    var query = "SEARCH('${roleId}',${TableNames.CLM_ROLE_ID},0)";
    setState(() {
      isVisible = true;
    });
    homeModule = await homeRepository.getHomeModulesApi(query);
    if (homeModule.records!.isNotEmpty) {
      setState(() {
        isVisible = false;
      });
    } else {
      setState(() {
        isVisible = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      getRecords("DR09");
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      getRecords(loginData.roleIdFromRoleIds![0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: colors_name.colorPrimary,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(14),
          ),
        ),
      ),
      body: Stack(
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            children: List.generate(
              homeModule.records != null ? homeModule.records!.length : 0,
              (index) {
                return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                        elevation: 10,
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(homeModule.records![index].fields!.moduleImage.toString(), fit: BoxFit.fill),
                                  ),
                                  custom_text(
                                    text: homeModule.records![index].fields!.moduleTitle.toString(),
                                    alignment: Alignment.center,
                                    textStyles: blackTextSemiBold14,
                                  ),
                                ],
                              ),
                              onTap: () {
                                Get.to(AddEmployee());
                              },
                            ),
                          ),
                        )));
              },
            ),
          ),
          Center(
            child: Visibility(child: const CircularProgressIndicator(strokeWidth: 5.0, backgroundColor: colors_name.colorPrimary), visible: isVisible),
          )
        ],
      ),
    ));
  }
}
