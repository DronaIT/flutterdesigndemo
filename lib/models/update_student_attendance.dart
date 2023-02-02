import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/student_attendance_response.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/models/units_response.dart';

class UpdateStudentAttendance {
  String? id;
  String? createdTime;
  StudentAttendanceResponse? fields;

  UpdateStudentAttendance({this.id, this.createdTime, this.fields});

  UpdateStudentAttendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? new StudentAttendanceResponse.fromJson(json['fields']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdTime'] = this.createdTime;
    if (this.fields != null) {
      data['fields'] = this.fields!.toJson();
    }
    return data;
  }
}
