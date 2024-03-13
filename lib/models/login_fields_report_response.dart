class LoginFieldsReportResponse {
  String? city;
  String? joiningYear;
  String? name;
  String? address;
  String? mobileNumber;
  String? email = " ";
  String? gender;
  String? enrollmentNumber;
  String? division;
  String? semester;
  String? birthdate;
  String? subject;
  String? specialization;
  String? hub;

  LoginFieldsReportResponse({
    this.city,
    this.joiningYear,
    this.name,
    this.address,
    this.mobileNumber,
    this.email,
    this.gender,
    this.enrollmentNumber,
    this.division,
    this.semester,
    this.birthdate,
    this.subject,
    this.specialization,
    this.hub,
  });

  LoginFieldsReportResponse.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    joiningYear = json['joining_year'];
    name = json['name'];
    address = json['address'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    gender = json['gender'];
    enrollmentNumber = json['enrollment_number'];
    division = json['division'];
    semester = json['semester'];
    birthdate = json['birthdate'];

    subject = json['subject'];
    specialization = json['specialization'];
    hub = json['hub'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['joining_year'] = joiningYear;
    data['name'] = name;
    data['address'] = address;
    data['mobile_number'] = mobileNumber;
    data['email'] = email;
    data['gender'] = gender;
    data['enrollment_number'] = enrollmentNumber;
    data['division'] = division;
    data['semester'] = semester;
    data['birthdate'] = birthdate;

    data['subject'] = subject;
    data['specialization'] = specialization;
    data['hub'] = hub;

    return data;
  }
}
