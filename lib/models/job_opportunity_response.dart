class JobOpportunityResponse {
  String? jobDescription;
  String? internshipDuration;
  List<String>? companyId;
  String? specificRequirements;
  int? vacancies;
  String? internshipModes;
  int? stipendRangeMin;
  String? timingEnd;
  String? gender;
  List<IncentiveStructure>? incentiveStructure;
  List<String>? semester;
  int? stipendRangeMax;
  String? jobTitle;
  int? minimumAge;
  String? timingStart;
  List<String>? hubIds;
  String? status;
  int? id;
  String? stipendType;
  List<String>? specializationIds;
  List<String>? companyCode;
  List<String>? companyName;
  List<String>? reporting_address;
  List<String>? reporting_branch;
  List<String>? city;

  JobOpportunityResponse(
      {this.jobDescription,
      this.internshipDuration,
      this.companyId,
      this.specificRequirements,
      this.vacancies,
      this.internshipModes,
      this.stipendRangeMin,
      this.timingEnd,
      this.gender,
      this.incentiveStructure,
      this.semester,
      this.stipendRangeMax,
      this.jobTitle,
      this.minimumAge,
      this.timingStart,
      this.hubIds,
      this.status,
      this.id,
      this.stipendType,
      this.specializationIds,
      this.companyCode,
      this.reporting_branch,
      this.reporting_address,
      this.city,
      this.companyName});

  JobOpportunityResponse.fromJson(Map<String, dynamic> json) {
    jobDescription = json['job_description'];
    internshipDuration = json['internship_duration'];
    companyId = json['company_id']?.cast<String>();
    specificRequirements = json['specific_requirements'];
    vacancies = json['vacancies'];
    internshipModes = json['internship_modes'];
    stipendRangeMin = json['stipend_range_min'];
    timingEnd = json['timing_end'];
    gender = json['gender'];
    if (json['incentive_structure'] != null) {
      incentiveStructure = <IncentiveStructure>[];
      json['incentive_structure'].forEach((v) {
        incentiveStructure!.add(new IncentiveStructure.fromJson(v));
      });
    }
    semester = json['semester']?.cast<String>();
    stipendRangeMax = json['stipend_range_max'];
    jobTitle = json['job_title'];
    minimumAge = json['minimum_age'];
    timingStart = json['timing_start'];
    hubIds = json['hub_ids']?.cast<String>();
    status = json['status'];
    id = json['id'];
    stipendType = json['stipend_type'];
    specializationIds = json['specialization_ids']?.cast<String>();
    companyCode = json['company_code']?.cast<String>();
    companyName = json['company_name']?.cast<String>();

    reporting_address = json['reporting_address']?.cast<String>();
    reporting_branch = json['reporting_branch']?.cast<String>();
    city = json['city']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['job_description'] = this.jobDescription;
    data['internship_duration'] = this.internshipDuration;
    data['company_id'] = this.companyId;
    data['specific_requirements'] = this.specificRequirements;
    data['vacancies'] = this.vacancies;
    data['internship_modes'] = this.internshipModes;
    data['stipend_range_min'] = this.stipendRangeMin;
    data['timing_end'] = this.timingEnd;
    data['gender'] = this.gender;
    if (this.incentiveStructure != null) {
      data['incentive_structure'] = this.incentiveStructure!.map((v) => v.toJson()).toList();
    }
    data['semester'] = this.semester;
    data['stipend_range_max'] = this.stipendRangeMax;
    data['job_title'] = this.jobTitle;
    data['minimum_age'] = this.minimumAge;
    data['timing_start'] = this.timingStart;
    data['hub_ids'] = this.hubIds;
    data['status'] = this.status;
    data['id'] = this.id;
    data['stipend_type'] = this.stipendType;
    data['specialization_ids'] = this.specializationIds;
    data['company_code'] = this.companyCode;
    data['company_name'] = this.companyName;

    data['reporting_address'] = this.reporting_address;
    data['reporting_branch'] = this.reporting_branch;
    data['city'] = this.city;
    return data;
  }
}

class IncentiveStructure {
  String? id;
  String? url;
  String? filename;
  int? size;
  String? type;

  IncentiveStructure({this.id, this.url, this.filename, this.size, this.type});

  IncentiveStructure.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    filename = json['filename'];
    size = json['size'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['filename'] = this.filename;
    data['size'] = this.size;
    data['type'] = this.type;
    return data;
  }
}
