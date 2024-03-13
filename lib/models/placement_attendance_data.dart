import 'package:flutterdesigndemo/models/request/add_placement_attendance_data.dart';

class PlacementAttendanceData {
  String? id;
  String? createdTime;
  AddPlacementAttendanceData? fields;

  PlacementAttendanceData({this.id, this.createdTime, this.fields});

  PlacementAttendanceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? AddPlacementAttendanceData.fromJson(json['fields']) : null;
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
