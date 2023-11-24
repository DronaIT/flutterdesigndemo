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
  List<Attachment_response>? company_loi;
  List<Attachment_response>? company_logo;
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
    this.company_loi,
    this.company_logo,
    this.status,
    this.rejection_reason,
    this.created_by_student,
    this.created_by_student_number,
    this.created_by_student_name,
    this.self_job,
    this.self_job_code,
  });

  CompanyDetailResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hubIds = json['hub_id']?.cast<String>();
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
    self_job = json['self_job']?.cast<String>();
    self_job_code = json['self_job_code']?.cast<String>();
    if (json['company_loi'] != null) {
      company_loi = <Attachment_response>[];
      json['company_loi'].forEach((v) {
        company_loi!.add(Attachment_response.fromJson(v));
      });
    }
    if (json['company_logo'] != null) {
      company_logo = <Attachment_response>[];
      json['company_logo'].forEach((v) {
        company_logo!.add(Attachment_response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['hub_id'] = this.hubIds;
    data['contact_name'] = this.contactName;
    data['contact_number'] = this.contactNumber;
    data['contact_whatsapp_number'] = this.contactWhatsappNumber;
    data['company_code'] = this.company_code;
    data['company_landline'] = this.company_landline;
    data['contact_designation'] = this.contactDesignation;
    data['contact_email'] = this.contactEmail;
    data['company_website'] = this.companyWebsite;
    data['company_identity_number'] = this.companyIdentityNumber;
    data['company_sector'] = this.companySector;
    data['sector_title (from company_sector)'] = this.sectorTitleFromCompanySector;
    data['reporting_branch'] = this.reporting_branch;
    data['reporting_address'] = this.reporting_address;
    data['city'] = this.city;
    data['password'] = this.password;
    data['token'] = this.token;
    data['status'] = this.status;
    data['rejection_reason'] = this.rejection_reason;
    data['created_by_student'] = this.created_by_student;
    data['created_by_student_number'] = this.created_by_student_number;
    data['created_by_student_name'] = this.created_by_student_name;
    data['self_job'] = this.self_job;
    data['self_job_code'] = this.self_job_code;
    if (this.company_loi != null) {
      data['company_loi'] = this.company_loi!.map((v) => v.toJson()).toList();
    }
    if (this.company_logo != null) {
      data['company_logo'] = this.company_logo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
