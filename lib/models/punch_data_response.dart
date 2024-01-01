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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['punch_date'] = this.punchDate;
    data['punch_in_time'] = this.punchInTime;
    data['punch_out_time'] = this.punchOutTime;
    data['attendance_type'] = this.attendanceType;
    data['reason_for_leave'] = this.reasonForLeave;
    data['hub_id (from hub_ids)'] = this.hubIdFromHubIds;
    data['employee_name'] = this.employeeName;
    data['employee_mobile_number'] = this.employeeMobileNumber;
    data['actual_out_time'] = this.actualOutTime;
    data['actual_in_time'] = this.actualInTime;
    return data;
  }
}