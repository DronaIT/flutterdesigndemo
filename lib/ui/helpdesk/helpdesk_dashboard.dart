import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/service_locator.dart';
import 'package:flutterdesigndemo/customwidget/app_widgets.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:flutterdesigndemo/utils/utils.dart';
import 'package:flutterdesigndemo/values/strings_name.dart';

class HelpdeskDashboard extends StatefulWidget {
  const HelpdeskDashboard({Key? key}) : super(key: key);

  @override
  State<HelpdeskDashboard> createState() => _HelpdeskDashboardState();
}

class _HelpdeskDashboardState extends State<HelpdeskDashboard> {
  final apiRepository = getIt.get<ApiRepository>();
  bool isVisible = false;

  bool canViewOther = false, canUpdateTicketStatus = false, canUpdateTicketCategory = false;

  List<BaseApiResponseWithSerializable<JobOpportunityResponse>>? ticketList = [];
  String offset = "";
  var loginId = "";

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  Future<void> getPermission() async {
    setState(() {
      isVisible = true;
    });
    var roleId = "";
    var isLogin = PreferenceUtils.getIsLogin();
    if (isLogin == 1) {
      roleId = TableNames.STUDENT_ROLE_ID;
      loginId = PreferenceUtils.getLoginData().studentId.toString();
    } else if (isLogin == 2) {
      var loginData = PreferenceUtils.getLoginDataEmployee();
      roleId = loginData.roleIdFromRoleIds!.join(',');
      loginId = loginData.employeeId.toString();
    } else if (isLogin == 3) {
      roleId = TableNames.ORGANIZATION_ROLE_ID;
      loginId = PreferenceUtils.getLoginDataOrganization().id.toString();
    }

    var query = "AND(FIND('${roleId}',role_ids)>0,module_ids='${TableNames.MODULE_HELP_DESK}')";
    try {
      var data = await apiRepository.getPermissionsApi(query);
      if (data.records!.isNotEmpty) {
        for (var i = 0; i < data.records!.length; i++) {
          if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_VIEW_OTHER_TICKET) {
            canViewOther = true;
          }else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_TICKET_STATUS) {
            canUpdateTicketStatus = true;
          }else if (data.records![i].fields!.permissionId == TableNames.PERMISSION_ID_UPDATE_TICKET_CATEGORY) {
            canUpdateTicketCategory = true;
          }
        }
        setState(() {
          isVisible = false;
        });
      } else {
        setState(() {
          isVisible = false;
        });
        Utils.showSnackBar(context, strings_name.str_something_wrong);
      }
    } on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }

  getRecords() async {
    setState(() {
      isVisible = true;
    });
    var query = "";
    if(canViewOther) {
      query = "OR(FIND('$loginId', ${TableNames.CLM_ASSIGNED_TO}, 0), ${TableNames.CLM_CREATED_BY_EMPLOYEE}='$loginId')";
    } else {
      query = "${TableNames.CLM_CREATED_BY_EMPLOYEE}='$loginId'";
    }

    try{
      var data = await apiRepository.getTicketsApi(query, offset);
      if (data.records!.isNotEmpty) {
        if (offset.isEmpty) {
          ticketList?.clear();
        }
        ticketList?.addAll(data.records as Iterable<BaseApiResponseWithSerializable<JobOpportunityResponse>>);
        offset = data.offset;
        if (offset.isNotEmpty) {
          getRecords();
        } else {
          setState(() {
            ticketList?.sort((a, b) => a.fields!.jobTitle!.trim().compareTo(b.fields!.jobTitle!.trim()));
            isVisible = false;
          });
        }
      } else {
        setState(() {
          isVisible = false;
          if (offset.isEmpty) {
            ticketList = [];
          }
        });
        offset = "";
      }
    }on DioError catch (e) {
      setState(() {
        isVisible = false;
      });
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showSnackBarUsingGet(errorMessage);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        appBar: AppWidgets.appBarWithoutBack(strings_name.str_help_desk),
        body: Stack(
          children: [
            Column(
              children: [

              ],
            )
          ],
        )
    ));
  }
}
