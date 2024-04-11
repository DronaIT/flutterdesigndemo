class StudentReferralRequest {
  String? name;
  String? mobile_number;
  String? email;
  String? state;
  String? city;
  List<String>? hub_id;
  List<String>? specialization_id;
  List<String>? added_by;
  List<String>? student_id;
  List<String>? status_updated_by;
  String? status;
  String? remarks;

  StudentReferralRequest({
    this.name,
    this.mobile_number,
    this.email,
    this.state,
    this.city,
    this.hub_id,
    this.specialization_id,
    this.added_by,
    this.student_id,
    this.status_updated_by,
    this.status,
    this.remarks,
  });

  StudentReferralRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile_number = json['mobile_number'];
    email = json['email'];
    state = json['state'];
    city = json['city'];
    hub_id = json['hub_id']?.cast<String>();
    specialization_id = json['specialization_id']?.cast<String>();
    added_by = json['added_by']?.cast<String>();
    student_id = json['student_id']?.cast<String>();
    status_updated_by = json['status_updated_by']?.cast<String>();
    status = json['status'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['mobile_number'] = mobile_number;
    data['email'] = email;
    data['state'] = state;
    data['city'] = city;
    data['hub_id'] = hub_id;
    data['specialization_id'] = specialization_id;
    data['added_by'] = added_by;
    data['student_id'] = student_id;
    data['status_updated_by'] = status_updated_by;
    data['status'] = status;
    data['remarks'] = remarks;
    return data;
  }
}
