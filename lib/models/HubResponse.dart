class HubResponse {
  String? hubName;
  String? tBLBRANCH;
  List<String>? tBLSTUDENT;
  List<String>? tBLSPECIALIZATION;
  String? city;
  String? hubId;
  String? address;

  HubResponse({this.hubName, this.tBLBRANCH, this.tBLSTUDENT, this.tBLSPECIALIZATION, this.city, this.hubId, this.address});

  HubResponse.fromJson(Map<String, dynamic> json) {
    hubName = json['hub_name'];
    tBLBRANCH = json['TBL_BRANCH'];
    tBLSTUDENT = json['TBL_STUDENT'].cast<String>();
    tBLSPECIALIZATION = json['TBL_SPECIALIZATION'].cast<String>();
    city = json['city'];
    hubId = json['hub_id'];
    address = json['Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hub_name'] = this.hubName;
    data['TBL_BRANCH'] = this.tBLBRANCH;
    data['TBL_STUDENT'] = this.tBLSTUDENT;
    data['TBL_SPECIALIZATION'] = this.tBLSPECIALIZATION;
    data['city'] = this.city;
    data['hub_id'] = this.hubId;
    data['Address'] = this.address;
    return data;
  }
}
