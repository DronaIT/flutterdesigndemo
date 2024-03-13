class CreateCompanyApproveRequest {
  String? company_name;
  String? contact_person_name;
  String? contact_person_no;
  String? contact_person_whatsapp_no;
  List<String>? type_of_industory;

  CreateCompanyApproveRequest({
    this.company_name,
    this.contact_person_name,
    this.contact_person_no,
    this.contact_person_whatsapp_no,
    this.type_of_industory,
  });

  CreateCompanyApproveRequest.fromJson(Map<String, dynamic> json) {
    company_name = json['company_name'];
    contact_person_name = json['contact_person_name'];
    contact_person_no = json['contact_person_no'];
    contact_person_whatsapp_no = json['contact_person_whatsapp_no'];
    type_of_industory = json['type_of_industory']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['company_name'] = company_name;
    data['contact_person_name'] = contact_person_name;
    data['contact_person_no'] = contact_person_no;
    data['contact_person_whatsapp_no'] = contact_person_whatsapp_no;
    data['type_of_industory'] = type_of_industory;
    return data;
  }
}
