import 'package:flutterdesigndemo/models/login_employee_response.dart';

class CreatePasswordEmployeeResponse {
  String? id;
  String? createdTime;
  LoginEmployeResponse? fields;

  CreatePasswordEmployeeResponse({this.id, this.createdTime, this.fields});

  CreatePasswordEmployeeResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? new LoginEmployeResponse.fromJson(json['fields']) : null;
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
