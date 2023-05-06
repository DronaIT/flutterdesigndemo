class AddUnitsRequest {
  String? unitTitle;
  List<String>? tBLTOPICS;
  List<String>? subjectIds;

  AddUnitsRequest({this.unitTitle, this.tBLTOPICS, this.subjectIds});

  AddUnitsRequest.fromJson(Map<String, dynamic> json) {
    unitTitle = json['unit_title'];
    tBLTOPICS = json['TBL_TOPICS']?.cast<String>();
    subjectIds = json['subject_ids']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit_title'] = this.unitTitle;
    data['TBL_TOPICS'] = this.tBLTOPICS;
    data['subject_ids'] = this.subjectIds;
    return data;
  }
}
