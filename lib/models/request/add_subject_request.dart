class AddSubjectRequest {
  String? subjectTitle;
  String? semester;
  String? code;
  String? credit;
  List<String>? tBLUNITS;

  AddSubjectRequest({this.subjectTitle, this.semester, this.tBLUNITS});

  AddSubjectRequest.fromJson(Map<String, dynamic> json) {
    subjectTitle = json['subject_title'];
    code = json['subject_code'];
    credit = json['subject_credit'];
    semester = json['semester'];
    tBLUNITS = json['TBL_UNITS']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_title'] = this.subjectTitle;
    data['subject_code'] = this.code;
    data['subject_credit'] = this.credit;
    data['semester'] = this.semester;
    data['TBL_UNITS'] = this.tBLUNITS;
    return data;
  }
}
