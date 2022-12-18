class HubResponse {
  String? hubName;
  String? city;
  String? hubId;
  String? address;

  HubResponse({this.hubName, this.city, this.hubId, this.address});

  HubResponse.fromJson(Map<String, dynamic> json) {
    hubName = json['hub_name'];
    city = json['city'];
    hubId = json['hub_id'];
    address = json['Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hub_name'] = this.hubName;
    data['city'] = this.city;
    data['hub_id'] = this.hubId;
    data['Address'] = this.address;
    return data;
  }
}
