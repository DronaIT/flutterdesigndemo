class ViewLectureAttendance {
  String? subject_title;
  String? specilization;

  String? lecture_date;
  String? unit_title;
  String? semester;
  String? division;
  String? lecture_id;
  String? employee_name;

  //1= present, 0= absent
  ViewLectureAttendance({this.subject_title, this.lecture_date, this.unit_title, this.semester, this.division, this.lecture_id, this.employee_name, this.specilization});

  ViewLectureAttendance.fromJson(Map<String, dynamic> json) {
    subject_title = json['subject_title'];
    lecture_date = json['lecture_date'];
    unit_title = json['unit_title'];
    semester = json['semester'];
    division = json['division'];
    lecture_id = json['lecture_id'];
    employee_name = json['employee_name'];
    specilization = json['specilization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subject_title'] = subject_title;
    data['lecture_date'] = lecture_date;
    data['unit_title'] = unit_title;
    data['semester'] = semester;
    data['division'] = division;
    data['lecture_id'] = lecture_id;
    data['employee_name'] = employee_name;
    data['specilization'] = specilization;

    return data;
  }
}
