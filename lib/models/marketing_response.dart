class MarketingResponse {
  String? city;
  int? numberOfApproach;
  int? numberOfMeetings;
  List<String>? employeeHubId;
  int? numberOfSeminarArranged;
  int? numberOfSeminarsCompleted;
  String? entryDate;
  List<String>? detailsAddedBy;
  List<String>? employeeName;
  List<String>? employeeMobileNumber;
  String? remarks;

  MarketingResponse(
      {this.city,
      this.numberOfApproach,
      this.numberOfMeetings,
      this.employeeHubId,
      this.numberOfSeminarArranged,
      this.numberOfSeminarsCompleted,
      this.entryDate,
      this.detailsAddedBy,
      this.employeeName,
      this.employeeMobileNumber,
      this.remarks});

  MarketingResponse.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    numberOfApproach = json['number_of_approach'];
    numberOfMeetings = json['number_of_meetings'];
    employeeHubId = json['employee_hub_id']?.cast<String>();
    numberOfSeminarArranged = json['number_of_seminar_arranged'];
    numberOfSeminarsCompleted = json['number_of_seminars_completed'];
    entryDate = json['entry_date'];
    detailsAddedBy = json['details_added_by']?.cast<String>();
    employeeName = json['employee_name']?.cast<String>();
    employeeMobileNumber = json['employee_mobile_number']?.cast<String>();
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['number_of_approach'] = this.numberOfApproach;
    data['number_of_meetings'] = this.numberOfMeetings;
    data['employee_hub_id'] = this.employeeHubId;
    data['number_of_seminar_arranged'] = this.numberOfSeminarArranged;
    data['number_of_seminars_completed'] = this.numberOfSeminarsCompleted;
    data['entry_date'] = this.entryDate;
    data['details_added_by'] = this.detailsAddedBy;
    data['employee_name'] = this.employeeName;
    data['employee_mobile_number'] = this.employeeMobileNumber;
    data['remarks'] = this.remarks;
    return data;
  }
}
