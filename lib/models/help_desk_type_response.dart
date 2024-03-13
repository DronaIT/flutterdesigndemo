class HelpDeskTypeResponse {
  int? id;
  String? title;
  List<String>? centerAuthority;
  List<String>? centerAuthorityMobileNumber;
  List<String>? concernPerson;
  List<String>? concernPersonMobileNumber;
  List<String>? centerAuthorityHubId;
  List<String>? concernPersonHubId;

  HelpDeskTypeResponse({this.id, this.title, this.centerAuthority, this.centerAuthorityMobileNumber, this.concernPerson, this.concernPersonMobileNumber, this.centerAuthorityHubId, this.concernPersonHubId});

  HelpDeskTypeResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    centerAuthority = json['center_autority']?.cast<String>();
    centerAuthorityMobileNumber = json['center_authority_mobile_number']?.cast<String>();
    concernPerson = json['concern_person']?.cast<String>();
    concernPersonMobileNumber = json['concern_person_mobile_number']?.cast<String>();
    centerAuthorityHubId = json['center_authority_hub_id']?.cast<String>();
    concernPersonHubId = json['concern_person_hub_id']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['center_autority'] = centerAuthority;
    data['center_authority_mobile_number'] = centerAuthorityMobileNumber;
    data['concern_person'] = concernPerson;
    data['concern_person_mobile_number'] = concernPersonMobileNumber;
    data['center_authority_hub_id'] = centerAuthorityHubId;
    data['concern_person_hub_id'] = concernPersonHubId;
    return data;
  }
}
