class AddSubjectRequest {
  String? subjectTitle;
  String? semester;
  String? code;
  String? credit;
  List<String>? tBLUNITS;
  List<String>? specializationIds;

  AddSubjectRequest({this.subjectTitle, this.semester, this.tBLUNITS, this.specializationIds});

  AddSubjectRequest.fromJson(Map<String, dynamic> json) {
    subjectTitle = json['subject_title'];
    code = json['subject_code'];
    credit = json['subject_credit'];
    semester = json['semester'];
    tBLUNITS = json['TBL_UNITS']?.cast<String>();
    specializationIds = json['specialization_ids']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_title'] = subjectTitle;
    data['subject_code'] = code;
    data['subject_credit'] = credit;
    data['semester'] = semester;
    data['specialization_ids'] = specializationIds;
    data['TBL_UNITS'] = tBLUNITS;
    return data;
  }
}
