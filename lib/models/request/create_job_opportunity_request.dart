class CreateJobOpportunityRequest {
  String? jobTitle;
  String? status;
  List<String>? companyId;
  String? jobDescription;
  String? specificRequirements;
  String? stipendType;
  int? stipendRangeMin;
  int? stipendRangeMax;
  int? vacancies;
  String? gender;
  int? minimumAge;
  String? timingStart;
  String? timingEnd;
  String? jobType;
  String? internshipModes;
  String? internshipDuration;
  List<String>? specializationIds;
  List<String>? semester;
  List<String>? hubIds;
  List<Map<String, dynamic>>? bondStructure;
  List<Map<String, dynamic>>? incentiveStructure;
  String? jobRejectionReason;
  String? jobApplyStartTime;
  String? jobApplyEndTime;
  List<String>? sortlisted;
  List<String>? selected;
  List<String>? appearedForInterview;
  String? interview_datetime;
  String? interview_instruction;
  String? interview_place_address;
  String? interview_place_url;
  String? coordinator_mobile_number;
  String? coordinator_name;
  String? joining_date;
  List<String>? applied_students;
  List<String>? placed_students;

  CreateJobOpportunityRequest({
    this.jobTitle,
    this.status,
    this.companyId,
    this.jobDescription,
    this.specificRequirements,
    this.stipendType,
    this.stipendRangeMin,
    this.stipendRangeMax,
    this.vacancies,
    this.gender,
    this.minimumAge,
    this.timingStart,
    this.timingEnd,
    this.jobType,
    this.internshipModes,
    this.internshipDuration,
    this.specializationIds,
    this.semester,
    this.hubIds,
    this.bondStructure,
    this.jobRejectionReason,
    this.jobApplyStartTime,
    this.jobApplyEndTime,
    this.sortlisted,
    this.appearedForInterview,
    this.incentiveStructure,
    this.interview_datetime,
    this.interview_instruction,
    this.interview_place_address,
    this.interview_place_url,
    this.coordinator_mobile_number,
    this.coordinator_name,
    this.joining_date,
    this.applied_students,
    this.placed_students,
  });

  CreateJobOpportunityRequest.fromJson(Map<String, dynamic> json) {
    jobTitle = json['job_title'];
    status = json['status'];
    companyId = json['company_id']?.cast<String>();
    jobDescription = json['job_description'];
    specificRequirements = json['specific_requirements'];
    stipendType = json['stipend_type'];
    stipendRangeMin = json['stipend_range_min'];
    stipendRangeMax = json['stipend_range_max'];
    vacancies = json['vacancies'];
    gender = json['gender'];
    minimumAge = json['minimum_age'];
    timingStart = json['timing_start'];
    timingEnd = json['timing_end'];
    jobType = json['job_type'];
    internshipModes = json['internship_modes'];
    internshipDuration = json['internship_duration'];
    specializationIds = json['specialization_ids']?.cast<String>();
    semester = json['semester']?.cast<String>();
    hubIds = json['hub_ids']?.cast<String>();
    bondStructure = json['bond_structure']?.cast<Map<String, dynamic>>();
    incentiveStructure = json['incentive_structure']?.cast<Map<String, dynamic>>();
    jobRejectionReason = json['job_rejection_reason'];
    jobApplyStartTime = json['job_apply_start_time'];
    jobApplyEndTime = json['job_apply_end_time'];
    sortlisted = json['shortlisted_students']?.cast<String>();
    appearedForInterview = json['appeared_for_interview']?.cast<String>();
    applied_students = json['applied_students']?.cast<String>();
    placed_students = json['placed_students']?.cast<String>();

    interview_datetime = json['interview_datetime'];
    interview_instruction = json['interview_instruction'];
    interview_place_address = json['interview_place_address'];
    interview_place_url = json['interview_place_url'];
    coordinator_mobile_number = json['coordinator_mobile_number'];
    coordinator_name = json['coordinator_name'];
    selected = json['selected_students']?.cast<String>();
    joining_date = json['joining_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['job_title'] = jobTitle;
    data['status'] = status;
    data['company_id'] = companyId;
    data['job_description'] = jobDescription;
    data['specific_requirements'] = specificRequirements;
    data['stipend_type'] = stipendType;
    data['stipend_range_min'] = stipendRangeMin;
    data['stipend_range_max'] = stipendRangeMax;
    data['vacancies'] = vacancies;
    data['gender'] = gender;
    data['minimum_age'] = minimumAge;
    data['timing_start'] = timingStart;
    data['timing_end'] = timingEnd;
    data['job_type'] = jobType;
    data['internship_modes'] = internshipModes;
    data['internship_duration'] = internshipDuration;
    data['specialization_ids'] = specializationIds;
    data['semester'] = semester;
    data['hub_ids'] = hubIds;
    data['bond_structure'] = bondStructure;
    data['incentive_structure'] = incentiveStructure;
    data['job_rejection_reason'] = jobRejectionReason;
    data['job_apply_start_time'] = jobApplyStartTime;
    data['job_apply_end_time'] = jobApplyEndTime;
    data['shortlisted_students'] = sortlisted;
    data['appeared_for_interview'] = appearedForInterview;
    data['applied_students'] = applied_students;
    data['placed_students'] = placed_students;

    data['selected_students'] = selected;
    data['interview_datetime'] = interview_datetime;
    data['interview_instruction'] = interview_instruction;
    data['interview_place_address'] = interview_place_address;
    data['interview_place_url'] = interview_place_url;
    data['coordinator_mobile_number'] = coordinator_mobile_number;
    data['coordinator_name'] = coordinator_name;
    data['joining_date'] = joining_date;
    return data;
  }
}
