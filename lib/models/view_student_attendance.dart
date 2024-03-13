class ViewStudentAttendance {
  String? subject_title;
  String? lecture_date;
  int? status;
  String? subject_id;
  int total_lectures = 0;
  int present_lectures = 0;
  int absent_lectures = 0;

  //1= present, 0= absent
  ViewStudentAttendance({this.subject_id, this.subject_title, this.lecture_date, this.status});

  ViewStudentAttendance.fromJson(Map<String, dynamic> json) {
    subject_id = json['subject_id'];
    subject_title = json['subject_title'];
    lecture_date = json['lecture_date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_id'] = subject_id;
    data['subject_title'] = subject_title;
    data['lecture_date'] = lecture_date;
    data['status'] = status;

    return data;
  }
}
