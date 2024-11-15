class SpecializationResponse {
  int? id;
  String? specializationId;
  String? specializationName;
  List<String>? hubIds;
  List<String>? hubIdFromHubIds;
  String? specializationDesc;
  bool selected = false;

  double feesReceived = 0;
  int studentsWhoPaidFees = 0;

  double averageLectureAttendance = 0;
  double overallStudentAttendance = 0;
  int totalLecture = 0;

  int newPlaced = 0;
  int newSelfPlaced = 0;
  int totalPlacement = 0;
  int totalStudent = 0;
  double overallPlacement = 0;

  SpecializationResponse({this.id, this.specializationId, this.specializationName, this.hubIds, this.hubIdFromHubIds, this.specializationDesc});

  SpecializationResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specializationId = json['specialization_id'];
    specializationName = json['specialization_name'];
    hubIds = json['hub_ids']?.cast<String>();
    hubIdFromHubIds = json['hub_id (from hub_ids)']?.cast<String>();
    specializationDesc = json['specialization_desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['specialization_id'] = specializationId;
    data['specialization_name'] = specializationName;
    data['hub_ids'] = hubIds;
    data['hub_id (from hub_ids)'] = hubIdFromHubIds;
    data['specialization_desc'] = specializationDesc;
    return data;
  }
}
