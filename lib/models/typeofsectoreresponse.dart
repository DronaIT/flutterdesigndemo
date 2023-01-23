class TypeOfsectoreResponse {
  int? id;
  String? sectorTitle;
  List<String>? tBLCOMPANY;

  TypeOfsectoreResponse({this.id, this.sectorTitle, this.tBLCOMPANY});

  TypeOfsectoreResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sectorTitle = json['sector_title'];
    tBLCOMPANY = json['TBL_COMPANY']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sector_title'] = this.sectorTitle;
    data['TBL_COMPANY'] = this.tBLCOMPANY;
    return data;
  }
}
