import 'dart:convert';

AddAnnouncementResponse addAnnouncementResponseFromJson(String str) => AddAnnouncementResponse.fromJson(json.decode(str));

String addAnnouncementResponseToJson(AddAnnouncementResponse data) => json.encode(data.toJson());

class AddAnnouncementResponse {
  List<Record>? records = [];

  AddAnnouncementResponse({
    required this.records,
  });

  factory AddAnnouncementResponse.fromJson(Map<String, dynamic> json) => AddAnnouncementResponse(
    records: json["records"] == null ?[]:List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "records": List<dynamic>.from(records!.map((x) => x.toJson())),
  };
}

class Record {
  String id;
  String? createdTime;
  Fields fields;

  Record({
    required this.id,
    required this.createdTime,
    required this.fields,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    id: json["id"].toString(),
    createdTime: json["createdTime"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdTime": createdTime,
    "fields": fields.toJson(),
  };
}

class Fields {
  int id;
  String title;
  String description;
  String image;
  String fieldsFor;
  List<Attachment> attachments;
  List<String> createdBy;
  List<int> employeeIdFromCreatedBy;

  Fields({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.fieldsFor,
    required this.attachments,
    required this.createdBy,
    required this.employeeIdFromCreatedBy,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    fieldsFor: json["for"],
    attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
    createdBy: List<String>.from(json["created_by"].map((x) => x)),
    employeeIdFromCreatedBy: List<int>.from(json["employee_id (from created_by)"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "for": fieldsFor,
    "attachments": List<dynamic>.from(attachments.map((x) => x.toJson())),
    "created_by": List<dynamic>.from(createdBy.map((x) => x)),
    "employee_id (from created_by)": List<dynamic>.from(employeeIdFromCreatedBy.map((x) => x)),
  };
}

class Attachment {
  String id;
  String url;
  String filename;

  Attachment({
    required this.id,
    required this.url,
    required this.filename,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    id: json["id"],
    url: json["url"],
    filename: json["filename"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "filename": filename,
  };
}
