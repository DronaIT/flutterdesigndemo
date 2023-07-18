class HelpDeskRequest {
  String? Notes;
  List<String>? ticket_type_id;
  String? field_type;
  List<String>? assigned_to;
  List<String>? authority_of;
  List<Map<String, dynamic>>? attachments;
  List<String>? createdByEmployee;
  List<String>? createdByStudent;
  List<String>? createdByOrganization;
  String? deadline;
  String? required_time;
  String? actual_time_taken;
  String? actual_finished_on;
  String? Status;
  String? remarks;

  HelpDeskRequest({
    this.Notes,
    this.ticket_type_id,
    this.field_type,
    this.assigned_to,
    this.authority_of,
    this.attachments,
    this.createdByStudent,
    this.createdByEmployee,
    this.createdByOrganization,
    this.deadline,
    this.required_time,
    this.actual_time_taken,
    this.actual_finished_on,
    this.Status,
    this.remarks,
  });

  HelpDeskRequest.fromJson(Map<String, dynamic> json) {
    Notes = json['Notes'];
    ticket_type_id = json['ticket_type_id']?.cast<String>();
    field_type = json['field_type'];
    assigned_to = json['assigned_to']?.cast<String>();
    authority_of = json['authority_of']?.cast<String>();
    attachments = json['attachments']?.cast<Map<String, dynamic>>();
    createdByStudent = json['created_by_student']?.cast<String>();
    createdByEmployee = json['created_by_employee']?.cast<String>();
    createdByOrganization = json['created_by_organization']?.cast<String>();
    deadline = json['deadline'];
    required_time = json['required_time'];
    actual_time_taken = json['actual_time_taken'];
    actual_finished_on = json['actual_finished_on'];
    Status = json['Status'];
    remarks = json['resolution_remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Notes'] = this.Notes;
    data['ticket_type_id'] = this.ticket_type_id;
    data['field_type'] = this.field_type;
    data['assigned_to'] = this.assigned_to;
    data['authority_of'] = this.authority_of;
    data['attachments'] = this.attachments;
    data['created_by_student'] = this.createdByStudent;
    data['created_by_employee'] = this.createdByEmployee;
    data['created_by_organization'] = this.createdByOrganization;
    data['deadline'] = this.deadline;
    data['required_time'] = this.required_time;
    data['actual_time_taken'] = this.actual_time_taken;
    data['actual_finished_on'] = this.actual_finished_on;
    data['Status'] = this.Status;
    data['resolution_remark'] = this.remarks;
    return data;
  }
}
