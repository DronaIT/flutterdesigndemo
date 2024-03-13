class UnitsResponse {
  List<String>? subjectIds;
  String? unitTitle;
  int? ids;
  String? unitId;
  List<String>? subjectIdFromSubjectIds;
  bool selected = false;

  UnitsResponse({this.subjectIds, this.unitTitle, this.ids, this.unitId, this.subjectIdFromSubjectIds});

  UnitsResponse.fromJson(Map<String, dynamic> json) {
    subjectIds = json['subject_ids']?.cast<String>();
    unitTitle = json['unit_title'];
    ids = json['ids'];
    unitId = json['unit_id'];
    subjectIdFromSubjectIds = json['subject_id (from subject_ids)']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_ids'] = subjectIds;
    data['unit_title'] = unitTitle;
    data['ids'] = ids;
    data['unit_id'] = unitId;
    data['subject_id (from subject_ids)'] = subjectIdFromSubjectIds;
    return data;
  }
}
