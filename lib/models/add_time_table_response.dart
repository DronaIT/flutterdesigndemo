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
  List<String>? proxy_taker_employee_name;
  List<String>? proxy_maker_employee_name;
  List<String>? proxy_maker;
  List<String>? proxy_taker;
  List<String>? subjectTitleFromSubjectId;
  bool? isHoliday;
  String? holidayTitle;
  List<int>? subjectIdFromSubjectId;
  bool? isAttendanceTaken;
  String? status;

  TimeTableResponseClass({
    this.id,
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
    this.proxy_taker_employee_name,
    this.proxy_maker_employee_name,
    this.proxy_maker,
    this.proxy_taker,
    this.subjectTitleFromSubjectId,
    this.isHoliday,
    this.holidayTitle,
    this.subjectIdFromSubjectId,
    this.isAttendanceTaken,
    this.status,
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
    proxy_taker_employee_name = json['proxy_taker_employee_name']?.cast<String>();
    proxy_maker_employee_name = json['proxy_maker_employee_name']?.cast<String>();
    proxy_maker = json['proxy_maker']?.cast<String>();
    proxy_taker = json['proxy_taker']?.cast<String>();
    subjectId = json['subject_id']?.cast<String>();
    subjectIdFromSubjectId = json['subject_id (from subject_id)']?.cast<int>();
    subjectTitleFromSubjectId = json['subject_title (from subject_id)']?.cast<String>();
    createdBy = json['created_by']?.cast<String>();
    updatedBy = json['updated_by']?.cast<String>();
    isHoliday = json["is_holiday"];
    holidayTitle = json["holiday_title"];
    isAttendanceTaken = json["is_attendance_taken"];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['mode'] = mode;
    data['mode_title'] = modeTitle;
    data['hub_id'] = hubId;
    data['hub_id (from hub_id)'] = hubIdFromHubId;
    data['specialization_id'] = specializationId;
    data['specialization_id (from specialization_id)'] = specializationIdFromSpecializationId;
    data['semester'] = semester;
    data['division'] = division;
    data['lecture_id'] = lectureId;
    data['employee_name (from lecture_id)'] = employeeNameFromLectureId;
    data['proxy_taker_employee_name'] = proxy_taker_employee_name;
    data['proxy_maker_employee_name'] = proxy_maker_employee_name;
    data['proxy_maker'] = proxy_maker;
    data['proxy_taker'] = proxy_taker;
    data['subject_id'] = subjectId;
    data['subject_id (from subject_id)'] = subjectIdFromSubjectId;
    data['subject_title (from subject_id)'] = subjectTitleFromSubjectId;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data["is_holiday"] = isHoliday;
    data["holiday_title"] = holidayTitle;
    data["is_attendance_taken"] = isAttendanceTaken;
    data['status'] = status;
    return data;
  }
}
