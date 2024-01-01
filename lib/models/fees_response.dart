import 'package:flutterdesigndemo/models/attachment_response.dart';

class FeesResponse {
  int? id;
  int? feesPaid;
  List<String>? studentId;
  List<String>? studentName;
  List<String>? studentSpecializationId;
  List<String>? studentHubId;
  List<String>? studentMobileNumber;
  String? remarks;
  String? feesBySemester;
  List<Attachment_response>? proofOfPayment;

  FeesResponse({
    this.id,
    this.feesPaid,
    this.studentId,
    this.studentName,
    this.studentSpecializationId,
    this.studentHubId,
    this.studentMobileNumber,
    this.remarks,
    this.feesBySemester,
    this.proofOfPayment,
  });

  FeesResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feesPaid = json['fees_paid'];
    studentId = json['student_id']?.cast<String>();
    studentName = json['student_name']?.cast<String>();
    studentHubId = json['hub_id (from hub_ids)']?.cast<String>();
    studentSpecializationId = json['student_specialization_id']?.cast<String>();
    studentMobileNumber = json['student_mobile_number']?.cast<String>();
    remarks = json['remarks'];
    feesBySemester = json['fees_by_semester'];
    if (json['proof_of_payment'] != null) {
      proofOfPayment = <Attachment_response>[];
      json['proof_of_payment'].forEach((v) {
        proofOfPayment!.add(new Attachment_response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fees_paid'] = this.feesPaid;
    data['student_id'] = this.studentId;
    data['student_name'] = this.studentName;
    data['hub_id (from hub_ids)'] = this.studentHubId;
    data['student_specialization_id'] = this.studentSpecializationId;
    data['student_mobile_number'] = this.studentMobileNumber;
    data['remarks'] = this.remarks;
    data['fees_by_semester'] = this.feesBySemester;
    if (this.proofOfPayment != null) {
      data['proof_of_payment'] = this.proofOfPayment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
