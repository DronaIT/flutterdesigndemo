class ViewEmployeeResponse {
  String? gender;
  int? employeeId;
  String? city;
  List<String>? roleIds;
  String? mobileNumber;
  String? email;
  String? address;
  String? employeeName;
  String? password;
  String? token;
  List<String>? hubIds;
  List<String>? roleIdFromRoleIds;
  List<String>? hubIdFromHubIds;
  List<String>? roleTitleFromRoleIds;
  String? employeeCode;
  String? createdOn;
  String? updatedOn;
  String? parents_mobile_number = "";
  String? spouse_mobile_number = "";
  String? pin_code = "";
  List<String>? accessible_hub_ids;
  List<String>? accessible_hub_codes;
  String? is_working;
  bool selected = false;
  String? actual_in_time = "";
  String? actual_out_time = "";

  ViewEmployeeResponse({
    this.gender,
    this.employeeId,
    this.city,
    this.roleIds,
    this.mobileNumber,
    this.email,
    this.employeeName,
    this.password,
    this.token,
    this.hubIds,
    this.roleIdFromRoleIds,
    this.hubIdFromHubIds,
    this.roleTitleFromRoleIds,
    this.employeeCode,
    this.createdOn,
    this.address,
    this.updatedOn,
    this.parents_mobile_number,
    this.spouse_mobile_number,
    this.pin_code,
    this.accessible_hub_ids,
    this.accessible_hub_codes,
    this.is_working,
    this.actual_in_time,
    this.actual_out_time,
  });

  ViewEmployeeResponse.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    employeeId = json['employee_id'];
    city = json['city'];
    email = json['email'];
    address = json['address'];
    roleIds = json['role_ids']?.cast<String>();
    mobileNumber = json['mobile_number'];
    employeeName = json['employee_name'];
    password = json['password'];
    token = json['token'];
    hubIds = json['hub_ids']?.cast<String>();
    roleIdFromRoleIds = json['role_id (from role_ids)']?.cast<String>();
    hubIdFromHubIds = json['hub_id (from hub_ids)']?.cast<String>();
    roleTitleFromRoleIds = json['role_title (from role_ids)']?.cast<String>();
    employeeCode = json['employee_code'];
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
    parents_mobile_number = json['parents_mobile_number'];
    spouse_mobile_number = json['spouse_mobile_number'];
    pin_code = json['pin_code'];
    accessible_hub_ids = json['accessible_hub_ids']?.cast<String>();
    accessible_hub_codes = json['accessible_hub_ids_code']?.cast<String>();
    is_working = json['is_working'];
    actual_in_time = json['actual_in_time'];
    actual_out_time = json['actual_out_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = gender;
    data['employee_id'] = employeeId;
    data['city'] = city;
    data['email'] = email;
    data['address'] = address;
    data['role_ids'] = roleIds;
    data['mobile_number'] = mobileNumber;
    data['employee_name'] = employeeName;
    data['password'] = password;
    data['token'] = token;
    data['hub_ids'] = hubIds;
    data['role_id (from role_ids)'] = roleIdFromRoleIds;
    data['hub_id (from hub_ids)'] = hubIdFromHubIds;
    data['role_title (from role_ids)'] = roleTitleFromRoleIds;
    data['employee_code'] = employeeCode;
    data['created_on'] = createdOn;
    data['updated_on'] = updatedOn;
    data['parents_mobile_number'] = parents_mobile_number;
    data['spouse_mobile_number'] = spouse_mobile_number;
    data['pin_code'] = pin_code;
    data['accessible_hub_ids'] = accessible_hub_ids;
    data['accessible_hub_ids_code'] = accessible_hub_codes;
    data['is_working'] = is_working;
    data['actual_in_time'] = actual_in_time;
    data['actual_out_time'] = actual_out_time;
    return data;
  }
}
