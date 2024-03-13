import 'package:flutterdesigndemo/models/subject_response.dart';

class UpdateSubject {
  String? id;
  String? createdTime;
  SubjectResponse? fields;

  UpdateSubject({this.id, this.createdTime, this.fields});

  UpdateSubject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? SubjectResponse.fromJson(json['fields']) : null;
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
