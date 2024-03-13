class SemesterData {
  int? semester;
  bool selected = false;

  SemesterData({this.semester});

  SemesterData.fromJson(Map<String, dynamic> json) {
    semester = json['semester'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['semester'] = semester;
    return data;
  }
}
