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
  String? batch;
  String? passed_out_year;
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

  CreateStudentRequest({
    this.city,
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
    this.batch,
    this.passed_out_year,
    this.fatherNumber,
  });

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
    batch = json['batch'];
    passed_out_year = json['passed_out_year'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['joining_year'] = joiningYear;
    data['password'] = password;
    data['name'] = name;
    data['address'] = address;
    data['mobile_number'] = mobileNumber;
    data['gender'] = gender;
    data['hub_ids'] = hubIds;
    data['email'] = email;
    data['semester'] = semester;
    data['division'] = division;
    data['passed_out_year'] = passed_out_year;
    data['specialization_ids'] = specializationIds;
    data['batch'] = batch;
    data['pin_code'] = pinCode;
    data['sr_number'] = srNumber;
    data['birthdate'] = birthdate;
    data['aadhar_card_number'] = aadharCardNumber;
    data['caste'] = caste;
    data['hsc_school'] = hscSchool;
    data['hsc_school_city'] = hscSchoolCity;
    data['hsc_percentage'] = hscPercentage;
    data['mother_name'] = motherName;
    data['mother_number'] = motherNumber;
    data['father_number'] = fatherNumber;
    return data;
  }
}
