import 'package:flutterdesigndemo/models/specialization_response.dart';

class UpdateSpecialization {
  String? id;
  String? createdTime;
  SpecializationResponse? fields;

  UpdateSpecialization({this.id, this.createdTime, this.fields});

  UpdateSpecialization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['createdTime'];
    fields = json['fields'] != null ? new SpecializationResponse.fromJson(json['fields']) : null;
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
