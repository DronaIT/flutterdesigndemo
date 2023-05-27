class HelpDeskTypeResponse {
  int? id;
  String? title;
  List<String>? centerAutority;
  List<String>? concernPerson;
  List<String>? centerAuthorityHubId;
  List<String>? concernPersonHubId;
  List<String>? tBLHELPDESK;

  HelpDeskTypeResponse({this.id, this.title, this.centerAutority, this.concernPerson, this.centerAuthorityHubId, this.concernPersonHubId, this.tBLHELPDESK});

  HelpDeskTypeResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    centerAutority = json['center_autority']?.cast<String>();
    concernPerson = json['concern_person']?.cast<String>();
    centerAuthorityHubId = json['center_authority_hub_id']?.cast<String>();
    concernPersonHubId = json['concern_person_hub_id']?.cast<String>();
    tBLHELPDESK = json['TBL_HELPDESK']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['center_autority'] = this.centerAutority;
    data['concern_person'] = this.concernPerson;
    data['center_authority_hub_id'] = this.centerAuthorityHubId;
    data['concern_person_hub_id'] = this.concernPersonHubId;
    data['TBL_HELPDESK'] = this.tBLHELPDESK;
    return data;
  }
}
