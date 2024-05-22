class StudentResponse {
  String? studentId;
  String? studentName;
  String? studentMobileNumber;
  String? studentSemester;
  String? studentSpecializationIds;
  String? studentHubIds;
  String? askScore;
  String? askTotal;
  bool selected = false;

  StudentResponse({
    this.studentId,
    this.studentName,
    this.studentMobileNumber,
    this.studentSemester,
    this.studentSpecializationIds,
    this.studentHubIds,
    this.askScore,
    this.askTotal,
  });

  StudentResponse.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    studentMobileNumber = json['studentMobileNumber'];
    studentSemester = json['studentSemester'];
    studentSpecializationIds = json['studentSpecializationIds'];
    studentHubIds = json['studentHubIds'];
    askScore = json['askScore'];
    askTotal = json['askTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentId'] = studentId;
    data['studentName'] = studentName;
    data['studentMobileNumber'] = studentMobileNumber;
    data['studentSemester'] = studentSemester;
    data['studentSpecializationIds'] = studentSpecializationIds;
    data['studentHubIds'] = studentHubIds;
    data['askScore'] = askScore;
    data['askTotal'] = askTotal;
    return data;
  }
}
