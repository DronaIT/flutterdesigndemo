import 'dart:convert';

UpdateAnnouncementRequest updateAnnouncementRequestFromJson(String str) => UpdateAnnouncementRequest.fromJson(json.decode(str));

String updateAnnouncementRequestToJson(UpdateAnnouncementRequest data) => json.encode(data.toJson());

class UpdateAnnouncementRequest {
  List<UpdateRecord> records;

  UpdateAnnouncementRequest({
    required this.records,
  });

  factory UpdateAnnouncementRequest.fromJson(Map<String, dynamic> json) => UpdateAnnouncementRequest(
    records: List<UpdateRecord>.from(json["records"].map((x) => UpdateRecord.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "records": List<dynamic>.from(records.map((x) => x.toJson())),
  };
}

class UpdateRecord {
  String id;
  UpdateFields fields;

  UpdateRecord({
    required this.id,
    required this.fields,
  });

  factory UpdateRecord.fromJson(Map<String, dynamic> json) => UpdateRecord(
    id: json["id"],
    fields: UpdateFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fields": fields.toJson(),
  };
}

class UpdateFields {
  String title;
  String description;
  String image;
  String fieldsFor;
  List<UpdateAttachment>? attachments;
  List<String> createdBy;
  bool? isAll;
  int? isActive;
  List<String>? hubIds = [];
  List<String>? specializationIds = [];
  List<String>? semesters = [];
  List<String>? divisions = [];
  List<String>? updatedBy = [];
  List<String>? seenByStudents = [];
  List<String>? seenByEmployees = [];


  UpdateFields({
    required this.title,
    required this.description,
    required this.image,
    required this.fieldsFor,
    this.attachments,
    required this.createdBy,
    this.isAll,
    this.isActive,
    this.hubIds,
    this.specializationIds,
    this.semesters,
    this.divisions,
    this.updatedBy,
    this.seenByStudents,
    this.seenByEmployees,
  });

  factory UpdateFields.fromJson(Map<String, dynamic> json) => UpdateFields(
    title: json["title"],
    description: json["description"],
    image: json["image"],
    fieldsFor: json["for"],
    attachments: json["attachments"] == null ? [] : List<UpdateAttachment>.from(json["attachments"]!.map((x) => UpdateAttachment.fromJson(x))),
    createdBy: List<String>.from(json["created_by"].map((x) => x)),
    isAll: json["is_all"],
    isActive: json["is_active"],
    hubIds: json["hub_ids"] == null ? [] : List<String>.from(json["hub_ids"]!.map((x) => x)),
    specializationIds: json["specialization_ids"] == null ? [] : List<String>.from(json["specialization_ids"]!.map((x) => x)),
    semesters: json["semesters"] == null ? [] : List<String>.from(json["semesters"]!.map((x) => x)),
    divisions: json["divisions"] == null ? [] : List<String>.from(json["divisions"]!.map((x) => x)),
    updatedBy: json["updated_by"] == null ? [] : List<String>.from(json["updated_by"].map((x) => x)),
    seenByStudents: json["seen_by_students"] == null ? [] : List<String>.from(json["seen_by_students"]!.map((x) => x)),
    seenByEmployees: json["seen_by_employees"] == null ? [] : List<String>.from(json["seen_by_employees"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "image": image,
    "for": fieldsFor,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "created_by": List<dynamic>.from(createdBy.map((x) => x)),
    "is_all": isAll,
    "is_active": isActive,
    "hub_ids": hubIds == null ? [] : List<dynamic>.from(hubIds!.map((x) => x)),
    "specialization_ids": specializationIds == null ? [] : List<dynamic>.from(specializationIds!.map((x) => x)),
    "semesters": semesters == null ? [] : List<dynamic>.from(semesters!.map((x) => x)),
    "divisions": divisions == null ? [] : List<dynamic>.from(divisions!.map((x) => x)),
    "updated_by": updatedBy == null ? [] : List<dynamic>.from(updatedBy!.map((x) => x)),
    "seen_by_students": seenByStudents == null ? [] : List<dynamic>.from(seenByStudents!.map((x) => x)),
    "seen_by_employees": seenByEmployees == null ? [] : List<dynamic>.from(seenByEmployees!.map((x) => x)),
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
