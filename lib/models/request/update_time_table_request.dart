// To parse this JSON data, do
//
//     final updateTimeTableRequest = updateTimeTableRequestFromJson(jsonString);

import 'dart:convert';

UpdateTimeTableRequest updateTimeTableRequestFromJson(String str) => UpdateTimeTableRequest.fromJson(json.decode(str));

String updateTimeTableRequestToJson(UpdateTimeTableRequest data) => json.encode(data.toJson());

class UpdateTimeTableRequest {
  List<UpdateRecord>? records;

  UpdateTimeTableRequest({
    this.records,
  });

  factory UpdateTimeTableRequest.fromJson(Map<String, dynamic> json) => UpdateTimeTableRequest(
    records: json["records"] == null ? [] : List<UpdateRecord>.from(json["records"]!.map((x) => UpdateRecord.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "records": records == null ? [] : List<dynamic>.from(records!.map((x) => x.toJson())),
  };
}

class UpdateRecord {
  String? id;
  UpdateFields? fields;

  UpdateRecord({
    this.id,
    this.fields,
  });

  factory UpdateRecord.fromJson(Map<String, dynamic> json) => UpdateRecord(
    id: json["id"],
    fields: json["fields"] == null ? null : UpdateFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fields": fields?.toJson(),
  };
}

class UpdateFields {
  String? date;
  String? startTime;
  String? endTime;
  String? mode;
  String? modeTitle;
  List<String>? hubId;
  List<String>? specializationId;
  String? semester;
  String? division;
  List<String>? lectureId;
  List<String>? subjectId;
  List<String>? createdBy;
  List<String>? updatedBy;
  bool? isHoliday;
  String? holidayTitle;
  bool? isAttendanceTaken;

  UpdateFields({
    this.date,
    this.startTime,
    this.endTime,
    this.mode,
    this.modeTitle,
    this.hubId,
    this.specializationId,
    this.semester,
    this.division,
    this.lectureId,
    this.subjectId,
    this.createdBy,
    this.updatedBy,
    this.isHoliday,
    this.holidayTitle,
    this.isAttendanceTaken
  });

  factory UpdateFields.fromJson(Map<String, dynamic> json) => UpdateFields(
    date: json["date"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    mode: json["mode"],
    modeTitle: json["mode_title"],
    hubId: json["hub_id"] == null ? [] : List<String>.from(json["hub_id"]!.map((x) => x)),
    specializationId: json["specialization_id"] == null ? [] : List<String>.from(json["specialization_id"]!.map((x) => x)),
    semester: json["semester"],
    division: json["division"],
    lectureId: json["lecture_id"] == null ? [] : List<String>.from(json["lecture_id"]!.map((x) => x)),
    subjectId: json["subject_id"] == null ? [] : List<String>.from(json["subject_id"]!.map((x) => x)),
    createdBy: json["created_by"] == null ? [] : List<String>.from(json["created_by"]!.map((x) => x)),
    updatedBy: json["updated_by"] == null ? [] : List<String>.from(json["updated_by"]!.map((x) => x)),
    isHoliday: json["is_holiday"],
    holidayTitle: json["holiday_title"],
    isAttendanceTaken: json["is_attendance_taken"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "start_time": startTime,
    "end_time": endTime,
    "mode": mode,
    "mode_title": modeTitle,
    "hub_id": hubId == null ? [] : List<dynamic>.from(hubId!.map((x) => x)),
    "specialization_id": specializationId == null ? [] : List<dynamic>.from(specializationId!.map((x) => x)),
    "semester": semester,
    "division": division,
    "lecture_id": lectureId == null ? [] : List<dynamic>.from(lectureId!.map((x) => x)),
    "subject_id": subjectId == null ? [] : List<dynamic>.from(subjectId!.map((x) => x)),
    "created_by": createdBy == null ? [] : List<dynamic>.from(createdBy!.map((x) => x)),
    "updated_by": updatedBy == null ? [] : List<dynamic>.from(updatedBy!.map((x) => x)),
    "is_holiday": isHoliday,
    "holiday_title": holidayTitle,
    "is_attendance_taken": isAttendanceTaken,
  };

}
