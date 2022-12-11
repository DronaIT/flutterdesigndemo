class SpecializationResponse {
  List<String>? tBLSTUDENT;
  String? specializationId;
  String? tBLUSER;
  String? specializationName;
  List<String>? hubIds;
  List<String>? hubIdFromHubIds;

  SpecializationResponse({this.tBLSTUDENT, this.specializationId, this.tBLUSER, this.specializationName, this.hubIds, this.hubIdFromHubIds});

  SpecializationResponse.fromJson(Map<String, dynamic> json) {
    tBLSTUDENT = json['TBL_STUDENT'].cast<String>();
    specializationId = json['specialization_id'];
    tBLUSER = json['TBL_USER'];
    specializationName = json['specialization_name'];
    hubIds = json['hub_ids'].cast<String>();
    hubIdFromHubIds = json['hub_id (from hub_ids)'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TBL_STUDENT'] = this.tBLSTUDENT;
    data['specialization_id'] = this.specializationId;
    data['TBL_USER'] = this.tBLUSER;
    data['specialization_name'] = this.specializationName;
    data['hub_ids'] = this.hubIds;
    data['hub_id (from hub_ids)'] = this.hubIdFromHubIds;
    return data;
  }
}
