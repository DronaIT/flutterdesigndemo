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
  String? task_importance;
  String? remarks;
  List<String>? status_updated_by;

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
    this.status_updated_by,
    this.task_importance,
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
    status_updated_by = json['status_updated_by']?.cast<String>();
    task_importance = json['task_importance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Notes'] = Notes;
    data['ticket_type_id'] = ticket_type_id;
    data['field_type'] = field_type;
    data['assigned_to'] = assigned_to;
    data['authority_of'] = authority_of;
    data['attachments'] = attachments;
    data['created_by_student'] = createdByStudent;
    data['created_by_employee'] = createdByEmployee;
    data['created_by_organization'] = createdByOrganization;
    data['deadline'] = deadline;
    data['required_time'] = required_time;
    data['actual_time_taken'] = actual_time_taken;
    data['actual_finished_on'] = actual_finished_on;
    data['Status'] = Status;
    data['resolution_remark'] = remarks;
    data['status_updated_by'] = status_updated_by;
    data['task_importance'] = task_importance;
    return data;
  }
}
