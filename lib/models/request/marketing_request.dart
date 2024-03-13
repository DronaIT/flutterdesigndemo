class MarketingRequest {
  String? city;
  int? numberOfApproach;
  int? numberOfMeetings;
  List<String>? employeeHubId;
  int? numberOfSeminarArranged;
  int? numberOfSeminarsCompleted;
  List<String>? detailsAddedBy;
  String remarks = "";

  MarketingRequest({this.city, this.numberOfApproach, this.numberOfMeetings, this.numberOfSeminarArranged, this.numberOfSeminarsCompleted, this.detailsAddedBy});

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city'] = city;
    data['number_of_approach'] = numberOfApproach;
    data['number_of_meetings'] = numberOfMeetings;
    data['number_of_seminar_arranged'] = numberOfSeminarArranged;
    data['number_of_seminars_completed'] = numberOfSeminarsCompleted;
    data['details_added_by'] = detailsAddedBy;
    data['remarks'] = remarks;
    return data;
  }
}
