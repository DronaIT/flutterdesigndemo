class LoginEmployeeResponse {
  String? gender;
  int? employeeId;
  String? city;
  List<String>? roleIds;
  String? employeeName;
  List<String>? hubIds;
  List<String>? roleIdFromRoleIds;
  List<String>? hubIdFromHubIds;
  String? employeeCode;
  String? mobileNumber;
  String? password;
  String? email = " ";
  String? address;

  List<String>? lectureIds;
  List<String>? lectureDate;
  List<String>? unitTitle;
  List<String>? semester;
  List<String>? subjectTitle;
  List<String>? division;
  List<String>? specialization_name;

  String? parents_mobile_number;
  String? spouse_mobile_number = " ";
  String? pin_code;
  List<String>? accessible_hub_ids;
  List<String>? accessible_hub_ids_code;
  List<String>? hub_id_from_lecture;
  String? token;

  LoginEmployeeResponse(
      {this.gender,
      this.employeeId,
      this.city,
      this.roleIds,
      this.employeeName,
      this.hubIds,
      this.roleIdFromRoleIds,
      this.hubIdFromHubIds,
      this.employeeCode,
      this.mobileNumber,
      this.email,
      this.password,
      this.lectureIds,
      this.lectureDate,
      this.unitTitle,
      this.semester,
      this.subjectTitle,
      this.division,
      this.parents_mobile_number,
      this.spouse_mobile_number,
      this.pin_code,
      this.accessible_hub_ids,
      this.accessible_hub_ids_code,
      this.hub_id_from_lecture,
      this.token,
      this.specialization_name,});

  LoginEmployeeResponse.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    employeeId = json['employee_id'];
    city = json['city'];
    roleIds = json['role_ids']?.cast<String>();
    employeeName = json['employee_name'];
    hubIds = json['hub_ids']?.cast<String>();
    roleIdFromRoleIds = json['role_id (from role_ids)']?.cast<String>();
    hubIdFromHubIds = json['hub_id (from hub_ids)']?.cast<String>();
    employeeCode = json['employee_code'];
    mobileNumber = json['mobile_number'];
    password = json['password'];
    email = json['email'];
    address = json['address'];
    specialization_name = json['specialization_name']?.cast<String>();

    lectureIds = json['lecture_ids']?.cast<String>();
    lectureDate = json['lecture_date']?.cast<String>();
    unitTitle = json['unit_title']?.cast<String>();
    semester = json['semester']?.cast<String>();
    subjectTitle = json['subject_title']?.cast<String>();
    division = json['division']?.cast<String>();
    parents_mobile_number = json['parents_mobile_number'];
    spouse_mobile_number = json['spouse_mobile_number'];
    pin_code = json['pin_code'];
    accessible_hub_ids = json['accessible_hub_ids']?.cast<String>();
    accessible_hub_ids_code = json['accessible_hub_ids_code']?.cast<String>();
    hub_id_from_lecture = json['hub_id_from_lecture']?.cast<String>();
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = gender;
    data['employee_id'] = employeeId;
    data['city'] = city;
    data['role_ids'] = roleIds;
    data['employee_name'] = employeeName;
    data['hub_ids'] = hubIds;
    data['role_id (from role_ids)'] = roleIdFromRoleIds;
    data['hub_id (from hub_ids)'] = hubIdFromHubIds;
    data['employee_code'] = employeeCode;
    data['mobile_number'] = mobileNumber;
    data['password'] = password;
    data['email'] = email;
    data['address'] = address;
    data['lecture_ids'] = lectureIds;
    data['lecture_date'] = lectureDate;
    data['unit_title'] = unitTitle;
    data['semester'] = semester;
    data['subject_title'] = subjectTitle;
    data['division'] = division;
    data['parents_mobile_number'] = parents_mobile_number;
    data['spouse_mobile_number'] = spouse_mobile_number;
    data['pin_code'] = pin_code;
    data['accessible_hub_ids'] = accessible_hub_ids;
    data['accessible_hub_ids_code'] = accessible_hub_ids_code;
    data['hub_id_from_lecture'] = hub_id_from_lecture;
    data['token'] = token;
    data['specialization_name'] = specialization_name;

    return data;
  }
}
