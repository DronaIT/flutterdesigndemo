class CreateStudentRequest {
  String? city;
  String? joiningYear;
  String? password;
  String? name;
  String? address;
  String? mobileNumber;
  String? gender;
  String? email;

  List<String>? hubIds;
  List<String>? specializationIds;

  CreateStudentRequest({this.city, this.joiningYear, this.password, this.name, this.address, this.mobileNumber, this.gender, this.email, this.hubIds, this.specializationIds});

  CreateStudentRequest.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    joiningYear = json['joining_year'];
    password = json['password'];
    name = json['name'];
    address = json['address'];
    mobileNumber = json['mobile_number'];
    gender = json['gender'];
    email = json['email'];
    hubIds = json['hub_ids']?.cast<String>();
    specializationIds = json['specialization_ids']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['joining_year'] = this.joiningYear;
    data['password'] = this.password;
    data['name'] = this.name;
    data['address'] = this.address;
    data['mobile_number'] = this.mobileNumber;
    data['gender'] = this.gender;
    data['hub_ids'] = this.hubIds;
    data['email'] = this.email;
    data['specialization_ids'] = this.specializationIds;
    return data;
  }
}
