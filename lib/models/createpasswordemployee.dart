import 'package:flutterdesigndemo/models/login_employee_response.dart';

class CreatePasswordEmployeeResponse {
  String? id;
  String? createdTime;
  LoginEmployeeResponse? fields;

  CreatePasswordEmployeeResponse({this.id, this.createdTime, this.fields});

  CreatePasswordEmployeeResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? LoginEmployeeResponse.fromJson(json['fields']) : null;
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
