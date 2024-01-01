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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = this.studentId;
    data['fees_paid'] = this.feesPaid;
    data['proof_of_payment'] = this.proofOfPayment;
    data['fees_by_semester'] = this.feesBySemester;
    data['remarks'] = this.remarks;
    return data;
  }
}
