class ViewLectureAttendence {
  String?  subject_title;
  String? lecture_date;
  String? unit_title;
  String? semester;
  String? division;
  //1= present, 0= absent
  ViewLectureAttendence({this.subject_title, this.lecture_date, this.unit_title, this.semester , this.division});

  ViewLectureAttendence.fromJson(Map<String, dynamic> json) {
    subject_title = json['subject_title'];
    lecture_date = json['lecture_date'];
    unit_title = json['unit_title'];
    semester = json['semester'];
    division = json['division'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_title'] = this.subject_title;
    data['lecture_date'] = this.lecture_date;
    data['unit_title'] = this.unit_title;
    data['semester'] = this.semester;
    data['division'] = this.division;
    return data;
  }
}
