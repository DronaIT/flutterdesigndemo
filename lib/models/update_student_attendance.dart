import 'package:flutterdesigndemo/models/student_attendance_response.dart';

class UpdateStudentAttendance {
  String? id;
  String? createdTime;
  StudentAttendanceResponse? fields;

  UpdateStudentAttendance({this.id, this.createdTime, this.fields});

  UpdateStudentAttendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? StudentAttendanceResponse.fromJson(json['fields']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdTime'] = createdTime;
    if (fields != null) {
      data['fields'] = fields!.toJson();
    }
    return data;
  }
}
