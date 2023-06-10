class CompanyDetailResponse {
  int? id;
  String? companyName;
  String? contactName;
  String? contactNumber;
  String? contactWhatsappNumber;
  String? contactDesignation;
  String? contactEmail;
  String? companyWebsite;
  String? companyIdentityNumber;
  String? company_code;
  String? company_landline;
  List<String>? companySector;
  List<String>? sectorTitleFromCompanySector;
  String? reporting_branch;
  String? reporting_address;
  String? city;
  String? password;
  String? token;

  CompanyDetailResponse(
      {this.id,
        this.companyName,
        this.contactName,
        this.contactNumber,
        this.contactWhatsappNumber,
        this.contactDesignation,
        this.contactEmail,
        this.companyWebsite,
        this.companyIdentityNumber,
        this.companySector,
        this.company_code,
        this.company_landline,
        this.reporting_branch,
        this.reporting_address,
        this.city,
        this.sectorTitleFromCompanySector,
        this.password,
        this.token
      });

  CompanyDetailResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    contactName = json['contact_name'];
    contactNumber = json['contact_number'];
    contactWhatsappNumber = json['contact_whatsapp_number'];
    contactDesignation = json['contact_designation'];
    contactEmail = json['contact_email'];
    companyWebsite = json['company_website'] ?? " ";
    companyIdentityNumber = json['company_identity_number'];
    company_code = json['company_code'];
    company_landline = json['company_landline'] ?? " ";
    companySector = json['company_sector']?.cast<String>();
    sectorTitleFromCompanySector =
        json['sector_title (from company_sector)']?.cast<String>();
    reporting_branch = json['reporting_branch'] ?? " ";
    reporting_address = json['reporting_address'] ?? " ";
    city = json['city'] ?? " ";
    password = json['password'] ?? " ";
    token = json['token'] ?? " ";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['contact_name'] = this.contactName;
    data['contact_number'] = this.contactNumber;
    data['contact_whatsapp_number'] = this.contactWhatsappNumber;
    data['company_code'] = this.company_code;
    data['company_landline'] = this.company_landline;
    data['contact_designation'] = this.contactDesignation;
    data['contact_email'] = this.contactEmail;
    data['company_website'] = this.companyWebsite;
    data['company_identity_number'] = this.companyIdentityNumber;
    data['company_sector'] = this.companySector;
    data['sector_title (from company_sector)'] = this.sectorTitleFromCompanySector;
    data['reporting_branch'] = this.reporting_branch;
    data['reporting_address'] = this.reporting_address;
    data['city'] = this.city;
    data['password'] = this.password;
    data['token'] = this.token;
    return data;
  }
}