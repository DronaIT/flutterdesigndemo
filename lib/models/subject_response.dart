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

  SubjectResponse({this.subjectTitle, this.specializationIds, this.ids, this.specializationIdFromSpecializationIds, this.subjectId, this.subjectCode, this.subjectCredit, this.semester});

  SubjectResponse.fromJson(Map<String, dynamic> json) {
    subjectTitle = json['subject_title'];
    specializationIds = json['specialization_ids']?.cast<String>();
    ids = json['ids'];
    specializationIdFromSpecializationIds = json['specialization_id (from specialization_ids)']?.cast<int>();
    subjectId = json['subject_id'];
    subjectCode = json['subject_code'] ?? "";
    subjectCredit = json['subject_credit'] ?? "";
    semester = json['semester'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_title'] = this.subjectTitle;
    data['specialization_ids'] = this.specializationIds;
    data['ids'] = this.ids;
    data['specialization_id (from specialization_ids)'] = this.specializationIdFromSpecializationIds;
    data['subject_id'] = this.subjectId;
    data['subject_code'] = this.subjectCode;
    data['subject_credit'] = this.subjectCredit;
    data['semester'] = this.semester;
    return data;
  }
}
