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
  int attendanceStatus = -1;

  LoginFieldsResponse(
      {this.city,
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
      this.lecture_date});

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
    return data;
  }
}
