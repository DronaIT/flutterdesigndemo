class AnnouncementResponse {
  int id;
  String title;
  String description;
  String image;
  String announcementResponseFor;
  List<Attachment>? attachments;
  List<String> createdBy;
  List<int> employeeIdFromCreatedBy;
  bool? isAll;
  List<String>? hubIds;
  List<String>? hubIdFromHubIds;
  List<String>? specializationIds;
  List<String>? specializationIdFromSpecializationIds;
  List<String>? semesters;
  List<String>? divisions;
  DateTime? createdOn;
  DateTime? updatedOn;
  List<String>? seenByStudents = [];
  List<int>? studentIdFromSeenByStudents = [];
  List<String>? seenByEmployees = [];
  List<int>? employeeIdFromSeenByEmployees = [];

  AnnouncementResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.announcementResponseFor,
    this.attachments,
    required this.createdBy,
    required this.employeeIdFromCreatedBy,
    this.isAll,
    this.hubIds,
    this.hubIdFromHubIds,
    this.specializationIds,
    this.specializationIdFromSpecializationIds,
    this.semesters,
    this.divisions,
    required this.createdOn,
    required this.updatedOn,
    this.seenByStudents,
    this.seenByEmployees,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) => AnnouncementResponse(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    announcementResponseFor: json["for"],
    attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
    createdBy: json["created_by"] == null ? [] : List<String>.from(json["created_by"].map((x) => x)),
    employeeIdFromCreatedBy:json["employee_id (from created_by)"] == null? [] : List<int>.from(json["employee_id (from created_by)"].map((x) => x)),
    isAll: json["is_all"],
    hubIds: json["hub_ids"] == null ? [] : List<String>.from(json["hub_ids"]!.map((x) => x)),
    hubIdFromHubIds: json["hub_id (from hub_ids)"] == null ? [] : List<String>.from(json["hub_id (from hub_ids)"]!.map((x) => x)),
    specializationIds: json["specialization_ids"] == null ? [] : List<String>.from(json["specialization_ids"]!.map((x) => x)),
    specializationIdFromSpecializationIds: json["specialization_id (from specialization_ids)"] == null ? [] : List<String>.from(json["specialization_id (from specialization_ids)"]!.map((x) => x)),
    semesters: json["semesters"] == null ? [] : List<String>.from(json["semesters"]!.map((x) => x)),
    divisions: json["divisions"] == null ? [] : List<String>.from(json["divisions"]!.map((x) => x)),
    createdOn: DateTime.parse(json["created_on"]),
    updatedOn: DateTime.parse(json["updated_on"]),
    seenByStudents: json["seen_by_students"] == null ? [] : List<String>.from(json["seen_by_students"]!.map((x) => x)),
    seenByEmployees: json["seen_by_employees"] == null ? [] : List<String>.from(json["seen_by_employees"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "for": announcementResponseFor,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "created_by": List<dynamic>.from(createdBy.map((x) => x)),
    "employee_id (from created_by)": List<dynamic>.from(employeeIdFromCreatedBy.map((x) => x)),
    "is_all": isAll,
    "hub_ids": hubIds == null ? [] : List<dynamic>.from(hubIds!.map((x) => x)),
    "hub_id (from hub_ids)": hubIdFromHubIds == null ? [] : List<dynamic>.from(hubIdFromHubIds!.map((x) => x)),
    "specialization_ids": specializationIds == null ? [] : List<dynamic>.from(specializationIds!.map((x) => x)),
    "specialization_id (from specialization_ids)": specializationIdFromSpecializationIds == null ? [] : List<dynamic>.from(specializationIdFromSpecializationIds!.map((x) => x)),
    "semesters": semesters == null ? [] : List<dynamic>.from(semesters!.map((x) => x)),
    "divisions": divisions == null ? [] : List<dynamic>.from(divisions!.map((x) => x)),
    "created_on": createdOn?.toIso8601String(),
    "updated_on": updatedOn?.toIso8601String(),
    "seen_by_students": seenByStudents == null ? [] : List<dynamic>.from(seenByStudents!.map((x) => x)),
    "seen_by_employees": seenByEmployees == null ? [] : List<dynamic>.from(seenByEmployees!.map((x) => x)),
  };
}

class Attachment {
  String id;
  int? width;
  int? height;
  String? url;
  String? filename;
  int? size;
  String? type;
  Thumbnails? thumbnails;

  Attachment({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.filename,
    required this.size,
    required this.type,
    required this.thumbnails,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    id: json["id"],
    width: json["width"],
    height: json["height"],
    url: json["url"],
    filename: json["filename"],
    size: json["size"],
    type: json["type"],
    thumbnails: json["thumbnails"] ==null ?null :Thumbnails.fromJson(json["thumbnails"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "width": width,
    "height": height,
    "url": url,
    "filename": filename,
    "size": size,
    "type": type,
    "thumbnails": thumbnails!.toJson(),
  };
}

class Thumbnails {
  Full? small;
  Full? large;
  Full? full;

  Thumbnails({
    required this.small,
    required this.large,
    required this.full,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) => Thumbnails(
    small: json["small"] == null?null:Full.fromJson(json["small"]),
    large: json["large"] == null?null:Full.fromJson(json["large"]),
    full: json["full"] == null?null: Full.fromJson(json["full"]),
  );

  Map<String, dynamic> toJson() => {
    "small": small?.toJson(),
    "large": large?.toJson(),
    "full": full?.toJson(),
  };
}

class Full {
  String url;
  int width;
  int height;

  Full({
    required this.url,
    required this.width,
    required this.height,
  });

  factory Full.fromJson(Map<String, dynamic> json) => Full(
    url: json["url"],
    width: json["width"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "width": width,
    "height": height,
  };
}

class Fields {
  int id;
  String title;
  String description;
  String image;
  String fieldsFor;
  List<Attachment>? attachments;
  bool? isAll;
  List<String>? hubIds;
  List<String>? specializationIds;
  List<String>? semesters;
  List<String>? divisions;
  List<String>? hubIdFromHubIds;
  List<String>? specializationIdFromSpecializationIds;

  Fields({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.fieldsFor,
    this.attachments,
    this.isAll,
    this.hubIds,
    this.specializationIds,
    this.semesters,
    this.divisions,
    this.hubIdFromHubIds,
    this.specializationIdFromSpecializationIds,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    fieldsFor: json["for"],
    attachments: json["attachments"] == null ? [] : List<Attachment>.from(json["attachments"]!.map((x) => Attachment.fromJson(x))),
    isAll: json["is_all"],
    hubIds: json["hub_ids"] == null ? [] : List<String>.from(json["hub_ids"]!.map((x) => x)),
    specializationIds: json["specialization_ids"] == null ? [] : List<String>.from(json["specialization_ids"]!.map((x) => x)),
    semesters: json["semesters"] == null ? [] : List<String>.from(json["semesters"]!.map((x) => x)),
    divisions: json["divisions"] == null ? [] : List<String>.from(json["divisions"]!.map((x) => x)),
    hubIdFromHubIds: json["hub_id (from hub_ids)"] == null ? [] : List<String>.from(json["hub_id (from hub_ids)"]!.map((x) => x)),
    specializationIdFromSpecializationIds: json["specialization_id (from specialization_ids)"] == null ? [] : List<String>.from(json["specialization_id (from specialization_ids)"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "for": fieldsFor,
    "attachments": attachments == null ? [] : List<dynamic>.from(attachments!.map((x) => x.toJson())),
    "is_all": isAll,
    "hub_ids": hubIds == null ? [] : List<dynamic>.from(hubIds!.map((x) => x)),
    "specialization_ids": specializationIds == null ? [] : List<dynamic>.from(specializationIds!.map((x) => x)),
    "semesters": semesters == null ? [] : List<dynamic>.from(semesters!.map((x) => x)),
    "divisions": divisions == null ? [] : List<dynamic>.from(divisions!.map((x) => x)),
    "hub_id (from hub_ids)": hubIdFromHubIds == null ? [] : List<dynamic>.from(hubIdFromHubIds!.map((x) => x)),
    "specialization_id (from specialization_ids)": specializationIdFromSpecializationIds == null ? [] : List<dynamic>.from(specializationIdFromSpecializationIds!.map((x) => x)),
  };
}
