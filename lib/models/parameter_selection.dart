class ParameterSelection {
  bool? isActiveParameter;
  int? parameterTotalValue;
  String? parameterTitle;
  String? parameterReceivedValue;

  ParameterSelection({
    this.isActiveParameter,
    this.parameterTotalValue,
    this.parameterTitle,
    this.parameterReceivedValue,
  });

  ParameterSelection.fromJson(Map<String, dynamic> json) {
    isActiveParameter = json['is_active_parameter'];
    parameterTotalValue = json['parameter_total_value'];
    parameterTitle = json['parameter_title'];
    parameterReceivedValue = json['parameter_received_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_active_parameter'] = this.isActiveParameter;
    data['parameter_total_value'] = this.parameterTotalValue;
    data['parameter_title'] = this.parameterTitle;
    data['parameter_received_value'] = this.parameterReceivedValue;
    return data;
  }
}
