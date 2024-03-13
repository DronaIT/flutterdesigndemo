import 'package:flutterdesigndemo/models/attachment_response.dart';

class CompanyDetailResponse {
  int? id;
  String? companyName;
  String? contactName;
  String? contactNumber;
  String? contactWhatsappNumber;
  String? contactDesignation;
  String? contactEmail;
  String? companyWebsite;
  String? companyIdentityNumber;
  String? company_code;
  String? company_landline;
  List<String>? companySector;
  List<String>? sectorTitleFromCompanySector;
  List<String>? hubIds;
  List<String>? hubIdFromHubIds;
  List<AttachmentResponse>? company_loi;
  List<AttachmentResponse>? company_logo;
  String? reporting_branch;
  String? reporting_address;
  String? city;
  String? password;
  String? token;
  String? status;
  String? rejection_reason;
  List<String>? created_by_student;
  List<String>? created_by_student_number;
  List<String>? created_by_student_name;
  List<String>? self_job;
  List<String>? self_job_code;
  List<String>? placed_students;
  List<String>? placed_students_is_placed_now;
  List<String>? placed_student_mobile_number;
  List<String>? placed_student_name;
  bool selected = false;

  CompanyDetailResponse({
    this.id,
    this.companyName,
    this.contactName,
    this.contactNumber,
    this.contactWhatsappNumber,
    this.contactDesignation,
    this.contactEmail,
    this.companyWebsite,
    this.companyIdentityNumber,
    this.companySector,
    this.company_code,
    this.company_landline,
    this.reporting_branch,
    this.reporting_address,
    this.city,
    this.sectorTitleFromCompanySector,
    this.password,
    this.token,
    this.hubIds,
    this.hubIdFromHubIds,
    this.company_loi,
    this.company_logo,
    this.status,
    this.rejection_reason,
    this.created_by_student,
    this.created_by_student_number,
    this.created_by_student_name,
    this.placed_students,
    this.placed_student_name,
    this.placed_students_is_placed_now,
    this.placed_student_mobile_number,
    this.self_job,
    this.self_job_code,
  });

  CompanyDetailResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hubIds = json['hub_id']?.cast<String>();
    hubIdFromHubIds = json['hub_id (from hub_ids)']?.cast<String>();
    companyName = json['company_name'];
    contactName = json['contact_name'];
    contactNumber = json['contact_number'];
    contactWhatsappNumber = json['contact_whatsapp_number'];
    contactDesignation = json['contact_designation'];
    contactEmail = json['contact_email'];
    companyWebsite = json['company_website'] ?? " ";
    companyIdentityNumber = json['company_identity_number'];
    company_code = json['company_code'];
    company_landline = json['company_landline'] ?? " ";
    companySector = json['company_sector']?.cast<String>();
    sectorTitleFromCompanySector = json['sector_title (from company_sector)']?.cast<String>();
    reporting_branch = json['reporting_branch'] ?? " ";
    reporting_address = json['reporting_address'] ?? " ";
    city = json['city'] ?? " ";
    password = json['password'] ?? " ";
    token = json['token'] ?? " ";
    status = json['status'] ?? " ";
    rejection_reason = json['rejection_reason'] ?? " ";
    created_by_student = json['created_by_student']?.cast<String>();
    created_by_student_number = json['created_by_student_number']?.cast<String>();
    created_by_student_name = json['created_by_student_name']?.cast<String>();
    placed_students = json['placed_students']?.cast<String>();
    placed_student_name = json['placed_student_name']?.cast<String>();
    placed_students_is_placed_now = json['placed_students_is_placed_now']?.cast<String>();
    placed_student_mobile_number = json['placed_student_mobile_number']?.cast<String>();
    self_job = json['self_job']?.cast<String>();
    self_job_code = json['self_job_code']?.cast<String>();
    if (json['company_loi'] != null) {
      company_loi = <AttachmentResponse>[];
      json['company_loi'].forEach((v) {
        company_loi!.add(AttachmentResponse.fromJson(v));
      });
    }
    if (json['company_logo'] != null) {
      company_logo = <AttachmentResponse>[];
      json['company_logo'].forEach((v) {
        company_logo!.add(AttachmentResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['hub_id'] = hubIds;
    data['hub_id (from hub_ids)'] = hubIdFromHubIds;
    data['contact_name'] = contactName;
    data['contact_number'] = contactNumber;
    data['contact_whatsapp_number'] = contactWhatsappNumber;
    data['company_code'] = company_code;
    data['company_landline'] = company_landline;
    data['contact_designation'] = contactDesignation;
    data['contact_email'] = contactEmail;
    data['company_website'] = companyWebsite;
    data['company_identity_number'] = companyIdentityNumber;
    data['company_sector'] = companySector;
    data['sector_title (from company_sector)'] = sectorTitleFromCompanySector;
    data['reporting_branch'] = reporting_branch;
    data['reporting_address'] = reporting_address;
    data['city'] = city;
    data['password'] = password;
    data['token'] = token;
    data['status'] = status;
    data['rejection_reason'] = rejection_reason;
    data['created_by_student'] = created_by_student;
    data['created_by_student_number'] = created_by_student_number;
    data['created_by_student_name'] = created_by_student_name;
    data['placed_students'] = placed_students;
    data['placed_student_name'] = placed_student_name;
    data['placed_students_is_placed_now'] = placed_students_is_placed_now;
    data['placed_student_mobile_number'] = placed_student_mobile_number;
    data['self_job'] = self_job;
    data['self_job_code'] = self_job_code;
    if (company_loi != null) {
      data['company_loi'] = company_loi!.map((v) => v.toJson()).toList();
    }
    if (company_logo != null) {
      data['company_logo'] = company_logo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
