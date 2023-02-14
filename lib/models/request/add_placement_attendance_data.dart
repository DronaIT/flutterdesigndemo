class AddPlacementAttendanceData {
  List<String>? student_id;
  List<String>? job_id;
  List<Map<String, dynamic>>? attendance_form;
  List<Map<String, dynamic>>? company_loc;

  AddPlacementAttendanceData({this.student_id, this.job_id, this.attendance_form, this.company_loc});

  AddPlacementAttendanceData.fromJson(Map<String, dynamic> json) {
    student_id = json['student_id']?.cast<String>();
    job_id = json['job_id']?.cast<String>();
    attendance_form = json['attendance_form']?.cast<Map<String, dynamic>>();
    company_loc = json['company_loc']?.cast<Map<String, dynamic>>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = this.student_id;
    data['job_id'] = this.job_id;
    data['attendance_form'] = this.attendance_form;
    data['company_loc'] = this.company_loc;
    return data;
  }
}
