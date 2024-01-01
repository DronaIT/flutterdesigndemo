class MarketingRequest {
  String? city;
  int? numberOfApproach;
  int? numberOfMeetings;
  List<String>? employeeHubId;
  int? numberOfSeminarArranged;
  int? numberOfSeminarsCompleted;
  List<String>? detailsAddedBy;
  String remarks = "";

  MarketingRequest(
      {this.city,
      this.numberOfApproach,
      this.numberOfMeetings,
      this.numberOfSeminarArranged,
      this.numberOfSeminarsCompleted,
      this.detailsAddedBy});

  MarketingRequest.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    numberOfApproach = json['number_of_approach'];
    numberOfMeetings = json['number_of_meetings'];
    numberOfSeminarArranged = json['number_of_seminar_arranged'];
    numberOfSeminarsCompleted = json['number_of_seminars_completed'];
    detailsAddedBy = json['details_added_by']?.cast<String>();
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['number_of_approach'] = this.numberOfApproach;
    data['number_of_meetings'] = this.numberOfMeetings;
    data['number_of_seminar_arranged'] = this.numberOfSeminarArranged;
    data['number_of_seminars_completed'] = this.numberOfSeminarsCompleted;
    data['details_added_by'] = this.detailsAddedBy;
    data['remarks'] = this.remarks;
    return data;
  }
}
