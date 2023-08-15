class TimeTableResponseClass {
  int? id;
  String? modeTitle;
  List<String>? hubId = [];
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
  DateTime? createdOn;
  DateTime? updatedOn;
  List<String>? employeeNameFromLectureId;
  List<String>? subjectTitleFromSubjectId = [];
  bool? isHoliday;
  String? holidayTitle;
  List<String>? subjectIdFromSubjectId = [];
  bool? isAttendanceTaken;

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
    this.createdOn,
    this.updatedOn,
    this.employeeNameFromLectureId,
    this.subjectTitleFromSubjectId,
    this.isHoliday,
    this.holidayTitle,
    this.subjectIdFromSubjectId,
    this.isAttendanceTaken,
  });

  factory TimeTableResponseClass.fromJson(Map<String, dynamic> json) => TimeTableResponseClass(
    id: json["id"],
    modeTitle: json["mode_title"],
    hubId: json["hub_id"] == null ? [] : List<String>.from(json["hub_id"]!.map((x) => x)),
    specializationId: json["specialization_id"] == null ? [] : List<String>.from(json["specialization_id"]!.map((x) => x)),
    semester: json["semester"],
    division: json["division"],
    createdBy: json["created_by"] == null ? [] : List<String>.from(json["created_by"]!.map((x) => x)),
    updatedBy: json["updated_by"] == null ? [] : List<String>.from(json["updated_by"]!.map((x) => x)),
    date: json["date"],
    mode: json["mode"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    lectureId: json["lecture_id"] == null ? [] : List<String>.from(json["lecture_id"]!.map((x) => x)),
    subjectId: json["subject_id"] == null ? [] : List<String>.from(json["subject_id"]!.map((x) => x)),
    hubIdFromHubId: json["hub_id (from hub_id)"] == null ? [] : List<String>.from(json["hub_id (from hub_id)"]!.map((x) => x)),
    specializationIdFromSpecializationId: json["specialization_id (from specialization_id)"] == null ? [] : List<String>.from(json["specialization_id (from specialization_id)"]!.map((x) => x)),
    createdOn: json["created_on"] == null ? null : DateTime.parse(json["created_on"]),
    updatedOn: json["updated_on"] == null ? null : DateTime.parse(json["updated_on"]),
    employeeNameFromLectureId: json["employee_name (from lecture_id)"] == null ? [] : List<String>.from(json["employee_name (from lecture_id)"]!.map((x) => x)),
    subjectTitleFromSubjectId: json["subject_title (from subject_id)"] == null ? [] : List<String>.from(json["subject_title (from subject_id)"]!.map((x) => x)),
    isHoliday: json["is_holiday"],
    holidayTitle: json["holiday_title"],
    subjectIdFromSubjectId: json["subject_id (from subject_id)"] == null ? [] : List<String>.from(json["subject_id (from subject_id)"]!.map((x) => x)),
    isAttendanceTaken: json["is_attendance_taken"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mode_title": modeTitle,
    "hub_id": hubId == null ? [] : List<dynamic>.from(hubId!.map((x) => x)),
    "specialization_id": specializationId == null ? [] : List<dynamic>.from(specializationId!.map((x) => x)),
    "semester": semester,
    "division": division,
    "created_by": createdBy == null ? [] : List<dynamic>.from(createdBy!.map((x) => x)),
    "updated_by": updatedBy == null ? [] : List<dynamic>.from(updatedBy!.map((x) => x)),
    "date":  date,
    "mode": mode,
    "start_time": startTime,
    "end_time": endTime,
    "lecture_id": lectureId == null ? [] : List<dynamic>.from(lectureId!.map((x) => x)),
    "subject_id": subjectId == null ? [] : List<dynamic>.from(subjectId!.map((x) => x)),
    "hub_id (from hub_id)": hubIdFromHubId == null ? [] : List<dynamic>.from(hubIdFromHubId!.map((x) => x)),
    "specialization_id (from specialization_id)": specializationIdFromSpecializationId == null ? [] : List<dynamic>.from(specializationIdFromSpecializationId!.map((x) => x)),
    "created_on": createdOn?.toIso8601String(),
    "updated_on": updatedOn?.toIso8601String(),
    "employee_name (from lecture_id)": employeeNameFromLectureId == null ? [] : List<dynamic>.from(employeeNameFromLectureId!.map((x) => x)),
    "subject_title (from subject_id)": subjectTitleFromSubjectId == null ? [] : List<dynamic>.from(subjectTitleFromSubjectId!.map((x) => x)),
    "is_holiday": isHoliday,
    "holiday_title": holidayTitle,
    "subject_id (from subject_id)": subjectIdFromSubjectId == null ? [] : List<dynamic>.from(subjectIdFromSubjectId!.map((x) => x)),
    "is_attendance_taken": isAttendanceTaken,
  };
}
