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
  List<String>? companySector;
  List<String>? sectorTitleFromCompanySector;

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
        this.sectorTitleFromCompanySector});

  CompanyDetailResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    contactName = json['contact_name'];
    contactNumber = json['contact_number'];
    contactWhatsappNumber = json['contact_whatsapp_number'];
    contactDesignation = json['contact_designation'];
    contactEmail = json['contact_email'];
    companyWebsite = json['company_website'];
    companyIdentityNumber = json['company_identity_number'];
    companySector = json['company_sector']?.cast<String>();
    sectorTitleFromCompanySector =
        json['sector_title (from company_sector)']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_name'] = this.companyName;
    data['contact_name'] = this.contactName;
    data['contact_number'] = this.contactNumber;
    data['contact_whatsapp_number'] = this.contactWhatsappNumber;
    data['contact_designation'] = this.contactDesignation;
    data['contact_email'] = this.contactEmail;
    data['company_website'] = this.companyWebsite;
    data['company_identity_number'] = this.companyIdentityNumber;
    data['company_sector'] = this.companySector;
    data['sector_title (from company_sector)'] =
        this.sectorTitleFromCompanySector;
    return data;
  }
}