import 'dart:convert';

AddTimeTableModel addTimeTableModelFromJson(String str) => AddTimeTableModel.fromJson(json.decode(str));

String addTimeTableModelToJson(AddTimeTableModel data) => json.encode(data.toJson());

class AddTimeTableModel {
  List<Record>? records;

  AddTimeTableModel({
    this.records,
  });

  factory AddTimeTableModel.fromJson(Map<String, dynamic> json) => AddTimeTableModel(
    records: json["records"] == null ? [] : List<Record>.from(json["records"]!.map((x) => Record.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "records": records == null ? [] : List<dynamic>.from(records!.map((x) => x.toJson())),
  };
}

class Record {
  AddTimeTable? fields;

  Record({
    this.fields,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    fields: json["fields"] == null ? null : AddTimeTable.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields?.toJson(),
  };
}

class AddTimeTable {
  String? date;
  bool? isHoliday;
  String? holidayTitle;
  List<String>? hubId;
  List<String>? specializationId;
  String? semester;
  String? division;
  List<String>? lectureId;
  List<String>? subjectId;
  List<String>? createdBy;
  List<String>? updatedBy;
  String? startTime;
  String? endTime;
  String? mode;
  String? modeTitle;

  AddTimeTable({
    this.date,
    this.isHoliday,
    this.holidayTitle,
    this.hubId,
    this.specializationId,
    this.semester,
    this.division,
    this.lectureId,
    this.subjectId,
    this.createdBy,
    this.updatedBy,
    this.startTime,
    this.endTime,
    this.mode,
    this.modeTitle,
  });

  factory AddTimeTable.fromJson(Map<String, dynamic> json) => AddTimeTable(
    date: json["date"],
    isHoliday: json["is_holiday"],
    holidayTitle: json["holiday_title"],
    hubId: json["hub_id"] == null ? [] : List<String>.from(json["hub_id"]!.map((x) => x)),
    specializationId: json["specialization_id"] == null ? [] : List<String>.from(json["specialization_id"]!.map((x) => x)),
    semester: json["semester"],
    division: json["division"],
    lectureId: json["lecture_id"] == null ? [] : List<String>.from(json["lecture_id"]!.map((x) => x)),
    subjectId: json["subject_id"] == null ? [] : List<String>.from(json["subject_id"]!.map((x) => x)),
    createdBy: json["created_by"] == null ? [] : List<String>.from(json["created_by"]!.map((x) => x)),
    updatedBy: json["updated_by"] == null ? [] : List<String>.from(json["updated_by"]!.map((x) => x)),
    startTime: json["start_time"],
    endTime: json["end_time"],
    mode: json["mode"],
    modeTitle: json["mode_title"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "is_holiday": isHoliday,
    "holiday_title": holidayTitle,
    "hub_id": hubId == null ? [] : List<dynamic>.from(hubId!.map((x) => x)),
    "specialization_id": specializationId == null ? [] : List<dynamic>.from(specializationId!.map((x) => x)),
    "semester": semester,
    "division": division,
    "lecture_id": lectureId == null ? [] : List<dynamic>.from(lectureId!.map((x) => x)),
    "subject_id": subjectId == null ? [] : List<dynamic>.from(subjectId!.map((x) => x)),
    "created_by": createdBy == null ? [] : List<dynamic>.from(createdBy!.map((x) => x)),
    "updated_by": updatedBy == null ? [] : List<dynamic>.from(updatedBy!.map((x) => x)),
    "start_time": startTime,
    "end_time": endTime,
    "mode": mode,
    "mode_title": modeTitle,
  };
}
