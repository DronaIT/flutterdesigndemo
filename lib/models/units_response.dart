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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_ids'] = this.subjectIds;
    data['unit_title'] = this.unitTitle;
    data['ids'] = this.ids;
    data['unit_id'] = this.unitId;
    data['subject_id (from subject_ids)'] = this.subjectIdFromSubjectIds;
    return data;
  }
}
