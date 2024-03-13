class PunchDataResponse {
  int? id;
  List<String>? employeeId;
  String? punchDate;
  String? punchInTime;
  String? punchOutTime;
  String? attendanceType;
  String? reasonForLeave;
  List<String>? hubIdFromHubIds;
  List<String>? employeeName;
  List<String>? employeeMobileNumber;
  List<String>? actualOutTime;
  List<String>? actualInTime;
  bool runningLate = false;

  PunchDataResponse(
      {this.id,
        this.employeeId,
        this.punchDate,
        this.punchInTime,
        this.punchOutTime,
        this.attendanceType,
        this.reasonForLeave,
        this.hubIdFromHubIds,
        this.employeeName,
        this.employeeMobileNumber,
        this.actualOutTime,
        this.actualInTime});

  PunchDataResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'].cast<String>();
    punchDate = json['punch_date'];
    punchInTime = json['punch_in_time'];
    punchOutTime = json['punch_out_time'];
    attendanceType = json['attendance_type'];
    reasonForLeave = json['reason_for_leave'];
    hubIdFromHubIds = json['hub_id (from hub_ids)'].cast<String>();
    employeeName = json['employee_name'].cast<String>();
    employeeMobileNumber = json['employee_mobile_number'].cast<String>();
    actualOutTime = json['actual_out_time'].cast<String>();
    actualInTime = json['actual_in_time'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['punch_date'] = punchDate;
    data['punch_in_time'] = punchInTime;
    data['punch_out_time'] = punchOutTime;
    data['attendance_type'] = attendanceType;
    data['reason_for_leave'] = reasonForLeave;
    data['hub_id (from hub_ids)'] = hubIdFromHubIds;
    data['employee_name'] = employeeName;
    data['employee_mobile_number'] = employeeMobileNumber;
    data['actual_out_time'] = actualOutTime;
    data['actual_in_time'] = actualInTime;
    return data;
  }
}