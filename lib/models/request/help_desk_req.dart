class HelpDeskRequest {
  String? Notes;
  List<String>? ticket_type_id;
  List<String>? assigned_to;
  List<Map<String, dynamic>>? attachments;
  List<String>? createdByEmployee;
  List<String>? createdByStudent;
  List<String>? createdByOrganization;

  HelpDeskRequest({
    this.Notes,
    this.ticket_type_id,
    this.assigned_to,
    this.attachments,
    this.createdByStudent,
    this.createdByEmployee,
    this.createdByOrganization
  });

  HelpDeskRequest.fromJson(Map<String, dynamic> json) {
    Notes = json['Notes'];
    ticket_type_id = json['ticket_type_id']?.cast<String>();
    assigned_to = json['assigned_to']?.cast<String>();
    attachments = json['attachments']?.cast<Map<String, dynamic>>();
    createdByStudent = json['created_by_student']?.cast<String>();
    createdByEmployee = json['created_by_employee']?.cast<String>();
    createdByOrganization = json['created_by_organization']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Notes'] = this.Notes;
    data['ticket_type_id'] = this.ticket_type_id;
    data['assigned_to'] = this.assigned_to;
    data['attachments'] = this.attachments;
    data['created_by_student'] = this.createdByStudent;
    data['created_by_employee'] = this.createdByEmployee;
    data['created_by_organization'] = this.createdByOrganization;
    return data;
  }
}
