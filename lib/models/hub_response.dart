class HubResponse {
  int? id;
  String? hubName;
  String? city;
  String? hubId;
  String? address;
  List<String>? tblStudent;
  List<String>? studentSpecializationIds;
  List<String>? isPlacedNow;
  List<String>? tblCompany;
  List<String>? workingEmployees;
  bool selected = false;

  double feesReceived = 0;
  int studentsWhoPaidFees = 0;

  double averageLectureAttendance = 0;
  double overallStudentAttendance = 0;
  int totalLecture = 0;

  int newPlaced = 0;
  int newSelfPlaced = 0;
  int totalPlacement = 0;
  double overallPlacement = 0;

  int newCompany = 0;
  int newJobs = 0;
  int newVacancies = 0;

  int totalEmployee = 0;
  int onLeaveToday = 0;
  int runningLate = 0;

  HubResponse({
    this.id,
    this.hubName,
    this.city,
    this.hubId,
    this.address,
    this.tblStudent,
    this.studentSpecializationIds,
    this.isPlacedNow,
    this.tblCompany,
    this.workingEmployees,
  });

  HubResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hubName = json['hub_name'];
    city = json['city'];
    hubId = json['hub_id'];
    address = json['address'];
    tblStudent = json['TBL_STUDENT']?.cast<String>();
    studentSpecializationIds = json['student_specialization_ids']?.cast<String>();
    isPlacedNow = json['is_placed_now_data']?.cast<String>();
    tblCompany = json['TBL_COMPANY']?.cast<String>();
    workingEmployees = json['working_employees']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hub_name'] = this.hubName;
    data['city'] = this.city;
    data['hub_id'] = this.hubId;
    data['address'] = this.address;
    data['TBL_STUDENT'] = this.tblStudent;
    data['student_specialization_ids'] = this.studentSpecializationIds;
    data['is_placed_now_data'] = this.isPlacedNow;
    data['TBL_COMPANY'] = this.tblCompany;
    data['working_employees'] = this.workingEmployees;
    return data;
  }
}
