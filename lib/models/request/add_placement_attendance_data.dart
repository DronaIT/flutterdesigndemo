class AddPlacementAttendanceData {
  List<String>? student_id;
  List<String>? job_id;
  List<Map<String, dynamic>>? attendance_form;
  List<Map<String, dynamic>>? company_loc;
  List<Map<String, dynamic>>? resignation_letter;
  String? resignation_reason;
  String? notice_period_end_date;

  AddPlacementAttendanceData({
    this.student_id,
    this.job_id,
    this.attendance_form,
    this.company_loc,
    this.resignation_letter,
    this.resignation_reason,
    this.notice_period_end_date,
  });

  AddPlacementAttendanceData.fromJson(Map<String, dynamic> json) {
    student_id = json['student_id']?.cast<String>();
    job_id = json['job_id']?.cast<String>();
    attendance_form = json['attendance_form']?.cast<Map<String, dynamic>>();
    company_loc = json['company_loc']?.cast<Map<String, dynamic>>();
    resignation_letter = json['resignation_letter']?.cast<Map<String, dynamic>>();
    resignation_reason = json['resignation_reason'];
    notice_period_end_date = json['notice_period_end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = this.student_id;
    data['job_id'] = this.job_id;
    data['attendance_form'] = this.attendance_form;
    data['company_loc'] = this.company_loc;
    data['resignation_letter'] = this.resignation_letter;
    data['resignation_reason'] = this.resignation_reason;
    data['notice_period_end_date'] = this.notice_period_end_date;
    return data;
  }
}
