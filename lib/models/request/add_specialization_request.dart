class AddSpecializationRequest {
  String? specializationName;
  String? specializationDesc;
  List<String>? tBLSUBJECT;
  // List<String>? hubIds;

  AddSpecializationRequest({this.specializationName, this.specializationDesc, this.tBLSUBJECT});

  AddSpecializationRequest.fromJson(Map<String, dynamic> json) {
    specializationName = json['specialization_name'];
    specializationDesc = json['specialization_desc'];
    tBLSUBJECT = json['TBL_SUBJECT']?.cast<String>();
    // hubIds = json['hub_ids']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['specialization_name'] = specializationName;
    data['specialization_desc'] = specializationDesc;
    data['TBL_SUBJECT'] = tBLSUBJECT;
    // data['hub_ids'] = this.hubIds;
    return data;
  }
}
