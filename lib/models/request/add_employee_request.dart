class AddEmployeeRequest {
  String? employee_name;
  String? city;
  String? mobileNumber;
  String? gender;
  List<String>? hubIds;
  List<String>? roleIds;

  AddEmployeeRequest({this.employee_name, this.city, this.mobileNumber, this.gender, this.hubIds, this.roleIds});

  AddEmployeeRequest.fromJson(Map<String, dynamic> json) {
    employee_name = json['employee_name'];
    city = json['city'];
    mobileNumber = json['mobile_number'];
    gender = json['gender'];
    hubIds = json['hub_ids'].cast<String>();
    roleIds = json['role_ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_name'] = this.employee_name;
    data['city'] = this.city;
    data['mobile_number'] = this.mobileNumber;
    data['gender'] = this.gender;
    data['hub_ids'] = this.hubIds;
    data['role_ids'] = this.roleIds;
    return data;
  }
}
