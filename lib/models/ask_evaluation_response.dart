class AskEvaluationResponse {
  int? askScoreId;
  List<String>? student;
  List<String>? specializationId;
  List<String>? hubIds;
  List<String>? studentEmail;
  List<String>? studentName;
  List<String>? studentMobileNumber;
  List<String>? askAddedBy;
  List<String>? askAddedByEmployeeName;
  String? semesterWhenAdded;
  List<String>? askLevel;
  List<String>? askLevelTitleFromAskLevel;
  List<String>? askParameters;
  List<int>? parameterTotalMarks;
  List<String>? parameterType;
  List<String>? parameterTitle;
  List<String>? parameterMarksReceived;

  AskEvaluationResponse(
      {this.askScoreId,
      this.student,
      this.specializationId,
      this.hubIds,
      this.studentEmail,
      this.studentName,
      this.studentMobileNumber,
      this.askAddedBy,
      this.askAddedByEmployeeName,
      this.semesterWhenAdded,
      this.askLevel,
      this.askLevelTitleFromAskLevel,
      this.askParameters,
      this.parameterTotalMarks,
      this.parameterType,
      this.parameterTitle,
      this.parameterMarksReceived});

  AskEvaluationResponse.fromJson(Map<String, dynamic> json) {
    askScoreId = json['ask_score_id'];
    student = json['student']?.cast<String>();
    specializationId = json['specialization_id']?.cast<String>();
    hubIds = json['hub_ids']?.cast<String>();
    studentEmail = json['student_email']?.cast<String>();
    studentName = json['student_name']?.cast<String>();
    studentMobileNumber = json['student_mobile_number']?.cast<String>();
    askAddedBy = json['ask_added_by']?.cast<String>();
    askAddedByEmployeeName = json['ask_added_by_employee_name']?.cast<String>();
    semesterWhenAdded = json['semester_when_added'];
    askLevel = json['ask_level']?.cast<String>();
    askLevelTitleFromAskLevel = json['ask_level_title (from ask_level)']?.cast<String>();
    askParameters = json['ask_parameters']?.cast<String>();
    parameterTotalMarks = json['parameter_total_marks']?.cast<int>();
    parameterType = json['parameter_type']?.cast<String>();
    parameterTitle = json['parameter_title']?.cast<String>();
    parameterMarksReceived = json['parameter_marks_received']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ask_score_id'] = this.askScoreId;
    data['student'] = this.student;
    data['specialization_id'] = this.specializationId;
    data['hub_ids'] = this.hubIds;
    data['student_email'] = this.studentEmail;
    data['student_name'] = this.studentName;
    data['student_mobile_number'] = this.studentMobileNumber;
    data['ask_added_by'] = this.askAddedBy;
    data['ask_added_by_employee_name'] = this.askAddedByEmployeeName;
    data['semester_when_added'] = this.semesterWhenAdded;
    data['ask_level'] = this.askLevel;
    data['ask_level_title (from ask_level)'] = this.askLevelTitleFromAskLevel;
    data['ask_parameters'] = this.askParameters;
    data['parameter_total_marks'] = this.parameterTotalMarks;
    data['parameter_type'] = this.parameterType;
    data['parameter_title'] = this.parameterTitle;
    data['parameter_marks_received'] = this.parameterMarksReceived;
    return data;
  }
}
