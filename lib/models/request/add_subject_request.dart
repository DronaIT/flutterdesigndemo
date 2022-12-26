class AddSubjectRequest {
  String? subjectTitle;
  List<String>? tBLUNITS;

  AddSubjectRequest({this.subjectTitle, this.tBLUNITS});

  AddSubjectRequest.fromJson(Map<String, dynamic> json) {
    subjectTitle = json['subject_title'];
    tBLUNITS = json['TBL_UNITS'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_title'] = this.subjectTitle;
    data['TBL_UNITS'] = this.tBLUNITS;
    return data;
  }
}
