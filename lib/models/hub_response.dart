class HubResponse {
  int? id;
  String? hubName;
  String? city;
  String? hubId;
  String? address;
  List<String>? tblStudent;
  List<String>? studentSpecializationIds;
  List<String>? studentMobileNumber;
  List<String>? studentName;
  List<String>? studentEmail;
  List<String>? studentSemester;
  List<String>? studentDivision;
  List<String>? studentGender;
  List<String>? admissionBatchStart;
  List<String>? admissionBatchEnd;
  List<String>? warningLetter1Issued;
  List<String>? warningLetter2Issued;
  List<String>? warningLetter3Issued;
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
    this.studentMobileNumber,
    this.studentName,
    this.studentEmail,
    this.studentSemester,
    this.studentDivision,
    this.studentGender,
    this.admissionBatchStart,
    this.admissionBatchEnd,
    this.warningLetter1Issued,
    this.warningLetter2Issued,
    this.warningLetter3Issued,
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
    studentMobileNumber = json['student_mobile_number']?.cast<String>();
    studentName = json['student_name']?.cast<String>();
    studentEmail = json['student_email']?.cast<String>();
    studentSemester = json['student_semester']?.cast<String>();
    studentDivision = json['student_division']?.cast<String>();
    studentGender = json['student_gender']?.cast<String>();
    admissionBatchStart = json['admission_batch_start']?.cast<String>();
    admissionBatchEnd = json['admission_batch_end']?.cast<String>();
    warningLetter1Issued = json['warning_letter_1_issued']?.cast<String>();
    warningLetter2Issued = json['warning_letter_2_issued']?.cast<String>();
    warningLetter3Issued = json['warning_letter_3_issued']?.cast<String>();
    isPlacedNow = json['is_placed_now_data']?.cast<String>();
    tblCompany = json['TBL_COMPANY']?.cast<String>();
    workingEmployees = json['working_employees']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hub_name'] = hubName;
    data['city'] = city;
    data['hub_id'] = hubId;
    data['address'] = address;
    data['TBL_STUDENT'] = tblStudent;
    data['student_specialization_ids'] = studentSpecializationIds;
    data['student_mobile_number'] = studentMobileNumber;
    data['student_name'] = studentName;
    data['student_email'] = studentEmail;
    data['student_semester'] = studentSemester;
    data['student_division'] = studentDivision;
    data['student_gender'] = studentGender;
    data['admission_batch_start'] = admissionBatchStart;
    data['admission_batch_end'] = admissionBatchEnd;
    data['warning_letter_1_issued'] = warningLetter1Issued;
    data['warning_letter_2_issued'] = warningLetter2Issued;
    data['warning_letter_3_issued'] = warningLetter3Issued;
    data['is_placed_now_data'] = isPlacedNow;
    data['TBL_COMPANY'] = tblCompany;
    data['working_employees'] = workingEmployees;
    return data;
  }
}
