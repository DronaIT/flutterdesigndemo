// To parse this JSON data, do
//
//     final addTimeTableRequest = addTimeTableRequestFromJson(jsonString);

import 'dart:convert';

import '../add_timetable_model.dart';

AddTimeTableResponse addTimeTableResponseFromJson(String str) => AddTimeTableResponse.fromJson(json.decode(str));

String addTimeTableResponseToJson(AddTimeTableResponse data) => json.encode(data.toJson());

class AddTimeTableResponse {
  List<AddRecord>? records;

  AddTimeTableResponse({
    this.records,
  });

  factory AddTimeTableResponse.fromJson(Map<String, dynamic> json) => AddTimeTableResponse(
    records: json["records"] == null ? [] : List<AddRecord>.from(json["records"]!.map((x) => AddRecord.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "records": records == null ? [] : List<dynamic>.from(records!.map((x) => x.toJson())),
  };
}

class AddRecord {
  String? id;
  DateTime? createdTime;
  AddTimeTable? fields;

  AddRecord({
    this.id,
    this.createdTime,
    this.fields,
  });

  factory AddRecord.fromJson(Map<String, dynamic> json) => AddRecord(
    id: json["id"],
    createdTime: json["createdTime"] == null ? null : DateTime.parse(json["createdTime"]),
    fields: json["fields"] == null ? null : AddTimeTable.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdTime": createdTime?.toIso8601String(),
    "fields": fields?.toJson(),
  };
}
