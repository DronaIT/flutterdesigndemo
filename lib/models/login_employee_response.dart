class LoginEmployeResponse {
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
  String? email =" ";
  String? address;

  LoginEmployeResponse(
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
      this.password});

  LoginEmployeResponse.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    employeeId = json['employee_id'];
    city = json['city'];
    roleIds = json['role_ids'].cast<String>();
    employeeName = json['employee_name'];
    hubIds = json['hub_ids'].cast<String>();
    roleIdFromRoleIds = json['role_id (from role_ids)'].cast<String>();
    hubIdFromHubIds = json['hub_id (from hub_ids)'].cast<String>();
    employeeCode = json['employee_code'];
    mobileNumber = json['mobile_number'];
    password = json['password'];
    email = json['email'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['employee_id'] = this.employeeId;
    data['city'] = this.city;
    data['role_ids'] = this.roleIds;
    data['employee_name'] = this.employeeName;
    data['hub_ids'] = this.hubIds;
    data['role_id (from role_ids)'] = this.roleIdFromRoleIds;
    data['hub_id (from hub_ids)'] = this.hubIdFromHubIds;
    data['employee_code'] = this.employeeCode;
    data['mobile_number'] = this.mobileNumber;
    data['password'] = this.password;
    data['email'] = this.email;
    data['address'] = this.address;
    return data;
  }
}
