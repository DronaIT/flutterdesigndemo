class CreateStudentRequest {
  String? city;
  String? joiningYear;
  String? password;
  String? name;
  String? address;
  String? mobileNumber;
  String? gender;
  String? email;
  String? semester;
  String? division;

  List<String>? hubIds;
  List<String>? specializationIds;

  String? pinCode;
  String? srNumber;
  String? birthdate;
  String? aadharCardNumber;
  String? caste;
  String? hscSchool;
  String? hscSchoolCity;
  String? hscPercentage;
  String? motherName;
  String? motherNumber;
  String? fatherNumber;

  CreateStudentRequest(
      {this.city,
      this.joiningYear,
      this.password,
      this.name,
      this.address,
      this.mobileNumber,
      this.gender,
      this.email,
      this.hubIds,
      this.specializationIds,
      this.semester,
      this.division,
      this.pinCode,
      this.srNumber,
      this.birthdate,
      this.aadharCardNumber,
      this.caste,
      this.hscSchool,
      this.hscSchoolCity,
      this.hscPercentage,
      this.motherName,
      this.motherNumber,
      this.fatherNumber});

  CreateStudentRequest.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    joiningYear = json['joining_year'];
    password = json['password'];
    name = json['name'];
    address = json['address'];
    mobileNumber = json['mobile_number'];
    gender = json['gender'];
    email = json['email'];
    semester = json['semester'];
    division = json['division'];
    hubIds = json['hub_ids']?.cast<String>();
    specializationIds = json['specialization_ids']?.cast<String>();

    pinCode = json['pin_code'];
    srNumber = json['sr_number'];
    birthdate = json['birthdate'];
    aadharCardNumber = json['aadhar_card_number'];
    caste = json['caste'];
    hscSchool = json['hsc_school'];
    hscSchoolCity = json['hsc_school_city'];
    hscPercentage = json['hsc_percentage'];
    motherName = json['mother_name'];
    motherNumber = json['mother_number'];
    fatherNumber = json['father_number'];
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
    data['semester'] = this.semester;
    data['division'] = this.division;
    data['specialization_ids'] = this.specializationIds;

    data['pin_code'] = this.pinCode;
    data['sr_number'] = this.srNumber;
    data['birthdate'] = this.birthdate;
    data['aadhar_card_number'] = this.aadharCardNumber;
    data['caste'] = this.caste;
    data['hsc_school'] = this.hscSchool;
    data['hsc_school_city'] = this.hscSchoolCity;
    data['hsc_percentage'] = this.hscPercentage;
    data['mother_name'] = this.motherName;
    data['mother_number'] = this.motherNumber;
    data['father_number'] = this.fatherNumber;
    return data;
  }
}
