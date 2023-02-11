class CompleteModuleResponse {

  String? applied_students_name;
  String? applied_students_email;
  String? applied_students_enrollment_number;
  String? applied_students_number;

  int?  completionStatus = 0; //0 = pending,1= placed,2= rejected
  String? compName;


  CompleteModuleResponse({
    this.applied_students_name,
    this.applied_students_email,
    this.applied_students_number,
    this.applied_students_enrollment_number,
    this.completionStatus,
    this.compName,
  });

  CompleteModuleResponse.fromJson(Map<String, dynamic> json) {
    applied_students_number = json['applied_students_number'];
    applied_students_name = json['applied_students_name'];
    applied_students_email = json['applied_students_email'];
    applied_students_enrollment_number = json['applied_students_enrollment_number'];
    completionStatus = json['completionStatus'];
    compName = json['compName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applied_students_number'] = this.applied_students_number;
    data['applied_students_name'] = this.applied_students_name;
    data['applied_students_email'] = this.applied_students_email;
    data['applied_students_enrollment_number'] = this.applied_students_enrollment_number;
    data['completionStatus'] = this.completionStatus;
    data['compName'] = this.compName;
    return data;
  }
}
