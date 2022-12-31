class AddStudentAttendanceRequest {
  List<String>? employeeId;
  List<String>? hubId;
  List<String>? specializationId;
  List<String>? subjectId;
  List<String>? unitId;
  List<String>? topicId;
  String? division;
  String? lectureDate;
  List<String>? studentIds;
  List<String>? presentIds;
  List<String>? absentIds;

  AddStudentAttendanceRequest({this.employeeId, this.hubId, this.specializationId, this.subjectId, this.unitId, this.topicId, this.division, this.lectureDate, this.studentIds, this.presentIds, this.absentIds});

  AddStudentAttendanceRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'].cast<String>();
    hubId = json['hub_id'].cast<String>();
    specializationId = json['specialization_id'].cast<String>();
    subjectId = json['subject_id'].cast<String>();
    unitId = json['unit_id'].cast<String>();
    topicId = json['topic_id'].cast<String>();
    division = json['division'];
    lectureDate = json['lecture_date'];
    studentIds = json['student_ids'].cast<String>();
    presentIds = json['present_ids'].cast<String>();
    absentIds = json['absent_ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['hub_id'] = this.hubId;
    data['specialization_id'] = this.specializationId;
    data['subject_id'] = this.subjectId;
    data['unit_id'] = this.unitId;
    data['topic_id'] = this.topicId;
    data['division'] = this.division;
    data['lecture_date'] = this.lectureDate;
    data['student_ids'] = this.studentIds;
    data['present_ids'] = this.presentIds;
    data['absent_ids'] = this.absentIds;
    return data;
  }
}
