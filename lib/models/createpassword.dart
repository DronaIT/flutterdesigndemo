import 'package:flutterdesigndemo/models/login_fields_response.dart';

class CreatePasswordResponse {
  String? id;
  String? createdTime;
  LoginFieldsResponse? fields;

  CreatePasswordResponse({this.id, this.createdTime, this.fields});

  CreatePasswordResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? LoginFieldsResponse.fromJson(json['fields']) : null;
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
