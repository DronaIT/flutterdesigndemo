import 'package:flutterdesigndemo/models/hub_response.dart';

class UpdateHub {
  String? id;
  String? createdTime;
  HubResponse? fields;

  UpdateHub({this.id, this.createdTime, this.fields});

  UpdateHub.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? HubResponse.fromJson(json['fields']) : null;
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
