class StudentAttendanceResponse {
  int? lectureId;
  List<String>? employeeId;
  List<String>? hubId;
  List<String>? specializationId;
  List<String>? subjectId;
  List<String>? unitId;
  List<String>? topicId;
  String? division;
  String? lectureDate;
  String? lectureTime;
  List<String>? studentIds;
  List<String>? presentIds;
  List<String>? absent_ids;
  List<String>? subjectTitleFromSubjectId;
  List<String>? unitTitleFromUnitId;
  List<String>? semesterFromSubjectId;
  List<String>? employeeNameFromEmployeeId;
  List<String>? hubNameFromHubId;
  List<String>? specializationNameFromSpecializationId;
  List<String>? topicTitleFromTopicId;
  List<String>? enrollmentNumberFromStudentIds;
  List<String>? nameFromStudentIds;
  String? lecture_duration;

  StudentAttendanceResponse(
      {this.lectureId,
      this.employeeId,
      this.hubId,
      this.specializationId,
      this.subjectId,
      this.unitId,
      this.topicId,
      this.division,
      this.lectureDate,
      this.lectureTime,
      this.studentIds,
      this.presentIds,
      this.subjectTitleFromSubjectId,
      this.unitTitleFromUnitId,
      this.semesterFromSubjectId,
      this.employeeNameFromEmployeeId,
      this.hubNameFromHubId,
      this.specializationNameFromSpecializationId,
      this.topicTitleFromTopicId,
      this.enrollmentNumberFromStudentIds,
      this.nameFromStudentIds,
        this.lecture_duration,
      this.absent_ids});

  StudentAttendanceResponse.fromJson(Map<String, dynamic> json) {
    lectureId = json['lecture_id'];
    employeeId = json['employee_id']?.cast<String>();
    hubId = json['hub_id']?.cast<String>();
    specializationId = json['specialization_id']?.cast<String>();
    subjectId = json['subject_id']?.cast<String>();
    unitId = json['unit_id']?.cast<String>();
    topicId = json['topic_id']?.cast<String>();
    division = json['division'];
    lectureDate = json['lecture_date'];
    lectureTime = json['lecture_time'];
    studentIds = json['student_ids']?.cast<String>();
    presentIds = json['present_ids']?.cast<String>();
    subjectTitleFromSubjectId = json['subject_title (from subject_id)']?.cast<String>();
    unitTitleFromUnitId = json['unit_title (from unit_id)']?.cast<String>();
    semesterFromSubjectId = json['semester (from subject_id)']?.cast<String>();
    employeeNameFromEmployeeId = json['employee_name (from employee_id)']?.cast<String>();
    hubNameFromHubId = json['hub_name (from hub_id)']?.cast<String>();
    specializationNameFromSpecializationId = json['specialization_name (from specialization_id)']?.cast<String>();
    topicTitleFromTopicId = json['topic_title (from topic_id)']?.cast<String>();
    enrollmentNumberFromStudentIds = json['enrollment_numbers']?.cast<String>();
    nameFromStudentIds = json['name (from student_ids)']?.cast<String>();
    absent_ids = json['absent_ids']?.cast<String>();
    lecture_duration = json['lecture_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lecture_id'] = this.lectureId;
    data['employee_id'] = this.employeeId;
    data['hub_id'] = this.hubId;
    data['specialization_id'] = this.specializationId;
    data['subject_id'] = this.subjectId;
    data['unit_id'] = this.unitId;
    data['topic_id'] = this.topicId;
    data['division'] = this.division;
    data['lecture_date'] = this.lectureDate;
    data['lecture_time'] = this.lectureTime;
    data['student_ids'] = this.studentIds;
    data['present_ids'] = this.presentIds;
    data['subject_title (from subject_id)'] = this.subjectTitleFromSubjectId;
    data['unit_title (from unit_id)'] = this.unitTitleFromUnitId;
    data['semester (from subject_id)'] = this.semesterFromSubjectId;
    data['employee_name (from employee_id)'] = this.employeeNameFromEmployeeId;
    data['hub_name (from hub_id)'] = this.hubNameFromHubId;
    data['specialization_name (from specialization_id)'] = this.specializationNameFromSpecializationId;
    data['topic_title (from topic_id)'] = this.topicTitleFromTopicId;
    data['enrollment_numbers'] = this.enrollmentNumberFromStudentIds;
    data['name (from student_ids)'] = this.nameFromStudentIds;
    data['absent_ids'] = this.absent_ids;
    data['lecture_duration'] = this.lecture_duration;
    return data;
  }
}
