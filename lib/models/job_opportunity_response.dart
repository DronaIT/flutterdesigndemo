import 'package:flutterdesigndemo/models/document_response.dart';

class JobOpportunityResponse {
  String? jobDescription;
  String? internshipDuration;
  List<String>? companyId;
  String? specificRequirements;
  int? vacancies;
  String? internshipModes;
  String? timingEnd;
  String? gender;
  List<String>? semester;
  String? jobTitle;
  int? minimumAge;
  String? timingStart;
  List<String>? hubIds;
  String? status;
  int? jobId;
  String? stipendType;
  List<String>? specializationIds;
  List<String>? companyCode;
  List<String>? companyName;
  List<dynamic>? reportingAddress;
  List<String>? reportingBranch;
  List<dynamic>? city;
  String? jobCode;
  List<String>? contactNameFromCompanyId;

  String? joiningDate;
  List<String>? selectedStudents;
  List<String>? attendance_data;
  int? stipendRangeMin;
  String? interviewPlaceAddress;
  List<String>? interviewCoordinator;
  List<String>? shortlistedStudents;
  String? interviewPlaceUrl;
  int? stipendRangeMax;
  List<String>? placedStudents;
  String? interviewDatetime;
  String? jobApplyEndTime;
  String? jobApplyStartTime;
  String? interviewInstruction;
  List<String>? appliedStudents;
  String? coordinatorName;
  String? coordinatorMobileNumber;

  List<String>? applied_students_email;
  List<String>? applied_students_enrollment_number;
  List<String>? applied_students_name;
  List<String>? applied_students_number;
  List<String>? applied_students_specialization;
  List<String>? applied_students_semester;
  List<AppliedResume>? applied_students_resume;

  List<String>? shortlisted_students_email;
  List<String>? shortlisted_students_enrollment_number;
  List<String>? shortlisted_students_name;

  List<String>? selected_students_email;
  List<String>? selected_students_enrollment_number;
  List<String>? selected_students_name;

  List<String>? rejected_students;
  List<DocumentResponse>? company_loi;
  List<DocumentResponse>? bond_structure;
  List<DocumentResponse>? incentive_structure;

  JobOpportunityResponse({
      this.jobDescription,
      this.internshipDuration,
      this.companyId,
      this.specificRequirements,
      this.vacancies,
      this.internshipModes,
      this.timingEnd,
      this.gender,
      this.semester,
      this.jobTitle,
      this.minimumAge,
      this.timingStart,
      this.hubIds,
      this.status,
      this.jobId,
      this.stipendType,
      this.specializationIds,
      this.companyCode,
      this.companyName,
      this.reportingAddress,
      this.reportingBranch,
      this.city,
      this.jobCode,
      this.contactNameFromCompanyId,
      this.joiningDate,
      this.selectedStudents,
      this.attendance_data,
      this.stipendRangeMin,
      this.interviewPlaceAddress,
      this.interviewCoordinator,
      this.shortlistedStudents,
      this.interviewPlaceUrl,
      this.stipendRangeMax,
      this.placedStudents,
      this.interviewDatetime,
      this.jobApplyEndTime,
      this.jobApplyStartTime,
      this.interviewInstruction,
      this.appliedStudents,
      this.coordinatorName,
      this.coordinatorMobileNumber,
      this.applied_students_email,
      this.applied_students_enrollment_number,
      this.applied_students_name,
      this.applied_students_number,
      this.applied_students_specialization,
      this.applied_students_semester,
      this.shortlisted_students_email,
      this.shortlisted_students_enrollment_number,
      this.shortlisted_students_name,
      this.selected_students_email,
      this.selected_students_enrollment_number,
      this.selected_students_name,
      this.rejected_students,
      this.company_loi,
      this.bond_structure,
      this.incentive_structure,
  });

  JobOpportunityResponse.fromJson(Map<String, dynamic> json) {
    jobDescription = json['job_description'];
    internshipDuration = json['internship_duration'];
    companyId = json['company_id']?.cast<String>();
    specificRequirements = json['specific_requirements'];
    vacancies = json['vacancies'];
    internshipModes = json['internship_modes'];
    timingEnd = json['timing_end'];
    gender = json['gender'];
    semester = json['semester']?.cast<String>();
    jobTitle = json['job_title'];
    minimumAge = json['minimum_age'];
    timingStart = json['timing_start'];
    hubIds = json['hub_ids']?.cast<String>();
    status = json['status'];
    jobId = json['job_id'];
    stipendType = json['stipend_type'];
    specializationIds = json['specialization_ids']?.cast<String>();
    companyCode = json['company_code']?.cast<String>();
    companyName = json['company_name']?.cast<String>();
    reportingAddress = json['reporting_address']?.cast<dynamic>() ?? " ";
    reportingBranch = json['reporting_branch']?.cast<String>() ;
    city = json['city']?.cast<dynamic>() ?? " ";
    jobCode = json['job_code'];
    contactNameFromCompanyId = json['contact_name (from company_id)']?.cast<String>();
    joiningDate = json['joining_date'];
    selectedStudents = json['selected_students']?.cast<String>();
    attendance_data = json['TBL_PLACEMENT_ATTENDANCE']?.cast<String>();
    stipendRangeMin = json['stipend_range_min'];
    interviewPlaceAddress = json['interview_place_address'];
    interviewCoordinator = json['interview_coordinator']?.cast<String>();
    shortlistedStudents = json['shortlisted_students']?.cast<String>();
    interviewPlaceUrl = json['interview_place_url'];
    stipendRangeMax = json['stipend_range_max'];
    placedStudents = json['placed_students']?.cast<String>();
    interviewDatetime = json['interview_datetime'];
    jobApplyEndTime = json['job_apply_end_time'];
    jobApplyStartTime = json['job_apply_start_time'];
    interviewInstruction = json['interview_instruction'];
    appliedStudents = json['applied_students']?.cast<String>();
    coordinatorName = json['coordinator_name'];
    coordinatorMobileNumber = json['coordinator_mobile_number'];
    applied_students_email = json['applied_students_email']?.cast<String>();
    applied_students_enrollment_number = json['applied_students_enrollment_number']?.cast<String>();
    applied_students_name = json['applied_students_name']?.cast<String>();
    applied_students_number = json['applied_students_number']?.cast<String>();
    applied_students_specialization = json['applied_students_specialization']?.cast<String>();
    applied_students_semester = json['applied_students_semester']?.cast<String>();

    shortlisted_students_email = json['shortlisted_students_email']?.cast<String>();
    shortlisted_students_enrollment_number = json['shortlisted_students_enrollment_number']?.cast<String>();
    shortlisted_students_name = json['shortlisted_students_name']?.cast<String>();

    selected_students_email = json['selected_students_email']?.cast<String>();
    selected_students_enrollment_number = json['selected_students_enrollment_number']?.cast<String>();
    selected_students_name = json['selected_students_name']?.cast<String>();

    rejected_students = json['rejected_students']?.cast<String>();

    if (json['company_loi'] != null) {
      company_loi = <DocumentResponse>[];
      json['company_loi'].forEach((v) {
        company_loi!.add(new DocumentResponse.fromJson(v));
      });
    }
  if (json['bond_structure'] != null) {
      bond_structure = <DocumentResponse>[];
      json['bond_structure'].forEach((v) {
        bond_structure!.add(new DocumentResponse.fromJson(v));
      });
    }
  if (json['incentive_structure'] != null) {
    incentive_structure = <DocumentResponse>[];
      json['incentive_structure'].forEach((v) {
        incentive_structure!.add(new DocumentResponse.fromJson(v));
      });
    }

    if (json['applied_students_resume'] != null) {
      applied_students_resume = <AppliedResume>[];
      json['applied_students_resume'].forEach((v) {
        applied_students_resume?.add(new AppliedResume.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_description'] = this.jobDescription;
    data['internship_duration'] = this.internshipDuration;
    data['company_id'] = this.companyId;
    data['specific_requirements'] = this.specificRequirements;
    data['vacancies'] = this.vacancies;
    data['internship_modes'] = this.internshipModes;
    data['timing_end'] = this.timingEnd;
    data['gender'] = this.gender;
    data['semester'] = this.semester;
    data['job_title'] = this.jobTitle;
    data['minimum_age'] = this.minimumAge;
    data['timing_start'] = this.timingStart;
    data['hub_ids'] = this.hubIds;
    data['status'] = this.status;
    data['job_id'] = this.jobId;
    data['stipend_type'] = this.stipendType;
    data['specialization_ids'] = this.specializationIds;
    data['company_code'] = this.companyCode;
    data['company_name'] = this.companyName;
    data['reporting_address'] = this.reportingAddress;
    data['reporting_branch'] = this.reportingBranch;
    data['city'] = this.city;
    data['job_code'] = this.jobCode;
    data['contact_name (from company_id)'] = this.contactNameFromCompanyId;
    data['joining_date'] = this.joiningDate;
    data['selected_students'] = this.selectedStudents;
    data['TBL_PLACEMENT_ATTENDANCE'] = this.attendance_data;
    data['stipend_range_min'] = this.stipendRangeMin;
    data['interview_place_address'] = this.interviewPlaceAddress;
    data['interview_coordinator'] = this.interviewCoordinator;
    data['shortlisted_students'] = this.shortlistedStudents;
    data['interview_place_url'] = this.interviewPlaceUrl;
    data['stipend_range_max'] = this.stipendRangeMax;
    data['placed_students'] = this.placedStudents;
    data['interview_datetime'] = this.interviewDatetime;
    data['job_apply_end_time'] = this.jobApplyEndTime;
    data['job_apply_start_time'] = this.jobApplyStartTime;
    data['interview_instruction'] = this.interviewInstruction;
    data['applied_students'] = this.appliedStudents;
    data['coordinator_name'] = this.coordinatorName;
    data['coordinator_mobile_number'] = this.coordinatorMobileNumber;
    data['applied_students_email'] = this.applied_students_email;
    data['applied_students_enrollment_number'] = this.applied_students_enrollment_number;
    data['applied_students_name'] = this.applied_students_name;
    data['applied_students_number'] = this.applied_students_number;
    data['applied_students_specialization'] = this.applied_students_specialization;
    data['applied_students_semester'] = this.applied_students_semester;

    data['shortlisted_students_email'] = this.shortlisted_students_email;
    data['shortlisted_students_enrollment_number'] = this.shortlisted_students_enrollment_number;
    data['shortlisted_students_name'] = this.shortlisted_students_name;

    data['selected_students_email'] = this.selected_students_email;
    data['selected_students_enrollment_number'] = this.selected_students_enrollment_number;
    data['selected_students_name'] = this.selected_students_name;
    data['rejected_students'] = this.rejected_students;

    if (this.company_loi != null) {
      data['company_loi'] = this.company_loi!.map((v) => v.toJson()).toList();
    }
    if (this.bond_structure != null) {
      data['bond_structure'] = this.bond_structure!.map((v) => v.toJson()).toList();
    }
    if (this.incentive_structure != null) {
      data['incentive_structure'] = this.incentive_structure!.map((v) => v.toJson()).toList();
    }
    if (this.applied_students_resume != null) {
      data['applied_students_resume'] = this.applied_students_resume?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppliedResume {
  String? id;
  String? url;
  String? filename;

  AppliedResume(
      {this.id,
        this.url,
        this.filename,
      });

  AppliedResume.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    filename = json['filename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['filename'] = this.filename;
    return data;
  }
}
