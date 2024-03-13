class FeesRequest {
  List<String>? studentId;
  int? feesPaid;
  List<Map<String, dynamic>>? proofOfPayment;
  String? feesBySemester;
  String remarks = "";

  FeesRequest({
    this.studentId,
    this.feesPaid,
    this.proofOfPayment,
    this.feesBySemester,
  });

  FeesRequest.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id']?.cast<String>();
    feesPaid = json['fees_paid'];
    proofOfPayment = json['proof_of_payment']?.cast<Map<String, dynamic>>();
    feesBySemester = json['fees_by_semester']?.cast<String>();
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['student_id'] = studentId;
    data['fees_paid'] = feesPaid;
    data['proof_of_payment'] = proofOfPayment;
    data['fees_by_semester'] = feesBySemester;
    data['remarks'] = remarks;
    return data;
  }
}
