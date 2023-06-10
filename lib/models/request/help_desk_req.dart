class HelpDeskRequest {
  String? Notes;
  List<String>? ticket_type_id;

  List<String>? assigned_to;

  List<Map<String, dynamic>>? attachments;

  HelpDeskRequest({
    this.Notes,
    this.ticket_type_id,
    this.assigned_to,
    this.attachments,
  });

  HelpDeskRequest.fromJson(Map<String, dynamic> json) {
    Notes = json['Notes'];
    ticket_type_id = json['ticket_type_id']?.cast<String>();
    assigned_to = json['assigned_to']?.cast<String>();
    attachments = json['attachments']?.cast<Map<String, dynamic>>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Notes'] = this.Notes;
    data['ticket_type_id'] = this.ticket_type_id;
    data['assigned_to'] = this.assigned_to;
    data['attachments'] = this.attachments;
    return data;
  }
}
