class CompanyApproachResponse {
  int? id;
  String? companyName;
  String? contactPersonName;
  String? contactPersonNo;
  String? contactPersonWhatsappNo;
  List<String>? typeOfIndustry;
  List<int>? idFromTypeOfIndustry;

  CompanyApproachResponse({this.id, this.companyName, this.contactPersonName, this.contactPersonNo, this.contactPersonWhatsappNo, this.typeOfIndustry, this.idFromTypeOfIndustry});

  CompanyApproachResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    contactPersonName = json['contact_person_name'];
    contactPersonNo = json['contact_person_no'];
    contactPersonWhatsappNo = json['contact_person_whatsapp_no'];
    typeOfIndustry = json['type_of_industory']?.cast<String>();
    idFromTypeOfIndustry = json['id (from type_of_industory)']?.cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['contact_person_name'] = contactPersonName;
    data['contact_person_no'] = contactPersonNo;
    data['contact_person_whatsapp_no'] = contactPersonWhatsappNo;
    data['type_of_industory'] = typeOfIndustry;
    data['id (from type_of_industory)'] = idFromTypeOfIndustry;
    return data;
  }
}
