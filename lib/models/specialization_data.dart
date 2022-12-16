class SpecializationData {
  List<String>? tBLSUBJECT;
  List<String>? tBLSTUDENT;
  String? specializationId;
  String? tBLUSER;
  String? specializationName;
  List<String>? hubIds;
  List<String>? hubIdFromHubIds;
  String? specializationDesc;

  SpecializationData({this.tBLSUBJECT, this.tBLSTUDENT, this.specializationId, this.tBLUSER, this.specializationName, this.hubIds, this.hubIdFromHubIds, this.specializationDesc});

  SpecializationData.fromJson(Map<String, dynamic> json) {
    tBLSUBJECT = json['TBL_SUBJECT'].cast<String>();
    tBLSTUDENT = json['TBL_STUDENT'].cast<String>();
    specializationId = json['specialization_id'];
    tBLUSER = json['TBL_USER'];
    specializationName = json['specialization_name'];
    hubIds = json['hub_ids'].cast<String>();
    hubIdFromHubIds = json['hub_id (from hub_ids)'].cast<String>();
    specializationDesc = json['specialization_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TBL_SUBJECT'] = this.tBLSUBJECT;
    data['TBL_STUDENT'] = this.tBLSTUDENT;
    data['specialization_id'] = this.specializationId;
    data['TBL_USER'] = this.tBLUSER;
    data['specialization_name'] = this.specializationName;
    data['hub_ids'] = this.hubIds;
    data['hub_id (from hub_ids)'] = this.hubIdFromHubIds;
    data['specialization_desc'] = this.specializationDesc;
    return data;
  }
}
