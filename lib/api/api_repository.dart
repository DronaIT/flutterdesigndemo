import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/dio_exception.dart';
import 'package:flutterdesigndemo/api/api_request.dart';
import 'package:flutterdesigndemo/models/app_version_response.dart';
import 'package:flutterdesigndemo/models/fees_response.dart';
import 'package:flutterdesigndemo/models/helpdesk_responses.dart';
import 'package:flutterdesigndemo/models/job_opportunity_response.dart';
import 'package:flutterdesigndemo/models/marketing_response.dart';
import 'package:flutterdesigndemo/models/permission_response.dart';
import 'package:flutterdesigndemo/models/punch_data_response.dart';
import 'package:flutterdesigndemo/models/request/add_placement_attendance_data.dart';
import 'package:flutterdesigndemo/models/request/add_punch_request.dart';
import 'package:flutterdesigndemo/models/request/add_student_attendance_request.dart';
import 'package:flutterdesigndemo/models/request/add_employee_request.dart';
import 'package:flutterdesigndemo/models/request/add_hub_request.dart';
import 'package:flutterdesigndemo/models/request/add_specialization_request.dart';
import 'package:flutterdesigndemo/models/request/add_subject_request.dart';
import 'package:flutterdesigndemo/models/request/add_topics_request.dart';
import 'package:flutterdesigndemo/models/request/add_units_request.dart';
import 'package:flutterdesigndemo/models/request/create_job_opportunity_request.dart';
import 'package:flutterdesigndemo/models/request/create_student_request.dart';
import 'package:flutterdesigndemo/models/hub_response.dart';
import 'package:flutterdesigndemo/models/request/fees_request.dart';
import 'package:flutterdesigndemo/models/request/marketing_request.dart';
import 'package:flutterdesigndemo/models/role_response.dart';
import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/login_employee_response.dart';
import 'package:flutterdesigndemo/models/base_api_response.dart';
import 'package:flutterdesigndemo/models/createpassword.dart';
import 'package:flutterdesigndemo/models/home_module_response.dart';
import 'package:flutterdesigndemo/models/createpasswordemployee.dart';
import 'package:flutterdesigndemo/models/login_fields_response.dart';
import 'package:flutterdesigndemo/models/student_attendance_response.dart';
import 'package:flutterdesigndemo/models/subject_response.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/models/typeofsectoreresponse.dart';
import 'package:flutterdesigndemo/models/units_response.dart';
import 'package:flutterdesigndemo/models/update_job_opportunity.dart';
import 'package:flutterdesigndemo/models/update_specialization.dart';
import 'package:flutterdesigndemo/models/update_student_attendance.dart';
import 'package:flutterdesigndemo/models/update_subject.dart';
import 'package:flutterdesigndemo/models/update_topics.dart';
import 'package:flutterdesigndemo/models/update_units.dart';
import 'package:flutterdesigndemo/models/updatehub.dart';
import 'package:flutterdesigndemo/models/viewemployeeresponse.dart';

import '../models/App_data_response.dart';
import '../models/add_announcement_response.dart';
import '../models/add_time_table_response.dart';
import '../models/announcement_response.dart';
import '../models/company_approch_response.dart';
import '../models/company_detail_response.dart';
import '../models/help_desk_response.dart';
import '../models/help_desk_type_response.dart';
import '../models/request/add_time_table_response.dart';
import '../models/request/create_company_appr_req.dart';
import '../models/request/create_company_det_req.dart';
import '../models/request/help_desk_req.dart';

class ApiRepository {
  final ApiRequest userApi;

  ApiRepository(this.userApi);

  Future<BaseLoginResponse<LoginFieldsResponse>> loginApi(String query, [String offset = ""]) async {
    try {
      final response = await userApi.loginRegisterApi(query, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<LoginEmployeResponse>> loginEmployeeApi(String query) async {
    try {
      final response = await userApi.loginRegisterEmployeeApi(query);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<LoginFieldsResponse>> registerApi(String query) async {
    try {
      final response = await userApi.loginRegisterApi(query);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<LoginEmployeResponse>> registerEmployeeApi(String query) async {
    try {
      final response = await userApi.loginRegisterEmployeeApi(query);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<CreatePasswordResponse> createPasswordApi(Map<String, String> loginFormula, String recordId) async {
    try {
      final response = await userApi.createPasswordApi(loginFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<CreatePasswordEmployeeResponse> createPasswordEmpApi(Map<String, String> loginFormula, String recordId) async {
    try {
      final response = await userApi.createPasswordEmployeeApi(loginFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<homeModuleResponse>> getHomeModulesApi(String homeModuleFormula) async {
    try {
      final response = await userApi.getHomeModulesApi(homeModuleFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<CreatePasswordResponse>> createStudentApi(List<Map<String, CreateStudentRequest>> createStudentFormula) async {
    try {
      final response = await userApi.createStudentApi(createStudentFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyApprochResponse>> creCompanyApprochApi(List<Map<String, CreateCompanyaRequest>> createCompFormula) async {
    try {
      final response = await userApi.createCompanyApproachApi(createCompFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyDetailResponse>> createCompanyDetailApi(List<Map<String, CreateCompanyDetailRequest>> createCompFormula) async {
    try {
      final response = await userApi.createCompanyDetailApi(createCompFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<RoleResponse>> getRolesApi() async {
    try {
      final response = await userApi.getRolesApi();
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<HubResponse>> getHubApi() async {
    try {
      final response = await userApi.getHubApi();
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyApprochResponse>> getCompanyApproachApi(String formula, [String offset = ""]) async {
    try {
      final response = await userApi.getCompanyApproachApi(formula, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyDetailResponse>> getCompanyDetailApi(String formula, [String offset = ""]) async {
    try {
      final response = await userApi.getCompanyDetailApi(formula, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<SpecializationResponse>> getSpecializationApi() async {
    try {
      final response = await userApi.getSpecializationApi();
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<TypeOfsectoreResponse>> getSectorApi() async {
    try {
      final response = await userApi.getSectorsApi();
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<LoginEmployeResponse>> addEmployeeApi(AddEmployeeRequest addEmployeeFormula) async {
    try {
      final response = await userApi.addEmployeeApi(addEmployeeFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<PermissionResponse>> getPermissionsApi(String permissionFormula) async {
    try {
      final response = await userApi.getPermissionsApi(permissionFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<ViewEmployeeResponse>> viewEmployeeApi(String viewEmpFormula) async {
    try {
      final response = await userApi.viewEmployeeApi(viewEmpFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<CreatePasswordEmployeeResponse> updateEmployeeApi(Map<String, dynamic> loginFormula, String recordId) async {
    try {
      final response = await userApi.updateEmployeeApi(loginFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<CreatePasswordResponse> updateStudentApi(Map<String, dynamic> loginFormula, String recordId) async {
    try {
      final response = await userApi.updateStudentApi(loginFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<SpecializationResponse>> getSpecializationDetailApi(String detailFormula) async {
    try {
      final response = await userApi.getSpecializationDetailApi(detailFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<HubResponse>> addHubApi(AddHubRequest addHubRequest) async {
    try {
      final response = await userApi.addHubApi(addHubRequest);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<UpdateHub> updateHubApi(Map<String, dynamic> loginFormula, String recordId) async {
    try {
      final response = await userApi.updateHubApi(loginFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<SubjectResponse>> getSubjectsApi(String detailFormula) async {
    try {
      final response = await userApi.getSubjectsApi(detailFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<UnitsResponse>> getUnitsApi(String unitsFormula) async {
    try {
      final response = await userApi.getUnitsApi(unitsFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<TopicsResponse>> getTopicsApi(String topicsFormula) async {
    try {
      final response = await userApi.getTopicsApi(topicsFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<SpecializationResponse>> addSpecializationApi(AddSpecializationRequest addSpecializationRequest) async {
    try {
      final response = await userApi.addSpecializationApi(addSpecializationRequest);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<UpdateSpecialization> updateSpecializationApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      final response = await userApi.updateSpecializationApi(updateFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<SubjectResponse>> addSubjectApi(AddSubjectRequest addSubjectRequest) async {
    try {
      final response = await userApi.addSubjectApi(addSubjectRequest);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<UpdateSubject> updateSubjectApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      final response = await userApi.updateSubjectApi(updateFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<UpdateSubject> updateCompanyDetailApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      final response = await userApi.updateCompanyDetailApi(updateFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<UnitsResponse>> addUnitsApi(AddUnitsRequest addUnitsRequest) async {
    try {
      final response = await userApi.addUnitsApi(addUnitsRequest);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<UpdateUnits> updateUnitsApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      final response = await userApi.updateUnitsApi(updateFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<TopicsResponse>> addTopicApi(AddTopicsRequest addTopicsRequest) async {
    try {
      final response = await userApi.addTopicApi(addTopicsRequest);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<UpdateTopics> updateTopicsApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      final response = await userApi.updateTopicsApi(updateFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<StudentAttendanceResponse>> addStudentAttendanceApi(AddStudentAttendanceRequest request) async {
    try {
      final response = await userApi.addStudentAttendanceApi(request);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<StudentAttendanceResponse>> studentAttendanceDetailApi(String recordId) async {
    try {
      final response = await userApi.studentAttendanceApi(recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<StudentAttendanceResponse>> getStudentAttendanceApi(String attendanceFormula, [String offset = ""]) async {
    try {
      final response = await userApi.getStudentAttendanceApi(attendanceFormula, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<UpdateStudentAttendance> updateStudentAttendanceApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      final response = await userApi.updateStudentAttendanceApi(updateFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<JobOpportunityResponse>> createJobOpportunityApi(CreateJobOpportunityRequest request) async {
    try {
      final response = await userApi.createJobOpportunityApi(request);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<JobOpportunityResponse>> getJobOppoApi(String jobFormula, [String offset = ""]) async {
    try {
      final response = await userApi.getJobOppoApi(jobFormula, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<UpdateJobOpportunity> updateJobOpportunityApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      final response = await userApi.updateJobOpportunityApi(updateFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<UpdateJobOpportunity> updateJobSortListedApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      final response = await userApi.updateJobSortListedApi(updateFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<JobOpportunityResponse>> getJobOpportunityApi(String jobOpportunityFormula) async {
    try {
      final response = await userApi.getJobOpportunityApi(jobOpportunityFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<CreatePasswordResponse> updateStudentDataApi(Map<String, dynamic> loginFormula, String recordId) async {
    try {
      final response = await userApi.updateStudentDataApi(loginFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<AddAnnouncementResponse> updateAnnouncementDataApi(Map<String, dynamic> loginFormula, String recordId) async {
    try {
      final response = await userApi.updateAnnouncementApi(loginFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<AddAnnouncementResponse> removeAnnouncementDataApi(Map<String, dynamic> loginFormula, String recordId) async {
    try {
      final response = await userApi.removeAnnouncementApi(loginFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<AddTimeTableResponse> updateTimeTableDataApi(Map<String, dynamic> loginFormula, String recordId) async {
    try {
      final response = await userApi.updateTimeTableApi(loginFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<UpdateJobOpportunity> getJobOpportunityWithRecordIdApi(String recordId) async {
    try {
      final response = await userApi.getJobOpportunityWithRecordIdApi(recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<AddPlacementAttendanceData>> updatePlacementInfoApi(Map<String, dynamic> request) async {
    try {
      final response = await userApi.updatePlacementInfoApi(request);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<AppVersionResponse>> getAppVersions() async {
    try {
      final response = await userApi.getAppVersions();
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<App_data_response>> getAppData() async {
    try {
      final response = await userApi.getAppData();
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<App_data_response>> addAppDataApi(Map<String, dynamic> data) async {
    try {
      final response = await userApi.addAppDataApi(data);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseResponse<AddAnnouncementResponse>> addAnnouncementDataApi(Map<String, dynamic> data) async {
    try {
      final response = await userApi.addAnnouncementDataApi(data);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseResponse<AddTimeTableResponse>> addTimeTableDataApi(Map<String, dynamic> data) async {
    try {
      final response = await userApi.addTimeTableDataApi(data);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<LoginFieldsResponse>> addToken(Map<String, dynamic> data, String recordId) async {
    try {
      final response = await userApi.addToken(data, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<LoginEmployeResponse>> addTokenEmployee(Map<String, dynamic> data, String recordId) async {
    try {
      final response = await userApi.addTokenEmployee(data, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<HelpDeskTypeResponse>> getHelpdesk() async {
    try {
      final response = await userApi.getHelpdesk();
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<HelpDeskResponse> addHelpDeskApi(HelpDeskRequest helpDeskReq) async {
    try {
      final response = await userApi.addHelpDeskApi(helpDeskReq);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyDetailResponse>> addTokenOrganization(Map<String, dynamic> data, String recordId) async {
    try {
      final response = await userApi.addTokenOrganization(data, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<HelpdeskResponses>> getTicketsApi(String ticketFormula, [String offset = ""]) async {
    try {
      final response = await userApi.getTicketsApi(ticketFormula, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<HelpDeskResponse> updateTicket(Map<String, dynamic> ticketFormula, String recordId) async {
    try {
      final response = await userApi.updateTicket(ticketFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<ViewEmployeeResponse>> getEmployeeListApi(String viewEmpFormula, [String offset = ""]) async {
    try {
      final response = await userApi.getEmployeeListApi(viewEmpFormula, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseResponse<AnnouncementResponse>> fetchAnnouncementListApi(String viewEmpFormula, [String offset = ""]) async {
    try {
      final response = await userApi.fetchAnnouncementApi(viewEmpFormula, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseResponse<TimeTableResponseClass>> fetchTimeTablesListApi(String viewEmpFormula, [String offset = "",int? pageSize]) async {
    try {
      final response = await userApi.fetchTimeTablesApi(viewEmpFormula, offset,pageSize);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyDetailResponse>> getSelfPlaceCompanyDetailApi(String formula, [String offset = ""]) async {
    try {
      final response = await userApi.getSelfPlaceCompanyDetailApi(formula, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<JobOpportunityResponse>> getSelfPlaceJobDetailApi(String formula, [String offset = ""]) async {
    try {
      final response = await userApi.getSelfPlaceJobDetailApi(formula, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<CompanyDetailResponse>> createSelfPlaceCompanyApi(List<Map<String, CreateCompanyDetailRequest>> createCompFormula) async {
    try {
      final response = await userApi.createSelfPlaceCompanyApi(createCompFormula);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<UpdateSubject> updateSelfPlaceCompanyApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      final response = await userApi.updateSelfPlaceCompanyApi(updateFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<JobOpportunityResponse>> createSelfPlaceJobApi(Map<String, dynamic> request) async {
    try {
      final response = await userApi.createSelfPlaceJobApi(request);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<UpdateJobOpportunity> updateSelfPlaceJobApi(Map<String, dynamic> updateFormula, String recordId) async {
    try {
      final response = await userApi.updateSelfPlaceJobApi(updateFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<MarketingResponse>> getMarketingRecordsApi(String marketingFormula, [String offset = ""]) async {
    try {
      final response = await userApi.getMarketingRecordsApi(marketingFormula, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<MarketingResponse>> addMarketingRecordApi(MarketingRequest marketingReq) async {
    try {
      final response = await userApi.addMarketingRecordApi(marketingReq);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<MarketingResponse>> updateMarketingRecord(Map<String, dynamic> marketingFormula, String recordId) async {
    try {
      final response = await userApi.updateMarketingRecord(marketingFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<FeesResponse>> getFeesRecordsApi(String feesFormula, [String offset = ""]) async {
    try {
      final response = await userApi.getFeesRecordsApi(feesFormula, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<FeesResponse>> addFeesRecordApi(FeesRequest feesReq) async {
    try {
      final response = await userApi.addFeesRecordApi(feesReq);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<FeesResponse>> updateFeesRecord(Map<String, dynamic> feesFormula, String recordId) async {
    try {
      final response = await userApi.updateFeesRecord(feesFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseLoginResponse<PunchDataResponse>> getPunchRecordsApi(String punchFormula, [String offset = ""]) async {
    try {
      final response = await userApi.getPunchRecordsApi(punchFormula, offset);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<PunchDataResponse>> addPunchRecordApi(AddPunchRequest punchReq) async {
    try {
      final response = await userApi.addPunchRecordApi(punchReq);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }

  Future<BaseApiResponseWithSerializable<PunchDataResponse>> updatePunchRecord(Map<String, dynamic> punchFormula, String recordId) async {
    try {
      final response = await userApi.updatePunchRecord(punchFormula, recordId);
      return response;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      rethrow;
    }
  }
}