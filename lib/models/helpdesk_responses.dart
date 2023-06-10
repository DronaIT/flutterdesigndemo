class HelpdeskResponses {
  String? ticketId;
  String? notes;
  List<String>? ticketTypeId;
  String? status;
  List<String>? ticketTitle;
  List<String>? assignedTo;
  List<String>? assignedEmployeeName;
  List<String>? assignedMobileNumber;

  List<String>? createdByEmployee;
  List<String>? employeeRoleTitle;
  List<String>? employeeName;
  List<String>? employeeMobileNumber;

  List<String>? createdByStudent;
  List<String>? studentName;
  List<String>? studentHubName;
  List<String>? studentSpecializationName;

  List<String>? createdByOrganization;
  List<String>? companyName;
  List<String>? companyContactNumber;

  String? createdOn;

  HelpdeskResponses(
      {this.ticketId,
        this.notes,
        this.ticketTypeId,
        this.status,
        this.ticketTitle,
        this.assignedTo,
        this.assignedEmployeeName,
        this.assignedMobileNumber,
        this.createdByEmployee,
        this.employeeRoleTitle,
        this.employeeName,
        this.employeeMobileNumber,
        this.createdByStudent,
        this.studentName,
        this.studentHubName,
        this.studentSpecializationName,
        this.createdByOrganization,
        this.companyName,
        this.companyContactNumber,
        this.createdOn});

  HelpdeskResponses.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    notes = json['Notes'];
    ticketTypeId = json['ticket_type_id']?.cast<String>();
    status = json['Status'];
    ticketTitle = json['ticket_title']?.cast<String>();
    assignedTo = json['assigned_to']?.cast<String>();
    assignedEmployeeName = json['assigned_employee_name']?.cast<String>();
    assignedMobileNumber = json['assigned_mobile_number']?.cast<String>();

    createdByEmployee = json['created_by_employee']?.cast<String>();
    employeeRoleTitle = json['employee_role_title']?.cast<String>();
    employeeName = json['employee_name']?.cast<String>();
    employeeMobileNumber = json['employee_mobile_number']?.cast<String>();

    createdByStudent = json['created_by_student']?.cast<String>();
    studentName = json['student_name']?.cast<String>();
    studentHubName = json['student_hub_name']?.cast<String>();
    studentSpecializationName = json['student_specialization_name']?.cast<String>();

    createdByOrganization = json['created_by_organization']?.cast<String>();
    companyName = json['company_name']?.cast<String>();
    companyContactNumber = json['company_contact_number']?.cast<String>();
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticket_id'] = this.ticketId;
    data['Notes'] = this.notes;
    data['ticket_type_id'] = this.ticketTypeId;
    data['Status'] = this.status;
    data['ticket_title'] = this.ticketTitle;
    data['assigned_to'] = this.assignedTo;
    data['assigned_employee_name'] = this.assignedEmployeeName;
    data['assigned_mobile_number'] = this.assignedMobileNumber;

    data['created_by_employee'] = this.createdByEmployee;
    data['employee_role_title'] = this.employeeRoleTitle;
    data['employee_name'] = this.employeeName;
    data['employee_mobile_number'] = this.employeeMobileNumber;

    data['created_by_student'] = this.createdByStudent;
    data['student_name'] = this.studentName;
    data['student_hub_name'] = this.studentHubName;
    data['student_specialization_name'] = this.studentSpecializationName;

    data['created_by_organization'] = this.createdByOrganization;
    data['company_name'] = this.companyName;
    data['company_contact_number'] = this.companyContactNumber;

    data['created_on'] = this.createdOn;
    return data;
  }
}
