class LoginFieldsResponse {
  String? city;
  String? joiningYear;
  String? password;
  int? studentId;
  List<String>? hubIds;
  String? name;
  String? address;
  String? mobileNumber;
  String? email = " ";
  List<String>? specializationIds;
  String? gender;
  String? createdOn;
  String? updatedOn;
  String? enrollmentNumber;
  List<String>? hubIdFromHubIds;
  List<String>? specializationIdFromSpecializationIds;

  String? division;
  String? semester;
  List<String>? lectureIds;
  List<String>? absentLectureIds;
  List<String>? absentLectureDate;
  List<String>? absentSubjectTitle;
  List<String>? absentSubjectId;

  List<String>? presentLectureIds;
  List<String>? presentLectureDate;
  List<String>? presentSubjectTitle;
  List<String>? presentSubjectId;
  List<String>? lecture_date;
  int attendanceStatus = 1;

  String? sr_number;
  String? birthdate;
  String? aadhar_card_number;
  String? caste;
  String? hsc_school;
  String? hsc_school_city;
  String? hsc_percentage;
  String? mother_name;
  String? mother_number;
  String? father_number;
  String? pin_code;

  LoginFieldsResponse({
    this.city,
    this.joiningYear,
    this.password,
    this.studentId,
    this.hubIds,
    this.name,
    this.address,
    this.mobileNumber,
    this.email,
    this.specializationIds,
    this.gender,
    this.createdOn,
    this.updatedOn,
    this.enrollmentNumber,
    this.hubIdFromHubIds,
    this.specializationIdFromSpecializationIds,
    this.division,
    this.semester,
    this.lectureIds,
    this.absentLectureIds,
    this.absentLectureDate,
    this.absentSubjectTitle,
    this.absentSubjectId,
    this.presentLectureIds,
    this.presentLectureDate,
    this.presentSubjectTitle,
    this.presentSubjectId,
    this.lecture_date,
    this.sr_number,
    this.birthdate,
    this.aadhar_card_number,
    this.caste,
    this.hsc_school,
    this.hsc_school_city,
    this.hsc_percentage,
    this.mother_name,
    this.mother_number,
    this.father_number,
    this.pin_code,
  });

  LoginFieldsResponse.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    joiningYear = json['joining_year'];
    password = json['password'];
    studentId = json['student_id'];
    hubIds = json['hub_ids']?.cast<String>();
    name = json['name'];
    address = json['address'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    specializationIds = json['specialization_ids']?.cast<String>();
    gender = json['gender'];
    createdOn = json['created_on'];
    updatedOn = json['updated_on'];
    enrollmentNumber = json['enrollment_number'];
    hubIdFromHubIds = json['hub_id (from hub_ids)']?.cast<String>();
    specializationIdFromSpecializationIds = json['specialization_id (from specialization_ids)']?.cast<String>();

    division = json['division'];
    semester = json['semester'];
    lectureIds = json['lecture_ids']?.cast<String>();
    absentLectureIds = json['absent_lecture_ids']?.cast<String>();
    absentLectureDate = json['absent_lecture_date']?.cast<String>();
    absentSubjectTitle = json['absent_subject_title']?.cast<String>();
    absentSubjectId = json['absent_subject_id']?.cast<String>();
    presentLectureIds = json['present_lecture_ids']?.cast<String>();
    presentLectureDate = json['present_lecture_date']?.cast<String>();
    presentSubjectTitle = json['present_subject_title']?.cast<String>();
    presentSubjectId = json['present_subject_id']?.cast<String>();
    lecture_date = json['lecture_date']?.cast<String>();

    sr_number = json['sr_number'];
    birthdate = json['birthdate'];
    aadhar_card_number = json['aadhar_card_number'];
    caste = json['caste'];
    hsc_school = json['hsc_school'];
    hsc_school_city = json['hsc_school_city'];
    hsc_percentage = json['hsc_percentage'];
    mother_name = json['mother_name'];
    mother_number = json['mother_number'];
    father_number = json['father_number'];
    pin_code = json['pin_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['joining_year'] = this.joiningYear;
    data['password'] = this.password;
    data['student_id'] = this.studentId;
    data['hub_ids'] = this.hubIds;
    data['name'] = this.name;
    data['address'] = this.address;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['specialization_ids'] = this.specializationIds;
    data['gender'] = this.gender;
    data['created_on'] = this.createdOn;
    data['updated_on'] = this.updatedOn;
    data['enrollment_number'] = this.enrollmentNumber;
    data['hub_id (from hub_ids)'] = this.hubIdFromHubIds;
    data['specialization_id (from specialization_ids)'] = this.specializationIdFromSpecializationIds;
    data['division'] = this.division;
    data['semester'] = this.semester;
    data['lecture_ids'] = this.lectureIds;
    data['absent_lecture_ids'] = this.absentLectureIds;
    data['absent_lecture_date'] = this.absentLectureDate;
    data['absent_subject_title'] = this.absentSubjectTitle;
    data['absent_subject_id'] = this.absentSubjectId;
    data['present_lecture_date'] = this.presentLectureDate;
    data['present_subject_title'] = this.presentSubjectTitle;
    data['present_subject_id'] = this.presentSubjectId;
    data['present_lecture_ids'] = this.presentLectureIds;
    data['lecture_date'] = this.lecture_date;



    data['sr_number'] = this.sr_number;
    data['birthdate'] = this.birthdate;
    data['aadhar_card_number'] = this.aadhar_card_number;
    data['caste'] = this.caste;
    data['hsc_school'] = this.hsc_school;
    data['hsc_school_city'] = this.hsc_school_city;
    data['hsc_percentage'] = this.hsc_percentage;
    data['mother_name'] = this.mother_name;
    data['mother_number'] = this.mother_number;
    data['father_number'] = this.father_number;
    data['pin_code'] = this.pin_code;
    return data;
  }
}
