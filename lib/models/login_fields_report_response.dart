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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['joining_year'] = this.joiningYear;
    data['name'] = this.name;
    data['address'] = this.address;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['enrollment_number'] = this.enrollmentNumber;
    data['division'] = this.division;
    data['semester'] = this.semester;
    data['birthdate'] = this.birthdate;

    data['subject'] = this.subject;
    data['specialization'] = this.specialization;
    data['hub'] = this.hub;

    return data;
  }
}
