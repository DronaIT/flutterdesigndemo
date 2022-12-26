class AddHubRequest {
  String? hub_name;
  String? city;
  String? address;
  List<String>? tBLSPECIALIZATION;

  AddHubRequest({this.hub_name, this.city, this.address, this.tBLSPECIALIZATION});

  AddHubRequest.fromJson(Map<String, dynamic> json) {
    hub_name = json['hub_name'];
    city = json['city'];
    address = json['address'];
    tBLSPECIALIZATION = json['TBL_SPECIALIZATION']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hub_name'] = this.hub_name;
    data['city'] = this.city;
    data['address'] = this.address;
    data['TBL_SPECIALIZATION'] = this.tBLSPECIALIZATION;
    return data;
  }
}
