import 'package:flutterdesigndemo/models/specialization_response.dart';

class UpdateSpecialization {
  String? id;
  String? createdTime;
  SpecializationResponse? fields;

  UpdateSpecialization({this.id, this.createdTime, this.fields});

  UpdateSpecialization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? SpecializationResponse.fromJson(json['fields']) : null;
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
