class CreateCompanyDetailRequest {
  String? company_identity_number;
  String? company_name;
  String? contact_name;
  String? contact_number;
  String? contact_whatsapp_number;
  String? contact_designation;
  String? company_landline;
  String? contact_email;
  String? company_website;
  List<String>? company_sector;
  List<String>? hub_id;

  String? reporting_branch;
  String? reporting_address;
  String? city;
  List<Map<String, dynamic>>? company_logo;
  List<Map<String, dynamic>>? company_loi;

  CreateCompanyDetailRequest(

      {this.company_identity_number,
        this.hub_id,
      this.company_name,
      this.contact_name,
      this.contact_number,
      this.contact_whatsapp_number,
      this.company_sector,
      this.contact_designation,
      this.company_landline,
      this.company_website,
      this.contact_email,
      this.reporting_branch,
      this.reporting_address,
      this.city,
      this.company_logo,
      this.company_loi});

  CreateCompanyDetailRequest.fromJson(Map<String, dynamic> json) {
    company_identity_number = json['company_identity_number'];
    company_name = json['company_name'];
    contact_name = json['contact_name'];
    hub_id = json['hub_id']?.cast<String>();

    contact_number = json['contact_number'];
    contact_whatsapp_number = json['contact_whatsapp_number'];
    company_sector = json['company_sector']?.cast<String>();
    contact_designation = json['contact_designation'];
    company_landline = json['company_landline'];
    contact_email = json['contact_email'];
    company_website = json['company_website'];

    reporting_branch = json['reporting_branch'];
    reporting_address = json['reporting_address'];
    city = json['city'];
    company_logo = json['company_logo']?.cast<Map<String, dynamic>>();
    company_loi = json['company_loi']?.cast<Map<String, dynamic>>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_identity_number'] = company_identity_number;
    data['hub_id'] = hub_id;

    data['company_name'] = company_name;
    data['contact_name'] = contact_name;
    data['contact_number'] = contact_number;
    data['contact_whatsapp_number'] = contact_whatsapp_number;
    data['company_sector'] = company_sector;
    data['contact_designation'] = contact_designation;
    data['company_website'] = company_website;
    data['contact_email'] = contact_email;
    data['reporting_branch'] = reporting_branch;
    data['reporting_address'] = reporting_address;
    data['city'] = city;
    data['company_landline'] = company_landline;
    data['company_logo'] = company_logo;
    data['company_loi'] = company_loi;
    return data;
  }
}
