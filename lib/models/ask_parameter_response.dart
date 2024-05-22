class ASKParameterResponse {
  String? parameterTitle;
  String? parameterDescription;
  String? askParameterCode;
  bool? isActive;
  int? parameterTotalValue;
  String? parameterType;
  List<String>? askType;
  List<String>? askLevel;
  List<String>? askLevelTitle;
  List<String>? askCode;
  List<String>? hubIds;
  List<String>? hubIdFromHubIds;
  List<String>? specializationIds;
  List<String>? specializationIdFromSpecializationIds;

  ASKParameterResponse(
      {this.parameterTitle,
      this.parameterDescription,
      this.askParameterCode,
      this.isActive,
      this.parameterTotalValue,
      this.parameterType,
      this.askType,
      this.askLevel,
      this.askLevelTitle,
      this.askCode,
      this.hubIds,
      this.hubIdFromHubIds,
      this.specializationIds,
      this.specializationIdFromSpecializationIds});

  ASKParameterResponse.fromJson(Map<String, dynamic> json) {
    parameterTitle = json['parameter_title'];
    parameterDescription = json['parameter_description'];
    askParameterCode = json['ask_parameter_code'];
    isActive = json['is_active'];
    parameterTotalValue = json['parameter_total_value'];
    parameterType = json['parameter_type'];
    askType = json['ask_type']?.cast<String>();
    askLevel = json['ask_level']?.cast<String>();
    askLevelTitle = json['ask_level_title']?.cast<String>();
    askCode = json['ask_code']?.cast<String>();
    hubIds = json['hub_ids']?.cast<String>();
    hubIdFromHubIds = json['hub_id (from hub_ids)']?.cast<String>();
    specializationIds = json['specialization_ids']?.cast<String>();
    specializationIdFromSpecializationIds = json['specialization_id (from specialization_ids)']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parameter_title'] = this.parameterTitle;
    data['parameter_description'] = this.parameterDescription;
    data['ask_parameter_code'] = this.askParameterCode;
    data['is_active'] = this.isActive;
    data['parameter_total_value'] = this.parameterTotalValue;
    data['parameter_type'] = this.parameterType;
    data['ask_type'] = this.askType;
    data['ask_level'] = this.askLevel;
    data['ask_level_title'] = this.askLevelTitle;
    data['ask_code'] = this.askCode;
    data['hub_ids'] = this.hubIds;
    data['hub_id (from hub_ids)'] = this.hubIdFromHubIds;
    data['specialization_ids'] = this.specializationIds;
    data['specialization_id (from specialization_ids)'] = this.specializationIdFromSpecializationIds;
    return data;
  }
}
