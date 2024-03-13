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
  List<AttachmentResponse>? proofOfPayment;

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
      proofOfPayment = <AttachmentResponse>[];
      json['proof_of_payment'].forEach((v) {
        proofOfPayment!.add(AttachmentResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fees_paid'] = feesPaid;
    data['student_id'] = studentId;
    data['student_name'] = studentName;
    data['hub_id (from hub_ids)'] = studentHubId;
    data['student_specialization_id'] = studentSpecializationId;
    data['student_mobile_number'] = studentMobileNumber;
    data['remarks'] = remarks;
    data['fees_by_semester'] = feesBySemester;
    if (proofOfPayment != null) {
      data['proof_of_payment'] = proofOfPayment!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
