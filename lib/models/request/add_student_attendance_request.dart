class AddStudentAttendanceRequest {
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
  List<String>? absentIds;
  String? lecture_duration;
  String? semesterByStudent;

  AddStudentAttendanceRequest(
      {this.employeeId,
      this.hubId,
      this.specializationId,
      this.subjectId,
      this.unitId,
      this.topicId,
      this.division,
      this.lectureDate,
      this.studentIds,
      this.presentIds,
      this.absentIds,
      this.lectureTime,
      this.lecture_duration,
      this.semesterByStudent});

  AddStudentAttendanceRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id']?.cast<String>();
    hubId = json['hub_id']?.cast<String>();
    specializationId = json['specialization_id']?.cast<String>();
    subjectId = json['subject_id']?.cast<String>();
    unitId = json['unit_id']?.cast<String>();
    topicId = json['topic_id']?.cast<String>();
    division = json['division'];
    lectureDate = json['lecture_date'];
    studentIds = json['student_ids']?.cast<String>();
    presentIds = json['present_ids']?.cast<String>();
    absentIds = json['absent_ids']?.cast<String>();
    lectureTime = json['lecture_time'];
    lecture_duration = json['lecture_duration'];
    semesterByStudent = json['semester_by_student']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['hub_id'] = hubId;
    data['specialization_id'] = specializationId;
    data['subject_id'] = subjectId;
    data['unit_id'] = unitId;
    data['topic_id'] = topicId;
    data['division'] = division;
    data['lecture_date'] = lectureDate;
    data['student_ids'] = studentIds;
    data['present_ids'] = presentIds;
    data['absent_ids'] = absentIds;
    data['lecture_time'] = lectureTime;
    data['lecture_duration'] = lecture_duration;
    data['semester_by_student'] = semesterByStudent;
    return data;
  }
}
