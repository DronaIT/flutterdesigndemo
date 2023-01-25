class HubResponse {
  int? id;
  String? hubName;
  String? city;
  String? hubId;
  String? address;
  bool selected = false;

  HubResponse({this.id, this.hubName, this.city, this.hubId, this.address});

  HubResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hubName = json['hub_name'];
    city = json['city'];
    hubId = json['hub_id'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hub_name'] = this.hubName;
    data['city'] = this.city;
    data['hub_id'] = this.hubId;
    data['address'] = this.address;
    return data;
  }
}
