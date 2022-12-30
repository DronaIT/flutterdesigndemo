import 'package:flutterdesigndemo/models/hub_response.dart';

class UpdateHub {
  String? id;
  String? createdTime;
  HubResponse? fields;

  UpdateHub({this.id, this.createdTime, this.fields});

  UpdateHub.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? new HubResponse.fromJson(json['fields']) : null;
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
