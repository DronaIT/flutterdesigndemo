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
  List<String>? sortlisted;

  CreateJobOpportunityRequest(
      {this.jobTitle,
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
        this.sortlisted,
      this.incentiveStructure});

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

    sortlisted = json['shortlisted_students']?.cast<String>();
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
    data['shortlisted_students'] = this.sortlisted;
    return data;
  }
}
