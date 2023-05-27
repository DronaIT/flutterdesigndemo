class HelpDeskResponse {
  String? id;
  String? createdTime;
  Fields? fields;

  HelpDeskResponse({this.id, this.createdTime, this.fields});

  HelpDeskResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields =
    json['fields'] != null ? new Fields.fromJson(json['fields']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdTime'] = this.createdTime;
    if (this.fields != null) {
      data['fields'] = this.fields!.toJson();
    }
    return data;
  }
}

class Fields {
  String? notes;
  List<String>? ticketTypeId;
  String? status;
  List<String>? assignedTo;
  String? ticketId;
  List<String>? ticketTitle;
  List<String>? assignedEmployeeName;
  List<String>? assignedMobileNumber;
  String? createdOn;

  Fields(
      {this.notes,
        this.ticketTypeId,
        this.status,
        this.assignedTo,
        this.ticketId,
        this.ticketTitle,
        this.assignedEmployeeName,
        this.assignedMobileNumber,
        this.createdOn});

  Fields.fromJson(Map<String, dynamic> json) {
    notes = json['Notes'];
    ticketTypeId = json['ticket_type_id'].cast<String>();
    status = json['Status'];
    assignedTo = json['assigned_to'].cast<String>();
    ticketId = json['ticket_id'];
    ticketTitle = json['ticket_title'].cast<String>();
    assignedEmployeeName = json['assigned_employee_name'].cast<String>();
    assignedMobileNumber = json['assigned_mobile_number'].cast<String>();
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Notes'] = this.notes;
    data['ticket_type_id'] = this.ticketTypeId;
    data['Status'] = this.status;
    data['assigned_to'] = this.assignedTo;
    data['ticket_id'] = this.ticketId;
    data['ticket_title'] = this.ticketTitle;
    data['assigned_employee_name'] = this.assignedEmployeeName;
    data['assigned_mobile_number'] = this.assignedMobileNumber;
    data['created_on'] = this.createdOn;
    return data;
  }
}