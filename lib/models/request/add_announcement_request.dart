import 'dart:convert';

AddAnnouncementRequest addAnnouncementRequestFromJson(String str) => AddAnnouncementRequest.fromJson(json.decode(str));

String addAnnouncementRequestToJson(AddAnnouncementRequest data) => json.encode(data.toJson());

class AddAnnouncementRequest {
  List<Record>? records = [];

  AddAnnouncementRequest({
    this.records,
  });

  factory AddAnnouncementRequest.fromJson(Map<String, dynamic> json) => AddAnnouncementRequest(
    records: List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "records": List<dynamic>.from(records?.map((x) => x.toJson())??[]),
  };
}

class Record {
  Fields fields;

  Record({
    required this.fields,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "fields": fields.toJson(),
  };
}

class Fields {
  String title;
  String description;
  String image;
  String fieldsFor;
  List<Attachment>? attachments;
  List<String> createdBy;
  bool? isAll;
  int? isActive;
  List<String>? hubIds = [];
  List<String>? specializationIds = [];
  List<String>? semesters = [];
  List<String>? divisions = [];
  List<String>? updatedBy = [];

  Fields({
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
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    title: json["title"],
    description: json["description"],
    image: json["image"],
    fieldsFor: json["for"],
    attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"]!.map((x) => Attachment.fromJson(x))),
    createdBy: List<String>.from(json["created_by"].map((x) => x)),
    isAll: json["is_all"],
    isActive: json["is_active"],
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
    "is_active": isActive,
    "hub_ids": hubIds == null ? [] : List<dynamic>.from(hubIds!.map((x) => x)),
    "specialization_ids": specializationIds == null ? [] : List<dynamic>.from(specializationIds!.map((x) => x)),
    "semesters": semesters == null ? [] : List<dynamic>.from(semesters!.map((x) => x)),
    "divisions": divisions == null ? [] : List<dynamic>.from(divisions!.map((x) => x)),
    "updated_by": updatedBy == null ? [] : List<dynamic>.from(updatedBy!.map((x) => x)),
  };
}

class Attachment {
  String url;

  Attachment({
    required this.url,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}
