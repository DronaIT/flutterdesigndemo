class AddEmployeeRequest {
  String? employee_name;
  String? city;
  String? mobileNumber;
  String? gender;
  String? email;
  String? address;
  List<String>? hubIds;
  List<String>? roleIds;

  String? parents_mobile_number;
  String? spouse_mobile_number = " ";
  String? pin_code;
  List<String>? accessible_hub_ids;

  AddEmployeeRequest(
      {this.employee_name,
      this.city,
      this.mobileNumber,
      this.gender,
      this.email,
      this.hubIds,
      this.roleIds,
      this.address,
      this.parents_mobile_number,
      this.spouse_mobile_number,
      this.pin_code,
      this.accessible_hub_ids});

  AddEmployeeRequest.fromJson(Map<String, dynamic> json) {
    employee_name = json['employee_name'];
    city = json['city'];
    mobileNumber = json['mobile_number'];
    gender = json['gender'];
    email = json['email'];
    address = json['address'];
    hubIds = json['hub_ids']?.cast<String>();
    roleIds = json['role_ids']?.cast<String>();
    parents_mobile_number = json['parents_mobile_number'];
    spouse_mobile_number = json['spouse_mobile_number'];
    pin_code = json['pin_code'];
    accessible_hub_ids = json['accessible_hub_ids']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_name'] = employee_name;
    data['city'] = city;
    data['mobile_number'] = mobileNumber;
    data['gender'] = gender;
    data['email'] = email;
    data['hub_ids'] = hubIds;
    data['role_ids'] = roleIds;
    data['address'] = address;
    data['parents_mobile_number'] = parents_mobile_number;
    data['spouse_mobile_number'] = spouse_mobile_number;
    data['pin_code'] = pin_code;
    data['accessible_hub_ids'] = accessible_hub_ids;
    return data;
  }
}
