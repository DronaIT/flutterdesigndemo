class AddPlacementMarksRequest {
  List<String>? studentNumber;
  List<String>? companyId;
  String? punctualityMarks;
  String? groomingMarks;
  String? attitudeMarks;
  String? improvementsMarks;
  String? overallMarks;
  String? addedType;
  String? otherFeedback;

  AddPlacementMarksRequest({
    this.studentNumber,
    this.companyId,
    this.punctualityMarks,
    this.groomingMarks,
    this.attitudeMarks,
    this.improvementsMarks,
    this.overallMarks,
    this.addedType,
    this.otherFeedback,
  });

  AddPlacementMarksRequest.fromJson(Map<String, dynamic> json) {
    studentNumber = json['student_number']?.cast<String>();
    companyId = json['company_id']?.cast<String>();
    punctualityMarks = json['punctuality_marks'];
    groomingMarks = json['grooming_marks'];
    attitudeMarks = json['attitude_marks'];
    improvementsMarks = json['improvement_marks'];
    overallMarks = json['overall_marks'];
    addedType = json['added_type'];
    otherFeedback = json['other_feedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_number'] = studentNumber;
    data['company_id'] = companyId;
    data['punctuality_marks'] = punctualityMarks;
    data['grooming_marks'] = groomingMarks;
    data['attitude_marks'] = attitudeMarks;
    data['improvement_marks'] = improvementsMarks;
    data['overall_marks'] = overallMarks;
    data['added_type'] = addedType;
    data['other_feedback'] = otherFeedback;
    return data;
  }
}
