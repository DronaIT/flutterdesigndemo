class TimeTableResponseClass {
  int? id;
  String? modeTitle;
  List<String>? hubId;
  List<String>? specializationId;
  String? semester;
  String? division;
  List<String>? createdBy;
  List<String>? updatedBy;
  String? date;
  String? mode;
  String? startTime;
  String? endTime;
  List<String>? lectureId;
  List<String>? subjectId;
  List<String>? hubIdFromHubId;
  List<String>? specializationIdFromSpecializationId;
  List<String>? employeeNameFromLectureId;
  List<String>? subjectTitleFromSubjectId;
  bool? isHoliday;
  String? holidayTitle;
  List<int>? subjectIdFromSubjectId;
  bool? isAttendanceTaken;

  TimeTableResponseClass(
      {this.id,
      this.modeTitle,
      this.hubId,
      this.specializationId,
      this.semester,
      this.division,
      this.createdBy,
      this.updatedBy,
      this.date,
      this.mode,
      this.startTime,
      this.endTime,
      this.lectureId,
      this.subjectId,
      this.hubIdFromHubId,
      this.specializationIdFromSpecializationId,
      this.employeeNameFromLectureId,
      this.subjectTitleFromSubjectId,
      this.isHoliday,
      this.holidayTitle,
      this.subjectIdFromSubjectId,
      this.isAttendanceTaken,
    });

  TimeTableResponseClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    mode = json['mode'];
    modeTitle = json['mode_title'];
    hubId = json['hub_id']?.cast<String>();
    hubIdFromHubId = json['hub_id (from hub_id)']?.cast<String>();
    specializationId = json['specialization_id']?.cast<String>();
    specializationIdFromSpecializationId = json['specialization_id (from specialization_id)']?.cast<String>();
    semester = json['semester'];
    division = json['division'];
    lectureId = json['lecture_id']?.cast<String>();
    employeeNameFromLectureId = json['employee_name (from lecture_id)']?.cast<String>();
    subjectId = json['subject_id']?.cast<String>();
    subjectIdFromSubjectId = json['subject_id (from subject_id)']?.cast<int>();
    subjectTitleFromSubjectId = json['subject_title (from subject_id)']?.cast<String>();
    createdBy = json['created_by']?.cast<String>();
    updatedBy = json['updated_by']?.cast<String>();
    isHoliday = json["is_holiday"];
    holidayTitle = json["holiday_title"];
    isAttendanceTaken = json["is_attendance_taken"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['mode'] = this.mode;
    data['mode_title'] = this.modeTitle;
    data['hub_id'] = this.hubId;
    data['hub_id (from hub_id)'] = this.hubIdFromHubId;
    data['specialization_id'] = this.specializationId;
    data['specialization_id (from specialization_id)'] = this.specializationIdFromSpecializationId;
    data['semester'] = this.semester;
    data['division'] = this.division;
    data['lecture_id'] = this.lectureId;
    data['employee_name (from lecture_id)'] = this.employeeNameFromLectureId;
    data['subject_id'] = this.subjectId;
    data['subject_id (from subject_id)'] = this.subjectIdFromSubjectId;
    data['subject_title (from subject_id)'] = this.subjectTitleFromSubjectId;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data["is_holiday"] = this.isHoliday;
    data["holiday_title"] = this.holidayTitle;
    data["is_attendance_taken"] = this.isAttendanceTaken;
    return data;
  }
}
