import 'package:flutterdesigndemo/models/specialization_response.dart';
import 'package:flutterdesigndemo/models/topics_response.dart';
import 'package:flutterdesigndemo/models/units_response.dart';

class UpdateTopics {
  String? id;
  String? createdTime;
  TopicsResponse? fields;

  UpdateTopics({this.id, this.createdTime, this.fields});

  UpdateTopics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? new TopicsResponse.fromJson(json['fields']) : null;
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
