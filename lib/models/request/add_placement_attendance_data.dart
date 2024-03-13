class AddPlacementAttendanceData {
  List<String>? student_id;
  List<String>? job_id;
  List<String>? job_title;
  List<String>? company_name;
  List<Map<String, dynamic>>? attendance_form;
  List<Map<String, dynamic>>? company_loc;
  List<Map<String, dynamic>>? workbook;
  List<Map<String, dynamic>>? resignation_letter;
  String? resignation_reason;
  String? notice_period_end_date;
  String? uploadedOn;
  String? placement_attendance_status;
  String? placement_company_loc_status;
  String? placement_workbook_status;

  AddPlacementAttendanceData({
    this.student_id,
    this.job_id,
    this.job_title,
    this.company_name,
    this.attendance_form,
    this.company_loc,
    this.workbook,
    this.resignation_letter,
    this.resignation_reason,
    this.notice_period_end_date,
    this.uploadedOn,
    this.placement_attendance_status,
    this.placement_company_loc_status,
    this.placement_workbook_status,
  });

  AddPlacementAttendanceData.fromJson(Map<String, dynamic> json) {
    student_id = json['student_id']?.cast<String>();
    job_id = json['job_id']?.cast<String>();
    job_title = json['job_title']?.cast<String>();
    company_name = json['company_name']?.cast<String>();
    attendance_form = json['attendance_form']?.cast<Map<String, dynamic>>();
    company_loc = json['company_loc']?.cast<Map<String, dynamic>>();
    workbook = json['workbook']?.cast<Map<String, dynamic>>();
    resignation_letter = json['resignation_letter']?.cast<Map<String, dynamic>>();
    resignation_reason = json['resignation_reason'];
    notice_period_end_date = json['notice_period_end_date'];
    uploadedOn = json['uploaded_on'];
    placement_attendance_status = json['placement_attendance_status'];
    placement_company_loc_status = json['placement_company_loc_status'];
    placement_workbook_status = json['placement_workbook_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_id'] = student_id;
    data['job_id'] = job_id;
    data['job_title'] = job_title;
    data['company_name'] = company_name;
    data['attendance_form'] = attendance_form;
    data['company_loc'] = company_loc;
    data['workbook'] = workbook;
    data['resignation_letter'] = resignation_letter;
    data['resignation_reason'] = resignation_reason;
    data['notice_period_end_date'] = notice_period_end_date;
    data['uploaded_on'] = uploadedOn;
    data['placement_attendance_status'] = placement_attendance_status;
    data['placement_company_loc_status'] = placement_company_loc_status;
    data['placement_workbook_status'] = placement_workbook_status;
    return data;
  }
}
