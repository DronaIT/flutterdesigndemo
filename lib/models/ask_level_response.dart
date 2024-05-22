class ASKLevelResponse {
  String? askType;
  List<String>? askParameters;
  String? askLevels;
  String? askLevelTitle;
  String? askCode;
  List<String>? createdBy;
  List<String>? createdEmployeeName;
  List<String>? updatedBy;
  List<String>? updatedEmployeeName;
  List<bool>? isActiveParameter;
  List<int>? parameterTotalValue;
  List<String>? parameterTitle;

  ASKLevelResponse(
      {this.askType,
      this.askParameters,
      this.askLevels,
      this.askLevelTitle,
      this.askCode,
      this.createdBy,
      this.createdEmployeeName,
      this.updatedBy,
      this.updatedEmployeeName,
      this.isActiveParameter,
      this.parameterTotalValue,
      this.parameterTitle});

  ASKLevelResponse.fromJson(Map<String, dynamic> json) {
    askType = json['ask_type'];
    askParameters = json['ask_parameters']?.cast<String>();
    askLevels = json['ask_levels'];
    askLevelTitle = json['ask_level_title'];
    askCode = json['ask_code'];
    createdBy = json['created_by']?.cast<String>();
    createdEmployeeName = json['created_employee_name']?.cast<String>();
    updatedBy = json['updated_by']?.cast<String>();
    updatedEmployeeName = json['updated_employee_name']?.cast<String>();
    isActiveParameter = json['is_active_parameter']?.cast<bool>();
    parameterTotalValue = json['parameter_total_value']?.cast<int>();
    parameterTitle = json['parameter_title']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ask_type'] = this.askType;
    data['ask_parameters'] = this.askParameters;
    data['ask_levels'] = this.askLevels;
    data['ask_code'] = this.askCode;
    data['ask_level_title'] = this.askLevelTitle;
    data['created_by'] = this.createdBy;
    data['created_employee_name'] = this.createdEmployeeName;
    data['updated_by'] = this.updatedBy;
    data['updated_employee_name'] = this.updatedEmployeeName;
    data['is_active_parameter'] = this.isActiveParameter;
    data['parameter_total_value'] = this.parameterTotalValue;
    data['parameter_title'] = this.parameterTitle;
    return data;
  }
}
