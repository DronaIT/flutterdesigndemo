import 'package:flutterdesigndemo/models/login_fields_response.dart';

class CreatePasswordResponse {
  String? id;
  String? createdTime;
  LoginFieldsResponse? fields;

  CreatePasswordResponse({this.id, this.createdTime, this.fields});

  CreatePasswordResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? new LoginFieldsResponse.fromJson(json['fields']) : null;
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
