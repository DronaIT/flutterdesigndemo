class HelpDeskTypeResponse {
  int? id;
  String? title;
  List<String>? centerAutority;
  List<String>? centerAuthorityMobileNumber;
  List<String>? concernPerson;
  List<String>? concernPersonMobileNumber;
  List<String>? centerAuthorityHubId;
  List<String>? concernPersonHubId;

  HelpDeskTypeResponse({this.id, this.title, this.centerAutority, this.centerAuthorityMobileNumber, this.concernPerson, this.concernPersonMobileNumber, this.centerAuthorityHubId, this.concernPersonHubId});

  HelpDeskTypeResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    centerAutority = json['center_autority']?.cast<String>();
    centerAuthorityMobileNumber = json['center_authority_mobile_number']?.cast<String>();
    concernPerson = json['concern_person']?.cast<String>();
    concernPersonMobileNumber = json['concern_person_mobile_number']?.cast<String>();
    centerAuthorityHubId = json['center_authority_hub_id']?.cast<String>();
    concernPersonHubId = json['concern_person_hub_id']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['center_autority'] = this.centerAutority;
    data['center_authority_mobile_number'] = this.centerAuthorityMobileNumber;
    data['concern_person'] = this.concernPerson;
    data['concern_person_mobile_number'] = this.concernPersonMobileNumber;
    data['center_authority_hub_id'] = this.centerAuthorityHubId;
    data['concern_person_hub_id'] = this.concernPersonHubId;
    return data;
  }
}
