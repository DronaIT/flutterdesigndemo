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

  AddEmployeeRequest({this.employee_name, this.city, this.mobileNumber, this.gender, this.email,
    this.hubIds, this.roleIds, this.address,
    this.parents_mobile_number,this.spouse_mobile_number, this.pin_code
  });

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_name'] = this.employee_name;
    data['city'] = this.city;
    data['mobile_number'] = this.mobileNumber;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['hub_ids'] = this.hubIds;
    data['role_ids'] = this.roleIds;
    data['address'] = this.address;
    data['parents_mobile_number'] = this.parents_mobile_number;
    data['spouse_mobile_number'] = this.spouse_mobile_number;
    data['pin_code'] = this.pin_code;
    return data;
  }
}
