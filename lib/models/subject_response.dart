import 'attachment_response.dart';

class SubjectResponse {
  String? subjectTitle;
  List<String>? specializationIds;
  int? ids;
  List<int>? specializationIdFromSpecializationIds;
  String? subjectId;
  String? subjectCode;
  String? subjectCredit;
  String? semester;
  bool selected = false;
  List<Attachment_response>? material;

  SubjectResponse({this.subjectTitle, this.specializationIds, this.ids, this.material, this.specializationIdFromSpecializationIds, this.subjectId, this.subjectCode, this.subjectCredit, this.semester});

  SubjectResponse.fromJson(Map<String, dynamic> json) {
    subjectTitle = json['subject_title'];
    specializationIds = json['specialization_ids']?.cast<String>();
    ids = json['ids'];
    specializationIdFromSpecializationIds = json['specialization_id (from specialization_ids)']?.cast<int>();
    subjectId = json['subject_id'];
    subjectCode = json['subject_code'] ?? "";
    subjectCredit = json['subject_credit'] ?? "";
    semester = json['semester'];
    if (json['material'] != null) {
      material = <Attachment_response>[];
      json['material'].forEach((v) {
        material!.add(Attachment_response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_title'] = subjectTitle;
    data['specialization_ids'] = specializationIds;
    data['ids'] = ids;
    data['specialization_id (from specialization_ids)'] = specializationIdFromSpecializationIds;
    data['subject_id'] = subjectId;
    data['subject_code'] = subjectCode;
    data['subject_credit'] = subjectCredit;
    data['semester'] = semester;
    if (material != null) {
      data['material'] = material!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
