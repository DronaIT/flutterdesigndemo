class TypeOfSectorResponse {
  int? id;
  String? sectorTitle;
  List<String>? tBLCOMPANY;

  TypeOfSectorResponse({this.id, this.sectorTitle, this.tBLCOMPANY});

  TypeOfSectorResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sectorTitle = json['sector_title'];
    tBLCOMPANY = json['TBL_COMPANY']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sector_title'] = sectorTitle;
    data['TBL_COMPANY'] = tBLCOMPANY;
    return data;
  }
}
