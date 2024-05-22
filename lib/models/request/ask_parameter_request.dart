class ASKParameterRequest {
  String? parameterTitle;
  String? parameterDescription;
  int? parameterTotalValue;
  List<String>? askLevel;
  List<String>? hubIds;
  List<String>? specializationIds;

  ASKParameterRequest(
      {this.parameterTitle,
        this.parameterDescription,
        this.parameterTotalValue,
        this.askLevel,
        this.hubIds,
        this.specializationIds});

  ASKParameterRequest.fromJson(Map<String, dynamic> json) {
    parameterTitle = json['parameter_title'];
    parameterDescription = json['parameter_description'];
    parameterTotalValue = json['parameter_total_value'];
    askLevel = json['ask_level'].cast<String>();
    hubIds = json['hub_ids'].cast<String>();
    specializationIds = json['specialization_ids'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parameter_title'] = this.parameterTitle;
    data['parameter_description'] = this.parameterDescription;
    data['parameter_total_value'] = this.parameterTotalValue;
    data['ask_level'] = this.askLevel;
    data['hub_ids'] = this.hubIds;
    data['specialization_ids'] = this.specializationIds;
    return data;
  }
}
