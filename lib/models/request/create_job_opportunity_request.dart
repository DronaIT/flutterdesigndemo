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
  String? internshipModes;
  String? internshipDuration;
  List<String>? specializationIds;
  List<String>? semester;
  List<String>? hubIds;
  List<Map<String, dynamic>>? bondStructure;
  List<Map<String, dynamic>>? incentiveStructure;
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
    this.internshipModes,
    this.internshipDuration,
    this.specializationIds,
    this.semester,
    this.hubIds,
    this.bondStructure,
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
    internshipModes = json['internship_modes'];
    internshipDuration = json['internship_duration'];
    specializationIds = json['specialization_ids']?.cast<String>();
    semester = json['semester']?.cast<String>();
    hubIds = json['hub_ids']?.cast<String>();
    bondStructure = json['bond_structure']?.cast<Map<String, dynamic>>();
    incentiveStructure = json['incentive_structure']?.cast<Map<String, dynamic>>();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_title'] = this.jobTitle;
    data['status'] = this.status;
    data['company_id'] = this.companyId;
    data['job_description'] = this.jobDescription;
    data['specific_requirements'] = this.specificRequirements;
    data['stipend_type'] = this.stipendType;
    data['stipend_range_min'] = this.stipendRangeMin;
    data['stipend_range_max'] = this.stipendRangeMax;
    data['vacancies'] = this.vacancies;
    data['gender'] = this.gender;
    data['minimum_age'] = this.minimumAge;
    data['timing_start'] = this.timingStart;
    data['timing_end'] = this.timingEnd;
    data['internship_modes'] = this.internshipModes;
    data['internship_duration'] = this.internshipDuration;
    data['specialization_ids'] = this.specializationIds;
    data['semester'] = this.semester;
    data['hub_ids'] = this.hubIds;
    data['bond_structure'] = this.bondStructure;
    data['incentive_structure'] = this.incentiveStructure;
    data['job_apply_start_time'] = this.jobApplyStartTime;
    data['job_apply_end_time'] = this.jobApplyEndTime;
    data['shortlisted_students'] = this.sortlisted;
    data['appeared_for_interview'] = this.appearedForInterview;
    data['applied_students'] = this.applied_students;
    data['placed_students'] = this.placed_students;

    data['selected_students'] = this.selected;
    data['interview_datetime'] = this.interview_datetime;
    data['interview_instruction'] = this.interview_instruction;
    data['interview_place_address'] = this.interview_place_address;
    data['interview_place_url'] = this.interview_place_url;
    data['coordinator_mobile_number'] = this.coordinator_mobile_number;
    data['coordinator_name'] = this.coordinator_name;
    data['joining_date'] = this.joining_date;
    return data;
  }
}
