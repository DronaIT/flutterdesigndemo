class SpecializationResponse {
  int? id;
  String? specializationId;
  String? specializationName;
  List<String>? hubIds;
  List<String>? hubIdFromHubIds;
  String? specializationDesc;

  SpecializationResponse({this.id, this.specializationId, this.specializationName, this.hubIds, this.hubIdFromHubIds, this.specializationDesc});

  SpecializationResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specializationId = json['specialization_id'];
    specializationName = json['specialization_name'];
    hubIds = json['hub_ids']?.cast<String>();
    hubIdFromHubIds = json['hub_id (from hub_ids)']?.cast<String>();
    specializationDesc = json['specialization_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specialization_id'] = this.specializationId;
    data['specialization_name'] = this.specializationName;
    data['hub_ids'] = this.hubIds;
    data['hub_id (from hub_ids)'] = this.hubIdFromHubIds;
    data['specialization_desc'] = this.specializationDesc;
    return data;
  }
}
