class login {
  List<Records>? records;

  login({this.records});

  login.fromJson(Map<String, dynamic> json) {
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(new Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  String? id;
  String? createdTime;
  Fields? fields;

  Records({this.id, this.createdTime, this.fields});

  Records.fromJson(Map<String, dynamic> json) {
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
  List<String>? collegeIds;
  String? city;
  String? password;
  List<String>? branchIds;
  int? userId;
  String? name;
  String? address;
  String? mobileNumber;
  List<String>? roleIds;
  String? gender;
  String? createdOn;
  String? updatedOn;
  List<String>? roleIdFromRoleIds;
  List<String>? collegeIdFromCollegeId;
  List<String>? branchIdFromBranchIds;
  String? enrollmentNumber;

  Fields(
      {this.collegeIds,
      this.city,
      this.password,
      this.branchIds,
      this.userId,
      this.name,
      this.address,
      this.mobileNumber,
      this.roleIds,
      this.gender,
      this.createdOn,
      this.updatedOn,
      this.roleIdFromRoleIds,
      this.collegeIdFromCollegeId,
      this.branchIdFromBranchIds,
      this.enrollmentNumber});

  Fields.fromJson(Map<String, dynamic> json) {
    collegeIds = json['college_ids'].cast<String>();
    city = json['city'];
    password = json['password'];
    branchIds = json['branch_ids'].cast<String>();
    userId = json['user_id'];
    name = json['name'];
    address = json['address'];
    mobileNumber = json['mobile_number'];
    roleIds = json['role_ids'].cast<String>();
    gender = json['gender'];
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
    roleIdFromRoleIds = json['role_id (from role_ids)'].cast<String>();
    collegeIdFromCollegeId =
        json['college_id (from college_id)'].cast<String>();
    branchIdFromBranchIds = json['branch_id (from branch_ids)'].cast<String>();
    enrollmentNumber = json['enrollment_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['college_ids'] = this.collegeIds;
    data['city'] = this.city;
    data['password'] = this.password;
    data['branch_ids'] = this.branchIds;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['mobile_number'] = this.mobileNumber;
    data['role_ids'] = this.roleIds;
    data['gender'] = this.gender;
    data['created_on'] = this.createdOn;
    data['updated_on'] = this.updatedOn;
    data['role_id (from role_ids)'] = this.roleIdFromRoleIds;
    data['college_id (from college_id)'] = this.collegeIdFromCollegeId;
    data['branch_id (from branch_ids)'] = this.branchIdFromBranchIds;
    data['enrollment_number'] = this.enrollmentNumber;
    return data;
  }
}


