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
  List<String>? hubIds;
  List<String>? roleIdFromRoleIds;
  List<String>? hubIdFromHubIds;
  String? employeeCode;
  String? createdOn;
  String? updatedOn;

  ViewEmployeeResponse(
      {this.gender,
      this.employeeId,
      this.city,
      this.roleIds,
      this.mobileNumber, this.email,
      this.employeeName,
      this.password,
      this.hubIds,
      this.roleIdFromRoleIds,
      this.hubIdFromHubIds,
      this.employeeCode,
      this.createdOn,
        this.address,
      this.updatedOn});

  ViewEmployeeResponse.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    employeeId = json['employee_id'];
    city = json['city'];
    email = json['email'];
    address = json['address'];
    roleIds = json['role_ids'].cast<String>();
    mobileNumber = json['mobile_number'];
    employeeName = json['employee_name'];
    password = json['password'];
    hubIds = json['hub_ids'].cast<String>();
    roleIdFromRoleIds = json['role_id (from role_ids)'].cast<String>();
    hubIdFromHubIds = json['hub_id (from hub_ids)'].cast<String>();
    employeeCode = json['employee_code'];
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['employee_id'] = this.employeeId;
    data['city'] = this.city;
    data['email'] = this.email;
    data['address'] = this.address;
    data['role_ids'] = this.roleIds;
    data['mobile_number'] = this.mobileNumber;
    data['employee_name'] = this.employeeName;
    data['password'] = this.password;
    data['hub_ids'] = this.hubIds;
    data['role_id (from role_ids)'] = this.roleIdFromRoleIds;
    data['hub_id (from hub_ids)'] = this.hubIdFromHubIds;
    data['employee_code'] = this.employeeCode;
    data['created_on'] = this.createdOn;
    data['updated_on'] = this.updatedOn;
    return data;
  }
}
