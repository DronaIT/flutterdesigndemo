import 'package:flutterdesigndemo/models/document_response.dart';

class HelpdeskResponses {
  String? ticketId;
  String? notes;
  List<String>? ticketTypeId;
  String? status;
  String? task_importance;
  List<String>? ticketTitle;
  List<String>? assignedTo;
  List<String>? assignedEmployeeName;
  List<String>? assignedMobileNumber;
  List<String>? assignedToToken;

  List<String>? createdByEmployee;
  List<String>? createdByEmployeeToken;
  List<String>? employeeRoleTitle;
  List<String>? employeeName;
  List<String>? employeeMobileNumber;

  List<String>? createdByStudent;
  List<String>? createdByStudentToken;
  List<String>? studentName;
  List<String>? studentHubName;
  List<String>? studentSpecializationName;
  List<String>? studentMobileNumber;

  List<String>? createdByOrganization;
  List<String>? createdByOrganizationToken;
  List<String>? companyName;
  List<String>? companyContactNumber;

  String? createdOn;
  String? resolutionRemark;
  String? fieldType;

  String? deadline;
  String? required_time;
  String? actual_time_taken;
  String? actual_finished_on;

  List<String>? status_updated_by;
  List<String>? status_updated_by_employee_name;
  List<DocumentResponse>? attachments;

  HelpdeskResponses.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    notes = json['Notes'];
    ticketTypeId = json['ticket_type_id']?.cast<String>();
    status = json['Status'];
    task_importance = json['task_importance'];
    ticketTitle = json['ticket_title']?.cast<String>();
    assignedTo = json['assigned_to']?.cast<String>();
    assignedEmployeeName = json['assigned_employee_name']?.cast<String>();
    assignedMobileNumber = json['assigned_mobile_number']?.cast<String>();
    assignedToToken = json['assigned_to_token']?.cast<String>();

    createdByEmployee = json['created_by_employee']?.cast<String>();
    createdByEmployeeToken = json['created_by_employee_token']?.cast<String>();
    employeeRoleTitle = json['employee_role_title']?.cast<String>();
    employeeName = json['employee_name']?.cast<String>();
    employeeMobileNumber = json['employee_mobile_number']?.cast<String>();

    createdByStudent = json['created_by_student']?.cast<String>();
    createdByStudentToken = json['created_by_student_token']?.cast<String>();
    studentName = json['student_name']?.cast<String>();
    studentHubName = json['student_hub_name']?.cast<String>();
    studentSpecializationName = json['student_specialization_name']?.cast<String>();
    studentMobileNumber = json['student_mobile_number']?.cast<String>();

    createdByOrganization = json['created_by_organization']?.cast<String>();
    createdByOrganizationToken = json['created_by_organization_token']?.cast<String>();
    companyName = json['company_name']?.cast<String>();
    companyContactNumber = json['company_contact_number']?.cast<String>();
    createdOn = json['created_on'];
    resolutionRemark = json['resolution_remark'];
    fieldType = json['field_type'];

    deadline = json['deadline'];
    required_time = json['required_time'];
    actual_time_taken = json['actual_time_taken'];
    actual_finished_on = json['actual_finished_on'];

    status_updated_by = json['status_updated_by']?.cast<String>();
    status_updated_by_employee_name = json['status_updated_by_employee_name']?.cast<String>();

    if (json['attachments'] != null) {
      attachments = <DocumentResponse>[];
      json['attachments'].forEach((v) {
        attachments!.add(DocumentResponse.fromJson(v));
      });
    }
  }

  HelpdeskResponses(
      {this.ticketId,
        this.notes,
        this.ticketTypeId,
        this.status,
        this.task_importance,
        this.ticketTitle,
        this.assignedTo,
        this.assignedEmployeeName,
        this.assignedMobileNumber,
        this.assignedToToken,
        this.createdByEmployee,
        this.createdByEmployeeToken,
        this.employeeRoleTitle,
        this.employeeName,
        this.employeeMobileNumber,
        this.createdByStudent,
        this.createdByStudentToken,
        this.studentName,
        this.studentHubName,
        this.studentMobileNumber,
        this.studentSpecializationName,
        this.createdByOrganization,
        this.createdByOrganizationToken,
        this.companyName,
        this.companyContactNumber,
        this.createdOn,
        this.resolutionRemark,
        this.fieldType,
        this.deadline,
        this.required_time,
        this.actual_time_taken,
        this.actual_finished_on,
        this.status_updated_by,
        this.status_updated_by_employee_name,
        this.attachments,
      });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticket_id'] = ticketId;
    data['Notes'] = notes;
    data['ticket_type_id'] = ticketTypeId;
    data['Status'] = status;
    data['task_importance'] = task_importance;
    data['ticket_title'] = ticketTitle;
    data['assigned_to'] = assignedTo;
    data['assigned_employee_name'] = assignedEmployeeName;
    data['assigned_mobile_number'] = assignedMobileNumber;
    data['assigned_to_token'] = assignedToToken;

    data['created_by_employee'] = createdByEmployee;
    data['created_by_employee_token'] = createdByEmployeeToken;
    data['employee_role_title'] = employeeRoleTitle;
    data['employee_name'] = employeeName;
    data['employee_mobile_number'] = employeeMobileNumber;

    data['created_by_student'] = createdByStudent;
    data['created_by_student_token'] = createdByStudentToken;
    data['student_name'] = studentName;
    data['student_hub_name'] = studentHubName;
    data['student_specialization_name'] = studentSpecializationName;
    data['student_mobile_number'] = studentMobileNumber;

    data['created_by_organization'] = createdByOrganization;
    data['created_by_organization_token'] = createdByOrganizationToken;
    data['company_name'] = companyName;
    data['company_contact_number'] = companyContactNumber;

    data['created_on'] = createdOn;
    data['resolution_remark'] = resolutionRemark;
    data['field_type'] = fieldType;

    data['deadline'] = deadline;
    data['required_time'] = required_time;
    data['actual_time_taken'] = actual_time_taken;
    data['actual_finished_on'] = actual_finished_on;

    data['status_updated_by'] = status_updated_by;
    data['status_updated_by_employee_name'] = status_updated_by_employee_name;

    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
