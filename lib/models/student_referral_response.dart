class StudentReferralResponse {
  String? mobile_number;
  String? name;
  String? email;
  String? state;
  String? city;
  String? status;
  String? remarks;
  String? created_on;

  List<String>? hubNameFromHubIds;
  List<String>? hub_id;
  List<String>? specialization_id;
  List<String>? speNameFromSpeId;
  List<String>? student_id;
  List<String>? student_name;
  List<String>? status_updated_by;
  List<String>? status_updated_name;

  StudentReferralResponse({
    this.mobile_number,
    this.name,
    this.email,
    this.state,
    this.city,
    this.status,
    this.remarks,
    this.hubNameFromHubIds,
    this.hub_id,
    this.specialization_id,
    this.speNameFromSpeId,
    this.student_id,
    this.student_name,
    this.status_updated_by,
    this.status_updated_name,
    this.created_on,
  });

  StudentReferralResponse.fromJson(Map<String, dynamic> json) {
    mobile_number = json['mobile_number'];
    name = json['name'];
    email = json['email'];
    state = json['state'];
    city = json['city'];
    status = json['status'];
    remarks = json['remarks'];
    hubNameFromHubIds = json['hub_name (from hub_id)']?.cast<String>();
    hub_id = json['hub_id']?.cast<String>();
    specialization_id = json['specialization_id']?.cast<String>();
    speNameFromSpeId = json['specialization_name (from specialization_id)']?.cast<String>();
    student_id = json['student_id']?.cast<String>();
    student_name = json['student_name']?.cast<String>();
    status_updated_by = json['status_updated_by']?.cast<String>();
    status_updated_name = json['status_updated_name']?.cast<String>();
    created_on = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile_number'] = mobile_number;
    data['name'] = name;
    data['email'] = email;
    data['state'] = state;
    data['city'] = city;
    data['status'] = status;
    data['remarks'] = remarks;
    data['hub_name (from hub_id)'] = hubNameFromHubIds;
    data['hub_id'] = hub_id;
    data['specialization_id'] = specialization_id;
    data['specialization_name (from specialization_id)'] = speNameFromSpeId;
    data['student_id'] = student_id;
    data['student_name'] = student_name;
    data['status_updated_by'] = status_updated_by;
    data['status_updated_name'] = status_updated_name;
    data['created_on'] = created_on;
    return data;
  }
}
