import 'package:flutterdesigndemo/models/topics_response.dart';

class UpdateTopics {
  String? id;
  String? createdTime;
  TopicsResponse? fields;

  UpdateTopics({this.id, this.createdTime, this.fields});

  UpdateTopics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? TopicsResponse.fromJson(json['fields']) : null;
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
