class MarksResponse {
  int? id;
  List<String>? studentNumber;
  List<String>? studentName;
  String? otherFeedback;
  List<String>? companyId;
  List<String>? companyNameFromCompanyId;
  List<String>? jobId;
  List<String>? jobTitleFromJobId;
  String? punctualityMarks;
  String? groomingMarks;
  String? attitudeMarks;
  String? improvementMarks;
  String? overallMarks;
  int? totalMarks;
  String? totalMarksFrom60;
  String? addedType;

  MarksResponse(
      {this.id,
      this.studentNumber,
      this.studentName,
      this.otherFeedback,
      this.companyId,
      this.companyNameFromCompanyId,
      this.jobId,
      this.jobTitleFromJobId,
      this.punctualityMarks,
      this.groomingMarks,
      this.attitudeMarks,
      this.improvementMarks,
      this.overallMarks,
      this.totalMarks,
      this.totalMarksFrom60,
      this.addedType});

  MarksResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentNumber = json['student_number']?.cast<String>();
    studentName = json['student_name']?.cast<String>();
    otherFeedback = json['other_feedback'];
    companyId = json['company_id']?.cast<String>();
    companyNameFromCompanyId = json['company_name (from company_id)']?.cast<String>();
    jobId = json['job_id']?.cast<String>();
    jobTitleFromJobId = json['job_title (from job_id)']?.cast<String>();
    punctualityMarks = json['punctuality_marks'];
    groomingMarks = json['grooming_marks'];
    attitudeMarks = json['attitude_marks'];
    improvementMarks = json['improvement_marks'];
    overallMarks = json['overall_marks'];
    totalMarks = json['total_marks'];
    totalMarksFrom60 = json['total_marks_from_60'];
    addedType = json['added_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_number'] = this.studentNumber;
    data['student_name'] = this.studentName;
    data['other_feedback'] = this.otherFeedback;
    data['company_id'] = this.companyId;
    data['company_name (from company_id)'] = this.companyNameFromCompanyId;
    data['job_id'] = this.jobId;
    data['job_title (from job_id)'] = this.jobTitleFromJobId;
    data['punctuality_marks'] = this.punctualityMarks;
    data['grooming_marks'] = this.groomingMarks;
    data['attitude_marks'] = this.attitudeMarks;
    data['improvement_marks'] = this.improvementMarks;
    data['overall_marks'] = this.overallMarks;
    data['total_marks'] = this.totalMarks;
    data['total_marks_from_60'] = this.totalMarksFrom60;
    data['added_type'] = this.addedType;
    return data;
  }
}
