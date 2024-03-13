class SpecializationData {
  String? specializationId;
  String? specializationName;
  List<String>? hubIds;
  List<String>? hubIdFromHubIds;
  String? specializationDesc;

  SpecializationData({this.specializationId, this.specializationName, this.hubIds, this.hubIdFromHubIds, this.specializationDesc});

  SpecializationData.fromJson(Map<String, dynamic> json) {
    specializationId = json['specialization_id'];
    specializationName = json['specialization_name'];
    hubIds = json['hub_ids']?.cast<String>();
    hubIdFromHubIds = json['hub_id (from hub_ids)']?.cast<String>();
    specializationDesc = json['specialization_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['specialization_id'] = specializationId;
    data['specialization_name'] = specializationName;
    data['hub_ids'] = hubIds;
    data['hub_id (from hub_ids)'] = hubIdFromHubIds;
    data['specialization_desc'] = specializationDesc;
    return data;
  }
}
