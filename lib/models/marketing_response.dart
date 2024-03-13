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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['number_of_approach'] = numberOfApproach;
    data['number_of_meetings'] = numberOfMeetings;
    data['employee_hub_id'] = employeeHubId;
    data['number_of_seminar_arranged'] = numberOfSeminarArranged;
    data['number_of_seminars_completed'] = numberOfSeminarsCompleted;
    data['entry_date'] = entryDate;
    data['details_added_by'] = detailsAddedBy;
    data['employee_name'] = employeeName;
    data['employee_mobile_number'] = employeeMobileNumber;
    data['remarks'] = remarks;
    return data;
  }
}
