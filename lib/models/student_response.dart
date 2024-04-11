class StudentResponse {
  String? studentId;
  String? studentName;
  String? studentMobileNumber;
  String? studentSemester;
  String? studentSpecializationIds;
  bool selected = false;

  StudentResponse({
    this.studentId,
    this.studentName,
    this.studentMobileNumber,
    this.studentSemester,
    this.studentSpecializationIds,
  });

  StudentResponse.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    studentMobileNumber = json['studentMobileNumber'];
    studentSemester = json['studentSemester'];
    studentSpecializationIds = json['studentSpecializationIds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentId'] = studentId;
    data['studentName'] = studentName;
    data['studentMobileNumber'] = studentMobileNumber;
    data['studentSemester'] = studentSemester;
    data['studentSpecializationIds'] = studentSpecializationIds;
    return data;
  }
}
