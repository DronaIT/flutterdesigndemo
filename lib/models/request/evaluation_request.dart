class EvaluationRequest {
  List<String>? student;
  List<String>? askAddedBy;
  String? semesterWhenAdded;
  List<String>? askLevel;
  List<String>? askParameters;
  List<String>? parameterMarksReceived;
  int? askTotalMarksReceived;

  EvaluationRequest({
    this.student,
    this.askAddedBy,
    this.semesterWhenAdded,
    this.askLevel,
    this.askParameters,
    this.parameterMarksReceived,
    this.askTotalMarksReceived,
  });

  EvaluationRequest.fromJson(Map<String, dynamic> json) {
    student = json['student']?.cast<String>();
    askAddedBy = json['ask_added_by']?.cast<String>();
    semesterWhenAdded = json['semester_when_added'];
    askLevel = json['ask_level']?.cast<String>();
    askParameters = json['ask_parameters']?.cast<String>();
    parameterMarksReceived = json['parameter_marks_received']?.cast<String>();
    askTotalMarksReceived = json['ask_total_marks_received']?.cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student'] = this.student;
    data['ask_added_by'] = this.askAddedBy;
    data['semester_when_added'] = this.semesterWhenAdded;
    data['ask_level'] = this.askLevel;
    data['ask_parameters'] = this.askParameters;
    data['parameter_marks_received'] = this.parameterMarksReceived;
    data['ask_total_marks_received'] = this.askTotalMarksReceived;
    return data;
  }
}
