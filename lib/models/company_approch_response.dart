class CompanyApprochResponse {
  int? id;
  String? companyName;
  String? contactPersonName;
  String? contactPersonNo;
  String? contactPersonWhatsappNo;
  List<String>? typeOfIndustory;
  List<int>? idFromTypeOfIndustory;

  CompanyApprochResponse({this.id,
    this.companyName,
    this.contactPersonName,
    this.contactPersonNo,
    this.contactPersonWhatsappNo,
    this.typeOfIndustory,
    this.idFromTypeOfIndustory});

  CompanyApprochResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    contactPersonName = json['contact_person_name'];
    contactPersonNo = json['contact_person_no'];
    contactPersonWhatsappNo = json['contact_person_whatsapp_no'];
    typeOfIndustory = json['type_of_industory'].cast<String>();
    idFromTypeOfIndustory = json['id (from type_of_industory)'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['contact_person_name'] = this.contactPersonName;
    data['contact_person_no'] = this.contactPersonNo;
    data['contact_person_whatsapp_no'] = this.contactPersonWhatsappNo;
    data['type_of_industory'] = this.typeOfIndustory;
    data['id (from type_of_industory)'] = this.idFromTypeOfIndustory;
    return data;
  }
}
