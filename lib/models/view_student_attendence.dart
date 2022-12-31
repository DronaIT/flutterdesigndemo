class ViewStudentAttendence {
  String?  subject_title;
  String? lecture_date;
  int? status;

  //1= present, 0= absent
  ViewStudentAttendence({this.subject_title, this.lecture_date, this.status});

  ViewStudentAttendence.fromJson(Map<String, dynamic> json) {
    subject_title = json['subject_title'];
    lecture_date = json['lecture_date'];
    status = json['status'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_title'] = this.subject_title;
    data['lecture_date'] = this.lecture_date;
    data['status'] = this.status;

    return data;
  }
}
