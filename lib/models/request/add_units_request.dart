class AddUnitsRequest {
  String? unitTitle;
  List<String>? tBLTOPICS;

  AddUnitsRequest({this.unitTitle, this.tBLTOPICS});

  AddUnitsRequest.fromJson(Map<String, dynamic> json) {
    unitTitle = json['unit_title'];
    tBLTOPICS = json['TBL_TOPICS'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unit_title'] = this.unitTitle;
    data['TBL_TOPICS'] = this.tBLTOPICS;
    return data;
  }
}
