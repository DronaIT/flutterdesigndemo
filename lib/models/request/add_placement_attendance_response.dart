import 'package:flutterdesigndemo/models/document_response.dart';

class AddPlacementAttendanceResponse {
  List<String>? student_id;
  List<String>? job_id;
  List<String>? job_title;
  List<String>? company_name;
  List<String>? student_name;

  List<DocumentResponse>? attendance_form;
  List<DocumentResponse>? company_loc;
  List<DocumentResponse>? workbook;
  List<DocumentResponse>? resignation_letter;

  String? resignation_reason;
  String? notice_period_end_date;
  String? uploadedOn;
  String? placement_attendance_status;
  String? placement_company_loc_status;
  String? placement_workbook_status;
  String? attendance_rejection_reason;
  String? company_loc_rejection_reason;
  String? workbook_rejection_reason;
  String? skp_marks;
  String? skp_hours;
  String? attendance_hours;

  AddPlacementAttendanceResponse({
    this.student_id,
    this.job_id,
    this.job_title,
    this.company_name,
    this.student_name,

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
    this.attendance_rejection_reason,
    this.company_loc_rejection_reason,
    this.workbook_rejection_reason,
    this.skp_marks,
    this.skp_hours,
    this.attendance_hours,
  });

  AddPlacementAttendanceResponse.fromJson(Map<String, dynamic> json) {
    student_id = json['student_id']?.cast<String>();
    job_id = json['job_id']?.cast<String>();
    job_title = json['job_title']?.cast<String>();
    company_name = json['company_name']?.cast<String>();
    student_name = json['student_name']?.cast<String>();

    resignation_reason = json['resignation_reason'];
    notice_period_end_date = json['notice_period_end_date'];
    uploadedOn = json['uploaded_on'];
    placement_attendance_status = json['placement_attendance_status'];
    placement_company_loc_status = json['placement_company_loc_status'];
    placement_workbook_status = json['placement_workbook_status'];
    attendance_rejection_reason = json['attendance_rejection_reason'];
    company_loc_rejection_reason = json['company_loc_rejection_reason'];
    workbook_rejection_reason = json['workbook_rejection_reason'];
    skp_marks = json['skp_marks'];
    skp_hours = json['skp_hours'];
    attendance_hours = json['attendance_hours'];

    if (json['attendance_form'] != null) {
      attendance_form = <DocumentResponse>[];
      json['attendance_form'].forEach((v) {
        attendance_form!.add(DocumentResponse.fromJson(v));
      });
    }
    if (json['company_loc'] != null) {
      company_loc = <DocumentResponse>[];
      json['company_loc'].forEach((v) {
        company_loc!.add(DocumentResponse.fromJson(v));
      });
    }
    if (json['workbook'] != null) {
      workbook = <DocumentResponse>[];
      json['workbook'].forEach((v) {
        workbook!.add(DocumentResponse.fromJson(v));
      });
    }
    if (json['resignation_letter'] != null) {
      resignation_letter = <DocumentResponse>[];
      json['resignation_letter'].forEach((v) {
        resignation_letter!.add(DocumentResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_id'] = student_id;
    data['job_id'] = job_id;
    data['job_title'] = job_title;
    data['company_name'] = company_name;
    data['student_name'] = student_name;

    data['resignation_reason'] = resignation_reason;
    data['notice_period_end_date'] = notice_period_end_date;
    data['uploaded_on'] = uploadedOn;
    data['placement_attendance_status'] = placement_attendance_status;
    data['placement_company_loc_status'] = placement_company_loc_status;
    data['placement_workbook_status'] = placement_workbook_status;
    data['attendance_rejection_reason'] = attendance_rejection_reason;
    data['company_loc_rejection_reason'] = company_loc_rejection_reason;
    data['workbook_rejection_reason'] = workbook_rejection_reason;
    data['skp_marks'] = skp_marks;
    data['skp_hours'] = skp_hours;
    data['attendance_hours'] = attendance_hours;

    if (attendance_form != null) {
      data['attendance_form'] = attendance_form!.map((v) => v.toJson()).toList();
    }
    if (company_loc != null) {
      data['company_loc'] = company_loc!.map((v) => v.toJson()).toList();
    }
    if (workbook != null) {
      data['workbook'] = workbook!.map((v) => v.toJson()).toList();
    }
    if (resignation_letter != null) {
      data['resignation_letter'] = resignation_letter!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
