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
  ViewLectureAttendance({this.subject_title, this.lecture_date, this.unit_title, this.semester,
    this.division, this.lecture_id, this.employee_name,
    this.specilization


  });

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_title'] = this.subject_title;
    data['lecture_date'] = this.lecture_date;
    data['unit_title'] = this.unit_title;
    data['semester'] = this.semester;
    data['division'] = this.division;
    data['lecture_id'] = this.lecture_id;
    data['employee_name'] = this.employee_name;
    data['specilization'] = this.specilization;

    return data;
  }
}
