class CompanyResponse {
  String? companyId;
  String? companyName;
  String? companyCity;
  String? companyContactPerson;
  bool selected = false;

  CompanyResponse({this.companyId, this.companyName, this.companyCity, this.companyContactPerson});

  CompanyResponse.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    companyName = json['company_name'];
    companyCity = json['company_city'];
    companyContactPerson = json['company_contact_person']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_id'] = companyId;
    data['company_name'] = companyName;
    data['company_city'] = companyCity;
    data['company_contact_person'] = companyContactPerson;
    return data;
  }
}
