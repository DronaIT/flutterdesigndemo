class AddPunchRequest {
  List<String>? employeeId;
  String? punch_date;
  String? punch_in_time;
  String? punch_out_time;
  String? attendance_type;
  String? reason_for_leave;

  AddPunchRequest({
    this.employeeId,
    this.punch_date,
    this.punch_in_time,
    this.punch_out_time,
    this.attendance_type,
    this.reason_for_leave,
  });

  AddPunchRequest.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id']?.cast<String>();
    punch_date = json['punch_date'];
    punch_in_time = json['punch_in_time'];
    punch_out_time = json['punch_out_time'];
    attendance_type = json['attendance_type'];
    reason_for_leave = json['reason_for_leave'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_id'] = this.employeeId;
    data['punch_date'] = this.punch_date;
    data['punch_in_time'] = this.punch_in_time;
    data['punch_out_time'] = this.punch_out_time;
    data['attendance_type'] = this.attendance_type;
    data['reason_for_leave'] = this.reason_for_leave;
    return data;
  }
}
