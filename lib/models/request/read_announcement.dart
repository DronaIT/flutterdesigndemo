// To parse this JSON data, do
//
//     final updateAnnouncementRequest = updateAnnouncementRequestFromJson(jsonString);

import 'dart:convert';

ReadAnnouncementRequest readAnnouncementRequestFromJson(String str) => ReadAnnouncementRequest.fromJson(json.decode(str));

String readAnnouncementRequestToJson(ReadAnnouncementRequest data) => json.encode(data.toJson());

class ReadAnnouncementRequest {
  List<ReadRecord> records;

  ReadAnnouncementRequest({
    required this.records,
  });

  factory ReadAnnouncementRequest.fromJson(Map<String, dynamic> json) => ReadAnnouncementRequest(
    records: List<ReadRecord>.from(json["records"].map((x) => ReadRecord.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "records": List<dynamic>.from(records.map((x) => x.toJson())),
  };
}

class ReadRecord {
  String id;
  ReadFields fields;

  ReadRecord({
    required this.id,
    required this.fields,
  });

  factory ReadRecord.fromJson(Map<String, dynamic> json) => ReadRecord(
    id: json["id"],
    fields: ReadFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fields": fields.toJson(),
  };
}

class ReadFields {
  String title;
  String description;
  String image;
  String fieldsFor;
  List<UpdateAttachment>? attachments;
  List<String> createdBy;
  bool? isAll;
  List<String>? hubIds = [];
  List<String>? specializationIds = [];
  List<String>? semesters = [];
  List<String>? divisions = [];
  List<String>? updatedBy = [];
  List<String>? seenByStudents = [];
  List<int>? studentIdFromSeenByStudents = [];
  List<String>? seenByEmployees = [];
  List<int>? employeeIdFromSeenByEmployees = [];

  ReadFields({
    required this.title,
    required this.description,
    required this.image,
    required this.fieldsFor,
    this.attachments,
    required this.createdBy,
    this.isAll,
    this.hubIds,
    this.specializationIds,
    this.semesters,
    this.divisions,
    this.updatedBy,
  });

  factory ReadFields.fromJson(Map<String, dynamic> json) => ReadFields(
    title: json["title"],
    description: json["description"],
    image: json["image"],
    fieldsFor: json["for"],
    attachments: json["attachments"] == null ? [] : List<UpdateAttachment>.from(json["attachments"]!.map((x) => UpdateAttachment.fromJson(x))),
    createdBy: List<String>.from(json["created_by"].map((x) => x)),
    isAll: json["is_all"],
    hubIds: json["hub_ids"] == null ? [] : List<String>.from(json["hub_ids"]!.map((x) => x)),
    specializationIds: json["specialization_ids"] == null ? [] : List<String>.from(json["specialization_ids"]!.map((x) => x)),
    semesters: json["semesters"] == null ? [] : List<String>.from(json["semesters"]!.map((x) => x)),
    divisions: json["divisions"] == null ? [] : List<String>.from(json["divisions"]!.map((x) => x)),
    updatedBy: json["updated_by"] == null ? [] : List<String>.from(json["updated_by"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "image": image,
    "for": fieldsFor,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "created_by": List<dynamic>.from(createdBy.map((x) => x)),
    "is_all": isAll,
    "hub_ids": hubIds == null ? [] : List<dynamic>.from(hubIds!.map((x) => x)),
    "specialization_ids": specializationIds == null ? [] : List<dynamic>.from(specializationIds!.map((x) => x)),
    "semesters": semesters == null ? [] : List<dynamic>.from(semesters!.map((x) => x)),
    "divisions": divisions == null ? [] : List<dynamic>.from(divisions!.map((x) => x)),
    "updated_by": updatedBy == null ? [] : List<dynamic>.from(updatedBy!.map((x) => x)),
  };
}

class UpdateAttachment {
  String url;

  UpdateAttachment({
    required this.url,
  });

  factory UpdateAttachment.fromJson(Map<String, dynamic> json) => UpdateAttachment(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}
