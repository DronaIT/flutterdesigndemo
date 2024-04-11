import 'package:flutterdesigndemo/models/document_response.dart';

class JobOpportunityResponse {
  String? jobDescription;
  String? internshipDuration;
  List<String>? companyId;
  String? specificRequirements;
  int? vacancies;
  String? jobType;
  String? internshipModes;
  String? timingEnd;
  String? gender;
  List<String>? semester;
  String? jobTitle;
  int? minimumAge;
  String? timingStart;
  List<String>? hubIds;
  List<String>? hubIdFromHubIds;
  String? status;
  int? jobId;
  String? stipendType;
  List<String>? specializationIds;
  List<String>? companyCode;
  List<String>? companyName;
  List<String>? reportingAddress;
  List<String>? reportingBranch;
  List<String>? city;
  String? jobCode;
  List<String>? contactNameFromCompanyId;
  String? joiningDate;

  List<String>? selectedStudents;
  List<String>? appearedForInterview;
  List<String>? attendance_data;
  int? stipendRangeMin;
  String? interviewPlaceAddress;
  List<String>? interviewCoordinator;
  List<String>? shortlistedStudents;
  String? interviewPlaceUrl;
  int? stipendRangeMax;
  List<String>? placedStudents;
  List<String>? placedStudentsWorkingNow;
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
  List<String>? shortlisted_students_number;

  List<String>? selected_students_email;
  List<String>? selected_students_enrollment_number;
  List<String>? selected_students_name;

  List<String>? rejected_students;

  List<String>? appeared_for_interview_email;
  List<String>? appeared_for_interview_enrollment_number;
  List<String>? appeared_for_interview_name;
  List<String>? appeared_for_interview_is_placed_now;
  List<String>? appeared_for_interview_mobile_number;

  List<DocumentResponse>? company_loi;
  List<DocumentResponse>? bond_structure;
  List<DocumentResponse>? incentive_structure;
  int? is_self_place;
  String? academic_year;
  String? created;

  int workingNow = 0;

  JobOpportunityResponse({
    this.jobDescription,
    this.internshipDuration,
    this.companyId,
    this.specificRequirements,
    this.vacancies,
    this.jobType,
    this.internshipModes,
    this.timingEnd,
    this.gender,
    this.semester,
    this.jobTitle,
    this.minimumAge,
    this.timingStart,
    this.hubIds,
    this.hubIdFromHubIds,
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
    this.appearedForInterview,
    this.attendance_data,
    this.stipendRangeMin,
    this.interviewPlaceAddress,
    this.interviewCoordinator,
    this.shortlistedStudents,
    this.interviewPlaceUrl,
    this.stipendRangeMax,
    this.placedStudents,
    this.placedStudentsWorkingNow,
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
    this.shortlisted_students_number,
    this.selected_students_email,
    this.selected_students_enrollment_number,
    this.selected_students_name,
    this.rejected_students,
    this.appeared_for_interview_name,
    this.appeared_for_interview_email,
    this.appeared_for_interview_enrollment_number,
    this.appeared_for_interview_is_placed_now,
    this.appeared_for_interview_mobile_number,
    this.company_loi,
    this.bond_structure,
    this.incentive_structure,
    this.is_self_place,
    this.academic_year,
    this.created,
  });

  JobOpportunityResponse.fromJson(Map<String, dynamic> json) {
    jobDescription = json['job_description'];
    internshipDuration = json['internship_duration'];
    companyId = json['company_id']?.cast<String>();
    specificRequirements = json['specific_requirements'];
    vacancies = json['vacancies'];
    jobType = json['job_type'];
    internshipModes = json['internship_modes'];
    timingEnd = json['timing_end'];
    gender = json['gender'];
    semester = json['semester']?.cast<String>();
    jobTitle = json['job_title'];
    minimumAge = json['minimum_age'];
    timingStart = json['timing_start'];
    hubIds = json['hub_ids']?.cast<String>();
    hubIdFromHubIds = json['hub_id (from hub_ids)']?.cast<String>();
    status = json['status'];
    jobId = json['job_id'];
    stipendType = json['stipend_type'];
    specializationIds = json['specialization_ids']?.cast<String>();
    companyCode = json['company_code']?.cast<String>();
    companyName = json['company_name']?.cast<String>();
    reportingAddress = json['reporting_address']?.cast<String>() ?? " ";
    reportingBranch = json['reporting_branch']?.cast<String>();
    city = json['city']?.cast<String>() ?? " ";
    jobCode = json['job_code'];
    contactNameFromCompanyId = json['contact_name (from company_id)']?.cast<String>();
    joiningDate = json['joining_date'];
    selectedStudents = json['selected_students']?.cast<String>();
    appearedForInterview = json['appeared_for_interview']?.cast<String>();
    attendance_data = json['TBL_PLACEMENT_ATTENDANCE']?.cast<String>();
    stipendRangeMin = json['stipend_range_min'];
    interviewPlaceAddress = json['interview_place_address'];
    interviewCoordinator = json['interview_coordinator']?.cast<String>();
    shortlistedStudents = json['shortlisted_students']?.cast<String>();
    interviewPlaceUrl = json['interview_place_url'];
    stipendRangeMax = json['stipend_range_max'];
    placedStudents = json['placed_students']?.cast<String>();
    placedStudentsWorkingNow = json['placed_students_is_placed_now']?.cast<String>();
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
    shortlisted_students_number = json['shortlisted_students_number']?.cast<String>();

    selected_students_email = json['selected_students_email']?.cast<String>();
    selected_students_enrollment_number = json['selected_students_enrollment_number']?.cast<String>();
    selected_students_name = json['selected_students_name']?.cast<String>();

    appeared_for_interview_email = json['appeared_for_interview_email']?.cast<String>();
    appeared_for_interview_enrollment_number = json['appeared_for_interview_enrollment_number']?.cast<String>();
    appeared_for_interview_name = json['appeared_for_interview_name']?.cast<String>();
    appeared_for_interview_is_placed_now = json['appeared_for_interview_is_placed_now']?.cast<String>();
    appeared_for_interview_mobile_number = json['appeared_for_interview_mobile_number']?.cast<String>();

    rejected_students = json['rejected_students']?.cast<String>();
    is_self_place = json['is_self_place'];
    academic_year = json['academic_year'];
    created = json['Created'];

    if (json['company_loi'] != null) {
      company_loi = <DocumentResponse>[];
      json['company_loi'].forEach((v) {
        company_loi!.add(DocumentResponse.fromJson(v));
      });
    }
    if (json['bond_structure'] != null) {
      bond_structure = <DocumentResponse>[];
      json['bond_structure'].forEach((v) {
        bond_structure!.add(DocumentResponse.fromJson(v));
      });
    }
    if (json['incentive_structure'] != null) {
      incentive_structure = <DocumentResponse>[];
      json['incentive_structure'].forEach((v) {
        incentive_structure!.add(DocumentResponse.fromJson(v));
      });
    }

    if (json['applied_students_resume'] != null) {
      applied_students_resume = <AppliedResume>[];
      json['applied_students_resume'].forEach((v) {
        applied_students_resume?.add(AppliedResume.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['job_description'] = jobDescription;
    data['internship_duration'] = internshipDuration;
    data['company_id'] = companyId;
    data['specific_requirements'] = specificRequirements;
    data['vacancies'] = vacancies;
    data['job_type'] = jobType;
    data['internship_modes'] = internshipModes;
    data['timing_end'] = timingEnd;
    data['gender'] = gender;
    data['semester'] = semester;
    data['job_title'] = jobTitle;
    data['minimum_age'] = minimumAge;
    data['timing_start'] = timingStart;
    data['hub_ids'] = hubIds;
    data['hub_id (from hub_ids)'] = hubIdFromHubIds;
    data['status'] = status;
    data['job_id'] = jobId;
    data['stipend_type'] = stipendType;
    data['specialization_ids'] = specializationIds;
    data['company_code'] = companyCode;
    data['company_name'] = companyName;
    data['reporting_address'] = reportingAddress;
    data['reporting_branch'] = reportingBranch;
    data['city'] = city;
    data['job_code'] = jobCode;
    data['contact_name (from company_id)'] = contactNameFromCompanyId;
    data['joining_date'] = joiningDate;
    data['selected_students'] = selectedStudents;
    data['appeared_for_interview'] = appearedForInterview;
    data['TBL_PLACEMENT_ATTENDANCE'] = attendance_data;
    data['stipend_range_min'] = stipendRangeMin;
    data['interview_place_address'] = interviewPlaceAddress;
    data['interview_coordinator'] = interviewCoordinator;
    data['shortlisted_students'] = shortlistedStudents;
    data['interview_place_url'] = interviewPlaceUrl;
    data['stipend_range_max'] = stipendRangeMax;
    data['placed_students'] = placedStudents;
    data['placed_students_is_placed_now'] = placedStudentsWorkingNow;
    data['interview_datetime'] = interviewDatetime;
    data['job_apply_end_time'] = jobApplyEndTime;
    data['job_apply_start_time'] = jobApplyStartTime;
    data['interview_instruction'] = interviewInstruction;
    data['applied_students'] = appliedStudents;
    data['coordinator_name'] = coordinatorName;
    data['coordinator_mobile_number'] = coordinatorMobileNumber;
    data['applied_students_email'] = applied_students_email;
    data['applied_students_enrollment_number'] = applied_students_enrollment_number;
    data['applied_students_name'] = applied_students_name;
    data['applied_students_number'] = applied_students_number;
    data['applied_students_specialization'] = applied_students_specialization;
    data['applied_students_semester'] = applied_students_semester;

    data['shortlisted_students_email'] = shortlisted_students_email;
    data['shortlisted_students_enrollment_number'] = shortlisted_students_enrollment_number;
    data['shortlisted_students_name'] = shortlisted_students_name;
    data['shortlisted_students_number'] = shortlisted_students_number;

    data['appeared_for_interview_email'] = appeared_for_interview_email;
    data['appeared_for_interview_enrollment_number'] = appeared_for_interview_enrollment_number;
    data['appeared_for_interview_name'] = appeared_for_interview_name;
    data['appeared_for_interview_is_placed_now'] = appeared_for_interview_is_placed_now;
    data['appeared_for_interview_mobile_number'] = appeared_for_interview_mobile_number;

    data['selected_students_email'] = selected_students_email;
    data['selected_students_enrollment_number'] = selected_students_enrollment_number;
    data['selected_students_name'] = selected_students_name;
    data['rejected_students'] = rejected_students;
    data['is_self_place'] = is_self_place;
    data['academic_year'] = academic_year;
    data['Created'] = created;

    if (company_loi != null) {
      data['company_loi'] = company_loi!.map((v) => v.toJson()).toList();
    }
    if (bond_structure != null) {
      data['bond_structure'] = bond_structure!.map((v) => v.toJson()).toList();
    }
    if (incentive_structure != null) {
      data['incentive_structure'] = incentive_structure!.map((v) => v.toJson()).toList();
    }
    if (applied_students_resume != null) {
      data['applied_students_resume'] = applied_students_resume?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppliedResume {
  String? id;
  String? url;
  String? filename;

  AppliedResume({
    this.id,
    this.url,
    this.filename,
  });

  AppliedResume.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    filename = json['filename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['filename'] = filename;
    return data;
  }
}
